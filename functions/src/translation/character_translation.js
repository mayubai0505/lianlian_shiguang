"use strict";
const { protectCharacterTranslationTokens, restoreCharacterTranslationTokens } = require("./token_protection");

function createCharacterTranslationTools({getTranslateClient}) {
const CHARACTER_TRANSLATION_TARGETS = {
  zh_Hans: "zh-CN",
  zh_Hant: "zh-TW",
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

function normalizeCharacterLocale(value) {
  const raw = String(value || "")
    .trim()
    .replace(/-/g, "_")
    .toLowerCase();

  if (
    raw === "zh" ||
    raw === "zh_tw" ||
    raw === "zh_hant" ||
    raw === "zh_hk" ||
    raw === "zh_mo"
  ) {
    return "zh_Hant";
  }

  if (
    raw === "zh_cn" ||
    raw === "zh_hans" ||
    raw === "zh_sg"
  ) {
    return "zh_Hans";
  }

  const code = raw.split("_")[0];
  return Object.prototype.hasOwnProperty.call(
    CHARACTER_TRANSLATION_TARGETS,
    code,
  )
    ? code
    : "zh_Hant";
}

function buildCharacterSourcePayload(data) {
  const stringFields = [
    "occupation",
    "storySummary",
    "story",
    "storyModeFirstLine",
    "background",
    "coreCharacterSetting",
    "detailedPersonality",
    "appearance",
    "toneAndStyle",
    "likes",
    "dislikes",
    "secrets",
    "initialRelationship",
    "dialogueExamples",
    "stageStranger",
    "stageAcquaintance",
    "stageIntimate",
    "socialInteraction",
    "playerIdentity",
  ];

  const listFields = [
    "personalityTags",
    "extraInfoItems",
    "identities",
  ];

  const payload = {};

  for (const field of stringFields) {
    const value = String(data?.[field] || "").trim();
    if (value) payload[field] = value;
  }

  for (const field of listFields) {
    const values = Array.isArray(data?.[field])
      ? data[field]
          .map((item) => String(item || "").trim())
          .filter(Boolean)
      : [];

    if (values.length > 0) payload[field] = values;
  }

  if (
    data?.relationships &&
    typeof data.relationships === "object" &&
    !Array.isArray(data.relationships)
  ) {
    const relationships = {};
    for (const [key, value] of Object.entries(data.relationships)) {
      const text = String(value || "").trim();
      if (text) relationships[key] = text;
    }
    if (Object.keys(relationships).length > 0) {
      payload.relationships = relationships;
    }
  }

  return payload;
}


async function translateCharacterPayload(payload, targetLanguage) {
  const translateClient = getTranslateClient();

  const descriptors = [];
  const texts = [];

  const queueText = (field, value, extra = {}) => {
    const protectedValue = protectCharacterTranslationTokens(value);
    descriptors.push({
      field,
      tokens: protectedValue.tokens,
      ...extra,
    });
    texts.push(protectedValue.protectedText);
  };

  for (const [field, value] of Object.entries(payload)) {
    if (typeof value === "string") {
      queueText(field, value);
      continue;
    }

    if (Array.isArray(value)) {
      value.forEach((item, index) => {
        queueText(field, item, { index, kind: "list" });
      });
      continue;
    }

    if (value && typeof value === "object") {
      for (const [key, item] of Object.entries(value)) {
        queueText(field, item, { key, kind: "map" });
      }
    }
  }

  if (texts.length === 0) return {};

  const [translatedRaw] = await translateClient.translate(
    texts,
    targetLanguage,
  );

  const translated = Array.isArray(translatedRaw)
    ? translatedRaw
    : [translatedRaw];

  const result = {};

  descriptors.forEach((descriptor, index) => {
    const value = restoreCharacterTranslationTokens(
      translated[index] ?? texts[index],
      descriptor.tokens,
    ).trim();

    if (descriptor.kind === "list") {
      if (!Array.isArray(result[descriptor.field])) {
        result[descriptor.field] = [];
      }
      result[descriptor.field][descriptor.index] = value;
      return;
    }

    if (descriptor.kind === "map") {
      if (
        !result[descriptor.field] ||
        typeof result[descriptor.field] !== "object"
      ) {
        result[descriptor.field] = {};
      }
      result[descriptor.field][descriptor.key] = value;
      return;
    }

    result[descriptor.field] = value;
  });

  return result;
}


return {CHARACTER_TRANSLATION_TARGETS,normalizeCharacterLocale,buildCharacterSourcePayload,translateCharacterPayload};
}
module.exports = {createCharacterTranslationTools};
