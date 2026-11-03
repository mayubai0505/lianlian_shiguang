// V86: Event-ending scheduler logic, separated from its existing Firebase schedule registration.
// Keep the original transactional claim and at-most-once delivery semantics.
'use strict';

function createEventEndingScheduler({db, APP_ID, FieldValue, sendEventEndingNotificationToAllUsers}) {
  return async () => {
            const now =
                new Date();

            const eventsSnapshot =
                await db
                    .collection("artifacts")
                    .doc(APP_ID)
                    .collection("events")
                    .where(
                        "isActive",
                        "==",
                        true
                    )
                    .limit(20)
                    .get();

            if (eventsSnapshot.empty) {
                console.log(
                    "⏳ 目前沒有啟用中的活動"
                );
                return null;
            }

            for (
                const eventDoc
                of eventsSnapshot.docs
            ) {
                const eventData =
                    eventDoc.data() || {};

                const endAt =
                    eventData.endAt
                        ?.toDate?.();

                if (!endAt) continue;

                const msLeft =
                    endAt.getTime() -
                    now.getTime();

                if (msLeft <= 0) {
                    continue;
                }

                const hoursLeft =
                    msLeft /
                    (60 * 60 * 1000);

                let stage = null;
                let sentField = null;

                // 3 天提醒：48～72 小時區間內第一次掃到就送。
                if (
                    hoursLeft > 48 &&
                    hoursLeft <= 72
                ) {
                    stage = "3d";
                    sentField =
                        "ending3DaysSentAt";
                }
                // 最後一天提醒：0～24 小時區間內第一次掃到就送。
                else if (
                    hoursLeft > 0 &&
                    hoursLeft <= 24
                ) {
                    stage = "1d";
                    sentField =
                        "ending1DaySentAt";
                }

                if (!stage || !sentField) {
                    continue;
                }

                // 原子性搶佔階段：避免排程重疊／重新啟動重送全服通知。
                // 保守採 at-most-once 自動派送：若中途故障，需檢查
                // notificationState.<stage>Dispatch 狀態後人工補送，
                // 不可直接清除鎖重跑，否則先前成功者會重複收到。
                const dispatchField = `${stage}Dispatch`;
                const claimed = await db.runTransaction(async (tx) => {
                    const fresh = await tx.get(eventDoc.ref);
                    if (!fresh.exists) return false;
                    const freshData = fresh.data() || {};
                    const state = freshData.notificationState || {};
                    if (state[sentField] || state[dispatchField]) return false;
                    tx.update(eventDoc.ref, {
                        [`notificationState.${dispatchField}`]: {
                            status: "sending",
                            startedAt: FieldValue.serverTimestamp(),
                            claimId: `${eventDoc.id}_${stage}`,
                        },
                    });
                    return true;
                });
                if (!claimed) continue;

                const eventName =
                    String(
                        eventData.name ||
                        "期間限定活動"
                    ).trim();

                const currencyName =
                    String(
                        eventData.currencyName ||
                        "活動貨幣"
                    ).trim();

                console.log(
                    "⏳ 準備發送活動結束提醒",
                    {
                        eventId:
                            eventDoc.id,
                        eventName,
                        stage,
                        hoursLeft:
                            Number(
                                hoursLeft
                                    .toFixed(2)
                            ),
                    }
                );

                let result;
                try {
                    result = await sendEventEndingNotificationToAllUsers({
                        eventId: eventDoc.id,
                        eventName,
                        currencyName,
                        stage,
                    });
                    await eventDoc.ref.update({
                        [`notificationState.${sentField}`]: FieldValue.serverTimestamp(),
                        [`notificationState.${dispatchField}.status`]: "completed",
                        [`notificationState.${dispatchField}.completedAt`]: FieldValue.serverTimestamp(),
                        [`notificationState.${stage}LastResult`]: result,
                        updatedAt: FieldValue.serverTimestamp(),
                    });
                } catch (error) {
                    await eventDoc.ref.update({
                        [`notificationState.${dispatchField}.status`]: "needs_review",
                        [`notificationState.${dispatchField}.error`]: String(error?.message || error).slice(0, 500),
                        [`notificationState.${dispatchField}.failedAt`]: FieldValue.serverTimestamp(),
                    }).catch((logError) => console.error("無法記錄提醒失敗", logError));
                    console.error("活動提醒派送中斷，已停止自動重送以防玩家重複收訊", eventDoc.id, stage, error);
                    continue;
                }

                console.log(
                    "✅ 活動結束提醒完成",
                    {
                        eventId:
                            eventDoc.id,
                        stage,
                        ...result,
                    }
                );
            }

            return null;
        }
}

module.exports = {createEventEndingScheduler};
