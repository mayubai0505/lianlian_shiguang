'use strict';

// V77: Original pure administration analytics helpers extracted verbatim from core.js.
// They classify existing data; they do not debit, credit or write any Firestore documents.
function normalizeAdminMode(rawMode) {
    const mode = String(rawMode || "").trim().toLowerCase();
    if (mode === "gemini") return "gemini";
    if (mode === "daily") return "daily";
    if (mode === "story") return "story";
    if (mode === "immersive") return "immersive";
    if (mode === "resonance") return "resonance";
    return "other";
}

function classifyFlowerGrantSource(data = {}) {
    const type = String(data.type || "").trim().toLowerCase();
    const source = String(data.source || "").trim().toLowerCase();
    const title = String(data.title || "").trim().toLowerCase();
    const reason = String(data.reason || "").trim().toLowerCase();
    const productId = String(data.productId || "").trim().toLowerCase();
    const productType = String(data.productType || "").trim().toLowerCase();
    const provider = String(data.provider || "").trim().toLowerCase();
    const text = `${type} ${source} ${title} ${reason} ${productId} ${productType} ${provider}`;

    const looksLikePurchase =
        type === "purchase" ||
        provider === "apple_iap" ||
        provider === "google_play" ||
        source === "stripe_web";

    if (
        /月卡/.test(text) &&
        /(每日|日領|daily)/.test(text)
    ) {
        return "monthlyDaily";
    }

    if (looksLikePurchase) {
        if (
            productType === "monthly_card" ||
            /monthly|月卡|星光契約/.test(text)
        ) {
            return "monthlyCardPurchase";
        }
        return "topup";
    }

    if (
        type === "cs_compensation" ||
        /客服補償|補償/.test(text)
    ) {
        return "compensation";
    }

    if (
        type === "reward_campaign" ||
        /活動|campaign|節慶|七夕|萬聖|聖誕/.test(text)
    ) {
        return "event";
    }

    if (
        type === "admin_adjustment" &&
        Number(data.amount || 0) > 0
    ) {
        return "admin";
    }

    if (
        type === "system_grant" ||
        /任務|簽到|新手|推薦|邀請|referral|每日任務|免費/.test(text)
    ) {
        return "freeTask";
    }

    return "other";
}

function classifyFlowerSpendUse(data = {}) {
    const billingType = String(data.billingType || "").trim().toLowerCase();
    const type = String(data.type || "").trim().toLowerCase();
    const title = String(data.title || "").trim().toLowerCase();
    const reason = String(data.reason || "").trim().toLowerCase();
    const text = `${billingType} ${type} ${title} ${reason}`;

    if (billingType === "interaction" || /互動|戳戳|抱抱|牽手|定位|擲骰子/.test(text)) {
        return "interaction";
    }
    if (billingType === "gift" || /禮物|gift/.test(text)) {
        return "gift";
    }

    const mode = normalizeAdminMode(data.chatMode);
    if (mode !== "other") return mode;

    return "other";
}

function getRevenuePurchaseInfo(data = {}) {
    const type = String(data.type || "").trim().toLowerCase();
    const provider = String(data.provider || "").trim().toLowerCase();
    const currency = String(data.currency || "").trim().toUpperCase();
    const price = Number(data.price || 0);
    const productType = String(data.productType || "").trim().toLowerCase();
    const productId = String(data.productId || "").trim().toLowerCase();
    const title = String(data.title || "").trim().toLowerCase();

    const isMobilePurchase =
        type === "purchase" &&
        (provider === "apple_iap" || provider === "google_play");

    if (!isMobilePurchase) {
        return null;
    }

    const isPricedTwd =
        currency === "TWD" &&
        Number.isFinite(price) &&
        price > 0;

    const isMonthlyCard =
        productType === "monthly_card" ||
        /monthly|月卡|星光契約/.test(`${productId} ${title}`);

    return {
        provider,
        isPricedTwd,
        revenueTwd: isPricedTwd ? price : 0,
        isMonthlyCard,
    };
}

function getBucketIndex(value, startMs, bucketMs, bucketCount) {
    const index = Math.floor((value.getTime() - startMs) / bucketMs);
    return index >= 0 && index < bucketCount ? index : -1;
}

function isInternalTesterForAnalytics(uid, data = {}, configuredUids = new Set()) {
    if (configuredUids.has(String(uid || "").trim())) return true;

    if (
        data.analyticsExcludeFromEconomy === true ||
        data.isInternalTester === true ||
        data.internalTester === true ||
        data.isTester === true ||
        data.isTestUser === true ||
        data.testUser === true ||
        data.isBetaTester === true ||
        data.betaTester === true
    ) {
        return true;
    }

    const accountType = String(data.accountType || "").trim().toLowerCase();
    return [
        "internal_test",
        "internal_tester",
        "tester",
        "test",
        "beta_tester",
        "beta"
    ].includes(accountType);
}

function medianNumber(values = []) {
    if (!Array.isArray(values) || values.length === 0) return 0;

    const sorted = values
        .map((value) => Number(value || 0))
        .filter((value) => Number.isFinite(value))
        .sort((a, b) => a - b);

    if (sorted.length === 0) return 0;

    const middle = Math.floor(sorted.length / 2);
    if (sorted.length % 2 === 1) return sorted[middle];
    return (sorted[middle - 1] + sorted[middle]) / 2;
}

function buildFlowerInventoryStats(rows = []) {
    const safeRows = Array.isArray(rows) ? rows : [];
    const balances = safeRows.map((row) => Math.max(0, Number(row?.balance || 0)));
    const totalPlayers = balances.length;
    const totalFlowers = balances.reduce((sum, value) => sum + value, 0);

    const bucketDefs = [
        { key: "0_100", label: "0～100", min: 0, max: 100 },
        { key: "101_300", label: "101～300", min: 101, max: 300 },
        { key: "301_1000", label: "301～1,000", min: 301, max: 1000 },
        { key: "1001_3000", label: "1,001～3,000", min: 1001, max: 3000 },
        { key: "3001_plus", label: "3,001 以上", min: 3001, max: null },
    ];

    const buckets = bucketDefs.map((def) => {
        const matched = safeRows.filter((row) => {
            const balance = Math.max(0, Number(row?.balance || 0));
            if (balance < def.min) return false;
            if (def.max != null && balance > def.max) return false;
            return true;
        });

        const flowerTotal = matched.reduce(
            (sum, row) => sum + Math.max(0, Number(row?.balance || 0)),
            0
        );

        return {
            key: def.key,
            label: def.label,
            players: matched.length,
            playerRatio: totalPlayers > 0 ? matched.length / totalPlayers : 0,
            flowerTotal,
        };
    });

    return {
        playerCount: totalPlayers,
        totalFlowers,
        averageFlowers: totalPlayers > 0 ? totalFlowers / totalPlayers : 0,
        medianFlowers: medianNumber(balances),
        buckets,
    };
}


module.exports = {
  normalizeAdminMode,
  classifyFlowerGrantSource,
  classifyFlowerSpendUse,
  getRevenuePurchaseInfo,
  getBucketIndex,
  isInternalTesterForAnalytics,
  medianNumber,
  buildFlowerInventoryStats
};
