'use strict';

// V73: Public character translation + persistent translation cache.
// Firebase onCall options remain at the root registration site.
function createCharacterTranslationHandler({
  HttpsError, db, APP_ID, crypto, FieldValue,
  CHARACTER_TRANSLATION_TARGETS, normalizeCharacterLocale,
  buildCharacterSourcePayload, translateCharacterPayload,
}) {
  return async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "請先登入。",
      );
    }

    const characterId = String(
      request.data?.characterId || "",
    ).trim();

    const targetLocale = normalizeCharacterLocale(
      request.data?.targetLocale,
    );

    const force = request.data?.force === true;

    if (!characterId) {
      throw new HttpsError(
        "invalid-argument",
        "缺少角色 ID。",
      );
    }

    if (
      !Object.prototype.hasOwnProperty.call(
        CHARACTER_TRANSLATION_TARGETS,
        targetLocale,
      )
    ) {
      throw new HttpsError(
        "invalid-argument",
        "不支援的目標語言。",
      );
    }

    const charRef = db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("public_characters")
      .doc(characterId);

    const charSnap = await charRef.get();

    if (!charSnap.exists) {
      throw new HttpsError(
        "not-found",
        "找不到角色。",
      );
    }

    const data = charSnap.data() || {};

    if (
      data.isPublic !== true ||
      String(data.status || "") !== "published"
    ) {
      throw new HttpsError(
        "permission-denied",
        "此角色目前不可翻譯。",
      );
    }

    const sourceLocale = normalizeCharacterLocale(
      data.content_language || "zh_Hant",
    );

    const sourcePayload = buildCharacterSourcePayload(data);

    const sourceHash = crypto
      .createHash("sha256")
      .update(JSON.stringify(sourcePayload))
      .digest("hex");

    if (targetLocale === sourceLocale) {
      return {
        success: true,
        locale: targetLocale,
        sourceLocale,
        cached: true,
        translation: sourcePayload,
      };
    }

    const existingTranslations =
      data.translations &&
      typeof data.translations === "object"
        ? data.translations
        : {};

    const cached = existingTranslations[targetLocale];

    if (
      !force &&
      cached &&
      typeof cached === "object" &&
      cached.__sourceHash === sourceHash
    ) {
      const {
        __sourceHash,
        __translatedAt,
        ...publicCached
      } = cached;

      return {
        success: true,
        locale: targetLocale,
        sourceLocale,
        cached: true,
        translation: publicCached,
      };
    }

    const targetLanguage =
      CHARACTER_TRANSLATION_TARGETS[targetLocale];

    const translated = await translateCharacterPayload(
      sourcePayload,
      targetLanguage,
    );

    const storedTranslation = {
      ...translated,
      __sourceHash: sourceHash,
      __translatedAt: new Date().toISOString(),
    };

    await charRef.set(
      {
        translations: {
          [targetLocale]: storedTranslation,
        },
        translationUpdatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    console.log("🌍 角色翻譯完成", {
      characterId,
      sourceLocale,
      targetLocale,
      fields: Object.keys(translated),
    });

    return {
      success: true,
      locale: targetLocale,
      sourceLocale,
      cached: false,
      translation: translated,
    };
  };
}

module.exports = {createCharacterTranslationHandler};
