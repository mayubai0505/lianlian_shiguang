'use strict';
// V56: Player-facing Voice Bank matching endpoint; unchanged ranking and fallback algorithm.
const {VOICE_MATCH_MIN_SCORE, normalizeVoiceAge, normalizeVoiceRequest, calculateVoiceMatch} = require('./matching');
function createVoiceBankMatchHandler({requireLogin,HttpsError,db,APP_ID}) {
  return async (request) => {
    requireLogin(request);

    const {
      description,
      characterName,
      gender,
      age,
    } = request.data || {};

    const normalizedDescription =
      String(description || "").trim();

    if (!normalizedDescription) {
      throw new HttpsError(
        "invalid-argument",
        "缺少聲音描述"
      );
    }

    const requestedProfile =
      normalizeVoiceRequest({
        description:
          normalizedDescription,
        gender,
        age,
      });

    console.log(
      "========== matchVoiceFromBank V2 =========="
    );
    console.log(
      "uid:",
      request.auth?.uid
    );
    console.log(
      "characterName:",
      characterName || ""
    );
    console.log(
      "description:",
      normalizedDescription
    );
    console.log(
      "requestedProfile:",
      JSON.stringify(
        requestedProfile
      )
    );

    const snapshot = await db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("voice_bank")
      .where("enabled", "==", true)
      .get();

    if (snapshot.empty) {
      throw new HttpsError(
        "not-found",
        "目前沒有可用的聲音"
      );
    }

    const scoredVoices = snapshot.docs
      .map((doc) => {
        const data = doc.data();

        const rawDefaultSettings =
          data.defaultSettings;

        const defaultSettings =
          rawDefaultSettings &&
          typeof rawDefaultSettings ===
            "object"
            ? rawDefaultSettings
            : {};

        const voiceData = {
          documentId: doc.id,

          voiceId: String(
            data.voiceId || ""
          ).trim(),

          name:
            String(
              data.name || ""
            ).trim() ||
            "未命名聲音",

          gender: String(
            data.gender || ""
          )
            .trim()
            .toLowerCase(),

          age: normalizeVoiceAge(
            data.age
          ),

          tags: Array.isArray(
            data.tags
          )
            ? data.tags
            : [],

          traits:
            data.traits &&
            typeof data.traits ===
              "object"
              ? data.traits
              : {},

          searchWeight:
            Number.isFinite(
              Number(data.searchWeight)
            )
              ? Number(
                  data.searchWeight
                )
              : 100,

          defaultSettings,

          previewUrl: String(
            data.previewUrl || ""
          ).trim(),
        };

        const matchResult =
          calculateVoiceMatch(
            requestedProfile,
            voiceData
          );

        return {
          ...voiceData,
          score: matchResult.score,
          reasons:
            matchResult.reasons,
          matchedTags:
            matchResult.matchedTags,
        };
      })
      .filter(
        (voice) =>
          voice.voiceId &&
          voice.score > -9999
      )
      .sort(
        (a, b) =>
          b.score - a.score
      );

    if (scoredVoices.length === 0) {
      throw new HttpsError(
        "not-found",
        "找不到符合條件的聲音"
      );
    }

    // 正常情況只保留達到最低門檻的聲音。
    const qualifiedMatches =
      scoredVoices.filter(
        (voice) =>
          voice.score >=
          VOICE_MATCH_MIN_SCORE
      );

    // 如果全部低於門檻，仍回傳最高分的前三個，
    // 避免前端完全無法繼續建立角色。
    const matches =
      (
        qualifiedMatches.length > 0
          ? qualifiedMatches
          : scoredVoices
      ).slice(0, 3);

    const usedFallback =
      qualifiedMatches.length === 0;

    console.log(
      "========== Voice Match Result V2 =========="
    );

    console.log(
      JSON.stringify(
        {
          minimumScore:
            VOICE_MATCH_MIN_SCORE,

          usedFallback,

          matches: matches.map(
            (voice) => ({
              voiceId:
                voice.voiceId,
              name: voice.name,
              score: voice.score,
              gender:
                voice.gender,
              age: voice.age,
              searchWeight:
                voice.searchWeight,
              tags: voice.tags,
              matchedTags:
                voice.matchedTags,
              reasons:
                voice.reasons,
            })
          ),
        }
      )
    );

    return {
      requestedProfile,

      minimumScore:
        VOICE_MATCH_MIN_SCORE,

      usedFallback,

      previews: matches.map(
        (voice) => ({
          voiceId:
            voice.voiceId,

          name:
            voice.name,

          previewUrl:
            voice.previewUrl,

          score:
            voice.score,

          tags:
            voice.tags,

          traits:
            voice.traits,

          reasons:
            voice.reasons,

          matchedTags:
            voice.matchedTags,

          searchWeight:
            voice.searchWeight,

          defaultSettings:
            voice.defaultSettings,
        })
      ),
    };
  };
}
module.exports={createVoiceBankMatchHandler};
