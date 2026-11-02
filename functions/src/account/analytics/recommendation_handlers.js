'use strict';
// V40: 推薦事件紀錄與推薦開聊轉換查詢。原處理器本體不變，注入 Firebase 相依。
function createRecommendationHandlers({db,FieldValue,HttpsError,getRecommendationTaipeiDateKey,requireRewardCampaignAdmin}) {
  return {
    recordRecommendationEvent: async (request) => {
    const uid = request.auth?.uid;

    if (!uid) {
      throw new HttpsError(
        "unauthenticated",
        "請先登入"
      );
    }

    const data = request.data || {};

    const type =
      typeof data.type === "string"
        ? data.type.trim()
        : "";

    const characterId =
      typeof data.characterId === "string"
        ? data.characterId.trim()
        : "";

    const source =
      typeof data.source === "string"
        ? data.source.trim()
        : "";

    const allowedTypes = new Set([
      "click",
      "chat_start",
    ]);

    const allowedSources = new Set([
      "recommendation_banner",
      "popular_recommendation",
    ]);

    if (!allowedTypes.has(type)) {
      throw new HttpsError(
        "invalid-argument",
        "無效的推薦事件類型"
      );
    }

    if (!allowedSources.has(source)) {
      throw new HttpsError(
        "invalid-argument",
        "無效的推薦來源"
      );
    }

    if (!characterId) {
      throw new HttpsError(
        "invalid-argument",
        "缺少 characterId"
      );
    }

    const dateKey =
      getRecommendationTaipeiDateKey();

    // 同一位玩家、同一天、同一角色、同一推薦來源：
    // click / chat_start 各只計一次。
    //
    // 避免玩家狂點造成數據膨脹。
    const safeSource =
      source.replace(/[^a-zA-Z0-9_-]/g, "_");

    const safeCharacterId =
      characterId.replace(
        /[^a-zA-Z0-9_-]/g,
        "_"
      );

    const docId =
      `${dateKey}_${uid}_${safeSource}_${safeCharacterId}_${type}`;

    const ref = db
      .collection(
        "analytics_recommendation_events"
      )
      .doc(docId);

    await ref.set(
      {
        uid,
        dateKey,
        type,
        source,
        characterId,
        recordedAt:
          FieldValue.serverTimestamp(),
      },
      {
        merge: true,
      }
    );

    return {
      success: true,
    };
  },
    getRecommendationConversionStats: async (request) => {
      requireRewardCampaignAdmin(request);

      const dateKey =
        getRecommendationTaipeiDateKey();

      const snapshot = await db
        .collection(
          "analytics_recommendation_events"
        )
        .where(
          "dateKey",
          "==",
          dateKey
        )
        .get();

      let clickCount = 0;
      let chatStartCount = 0;

      const sourceStats = {};

      for (const doc of snapshot.docs) {
        const data =
          doc.data() || {};

        const type =
          data.type?.toString() ?? "";

        const source =
          data.source?.toString() ??
          "unknown";

        if (!sourceStats[source]) {
          sourceStats[source] = {
            clicks: 0,
            chatStarts: 0,
          };
        }

        if (type === "click") {
          clickCount++;

          sourceStats[source].clicks++;
        }

        if (type === "chat_start") {
          chatStartCount++;

          sourceStats[source]
            .chatStarts++;
        }
      }

      const conversionRate =
        clickCount <= 0
          ? null
          : (
              chatStartCount /
              clickCount *
              100
            );

      return {
        dateKey,
        clicks: clickCount,
        chatStarts: chatStartCount,
        conversionRate,
        sources: sourceStats,
      };
    }
  };
}
module.exports={createRecommendationHandlers};
