'use strict';
// V39: 管理後台營運分析。原有查詢、分類、統計及管理員驗證逐字保留。
function createOperationsAnalyticsReader({db, APP_ID, Timestamp, requireRewardCampaignAdmin, getTaipeiUtcStartOfDay, getTaipeiMonthStart, isInternalTesterForAnalytics, buildFlowerInventoryStats, normalizeAdminMode, getBucketIndex, classifyFlowerGrantSource, classifyFlowerSpendUse, getRevenuePurchaseInfo}) {
  return     async (request) => {
        requireRewardCampaignAdmin(request);

        const now = new Date();
        const todayStart = getTaipeiUtcStartOfDay(now);
        const tomorrowStart = new Date(todayStart.getTime() + 24 * 60 * 60 * 1000);
        const monthStart = getTaipeiMonthStart(now, 0);
        const sixMonthStart = getTaipeiMonthStart(now, -5);
        const sevenDayStart = new Date(todayStart.getTime() - 6 * 24 * 60 * 60 * 1000);
        const eightWeekStart = new Date(todayStart.getTime() - 55 * 24 * 60 * 60 * 1000);

        // Three independent Firestore reads run concurrently rather than sequentially.
        // Timings help identify expensive queries without changing analytics semantics.
        const analyticsStartedAt = Date.now();
        const timedRead = async (label, read) => {
            const startedAt = Date.now();
            try {
                const snapshot = await read();
                console.info("[operationsAnalytics] read", {
                    label,
                    durationMs: Date.now() - startedAt,
                    documents: snapshot.size ?? (snapshot.exists ? 1 : 0),
                });
                return snapshot;
            } catch (error) {
                console.error("[operationsAnalytics] read failed", {
                    label,
                    durationMs: Date.now() - startedAt,
                    message: error?.message || String(error),
                });
                throw error;
            }
        };

        const [flowerSnapshot, modeEventSnapshot, usersSnapshot, analyticsConfigSnapshot] =
            await Promise.all([
                timedRead("flower_logs", () => db
                    .collectionGroup("flower_logs")
                    .where("createdAt", ">=", Timestamp.fromDate(sixMonthStart))
                    .where("createdAt", "<", Timestamp.fromDate(tomorrowStart))
                    .get()),
                timedRead("chat_mode_events", () => db
                    .collection("artifacts")
                    .doc(APP_ID)
                    .collection("chat_mode_events")
                    .where("createdAt", ">=", Timestamp.fromDate(monthStart))
                    .where("createdAt", "<", Timestamp.fromDate(tomorrowStart))
                    .get()).catch((error) => {
                    console.warn("⚠️ chat_mode_events 讀取失敗，將以舊花花紀錄補足：", error?.message || error);
                    return null;
                }),
                timedRead("users", () => db.collection("users").get()),
                timedRead("operations_analytics_config", () => db
                    .collection("artifacts")
                    .doc(APP_ID)
                    .collection("admin_settings")
                    .doc("operations_analytics")
                    .get()),
            ]);

        // Cache month boundaries instead of recalculating them for each flower log.
        const monthBoundaries = Array.from({ length: 6 }, (_, i) => ({
            start: getTaipeiMonthStart(now, i - 5),
            end: getTaipeiMonthStart(now, i - 4),
        }));
        const monthBucketIndex = (createdAt) => {
            for (let i = 0; i < monthBoundaries.length; i++) {
                if (createdAt >= monthBoundaries[i].start && createdAt < monthBoundaries[i].end) {
                    return i;
                }
            }
            return -1;
        };

        const configuredTesterUids = new Set(
            Array.isArray(analyticsConfigSnapshot.data()?.internalTesterUids)
                ? analyticsConfigSnapshot.data().internalTesterUids
                    .map((value) => String(value || "").trim())
                    .filter(Boolean)
                : []
        );

        const internalTesterUids = new Set();
        for (const userDoc of usersSnapshot.docs) {
            if (isInternalTesterForAnalytics(userDoc.id, userDoc.data() || {}, configuredTesterUids)) {
                internalTesterUids.add(userDoc.id);
            }
        }

        const allInventoryRows = [];
        const normalInventoryRows = [];
        const internalTesterRows = [];

        for (const userDoc of usersSnapshot.docs) {
            const userData = userDoc.data() || {};
            const rawBalance = Number(userData.flowerPoints || 0);
            const balance = Number.isFinite(rawBalance)
                ? Math.max(0, Math.trunc(rawBalance))
                : 0;

            const row = {
                uid: userDoc.id,
                balance,
            };

            allInventoryRows.push(row);

            if (
                isInternalTesterForAnalytics(
                    userDoc.id,
                    userData,
                    configuredTesterUids
                )
            ) {
                internalTesterRows.push(row);
            } else {
                normalInventoryRows.push(row);
            }
        }

        const flowerInventory = {
            allPlayers: buildFlowerInventoryStats(allInventoryRows),
            excludingInternalTesters: buildFlowerInventoryStats(normalInventoryRows),
            internalTesters: buildFlowerInventoryStats(internalTesterRows),
            internalTesterDetection: {
                configuredUidCount: configuredTesterUids.size,
                detectedPlayerCount: internalTesterRows.length,
            },
        };

        const calculateEconomy = (excludeInternal) => {
        let unattributedModeEventCount = 0;
        let unattributedFlowerLogCount = 0;
        const grantSources = {
            freeTask: 0,
            monthlyDaily: 0,
            monthlyCardPurchase: 0,
            topup: 0,
            compensation: 0,
            event: 0,
            admin: 0,
            other: 0,
        };

        const spendUses = {
            gemini: 0,
            daily: 0,
            story: 0,
            immersive: 0,
            resonance: 0,
            interaction: 0,
            gift: 0,
            other: 0,
        };

        const modeUsage = {
            gemini: 0,
            daily: 0,
            story: 0,
            immersive: 0,
            resonance: 0,
            other: 0,
        };

        const worldModeUsage = {story:0, immersive:0, resonance:0, interaction:0, gift:0};
        const worldStartedRooms = new Set();

        const dailyTrend = Array.from({ length: 7 }, (_, index) => ({
            label: new Intl.DateTimeFormat("zh-TW", {
                timeZone: "Asia/Taipei",
                month: "numeric",
                day: "numeric",
            }).format(new Date(sevenDayStart.getTime() + index * 24 * 60 * 60 * 1000)),
            granted: 0,
            spent: 0,
            revenueTwd: 0,
        }));

        const weeklyTrend = Array.from({ length: 8 }, (_, index) => ({
            label: `W${index + 1}`,
            granted: 0,
            spent: 0,
            revenueTwd: 0,
        }));

        const monthlyTrend = Array.from({ length: 6 }, (_, index) => {
            const bucketStart = getTaipeiMonthStart(now, index - 5);
            const taipeiLocal = new Date(bucketStart.getTime() + 8 * 60 * 60 * 1000);
            return {
                label: `${taipeiLocal.getUTCMonth() + 1}月`,
                granted: 0,
                spent: 0,
                revenueTwd: 0,
            };
        });

        const monthPayerUids = new Set();
        const seenModeEventKeys = new Set();

        let monthRevenueTwd = 0;
        let monthPurchaseCount = 0;
        let monthMonthlyCardRevenueTwd = 0;
        let monthTopupRevenueTwd = 0;
        let monthMonthlyCardPurchaseCount = 0;
        let monthTopupPurchaseCount = 0;
        let monthFlowerGranted = 0;
        let monthFlowerSpent = 0;
        let monthPaidRelatedGranted = 0;
        let monthFreeGranted = 0;
        let unpricedPurchaseCount = 0;

        if (modeEventSnapshot) {
            for (const doc of modeEventSnapshot.docs) {
                const data = doc.data() || {};
                const eventUid = String(data.uid || data.userId || data.playerUid || data.createdBy || "").trim();
                if (excludeInternal && (!eventUid || internalTesterUids.has(eventUid))) {
                    if (!eventUid) unattributedModeEventCount++;
                    continue;
                }
                const createdAt = data.createdAt?.toDate?.();
                if (!createdAt || createdAt < monthStart || createdAt >= tomorrowStart) continue;

                const mode = normalizeAdminMode(data.chatMode);
                const eventBillingType =
                    String(data.billingType || "chat")
                        .trim()
                        .toLowerCase();

                const worldEvent = String(doc.id).startsWith('world_') || Boolean(data.worldId);
                if (worldEvent) {
                    if (eventBillingType === 'chat' && ['story','immersive','resonance'].includes(mode)) {
                        worldModeUsage[mode]++;
                        if (data.sessionId) worldStartedRooms.add(String(data.sessionId));
                    } else if (eventBillingType === 'interaction' || eventBillingType === 'gift') {
                        worldModeUsage[eventBillingType]++;
                        if (data.sessionId) worldStartedRooms.add(String(data.sessionId));
                    }
                } else if (eventBillingType === "chat") {
                    modeUsage[mode] = (modeUsage[mode] || 0) + 1;
                }

                const key = `${String(data.sessionId || "")}|${String(data.messageId || "")}`;
                if (key !== "|") seenModeEventKeys.add(key);
            }
        }

        for (const doc of flowerSnapshot.docs) {
            const data = doc.data() || {};
            const transactionUid = doc.ref.parent.parent?.id || "";
            if (excludeInternal && (!transactionUid || internalTesterUids.has(transactionUid))) {
                if (!transactionUid) unattributedFlowerLogCount++;
                continue;
            }
            const createdAt = data.createdAt?.toDate?.();
            if (!createdAt) continue;

            const amount = Number(data.amount || 0);
            const isMonth = createdAt >= monthStart && createdAt < tomorrowStart;

            // 日趨勢
            if (createdAt >= sevenDayStart && createdAt < tomorrowStart) {
                const idx = getBucketIndex(createdAt, sevenDayStart.getTime(), 24 * 60 * 60 * 1000, 7);
                if (idx >= 0 && Number.isFinite(amount)) {
                    if (amount > 0) dailyTrend[idx].granted += amount;
                    if (amount < 0) dailyTrend[idx].spent += Math.abs(amount);
                }
            }

            // 週趨勢（近 8 週，每 7 天一桶）
            if (createdAt >= eightWeekStart && createdAt < tomorrowStart) {
                const idx = getBucketIndex(createdAt, eightWeekStart.getTime(), 7 * 24 * 60 * 60 * 1000, 8);
                if (idx >= 0 && Number.isFinite(amount)) {
                    if (amount > 0) weeklyTrend[idx].granted += amount;
                    if (amount < 0) weeklyTrend[idx].spent += Math.abs(amount);
                }
            }

            // 月趨勢
            const monthIndex = monthBucketIndex(createdAt);
            if (monthIndex >= 0 && Number.isFinite(amount)) {
                if (amount > 0) monthlyTrend[monthIndex].granted += amount;
                if (amount < 0) monthlyTrend[monthIndex].spent += Math.abs(amount);
            }

            const revenueInfo = getRevenuePurchaseInfo(data);
            if (revenueInfo) {
                if (!revenueInfo.isPricedTwd) {
                    if (isMonth) unpricedPurchaseCount++;
                } else {
                    // 日 revenue 趨勢
                    if (createdAt >= sevenDayStart && createdAt < tomorrowStart) {
                        const idx = getBucketIndex(createdAt, sevenDayStart.getTime(), 24 * 60 * 60 * 1000, 7);
                        if (idx >= 0) dailyTrend[idx].revenueTwd += revenueInfo.revenueTwd;
                    }
                    if (createdAt >= eightWeekStart && createdAt < tomorrowStart) {
                        const idx = getBucketIndex(createdAt, eightWeekStart.getTime(), 7 * 24 * 60 * 60 * 1000, 8);
                        if (idx >= 0) weeklyTrend[idx].revenueTwd += revenueInfo.revenueTwd;
                    }
                    if (monthIndex >= 0) {
                        monthlyTrend[monthIndex].revenueTwd += revenueInfo.revenueTwd;
                    }
                }

                if (isMonth) {
                    monthPurchaseCount++;
                    if (revenueInfo.isPricedTwd) {
                        monthRevenueTwd += revenueInfo.revenueTwd;
                    }

                    if (revenueInfo.isMonthlyCard) {
                        monthMonthlyCardPurchaseCount++;
                        if (revenueInfo.isPricedTwd) {
                            monthMonthlyCardRevenueTwd += revenueInfo.revenueTwd;
                        }
                    } else {
                        monthTopupPurchaseCount++;
                        if (revenueInfo.isPricedTwd) {
                            monthTopupRevenueTwd += revenueInfo.revenueTwd;
                        }
                    }

                    const uid = doc.ref.parent.parent?.id || "";
                    if (uid) monthPayerUids.add(uid);
                }
            }

            if (!isMonth || !Number.isFinite(amount) || amount === 0) {
                continue;
            }

            if (amount > 0) {
                monthFlowerGranted += amount;
                const sourceKey = classifyFlowerGrantSource(data);
                grantSources[sourceKey] = (grantSources[sourceKey] || 0) + amount;

                if (sourceKey === "monthlyCardPurchase" || sourceKey === "topup" || sourceKey === "monthlyDaily") {
                    monthPaidRelatedGranted += amount;
                } else {
                    monthFreeGranted += amount;
                }
            } else {
                monthFlowerSpent += Math.abs(amount);
                const spendKey = classifyFlowerSpendUse(data);
                spendUses[spendKey] = (spendUses[spendKey] || 0) + Math.abs(amount);

                // 舊資料沒有 chat_mode_events 時，以付費聊天 log 補模式次數。
                const mode = normalizeAdminMode(data.chatMode);
                const legacyBillingType =
                    String(data.billingType || "chat")
                        .trim()
                        .toLowerCase();

                if (!String(doc.id).startsWith('world_') &&
                    !String(data.type || '').startsWith('world_') &&
                    !data.worldId && mode !== "other" && legacyBillingType === "chat") {
                    const key = `${String(data.sessionId || "")}|${String(data.messageId || "")}`;
                    if (!seenModeEventKeys.has(key)) {
                        modeUsage[mode] = (modeUsage[mode] || 0) + 1;
                    }
                }
            }
        }

        const modeUsageTotal = Object.values(modeUsage)
            .reduce((sum, value) => sum + Number(value || 0), 0);

        const monthPayingUsers = monthPayerUids.size;
        const monthArppuTwd = monthPayingUsers > 0
            ? monthRevenueTwd / monthPayingUsers
            : null;

        return {
            generatedAt: new Date().toISOString(),
            unattributedModeEventCount,
            unattributedFlowerLogCount,
            month: {
                revenueTwd: monthRevenueTwd,
                payingUsers: monthPayingUsers,
                arppuTwd: monthArppuTwd,
                purchaseCount: monthPurchaseCount,
                monthlyCardRevenueTwd: monthMonthlyCardRevenueTwd,
                topupRevenueTwd: monthTopupRevenueTwd,
                monthlyCardPurchaseCount: monthMonthlyCardPurchaseCount,
                topupPurchaseCount: monthTopupPurchaseCount,
                flowerGranted: monthFlowerGranted,
                flowerSpent: monthFlowerSpent,
                paidRelatedGranted: monthPaidRelatedGranted,
                freeGranted: monthFreeGranted,
                unpricedPurchaseCount,
            },
            grantSources,
            spendUses,
            modeUsage,
            modeUsageTotal,
            worldModeUsage,
            worldModeUsageTotal: Object.values(worldModeUsage).reduce((sum, n) => sum + n, 0),
            worldStartedRooms: worldStartedRooms.size,
            trends: {
                day: dailyTrend,
                week: weeklyTrend,
                month: monthlyTrend,
            },
        };
        };
        const formalEconomy = calculateEconomy(true);
        const allEconomy = calculateEconomy(false);
        console.info("[operationsAnalytics] completed", {
            durationMs: Date.now() - analyticsStartedAt,
            flowerLogCount: flowerSnapshot.size,
            modeEventCount: modeEventSnapshot?.size ?? 0,
            userCount: usersSnapshot.size,
        });
        return {
            ...formalEconomy,
            flowerInventory,
            economyComparison: {
                excludingInternalTesters: formalEconomy,
                allPlayers: allEconomy,
                internalTesterCount: internalTesterUids.size,
            },
        };
    };
}
module.exports={createOperationsAnalyticsReader};
