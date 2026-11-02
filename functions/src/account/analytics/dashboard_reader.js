'use strict';

// 保留 V35 的查詢邏輯和權限檢查；依賴由 core.js 注入。
function createAdminDashboardStatsHandler({requireRewardCampaignAdmin, getTaipeiDayStart, ONE_DAY_MS, db, APP_ID, adminDateFromDynamic, getTaipeiDayIndex, HttpsError}) {
return async (request) => {
    // 🔐 只有管理員可以讀全服營運資料
    requireRewardCampaignAdmin(request);

    const now = new Date();
    const today = getTaipeiDayStart(now);

    // 包含今天在內，共 7 天
    const sevenDaysAgo = new Date(
      today.getTime() - 6 * ONE_DAY_MS
    );

    try {
      const usersFuture =
        db.collection("users").get();

      const publicCharactersFuture = db
        .collection("artifacts")
        .doc(APP_ID)
        .collection("public_characters")
        .get();

      const worldsFuture = db.collection('artifacts').doc(APP_ID)
        .collection('worlds').get();

      const privateCharactersFuture = db
        .collectionGroup("private_characters")
        .get();

      const reportsFuture =
        db.collection("reports").get();

      // ⭐ 這次改成由 Admin SDK 讀取聊天室，
      // 不再讓 Flutter App 直接碰全服 chat_sessions。
      const chatSessionsFuture = db
        .collection("artifacts")
        .doc(APP_ID)
        .collection("chat_sessions")
        .where(
          "lastActivity",
          ">=",
          Timestamp.fromDate(sevenDaysAgo)
        )
        .get();

        const todayKey =
          getAnalyticsTaipeiDateKey(now);

        const activityTodayFuture = db
          .collection(
            "analytics_user_activity"
          )
          .where(
            "dateKey",
            "==",
            todayKey
          )
          .get();

      const [
        usersSnapshot,
        publicCharactersSnapshot,
        worldsSnapshot,
        privateCharactersSnapshot,
        reportsSnapshot,
        chatSessionsSnapshot,
        activityTodaySnapshot,
      ] = await Promise.all([
        usersFuture,
        publicCharactersFuture,
        worldsFuture,
        privateCharactersFuture,
        reportsFuture,
        chatSessionsFuture,
        activityTodayFuture,
      ]);

      // ==================================================
      // 👥 玩家
      // ==================================================

      const activeTodayUserIds =
        new Set(
          activityTodaySnapshot.docs
            .map(
              (doc) =>
                String(
                  doc.data()?.uid || ""
                ).trim()
            )
            .filter(Boolean)
        );

      function dateKeyDaysAgo(days) {
        return getAnalyticsTaipeiDateKey(
          new Date(
            now.getTime() -
            days *
              24 *
              60 *
              60 *
              1000
          )
        );
      }

      const d1CohortDate =
        dateKeyDaysAgo(1);

      const d7CohortDate =
        dateKeyDaysAgo(7);

      const d30CohortDate =
        dateKeyDaysAgo(30);

      let d1Total = 0;
      let d1Returned = 0;

      let d7Total = 0;
      let d7Returned = 0;

      let d30Total = 0;
      let d30Returned = 0;

      let todayNewUsers = 0;
      let monthlyActive = 0;

      const userGrowth =
        new Array(7).fill(0);

      for (const document of usersSnapshot.docs) {
        const data = document.data() || {};

        const createdAt = adminDateFromDynamic(
          data.createdAt ??
          data.registeredAt ??
          data.joinedAt
        );

        if (createdAt) {
          const registrationKey =
            getAnalyticsTaipeiDateKey(
              createdAt
            );

          if (
            registrationKey ===
            d1CohortDate
          ) {
            d1Total++;

            if (
              activeTodayUserIds.has(
                document.id
              )
            ) {
              d1Returned++;
            }
          }

          if (
            registrationKey ===
            d7CohortDate
          ) {
            d7Total++;

            if (
              activeTodayUserIds.has(
                document.id
              )
            ) {
              d7Returned++;
            }
          }

          if (
            registrationKey ===
            d30CohortDate
          ) {
            d30Total++;

            if (
              activeTodayUserIds.has(
                document.id
              )
            ) {
              d30Returned++;
            }
          }
        }

        if (createdAt) {
          if (createdAt >= today) {
            todayNewUsers++;
          }

          const dayIndex =
            getTaipeiDayIndex(
              createdAt,
              sevenDaysAgo
            );

          if (
            dayIndex >= 0 &&
            dayIndex < 7
          ) {
            userGrowth[dayIndex]++;
          }
        }

        const monthlyEnd =
          adminDateFromDynamic(
            data.monthlySubEndDate ??
            data.subscriptionEndAt
          );

        if (
          monthlyEnd &&
          monthlyEnd > now
        ) {
          monthlyActive++;
        }
      }

      // ==================================================
      // 🎭 角色
      // ==================================================

      let todayNewCharacters = 0;

      // 公開角色
      for (
        const document
        of publicCharactersSnapshot.docs
      ) {
        const data = document.data() || {};

        const createdAt =
          adminDateFromDynamic(
            data.createdAt
          );

        if (
          createdAt &&
          createdAt >= today
        ) {
          todayNewCharacters++;
        }
      }

      // 私人角色
      for (
        const document
        of privateCharactersSnapshot.docs
      ) {
        const data = document.data() || {};

        const createdAt =
          adminDateFromDynamic(
            data.createdAt
          );

        if (
          createdAt &&
          createdAt >= today
        ) {
          todayNewCharacters++;
        }
      }

      // ==================================================
      // 💌 客服
      // ==================================================

      let pendingReports = 0;

      for (const document of reportsSnapshot.docs) {
        const data = document.data() || {};

        const status =
          String(data.status || "").trim();

        if (
          !status ||
          status === "pending" ||
          status === "processing"
        ) {
          pendingReports++;
        }
      }

      // ==================================================
      // 💬 聊天室活動
      // ==================================================

      const activeUserIdsToday =
        new Set();

      let activeSessionsToday = 0;

      const chatTrend =
        new Array(7).fill(0);

      const chatModes = {};

      const characterChatCounts = {};

      for (
        const document
        of chatSessionsSnapshot.docs
      ) {
        const data = document.data() || {};

        const lastActivity =
          adminDateFromDynamic(
            data.lastActivity
          );

        if (!lastActivity) {
          continue;
        }

        const dayIndex =
          getTaipeiDayIndex(
            lastActivity,
            sevenDaysAgo
          );

        if (
          dayIndex >= 0 &&
          dayIndex < 7
        ) {
          chatTrend[dayIndex]++;
        }

        if (lastActivity >= today) {
          activeSessionsToday++;

          const userId =
            String(
              data.userId || ""
            ).trim();

          if (userId) {
            activeUserIdsToday.add(userId);
          }
        }

        const mode =
          String(
            data.chatMode || "daily"
          ).trim();

        chatModes[mode] =
          (chatModes[mode] || 0) + 1;

        const characterId =
          String(
            data.characterId || ""
          ).trim();

        if (characterId) {
          characterChatCounts[characterId] =
            (
              characterChatCounts[
                characterId
              ] || 0
            ) + 1;
        }
      }

      // ==================================================
      // 🌸 今日花花收支
      // ==================================================

      let flowerGranted = 0;
      let flowerSpent = 0;

      try {
        const flowerLogsSnapshot = await db
          .collectionGroup("flower_logs")
          .where(
            "createdAt",
            ">=",
            Timestamp.fromDate(today)
          )
          .get();

        for (
          const document
          of flowerLogsSnapshot.docs
        ) {
          const data =
            document.data() || {};

          const amount =
            Number(data.amount || 0);

          if (!Number.isFinite(amount)) {
            continue;
          }

          if (amount >= 0) {
            flowerGranted += amount;
          } else {
            flowerSpent += Math.abs(amount);
          }
        }
      } catch (error) {
        console.warn(
          "⚠️ 管理後台讀取今日花花明細失敗：",
          error
        );
      }

      const d1Retention =
        d1Total > 0
          ? d1Returned /
            d1Total *
            100
          : null;

      const d7Retention =
        d7Total > 0
          ? d7Returned /
            d7Total *
            100
          : null;

      const d30Retention =
        d30Total > 0
          ? d30Returned /
            d30Total *
            100
          : null;

      // First publication date is preferred; old documents without it use
      // the initial creation date rather than updatedAt (which changes on edits).
      const publicWorldDocs = worldsSnapshot.docs.filter(doc => {
        const w = doc.data() || {};
        return w.isPublic === true && w.publicPlayable === true &&
          w.isDraft !== true && w.status === 'public';
      });
      const publicWorlds = publicWorldDocs.length;
      const todayNewWorlds = publicWorldDocs.filter(doc => {
        const w = doc.data() || {};
        const firstDate = w.firstPublishedAt?.toDate?.() || w.createdAt?.toDate?.();
        return firstDate && firstDate >= today && firstDate <= now;
      }).length;

      const result = {
        publicWorlds,
        todayNewWorlds,
        totalUsers:
          usersSnapshot.size,

        todayNewUsers,

        todayActiveUsers:
          activeUserIdsToday.size,

        publicCharacters:
          publicCharactersSnapshot.size,

        todayNewCharacters,

        pendingReports,

        todayChatSessions:
          activeSessionsToday,

        flowerGranted,
        flowerSpent,

        monthlyActive,

        userGrowth,
        chatTrend,
        chatModes,
        characterChatCounts,

        sessions7d:
          chatSessionsSnapshot.size,

        generatedAt:
          new Date().toISOString(),

        retention: {
          d1: {
            rate: d1Retention,
            cohortSize: d1Total,
            returned: d1Returned,
          },

          d7: {
            rate: d7Retention,
            cohortSize: d7Total,
            returned: d7Returned,
          },

          d30: {
            rate: d30Retention,
            cohortSize: d30Total,
            returned: d30Returned,
          },
        },
      };

      console.log(
        "📊 管理後台統計完成",
        {
          adminUid: request.auth?.uid,
          totalUsers: result.totalUsers,
          todayActiveUsers:
            result.todayActiveUsers,
          todayChatSessions:
            result.todayChatSessions,
          sessions7d:
            result.sessions7d,
        }
      );

      return result;
    } catch (error) {
      console.error(
        "❌ getAdminDashboardStats 失敗：",
        error
      );

      throw new HttpsError(
        "internal",
        "讀取管理後台統計資料失敗"
      );
    }
  };
}

module.exports = {createAdminDashboardStatsHandler};
