'use strict';
// V51: Preserve creator cooperation application eligibility and audit behavior.
function createCreatorApplicationHandler({db,HttpsError,FieldValue}) {
  const submitCreatorCooperationApplicationHandler = async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', '請先登入帳號');
  const raw = request.data || {};
  if (typeof raw.creatorDirection !== 'string' || typeof raw.creatorApplicationReason !== 'string') {
    throw new HttpsError('invalid-argument', '請填寫創作方向與合作動機');
  }
  const direction = raw.creatorDirection.trim();
  const reason = raw.creatorApplicationReason.trim();
  const count = (value) => Array.from(new Intl.Segmenter('zh-Hant', {granularity: 'grapheme'}).segment(value)).length;
  if (count(direction) < 2 || count(direction) > 100 || count(reason) < 10 || count(reason) > 500) {
    throw new HttpsError('invalid-argument', '創作方向須為 2～100 字，合作動機須為 10～500 字');
  }
  const ref = db.collection('users').doc(uid);
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) throw new HttpsError('not-found', '找不到玩家帳號');
    const data = snap.data() || {};
    const current = String(data.creatorStatus || 'none');
    if (!['none', '', 'rejected', 'revoked'].includes(current)) {
      throw new HttpsError('failed-precondition', '已有申請紀錄或合作資格，不能重複送出');
    }
    if (data.creatorVerified === true || data.creatorDashboardEnabled === true) {
      throw new HttpsError('failed-precondition', '已取得合作權限的帳號無法重新申請');
    }
    if (current === 'revoked') {
      const countRaw = Number(data.creatorRevocationCount);
      const revocationCount = Number.isSafeInteger(countRaw) && countRaw >= 0 ? countRaw : 1;
      // TEST ONLY: 測試期間不啟用五次封鎖；正式上線前恢復。
      // if (revocationCount >= 5) {
      //   throw new HttpsError('failed-precondition', '累計取消創作者資格達五次，無法再次申請');
      // }
      // TEST ONLY (2026-10-15): temporarily bypass the 72-hour reapplication cooldown.
      // Keep creatorRevocationCount and creatorRevokedAt untouched for the future production rule.
      // Restore the server-side 72-hour timestamp check before public release.
    }
    tx.update(ref, {
      creatorStatus: 'pending',
      creatorVerified: false,
      creatorDashboardEnabled: false,
      creatorDirection: direction,
      creatorApplicationReason: reason,
      creatorAppliedAt: FieldValue.serverTimestamp(),
      creatorStatusUpdatedAt: FieldValue.serverTimestamp(),
      creatorStatusReason: FieldValue.delete(),
    });
    tx.set(db.collection('creator_application_audit').doc(), {
      creatorUid: uid, action: 'submitted', previousStatus: current,
      submittedAt: FieldValue.serverTimestamp(),
    });
  });
  return {success: true, creatorStatus: 'pending'};
};
  return {submitCreatorCooperationApplicationHandler};
}
module.exports={createCreatorApplicationHandler};
