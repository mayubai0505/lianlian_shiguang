'use strict';
// 官方公告翻譯：只搬移原有工具，維持既有 13 語系與 fallback。
function createAnnouncementTranslationTools({getTranslateClient}) {
  if (typeof getTranslateClient !== 'function') throw new TypeError('getTranslateClient required');
  const ANNOUNCEMENT_TRANSLATION_TARGETS = {
    zh_Hans: "zh-CN",
    en: "en",
    ja: "ja",
    ko: "ko",
    vi: "vi",
    id: "id",
    th: "th",
    ar: "ar",
    fr: "fr",
    ms: "ms",
    es: "es",
    hi: "hi",
    pt: "pt",
  };
  
  async function translateAnnouncementForLocale(title, content, targetLanguage) {
    const translateClient = getTranslateClient();
  
    const [translated] = await translateClient.translate(
      [title, content],
      targetLanguage,
    );
  
    const result = Array.isArray(translated) ? translated : [translated];
    return {
      title: String(result[0] || title).trim(),
      content: String(result[1] || content).trim(),
    };
  }

  return {ANNOUNCEMENT_TRANSLATION_TARGETS,translateAnnouncementForLocale};
}
module.exports = {createAnnouncementTranslationTools};
