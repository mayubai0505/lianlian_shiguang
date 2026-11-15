'use strict';
// Reward campaign admin handlers. Firebase onCall metadata remains in core.js.
function createCampaignAdminHandlers({db, APP_ID, FieldValue, HttpsError, requireRewardCampaignAdmin, parseRewardCampaignDate}) {
  return {
    createRewardCampaignUs: async (request) => {
    const adminUid =
      requireRewardCampaignAdmin(request);

    const data = request.data || {};

    const title = String(
      data.title || ""
    ).trim();

    const description = String(
      data.description || ""
    ).trim();

    const rewardType = String(
      data.rewardType || "flowerPoints"
    ).trim();

    const rewardAmount = Number(
      data.rewardAmount || 0
    );

const rawAudience = String(
  data.audience || "admin_only"
).trim();

const audienceType =
  rawAudience === "all_users"
    ? "all"
    : "targeted";

const targetUserIds =
  audienceType === "all"
    ? []
    : [adminUid];

    const startAt = parseRewardCampaignDate(
      data.startAt,
      "開始時間"
    );

    const endAt = parseRewardCampaignDate(
      data.endAt,
      "結束時間"
    );

    if (!title) {
      throw new HttpsError(
        "invalid-argument",
        "請輸入活動標題"
      );
    }

    if (!description) {
      throw new HttpsError(
        "invalid-argument",
        "請輸入活動說明"
      );
    }

    if (!["flowerPoints", "avatar_frame", "sticker"].includes(rewardType)) {
      throw new HttpsError("invalid-argument", "不支援此禮物類型");
    }

    const rewardItemRaw = data.rewardItem && typeof data.rewardItem === "object"
      && !Array.isArray(data.rewardItem) ? data.rewardItem : {};
    const itemName = String(rewardItemRaw.name || "").trim().slice(0, 100);
    const imageUrl = String(rewardItemRaw.imageUrl || "").trim();
    const visualTags = Array.isArray(rewardItemRaw.visualTags)
      ? rewardItemRaw.visualTags.map(x => String(x).trim()).filter(Boolean).slice(0, 12)
      : [];
    const rewardItem = rewardType === "flowerPoints" ? null : {
      itemType: rewardType,
      name: itemName,
      imageUrl,
      ...(rewardType === "sticker" ? {
        stickerName: String(rewardItemRaw.stickerName || itemName).trim().slice(0, 100),
        visualTags,
        baseEmotion: String(rewardItemRaw.baseEmotion || "").trim().slice(0, 100),
        visualDescription: String(rewardItemRaw.visualDescription || "").trim().slice(0, 1200),
        analysisSource: String(rewardItemRaw.analysisSource || "manual").trim() === "ai" ? "ai" : "manual",
      } : {}),
    };
    if (rewardType === "flowerPoints") {
      if (!Number.isInteger(rewardAmount) || rewardAmount <= 0 || rewardAmount > 10000) {
        throw new HttpsError("invalid-argument", "花花數量必須是 1～10000 的整數");
      }
    } else {
      if (!itemName || !/^https:\/\//i.test(imageUrl) || imageUrl.length > 2048) {
        throw new HttpsError("invalid-argument", "請填寫禮物名稱並上傳有效的 HTTPS 圖片");
      }
      if (rewardType === "sticker" &&
          (!rewardItem.stickerName || !rewardItem.visualDescription)) {
        throw new HttpsError("invalid-argument", "貼紙需要名稱與圖像描述，請先執行 AI 分析或手動補齊");
      }
    }

    if (endAt <= startAt) {
      throw new HttpsError(
        "invalid-argument",
        "結束時間必須晚於開始時間"
      );
    }

    const campaignRef = db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("reward_campaigns")
      .doc();

    await campaignRef.set({
      title,
      description,
       rewardType,
       rewardAmount: rewardType === "flowerPoints" ? rewardAmount : 0,
       ...(rewardItem ? { rewardItem } : {}),

      audienceType,
      targetUserIds,

      startAt,
      endAt,
      status: "active",

      createdBy: adminUid,
      createdAt:
        FieldValue.serverTimestamp(),
      updatedAt:
        FieldValue.serverTimestamp(),
    });

    console.log(
      "🎁 已建立活動禮物",
      {
        campaignId: campaignRef.id,
        title,
        rewardAmount,
        adminUid,
      }
    );

    return {
      success: true,
      campaignId: campaignRef.id,
    };
  },
    disableRewardCampaignUs: async (request) => {
    const adminUid =
      requireRewardCampaignAdmin(request);

    const campaignId = String(
      request.data?.campaignId || ""
    ).trim();

    if (!campaignId) {
      throw new HttpsError(
        "invalid-argument",
        "缺少活動編號"
      );
    }

    const campaignRef = db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("reward_campaigns")
      .doc(campaignId);

    const snapshot =
      await campaignRef.get();

    if (!snapshot.exists) {
      throw new HttpsError(
        "not-found",
        "找不到這個活動"
      );
    }

    await campaignRef.update({
      status: "disabled",
      disabledBy: adminUid,
      disabledAt:
        FieldValue.serverTimestamp(),
      updatedAt:
        FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      campaignId,
    };
  },
    listRewardCampaignsUs: async (request) => {
    requireRewardCampaignAdmin(request);

    const snapshot = await db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("reward_campaigns")
      .orderBy("createdAt", "desc")
      .limit(50)
      .get();

    const campaigns = snapshot.docs.map(
      (document) => {
        const data = document.data();

        return {
          id: document.id,

          title:
            String(data.title || ""),

          description:
            String(
              data.description || ""
            ),

          rewardType:
            String(
              data.rewardType ||
              "flowerPoints"
            ),

           rewardAmount:
             Number(
               data.rewardAmount || 0
             ),

           rewardItem: data.rewardItem || null,

          audienceType:
            String(
              data.audienceType || "all"
            ),

          status:
            String(
              data.status || "active"
            ),

          startAt:
            data.startAt
              ?.toDate?.()
              ?.toISOString?.() || "",

          endAt:
            data.endAt
              ?.toDate?.()
              ?.toISOString?.() || "",

          createdAt:
            data.createdAt
              ?.toDate?.()
              ?.toISOString?.() || "",
        };
      }
    );

    return {
      success: true,
      campaigns,
    };
  },
  };
}
module.exports = {createCampaignAdminHandlers};
