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

    if (rewardType !== "flowerPoints") {
      throw new HttpsError(
        "invalid-argument",
        "目前僅支援花花點數"
      );
    }

    if (
      !Number.isInteger(rewardAmount) ||
      rewardAmount <= 0 ||
      rewardAmount > 10000
    ) {
      throw new HttpsError(
        "invalid-argument",
        "花花數量必須是 1～10000 的整數"
      );
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
      rewardAmount,

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
