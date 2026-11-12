"use strict";
// Heartbeat Diary fixed daily awards. No amount, userId, date, or progress from client.
const TASKS = Object.freeze({
  dailyChatClaimed: {progress: 'dailyChatProgress', required: 3, amount: 5, title: '閒話家常'},
  storyChatClaimed: {progress: 'storyChatProgress', required: 1, amount: 5, title: '劇情推進'},
  likeClaimed: {progress: 'likeProgress', required: 3, amount: 5, title: '社群巡禮'},
  monthlyCardClaimed: {progress: null, required: 0, amount: 10, title: '星之契約'},
});
function taipeiDayKey(date) {
  return new Date(date.getTime() + 8 * 3600000).toISOString().slice(0, 10);
}
function firestoreDate(value) {
  if (!value) return null;
  if (value instanceof Date) return value;
  if (typeof value.toDate === 'function') return value.toDate();
  if (typeof value === 'string') {
    const parsed = new Date(value);
    return Number.isNaN(parsed.valueOf()) ? null : parsed;
  }
  return null;
}
function createHeartbeatTaskClaimHandler({db, FieldValue, HttpsError}) {
  return async (request) => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', '請先登入');
    const key = request.data?.taskKey;
    if (typeof key !== 'string' || !Object.prototype.hasOwnProperty.call(TASKS, key)) {
      throw new HttpsError('invalid-argument', '無效的任務');
    }
    const task = TASKS[key];
    const today = taipeiDayKey(new Date());
    const userRef = db.collection('users').doc(uid);
    const logRef = userRef.collection('flower_logs').doc(`heartbeat_${today.replace(/-/g, '')}_${key}`);
    return db.runTransaction(async (tx) => {
      const userSnap = await tx.get(userRef);
      const logSnap = await tx.get(logRef);
      if (!userSnap.exists) throw new HttpsError('not-found', '找不到玩家資料');
      const user = userSnap.data() || {};
      const resetAt = firestoreDate(user.lastTasksResetDate);
      if (!resetAt || taipeiDayKey(resetAt) !== today) {
        throw new HttpsError('failed-precondition', '今日任務進度尚未初始化');
      }
      const daily = user.dailyTasks || {};
      if (daily[key] === true || logSnap.exists) {
        return {claimed: false, alreadyClaimed: true, taskKey: key, amount: 0};
      }
      if (task.progress) {
        const progress = daily[task.progress];
        if (!Number.isInteger(progress) || progress < task.required) {
          throw new HttpsError('failed-precondition', '任務進度尚未達標');
        }
      } else {
        const until = firestoreDate(user.monthlySubEndDate);
        if (!until || until.getTime() <= Date.now()) {
          throw new HttpsError('failed-precondition', '月卡尚未生效或已過期');
        }
      }
      if (!Number.isSafeInteger(user.flowerPoints) || user.flowerPoints < 0) {
        throw new HttpsError('failed-precondition', '花花餘額資料異常');
      }
      tx.update(userRef, {
        flowerPoints: FieldValue.increment(task.amount),
        [`dailyTasks.${key}`]: true,
      });
      tx.create(logRef, {
        title: `任務完成：${task.title}`,
        amount: task.amount,
        createdAt: FieldValue.serverTimestamp(),
      });
      return {claimed: true, alreadyClaimed: false, taskKey: key, amount: task.amount};
    });
  };
}
module.exports = {createHeartbeatTaskClaimHandler, taipeiDayKey, TASKS};
