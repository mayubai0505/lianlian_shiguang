'use strict';

// V38: 後台每日手機 IAP 營收統計；沿用原有條件與結果。
function createRevenueDailyReader({db, requireRewardCampaignAdmin, getRevenueTaipeiDayRange}) {
  return       async (request) => {
          requireRewardCampaignAdmin(request);

          const range =
              getRevenueTaipeiDayRange();

          const snapshot =
              await db
                  .collectionGroup(
                      "flower_logs"
                  )
                  .where(
                      "createdAt",
                      ">=",
                      range.start
                  )
                  .where(
                      "createdAt",
                      "<",
                      range.end
                  )
                  .get();

          let revenueTwd = 0;

          let purchaseCount = 0;

          let applePurchaseCount = 0;

          let googlePurchaseCount = 0;

          const payerUids =
              new Set();

          for (
              const doc of snapshot.docs
          ) {
              const data =
                  doc.data() || {};

              const type =
                  String(
                      data.type || ""
                  ).trim();

              const provider =
                  String(
                      data.provider || ""
                  ).trim();

              const currency =
                  String(
                      data.currency || ""
                  )
                      .trim()
                      .toUpperCase();

              const price =
                  Number(
                      data.price || 0
                  );

              // 只統計新的手機 IAP purchase log
              if (type !== "purchase") {
                  continue;
              }

              if (
                  provider !== "apple_iap" &&
                  provider !== "google_play"
              ) {
                  continue;
              }

              if (currency !== "TWD") {
                  continue;
              }

              if (
                  !Number.isFinite(price) ||
                  price <= 0
              ) {
                  continue;
              }

              revenueTwd += price;

              purchaseCount++;

              if (provider === "apple_iap") {
                  applePurchaseCount++;
              }

              if (provider === "google_play") {
                  googlePurchaseCount++;
              }

              // flower_logs 位於 users/{uid}/flower_logs/{logId}
              // parent = flower_logs
              // parent.parent = user document
              const userRef =
                  doc.ref.parent.parent;

              const uid =
                  userRef?.id || "";

              if (uid) {
                  payerUids.add(uid);
              }
          }

          const payingUsers =
              payerUids.size;

          const arppuTwd =
              payingUsers > 0
                  ? revenueTwd /
                    payingUsers
                  : null;

          console.log(
              "💰 今日手機 IAP 金流",
              {
                  revenueTwd,
                  payingUsers,
                  arppuTwd,
                  purchaseCount,
                  applePurchaseCount,
                  googlePurchaseCount,
              }
          );

          return {
              revenueTwd,

              payingUsers,

              arppuTwd,

              purchaseCount,

              applePurchaseCount,

              googlePurchaseCount,
          };
      };
}

module.exports = {createRevenueDailyReader};
