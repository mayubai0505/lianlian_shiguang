"use strict";

// Delete an owner-controlled role agreement and its delivery job atomically.
// Stale/expired agreements must remain deletable even if an old status was never
// finalized by the delivery worker. Only a genuinely active delivery/call is blocked.
function createDeleteRoleAgreementHandler({db, APP_ID, HttpsError}) {
  const toMillis = value => {
    if (!value) return null;
    if (typeof value.toMillis === 'function') return value.toMillis();
    if (value instanceof Date) return value.getTime();
    const n = Number(value);
    return Number.isFinite(n) ? n : null;
  };

  return async request => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', '請先登入');

    const characterId = String(request.data?.characterId || '').trim();
    const agreementId = String(request.data?.agreementId || '').trim();
    if (!/^[^/]{1,160}$/.test(characterId) || !/^[a-f0-9]{64}$/.test(agreementId)) {
      throw new HttpsError('invalid-argument', '約定編號無效');
    }

    const ref = db.collection('users').doc(uid).collection('characters').doc(characterId)
      .collection('role_agreements').doc(agreementId);
    const jobRef = db.collection('artifacts').doc(APP_ID)
      .collection('role_agreement_jobs').doc(agreementId);

    return db.runTransaction(async tx => {
      const [agreementSnap, jobSnap] = await Promise.all([
        tx.get(ref),
        tx.get(jobRef),
      ]);

      if (!agreementSnap.exists) {
        // Also clean a matching orphaned job if one somehow remains.
        if (jobSnap.exists) {
          const orphan = jobSnap.data() || {};
          if (orphan.uid === uid && orphan.characterId === characterId && orphan.agreementId === agreementId) {
            tx.delete(jobRef);
          }
        }
        return {success:true, alreadyDeleted:true};
      }

      const agreement = agreementSnap.data() || {};
      if (agreement.confirmedBy !== uid || agreement.characterId !== characterId) {
        throw new HttpsError('permission-denied', '無權刪除其他玩家的約定');
      }

      const job = jobSnap.exists ? (jobSnap.data() || {}) : null;
      if (job && (job.uid !== uid || job.characterId !== characterId || job.agreementId !== agreementId)) {
        throw new HttpsError('permission-denied', '排程資料不一致');
      }

      const now = Date.now();
      const scheduledAt = toMillis(agreement.scheduledAt) ?? toMillis(job?.scheduledAt);
      const nextActionAt = toMillis(job?.nextActionAt);
      const status = String(agreement.status || '');
      const jobState = String(job?.state || '');

      // A connected/accepted call is the only agreement state that must never be
      // deleted until the call is settled, otherwise charging/refund bookkeeping
      // can be orphaned.
      if (status === 'accepted' || jobState === 'accepted') {
        throw new HttpsError('failed-precondition', '通話正在進行中，結束後即可刪除');
      }

      // "sending" owns a two-minute lease. While that lease is still valid, a
      // worker may be performing network I/O, so deletion would race the push.
      const sendingLeaseActive = jobState === 'sending' && nextActionAt !== null && nextActionAt > now;
      if (sendingLeaseActive) {
        throw new HttpsError('failed-precondition', '約定正在送出中，請稍後再試');
      }

      // A ringing call is active only until its ring timeout. If the timeout has
      // already elapsed (or the job is missing), treat it as stale and let the
      // player clear the memo instead of permanently locking the record.
      const ringingStillActive = (status === 'ringing' || jobState === 'ringing') &&
        job !== null && nextActionAt !== null && nextActionAt > now;
      if (ringingStillActive) {
        throw new HttpsError('failed-precondition', '角色正在來電中，請先拒接或等來電結束');
      }

      // A pending delivery whose scheduled time has already passed is stale from
      // the player's perspective and is safe to remove together with its job.
      // Future scheduled/pending agreements are also user-cancellable by delete.
      // Do not require the old status machine to have finalized first.
      const expired = scheduledAt !== null && scheduledAt <= now;
      const staleStatus = ['pending_delivery','ringing','scheduled','delivery_failed','connection_failed','missed','completed','cancelled','suppressed_dnd'].includes(status);
      const staleJob = !job || ['pending','cancelled','completed','failed','suppressed_dnd','ringing','sending'].includes(jobState);

      if (!expired && status && !staleStatus && job && !staleJob) {
        throw new HttpsError('failed-precondition', '這筆約定目前無法刪除，請稍後再試');
      }

      if (job) tx.delete(jobRef);
      tx.delete(ref);
      return {success:true, alreadyDeleted:false, staleCleaned:expired};
    });
  };
}

module.exports = {createDeleteRoleAgreementHandler};
