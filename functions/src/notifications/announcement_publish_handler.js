'use strict';
// V66: original announcement publish handler, dependencies injected.
function createAnnouncementPublishHandler({requireRewardCampaignAdmin,HttpsError,ANNOUNCEMENT_TRANSLATION_TARGETS,translateAnnouncementForLocale,db,FieldValue}) {
  return async (request) => {
    const adminUid = requireRewardCampaignAdmin(request);

    const title = String(request.data?.title || "").trim();
    const content = String(request.data?.content || "").trim();
    const sendNotification = request.data?.sendNotification !== false;

    if (!title) {
      throw new HttpsError("invalid-argument", "公告標題不能為空");
    }
    if (!content) {
      throw new HttpsError("invalid-argument", "公告內容不能為空");
    }
    if (title.length > 150) {
      throw new HttpsError("invalid-argument", "公告標題不能超過 150 字");
    }
    if (content.length > 10000) {
      throw new HttpsError("invalid-argument", "公告內容不能超過 10000 字");
    }

    const translations = {};
    const translationFailures = [];

    // 每一個語系互不牽連；單一語言翻譯失敗時仍可發布公告，
    // 該語系前端會自動 fallback 到繁中原文。
    const translationResults = await Promise.allSettled(
      Object.entries(ANNOUNCEMENT_TRANSLATION_TARGETS).map(
        async ([localeKey, targetLanguage]) => {
          const translated = await translateAnnouncementForLocale(
            title,
            content,
            targetLanguage,
          );
          return { localeKey, translated };
        },
      ),
    );

    for (let i = 0; i < translationResults.length; i++) {
      const result = translationResults[i];
      const localeKey = Object.keys(ANNOUNCEMENT_TRANSLATION_TARGETS)[i];

      if (result.status === "fulfilled") {
        translations[result.value.localeKey] = result.value.translated;
      } else {
        translationFailures.push(localeKey);
        console.error(
          `❌ 公告翻譯失敗 locale=${localeKey}:`,
          result.reason,
        );
      }
    }

    const announcementRef = db.collection("announcements").doc();
    const batch = db.batch();

    batch.set(announcementRef, {
      title,
      content,
      sourceLocale: "zh_Hant",
      translations,
      translationStatus:
        translationFailures.length === 0 ? "complete" : "partial",
      translationFailures,
      publishedBy: adminUid,
      createdAt: FieldValue.serverTimestamp(),
    });

    if (sendNotification) {
      const notifyRef = db.collection("system_notifications").doc();
      batch.set(notifyRef, {
        type: "global_announcement",
        announcementId: announcementRef.id,
        createdAt: FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();

    console.log("📢 公告已發布並完成翻譯", {
      announcementId: announcementRef.id,
      translationCount: Object.keys(translations).length,
      translationFailures,
      sendNotification,
    });

    return {
      success: true,
      announcementId: announcementRef.id,
      translatedLocales: Object.keys(translations),
      translationFailures,
      sendNotification,
    };
  };
}
module.exports = {createAnnouncementPublishHandler};
