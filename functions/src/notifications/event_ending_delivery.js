'use strict';
// Original V62 notification-delivery logic, dependency-injected without changing behavior.
function createEventEndingDelivery({db, normalizeNotificationLocale, getEventEndingNotificationText, sendToUserDevices}) {
async function sendEventEndingNotificationToAllUsers({
    eventId,
    eventName,
    currencyName,
    stage,
}) {
    const usersSnapshot =
        await db.collection("users").get();

    let successUsers = 0;
    let failedUsers = 0;

    const batchSize = 20;

    for (
        let start = 0;
        start < usersSnapshot.docs.length;
        start += batchSize
    ) {
        const batchDocs =
            usersSnapshot.docs.slice(
                start,
                start + batchSize
            );

        const results =
            await Promise.allSettled(
                batchDocs.map(
                    async (userDoc) => {
                        const userId =
                            userDoc.id;

                        const userData =
                            userDoc.data() || {};

                        const locale =
                            normalizeNotificationLocale(
                                userData.notificationLocale ||
                                userData.locale ||
                                userData.languageCode ||
                                userData.language ||
                                "zh_Hant"
                            );

                        const text =
                            getEventEndingNotificationText(
                                locale,
                                {
                                    eventName,
                                    currencyName,
                                    stage,
                                }
                            );

                        return await sendToUserDevices(
                            userId,
                            {
                                notification: {
                                    title: text.title,
                                    body: text.body,
                                },
                                data: {
                                    type: "event_ending",
                                    eventId:
                                        String(eventId),
                                    stage:
                                        String(stage),
                                    click_action:
                                        "FLUTTER_NOTIFICATION_CLICK",
                                },
                                android: {
                                    priority: "high",
                                    notification: {
                                        channelId:
                                            "high_importance_channel",
                                        sound: "default",
                                        defaultVibrateTimings:
                                            true,
                                    },
                                },
                                apns: {
                                    headers: {
                                        "apns-priority": "10",
                                    },
                                    payload: {
                                        aps: {
                                            sound: "default",
                                        },
                                    },
                                },
                            }
                        );
                    }
                )
            );

        for (const result of results) {
            if (result.status === "fulfilled") {
                if ((result.value?.successCount || 0) > 0) successUsers++;
                else failedUsers++;
            } else {
                failedUsers++;
                console.error(
                    "❌ 活動結束提醒推播失敗：",
                    result.reason?.message ||
                    result.reason ||
                    "unknown"
                );
            }
        }
    }

    return {
        successUsers,
        failedUsers,
        totalUsers:
            usersSnapshot.size,
    };
}

return {sendEventEndingNotificationToAllUsers};
}
module.exports = {createEventEndingDelivery};
