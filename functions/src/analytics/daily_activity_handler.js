'use strict';
// 玩家每日活躍記錄；保留原本驗證、當日去重與寫入行為。
function createDailyActivityHandler({db,auth,FieldValue,HttpsError,getAnalyticsTaipeiDateKey}) {
  return async (request) => {
    const uid = request.auth?.uid;

    if (!uid) {
      throw new HttpsError(
        "unauthenticated",
        "請先登入"
      );
    }

    const todayKey =
      getAnalyticsTaipeiDateKey();

    const activityId =
      `${todayKey}_${uid}`;

    const activityRef = db
      .collection("analytics_user_activity")
      .doc(activityId);

    // 同一玩家同一天只建立一次
    const existing =
      await activityRef.get();

    if (existing.exists) {
      return {
        success: true,
        alreadyRecorded: true,
        dateKey: todayKey,
      };
    }

    // Firebase Auth 的建立時間比讓前端自己傳安全
    const authUser =
      await auth.getUser(uid);

    const creationTime =
      authUser.metadata?.creationTime
        ? new Date(
            authUser.metadata.creationTime
          )
        : new Date();

    const registrationDateKey =
      getAnalyticsTaipeiDateKey(
        creationTime
      );

    await activityRef.set({
      uid,
      dateKey: todayKey,
      registrationDateKey,

      recordedAt:
        FieldValue.serverTimestamp(),

      source: "app_open",
    });

    return {
      success: true,
      alreadyRecorded: false,
      dateKey: todayKey,
      registrationDateKey,
    };
  };
}
module.exports = {createDailyActivityHandler};
