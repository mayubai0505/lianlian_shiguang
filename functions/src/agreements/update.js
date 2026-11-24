'use strict';
// Secure, atomic rescheduling of an existing, pending role agreement.
function createUpdateRoleAgreementHandler({db, APP_ID, HttpsError, FieldValue}) {
  return async request => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', '請先登入');
    const {characterId, agreementId, sessionId} = request.data || {};
    const when = Number(request.data?.scheduledAtMs);
    if (typeof characterId !== 'string' || !/^[^/]{1,160}$/.test(characterId) ||
        typeof sessionId !== 'string' || !/^[^/]{1,160}$/.test(sessionId) ||
        typeof agreementId !== 'string' || !/^[a-f0-9]{64}$/.test(agreementId) ||
        !Number.isSafeInteger(when) || when < Date.now() + 60000 ||
        when > Date.now() + 365 * 86400000) {
      throw new HttpsError('invalid-argument', '修改時間或約定資料無效');
    }
    const ref = db.collection('users').doc(uid).collection('characters')
      .doc(characterId).collection('role_agreements').doc(agreementId);
    const jobRef = db.collection('artifacts').doc(APP_ID)
      .collection('role_agreement_jobs').doc(agreementId);
    return db.runTransaction(async tx => {
      const agreementSnap = await tx.get(ref);
      const jobSnap = await tx.get(jobRef);
      if (!agreementSnap.exists || !jobSnap.exists) {
        throw new HttpsError('not-found', '約定不存在或已進入通知程序');
      }
      const agreement = agreementSnap.data() || {};
      const job = jobSnap.data() || {};
      if (agreement.confirmedBy !== uid || agreement.characterId !== characterId ||
          agreement.sessionId !== sessionId || job.uid !== uid ||
          job.characterId !== characterId || job.agreementId !== agreementId) {
        throw new HttpsError('permission-denied', '無法修改其他玩家的約定');
      }
      if (agreement.status !== 'scheduled' || agreement.deliveryEnabled !== true ||
          job.state !== 'pending' || !['call', 'notification'].includes(job.method) ||
          job.method !== agreement.method) {
        throw new HttpsError('failed-precondition', '約定已進入通知或接聽流程，不能修改');
      }
      const updatedAt = new Date(when);
      tx.update(ref, {scheduledAt: updatedAt, updatedAt: FieldValue.serverTimestamp(),
        lastRescheduledAt: FieldValue.serverTimestamp()});
      tx.update(jobRef, {scheduledAt: updatedAt, nextActionAt: updatedAt,
        updatedAt: FieldValue.serverTimestamp()});
      return {success: true, agreementId, scheduledAtMs: when};
    });
  };
}
module.exports = {createUpdateRoleAgreementHandler};
