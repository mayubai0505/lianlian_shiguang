'use strict';
const {eventCollection,assertEventAccess}=require('./event_access');

function createEventDailyCheckInHandler({db, APP_ID, FieldValue, HttpsError, reusableEventIsRunning}) {
  return async (request) => {
    const userId = request.auth?.uid;
    if (!userId) throw new HttpsError('unauthenticated', '請先登入');

    const eventId = String(request.data?.eventId || '').trim();
    if (!eventId || eventId.includes('/') || eventId.length > 150) {
      throw new HttpsError('invalid-argument', '活動編號無效');
    }

    assertEventAccess(eventId,userId,HttpsError);
    const eventRef = db.collection('artifacts').doc(APP_ID).collection(eventCollection(eventId)).doc(eventId);
    const progressRef = db.collection('artifacts').doc(APP_ID)
      .collection('event_progress').doc(userId).collection('events').doc(eventId);
    const userRef = db.collection('users').doc(userId);
    // Server-side Taiwan calendar date; never trust the player's device clock.
    const dayKey = new Date(Date.now() + 8 * 3600 * 1000).toISOString().slice(0, 10);
    const claimRef = progressRef.collection('daily_checkins').doc(dayKey);
    const flowerLogRef = userRef.collection('flower_logs').doc(`event_checkin_${eventId}_${dayKey}`);

    const result = await db.runTransaction(async (transaction) => {
      // Firestore reads must precede every write.
      const [eventSnap, progressSnap, claimSnap] = await Promise.all([
        transaction.get(eventRef), transaction.get(progressRef), transaction.get(claimRef),
      ]);
      if (!eventSnap.exists) throw new HttpsError('not-found', '找不到活動');
      const event = eventSnap.data() || {};
      if (!reusableEventIsRunning(event, new Date())) {
        throw new HttpsError('failed-precondition', '活動目前未開放');
      }
      const checkIn = event.dailyCheckIn && typeof event.dailyCheckIn === 'object'
        ? event.dailyCheckIn : {};
      if (checkIn.enabled !== true) {
        throw new HttpsError('failed-precondition', '活動簽到未開放');
      }
      const rewardType = checkIn.rewardType;
      const rewardAmount = Number(checkIn.rewardAmount);
      if (!['flowerPoints', 'eventCurrency'].includes(rewardType) ||
          !Number.isSafeInteger(rewardAmount) || rewardAmount < 1 ||
          rewardAmount > (rewardType === 'flowerPoints' ? 10000 : 100000)) {
        throw new HttpsError('failed-precondition', '活動簽到獎勵設定異常');
      }
      const progress = progressSnap.data() || {};
      // Separate immutable receipt plus progress check protects against double-claims.
      if (claimSnap.exists || progress.lastCheckInDate === dayKey) {
        throw new HttpsError('already-exists', '今天已經領取簽到獎勵');
      }
      const userSnap = rewardType === 'flowerPoints' ? await transaction.get(userRef) : null;
      if (userSnap && !userSnap.exists) {
        throw new HttpsError('not-found', '找不到玩家資料');
      }
      const days = Math.max(0, Math.trunc(Number(progress.checkInDays || 0)));
      const currentCurrency = Math.max(0, Math.trunc(Number(progress.currency || 0)));
      transaction.set(progressRef, {
        userId, eventId, lastCheckInDate: dayKey, checkInDays: days + 1,
        ...(rewardType === 'eventCurrency' ? {
          currency: currentCurrency + rewardAmount,
          totalEarned: FieldValue.increment(rewardAmount),
        } : {}),
        updatedAt: FieldValue.serverTimestamp(),
      }, {merge: true});
      transaction.create(claimRef, {
        eventId, userId, dayKey, rewardType, rewardAmount,
        claimedAt: FieldValue.serverTimestamp(),
      });
      if (rewardType === 'flowerPoints') {
        transaction.update(userRef, {flowerPoints: FieldValue.increment(rewardAmount)});
        transaction.set(flowerLogRef, {
          title: `${String(event.name || '活動')}每日簽到`,
          amount: rewardAmount, type: 'reward_campaign',
          reason: 'reusable_event_daily_checkin', source: 'event_daily_checkin',
          eventId, dayKey, createdAt: FieldValue.serverTimestamp(),
        });
      }
      return {eventId, dayKey, rewardType, rewardAmount, checkInDays: days + 1,
        ...(rewardType === 'eventCurrency' ? {currency: currentCurrency + rewardAmount} : {})};
    });
    console.log('✅ EVENT DAILY CHECKIN CLAIMED', {
      eventId: result.eventId, dayKey: result.dayKey, rewardType: result.rewardType,
      rewardAmount: result.rewardAmount,
    });
    return {success: true, ...result};
  };
}

module.exports = {createEventDailyCheckInHandler};
