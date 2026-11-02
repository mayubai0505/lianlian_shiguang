'use strict';
// Reward campaign player handlers; Firebase region/options remain in core.js.
function createRewardCampaignPlayerHandlers({db, APP_ID, FieldValue, HttpsError}) {
  return {
    syncRewardCampaignsToMailbox: async (request) => {
    const userId = request.auth?.uid;

    if (!userId) {
      throw new HttpsError(
        "unauthenticated",
        "請先登入"
      );
    }

    const now = new Date();

    const campaignsSnapshot = await db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("reward_campaigns")
      .where("status", "==", "active")
      .limit(100)
      .get();

    const availableCampaigns =
      campaignsSnapshot.docs.filter(
        (document) => {
          const data = document.data();

          const startAt =
            data.startAt?.toDate?.();

          const endAt =
            data.endAt?.toDate?.();

          if (!startAt || !endAt) {
            return false;
          }

          if (now < startAt || now > endAt) {
            return false;
          }

          const audienceType =
            data.audienceType || "all";

          if (audienceType === "all") {
            return true;
          }

          const targetUserIds =
            Array.isArray(
              data.targetUserIds
            )
              ? data.targetUserIds
              : [];

          return targetUserIds.includes(
            userId
          );
        }
      );

    if (availableCampaigns.length === 0) {
      return {
        success: true,
        syncedCount: 0,
      };
    }

    const userMailboxRef = db
      .collection("users")
      .doc(userId)
      .collection("mailbox");

    const mailboxChecks =
      await Promise.all(
        availableCampaigns.map(
          async (campaignDocument) => {
            const mailRef =
              userMailboxRef.doc(
                `reward_campaign_${campaignDocument.id}`
              );

            const mailSnapshot =
              await mailRef.get();

            return {
              campaignDocument,
              mailRef,
              exists: mailSnapshot.exists,
            };
          }
        )
      );

    const batch = db.batch();
    let syncedCount = 0;

    for (const result of mailboxChecks) {
      if (result.exists) {
        continue;
      }

      const campaign =
        result.campaignDocument.data();

      batch.set(result.mailRef, {
        type: "reward_campaign",

        title:
          `🎁 ${campaign.title}`,

        body: campaign.description,

        rewardCampaignId:
          result.campaignDocument.id,

        rewardType:
          campaign.rewardType,

        rewardAmount:
          campaign.rewardAmount,

        endAt:
          campaign.endAt,

        expiresAt:
          campaign.endAt,

        claimed: false,
        isRead: false,

        createdAt:
          FieldValue.serverTimestamp(),
      });

      syncedCount++;
    }

    if (syncedCount > 0) {
      await batch.commit();
    }

    return {
      success: true,
      syncedCount,
    };
  },
    claimRewardCampaign: async (request) => {
    const userId = request.auth?.uid;

    if (!userId) {
      throw new HttpsError(
        "unauthenticated",
        "請先登入"
      );
    }

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

    const claimRef = campaignRef
      .collection("claims")
      .doc(userId);

    const userRef = db
      .collection("users")
      .doc(userId);

    const flowerLogRef = userRef
      .collection("flower_logs")
      .doc(
        `reward_campaign_${campaignId}`
      );

    const mailboxRef = userRef
      .collection("mailbox")
      .doc(
        `reward_campaign_${campaignId}`
      );

    const result = await db.runTransaction(
      async (transaction) => {
        // 所有讀取必須在所有寫入之前
        const campaignSnapshot =
          await transaction.get(
            campaignRef
          );

        const claimSnapshot =
          await transaction.get(
            claimRef
          );

        const userSnapshot =
          await transaction.get(
            userRef
          );

        if (!campaignSnapshot.exists) {
          throw new HttpsError(
            "not-found",
            "找不到這個活動"
          );
        }

        if (claimSnapshot.exists) {
          throw new HttpsError(
            "already-exists",
            "你已經領取過這份禮物"
          );
        }

        if (!userSnapshot.exists) {
          throw new HttpsError(
            "not-found",
            "找不到玩家資料"
          );
        }

        const campaign =
          campaignSnapshot.data() || {};

        if (campaign.status !== "active") {
          throw new HttpsError(
            "failed-precondition",
            "這個活動已經結束"
          );
        }

        const startAt =
          campaign.startAt?.toDate?.();

        const endAt =
          campaign.endAt?.toDate?.();

        const now = new Date();

        if (!startAt || !endAt) {
          throw new HttpsError(
            "failed-precondition",
            "活動時間設定不完整"
          );
        }

        if (now < startAt) {
          throw new HttpsError(
            "failed-precondition",
            "活動尚未開始"
          );
        }

        if (now > endAt) {
          throw new HttpsError(
            "deadline-exceeded",
            "活動已經結束"
          );
        }

        const audienceType =
          campaign.audienceType || "all";

        if (audienceType !== "all") {
          const targetUserIds =
            Array.isArray(
              campaign.targetUserIds
            )
              ? campaign.targetUserIds
              : [];

          if (!targetUserIds.includes(userId)) {
            throw new HttpsError(
              "permission-denied",
              "你不符合這次活動的領取資格"
            );
          }
        }

        if (
          campaign.rewardType !==
          "flowerPoints"
        ) {
          throw new HttpsError(
            "failed-precondition",
            "目前無法領取這種獎勵"
          );
        }

        const rewardAmount = Number(
          campaign.rewardAmount || 0
        );

        if (
          !Number.isInteger(rewardAmount) ||
          rewardAmount <= 0 ||
          rewardAmount > 10000
        ) {
          throw new HttpsError(
            "failed-precondition",
            "活動獎勵設定異常"
          );
        }

        const currentFlowerPoints =
          Number(
            userSnapshot.data()
              ?.flowerPoints || 0
          );

        const newFlowerPoints =
          currentFlowerPoints +
          rewardAmount;

        transaction.update(userRef, {
          flowerPoints:
            FieldValue.increment(
              rewardAmount
            ),
        });

        transaction.set(claimRef, {
          userId,
          campaignId,

          rewardType:
            campaign.rewardType,

          rewardAmount,

          campaignTitle:
            campaign.title || "活動禮物",

          claimedAt:
            FieldValue.serverTimestamp(),
        });

        transaction.set(flowerLogRef, {
          title:
            campaign.title ||
            "活動禮物",

          amount: rewardAmount,

          reason:
            "官方活動獎勵",

          campaignId,

          type:
            "reward_campaign",

          createdAt:
            FieldValue.serverTimestamp(),
        });

        transaction.set(
          mailboxRef,
          {
            claimed: true,
            claimedAt:
              FieldValue.serverTimestamp(),
            isRead: true,
          },
          {
            merge: true,
          }
        );

        return {
          rewardAmount,
          newFlowerPoints,
          campaignTitle:
            campaign.title ||
            "活動禮物",
        };
      }
    );

    console.log(
      "🎁 玩家已領取活動獎勵",
      {
        userId,
        campaignId,
        rewardAmount:
          result.rewardAmount,
      }
    );

    return {
      success: true,
      ...result,
    };
  },
    syncRewardCampaignsToMailboxUs: async (request) => {
    const userId = request.auth?.uid;

    if (!userId) {
      throw new HttpsError(
        "unauthenticated",
        "請先登入"
      );
    }

    const now = new Date();

    const campaignsSnapshot = await db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("reward_campaigns")
      .where("status", "==", "active")
      .limit(100)
      .get();

    const availableCampaigns =
      campaignsSnapshot.docs.filter(
        (document) => {
          const data = document.data();

          const startAt =
            data.startAt?.toDate?.();

          const endAt =
            data.endAt?.toDate?.();

          if (!startAt || !endAt) {
            return false;
          }

          if (now < startAt || now > endAt) {
            return false;
          }

          const audienceType =
            data.audienceType || "all";

          if (audienceType === "all") {
            return true;
          }

          const targetUserIds =
            Array.isArray(
              data.targetUserIds
            )
              ? data.targetUserIds
              : [];

          return targetUserIds.includes(
            userId
          );
        }
      );

    if (availableCampaigns.length === 0) {
      return {
        success: true,
        syncedCount: 0,
      };
    }

    const userMailboxRef = db
      .collection("users")
      .doc(userId)
      .collection("mailbox");

    const mailboxChecks =
      await Promise.all(
        availableCampaigns.map(
          async (campaignDocument) => {
            const mailRef =
              userMailboxRef.doc(
                `reward_campaign_${campaignDocument.id}`
              );

            const mailSnapshot =
              await mailRef.get();

            return {
              campaignDocument,
              mailRef,
              exists: mailSnapshot.exists,
            };
          }
        )
      );

    const batch = db.batch();
    let syncedCount = 0;

    for (const result of mailboxChecks) {
      if (result.exists) {
        continue;
      }

      const campaign =
        result.campaignDocument.data();

      batch.set(result.mailRef, {
        type: "reward_campaign",

        title:
          `🎁 ${campaign.title}`,

        body: campaign.description,

        rewardCampaignId:
          result.campaignDocument.id,

        rewardType:
          campaign.rewardType,

        rewardAmount:
          campaign.rewardAmount,

        endAt:
          campaign.endAt,

        expiresAt:
          campaign.endAt,

        claimed: false,
        isRead: false,

        createdAt:
          FieldValue.serverTimestamp(),
      });

      syncedCount++;
    }

    if (syncedCount > 0) {
      await batch.commit();
    }

    return {
      success: true,
      syncedCount,
    };
  },
  };
}
module.exports={createRewardCampaignPlayerHandlers};
