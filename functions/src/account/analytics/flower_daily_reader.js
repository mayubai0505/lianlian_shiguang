'use strict';

// V37: 管理後台每日花花加減統計；保留原查詢、驗權與計數語意。
function createFlowerDailyReader({db, requireRewardCampaignAdmin, getFlowerStatsTaipeiDayRange}) {
  return async (request) => {
          requireRewardCampaignAdmin(request);

          const range =
              getFlowerStatsTaipeiDayRange();

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

          let flowerGranted = 0;
          let flowerSpent = 0;

          let grantedTransactions = 0;
          let spentTransactions = 0;

          for (
              const doc of snapshot.docs
          ) {
              const data =
                  doc.data() || {};

              const amount =
                  Number(
                      data.amount || 0
                  );

              if (
                  !Number.isFinite(amount) ||
                  amount === 0
              ) {
                  continue;
              }

              if (amount > 0) {
                  flowerGranted += amount;

                  grantedTransactions++;
              } else {
                  // 後台顯示消耗量使用正數
                  flowerSpent +=
                      Math.abs(amount);

                  spentTransactions++;
              }
          }

          console.log(
              "🌸 今日花花統計",
              {
                  flowerGranted,
                  flowerSpent,
                  grantedTransactions,
                  spentTransactions,
                  logs:
                      snapshot.size,
              }
          );

          return {
              flowerGranted,
              flowerSpent,

              grantedTransactions,
              spentTransactions,

              totalLogs:
                  snapshot.size,
          };
      };
}

module.exports = {createFlowerDailyReader};
