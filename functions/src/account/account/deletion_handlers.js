'use strict';
// Account deletion: 72-hour grace period and scheduled deletion.
// Inject Firebase dependencies; do not reinitialize Admin SDK.
function createAccountDeletionHandlers({db,auth,Timestamp,FieldValue,HttpsError,logger}) {
// 帳號刪除：3 天冷靜期。所有期限都以伺服器時間為準。
const DELETE_GRACE_MS = 3 * 24 * 60 * 60 * 1000;

const getAccountDeletionStatus = async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', '請先登入');
  const snap = await db.collection('users').doc(request.auth.uid).get();
  // 不把找不到 users 文件當成正常帳號，以免清除中的帳號被重新建立。
  if (!snap.exists) return {status: 'processing'};
  const data = snap.data() || {};
  if (data.accountDeleteRequested !== true) return {status: 'active'};
  if (data.accountDeletionProcessing === true) return {status: 'processing'};
  const due = data.deleteScheduledAt?.toMillis?.();
  if (!Number.isFinite(due)) return {status: 'processing'}; // 壞資料不可放行
  return {status: Date.now() < due ? 'pending' : 'expired'};
};

const requestDeleteAccount = async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', '請先登入');
  const userRef = db.collection('users').doc(request.auth.uid);
  const scheduledAt = await db.runTransaction(async (tx) => {
    const snap = await tx.get(userRef);
    if (!snap.exists) throw new HttpsError('failed-precondition', '找不到帳號資料');
    const data = snap.data() || {};
    if (data.accountDeletionProcessing === true) {
      throw new HttpsError('failed-precondition', '帳號已進入刪除程序');
    }
    if (data.accountDeleteRequested === true) {
      const previousDue = data.deleteScheduledAt?.toMillis?.();
      if (!Number.isFinite(previousDue) || previousDue <= Date.now()) {
        throw new HttpsError('failed-precondition', '帳號已超過取消期限');
      }
      return previousDue; // 重複申請不延長冷靜期
    }
    const due = Date.now() + DELETE_GRACE_MS;
    tx.update(userRef, {
      accountDeleteRequested: true,
      deleteScheduledAt: Timestamp.fromMillis(due),
      accountDeletionProcessing: false,
      accountDeleteRequestedAt: FieldValue.serverTimestamp(),
    });
    return due;
  });
  return {success: true, deleteScheduledAt: scheduledAt};
};

const cancelDeleteAccount = async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', '請先登入');
  const userRef = db.collection('users').doc(request.auth.uid);
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(userRef);
    if (!snap.exists) throw new HttpsError('failed-precondition', '帳號已不存在');
    const data = snap.data() || {};
    if (data.accountDeleteRequested !== true) {
      throw new HttpsError('failed-precondition', '沒有待取消的刪除申請');
    }
    if (data.accountDeletionProcessing === true) {
      throw new HttpsError('failed-precondition', '帳號已進入刪除程序');
    }
    const due = data.deleteScheduledAt?.toMillis?.();
    if (!Number.isFinite(due) || Date.now() >= due) {
      throw new HttpsError('failed-precondition', '已超過三天取消期限');
    }
    tx.update(userRef, {
      accountDeleteRequested: false,
      deleteScheduledAt: FieldValue.delete(),
      accountDeleteRequestedAt: FieldValue.delete(),
      accountDeletionProcessing: FieldValue.delete(),
    });
  });
  return {success: true};
};

const checkScheduledDelete = async () => {
  const now = Timestamp.now();
  const snapshots = await db.collection('users')
    .where('accountDeleteRequested', '==', true)
    .where('deleteScheduledAt', '<=', now).get();
  for (const userDoc of snapshots.docs) {
    const uid = userDoc.id;
    const userRef = userDoc.ref;
    try {
      // 先標示執行中，和取消申請以 transaction 互斥。
      await db.runTransaction(async (tx) => {
        const snap = await tx.get(userRef);
        if (!snap.exists) return;
        const data = snap.data() || {};
        if (data.accountDeleteRequested !== true ||
            (data.deleteScheduledAt?.toMillis?.() || Infinity) > Date.now()) return;
        tx.update(userRef, {accountDeletionProcessing: true});
      });
      const current = await userRef.get();
      if (!current.exists || current.data()?.accountDeletionProcessing !== true ||
          current.data()?.accountDeleteRequested !== true) continue;

      // 先撤銷 Authentication，防止刪除期間再次登入。
      try {
        await auth.deleteUser(uid);
      } catch (error) {
        if (error.code !== 'auth/user-not-found') throw error;
      }
      // 遞迴清除 users/{uid} 的所有子集合，避免原本 batch 500 筆上限。
      // 其他頂層集合、Storage 尚須依實際資料歸屬另外清點，不能盲刪。
      await db.recursiveDelete(userRef);
      logger.info('✅ 已清除 Auth 與 users 子樹', {uid});
    } catch (error) {
      logger.error('❌ 刪除帳號失敗，下次排程將重試', {uid, error: String(error)});
    }
  }
};
  return {getAccountDeletionStatus,requestDeleteAccount,cancelDeleteAccount,checkScheduledDelete};
}
module.exports = {createAccountDeletionHandlers};
