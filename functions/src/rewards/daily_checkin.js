"use strict";

// Firebase Functions v2 callable; server owns reward amount, eligibility and writes.
// Set DAILY_CHECK_IN_FLOWERS in functions/.env and keep it aligned with
// AppConfig.dailyCheckIn in the released Flutter app. Do NOT accept an amount from client.
const DAY_MS = 24 * 60 * 60 * 1000;
function taipeiDayKey(date) {
  return new Date(date.getTime() + 8 * 60 * 60 * 1000)
    .toISOString().slice(0, 10);
}
function toDate(value) {
  if (!value) return null;
  if (typeof value.toDate === 'function') return value.toDate();
  if (value instanceof Date) return value;
  return null;
}
function rewardAmountFromEnvironment(HttpsError) {
  const raw = process.env.DAILY_CHECK_IN_FLOWERS;
  const amount = Number(raw);
  if (!raw || !Number.isInteger(amount) || amount < 1 || amount > 30) {
    throw new HttpsError('failed-precondition', '每日簽到獎勵尚未在後端正確設定');
  }
  return amount;
}
function createDailyCheckInHandler({db, FieldValue, HttpsError}) {
  return async (request) => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', '請先登入');
    // No client-supplied amount, date, userId or reason is trusted.
    const amount = rewardAmountFromEnvironment(HttpsError);
    const today = taipeiDayKey(new Date());
    const logId = `daily_check_in_${today.replace(/-/g, '')}`;
    const userRef = db.collection('users').doc(uid);
    const logRef = userRef.collection('flower_logs').doc(logId);
    const result = await db.runTransaction(async (tx) => {
      // Firestore requires all reads before writes.
      const userSnap = await tx.get(userRef);
      const logSnap = await tx.get(logRef);
      if (!userSnap.exists) throw new HttpsError('not-found', '找不到玩家資料');
      const userData = userSnap.data() || {};
      const lastDate = toDate(userData.lastCheckInDate);
      if ((lastDate && taipeiDayKey(lastDate) === today) || logSnap.exists) {
        return {claimed: false, alreadyClaimed: true, day: today, amount: 0};
      }
      if (!Number.isSafeInteger(userData.flowerPoints) || userData.flowerPoints < 0) {
        throw new HttpsError('failed-precondition', '玩家花花餘額資料異常');
      }
      tx.update(userRef, {
        flowerPoints: FieldValue.increment(amount),
        lastCheckInDate: FieldValue.serverTimestamp(),
      });
      // Keep legacy client log schema for existing UI and analytics readers.
      tx.create(logRef, {
        title: '每日簽到',
        amount,
        createdAt: FieldValue.serverTimestamp(),
      });
      return {claimed: true, alreadyClaimed: false, day: today, amount};
    });
    return result;
  };
}
module.exports = {createDailyCheckInHandler, taipeiDayKey};
