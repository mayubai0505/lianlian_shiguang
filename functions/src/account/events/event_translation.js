'use strict';
// 通用活動翻譯工具：保留原本欄位取值、空字串、翻譯陣列及 fallback 行為。
function createEventTranslationTools({getTranslateClient}) {
  if (typeof getTranslateClient !== 'function') throw new TypeError('getTranslateClient required');
  const EVENT_TRANSLATION_TARGETS = {
    zh_Hant: null,
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
  
  function eventTextRecord(source, keys) {
    const result = {};
  
    for (const key of keys) {
      const value = source?.[key];
  
      if (typeof value === "string" && value.trim()) {
        result[key] = value.trim();
      }
    }
  
    return result;
  }
  
  async function translateEventTextRecord(record, targetLanguage) {
    const entries = Object.entries(record || {})
      .filter(([, value]) => typeof value === "string" && value.trim());
  
    if (entries.length === 0) return {};
  
    if (!targetLanguage) {
      return Object.fromEntries(entries);
    }
  
    const translateClient = getTranslateClient();
  
    const sourceTexts = entries.map(([, value]) => value);
  
    const [translatedRaw] =
      await translateClient.translate(
        sourceTexts,
        targetLanguage
      );
  
    const translatedTexts =
      Array.isArray(translatedRaw)
        ? translatedRaw
        : [translatedRaw];
  
    const result = {};
  
    entries.forEach(([key], index) => {
      result[key] =
        String(
          translatedTexts[index] ??
          sourceTexts[index] ??
          ""
        ).trim();
    });
  
    return result;
  }
  return {EVENT_TRANSLATION_TARGETS,eventTextRecord,translateEventTextRecord};
}
module.exports={createEventTranslationTools};
