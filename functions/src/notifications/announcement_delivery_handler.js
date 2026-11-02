'use strict';
// V67: original announcement notification delivery, Firebase event passed through unchanged.
function createAnnouncementDeliveryHandler({db,normalizeNotificationLocale,getNotificationText,sendToUserDevices}) {
  return async (event) => {
        const snapshot = event.data;
        if (!snapshot) return null;

        const notificationData = snapshot.data() || {};
        if (notificationData.type !== "global_announcement") return null;

        const announcementId = String(
            notificationData.announcementId || ""
        ).trim();

        try {
            let announcementData = {};
            if (announcementId) {
                const announcementSnapshot = await db
                    .collection("announcements")
                    .doc(announcementId)
                    .get();
                if (announcementSnapshot.exists) {
                    announcementData = announcementSnapshot.data() || {};
                }
            }

            const originalTitle = String(announcementData.title || "").trim();
            const originalContent = String(announcementData.content || "").trim();
            const translations = announcementData.translations &&
                typeof announcementData.translations === "object"
                ? announcementData.translations
                : {};

            const usersSnapshot = await db.collection("users").get();
            let successUsers = 0;
            let failedUsers = 0;

            for (const userDoc of usersSnapshot.docs) {
                const userId = userDoc.id;
                const userData = userDoc.data() || {};
                const locale = normalizeNotificationLocale(
                    userData.notificationLocale ||
                    userData.locale ||
                    userData.languageCode ||
                    userData.language ||
                    "zh_Hant"
                );

                const translated = translations[locale] &&
                    typeof translations[locale] === "object"
                    ? translations[locale]
                    : null;

                const genericText = getNotificationText(locale, "announcement");
                const localizedTitle = String(
                    translated?.title || originalTitle || genericText.title
                ).trim();
                const localizedContent = String(
                    translated?.content || originalContent || genericText.body
                ).trim();
                const localizedBody = localizedContent.length > 140
                    ? `${localizedContent.slice(0, 137)}...`
                    : localizedContent;

                try {
                    const sendResult = await sendToUserDevices(userId, {
                        notification: {
                            title: localizedTitle,
                            body: localizedBody || genericText.body,
                        },
                        data: {
                            type: "global_announcement",
                            announcementId,
                            notificationId: event.params.notificationId,
                        },
                        android: {
                            priority: "high",
                            notification: {
                                channelId: "high_importance_channel",
                                sound: "default",
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
                    });
                    if ((sendResult?.successCount || 0) > 0) successUsers++;
                    else failedUsers++;
                } catch (error) {
                    failedUsers++;
                    console.error(
                        `公告推播失敗 user=${userId}`,
                        error?.message || error
                    );
                }
            }

            console.log(
                `全服公告推播完成：successUsers=${successUsers}, failedUsers=${failedUsers}`
            );
            return null;
        } catch (error) {
            console.error("全服公告推播發生錯誤：", error);
            return null;
        }
  };
}
module.exports = {createAnnouncementDeliveryHandler};
