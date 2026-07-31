const admin = require("firebase-admin");
const { initializeApp, getApps } = require("firebase-admin/app");const axios = require("axios");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const {defineSecret} = require("firebase-functions/params");
const {onCall, HttpsError} = require("firebase-functions/v2/https");

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();
const REGION = "asia-east1";

// 你剛剛已經存入 Firebase Secret 的兩個值
const tappayPartnerKey = defineSecret("TAPPAY_PARTNER_KEY");
const tappayMerchantId = defineSecret("TAPPAY_MERCHANT_ID");

// TapPay Sandbox API
const TAPPAY_PAY_BY_PRIME_URL =
  "https://sandbox.tappaysdk.com/tpc/payment/pay-by-prime";

// 商品編號必須與 store_page.dart 完全一致
const TAPPAY_PRODUCTS = {
  com_lianlian_monthly_card_250: {
    name: "星光契約月卡",
    amount: 250,
    points: 250,
    type: "monthly_card",
  },

  com_lianlian_points_90: {
    name: "初見傾心・90 花花",
    amount: 30,
    points: 90,
    type: "points",
  },

  com_lianlian_points_215: {
    name: "微光悸動・215 花花",
    amount: 70,
    points: 215,
    type: "points",
  },

  com_lianlian_points_590: {
    name: "熱戀時光・590 花花",
    amount: 170,
    points: 590,
    type: "points",
  },
};

/**
 * 將日期安全轉為 JavaScript Date。
 * 目前戀戀拾光的 monthlySubEndDate 是字串格式，
 * 同時也相容未來可能改用 Firestore Timestamp 的情況。
 */
function parseStoredDate(value) {
  if (!value) return null;

  if (value instanceof admin.firestore.Timestamp) {
    return value.toDate();
  }

  if (
    typeof value === "object" &&
    typeof value.toDate === "function"
  ) {
    return value.toDate();
  }

  const parsed = new Date(value);

  if (Number.isNaN(parsed.getTime())) {
    return null;
  }

  return parsed;
}

/**
 * 日期增加指定天數。
 */
function addDays(date, days) {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

/**
 * 統一整理前端傳來的持卡人資料。
 */
function normalizeCardholder(cardholder, authToken) {
  const source = cardholder || {};

  const name = String(
    source.name ||
    authToken.name ||
    "戀戀拾光玩家"
  ).trim();

  const email = String(
    source.email ||
    authToken.email ||
    ""
  ).trim();

  const phoneNumber = String(
    source.phoneNumber ||
    source.phone_number ||
    ""
  ).trim();

  if (!name) {
    throw new HttpsError(
      "invalid-argument",
      "請填寫持卡人姓名"
    );
  }

  if (!email) {
    throw new HttpsError(
      "invalid-argument",
      "請填寫電子信箱"
    );
  }

  if (!phoneNumber) {
    throw new HttpsError(
      "invalid-argument",
      "請填寫手機號碼"
    );
  }

  return {
    name,
    email,
    phone_number: phoneNumber,
    national_id: "",
  };
}

/**
 * TapPay 信用卡付款。
 *
 * 前端需傳入：
 * {
 *   prime: "...",
 *   productId: "com_lianlian_points_90",
 *   cardholder: {
 *     name: "王小明",
 *     email: "test@example.com",
 *     phoneNumber: "0912345678"
 *   }
 * }
 */
const payByPrime = onCall(
  {
    region: REGION,
    timeoutSeconds: 60,
    memory: "256Mi",
    secrets: [
      tappayPartnerKey,
      tappayMerchantId,
    ],
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "請先登入後再進行付款"
      );
    }

    const uid = request.auth.uid;
    const data = request.data || {};

    const prime = String(data.prime || "").trim();
    const productId = String(data.productId || "").trim();
    const product = TAPPAY_PRODUCTS[productId];

    if (!prime) {
      throw new HttpsError(
        "invalid-argument",
        "缺少 TapPay Prime"
      );
    }

    if (!product) {
      throw new HttpsError(
        "invalid-argument",
        "找不到此商品"
      );
    }

    const cardholder = normalizeCardholder(
      data.cardholder,
      request.auth.token || {}
    );

    const partnerKey = tappayPartnerKey.value();
    const merchantId = tappayMerchantId.value();

    if (!partnerKey || !merchantId) {
      throw new HttpsError(
        "failed-precondition",
        "TapPay 金鑰尚未設定完成"
      );
    }

    let tappayResult;

    try {
      const response = await axios.post(
        TAPPAY_PAY_BY_PRIME_URL,
        {
          prime,
          partner_key: partnerKey,
          merchant_id: merchantId,
          amount: product.amount,
          currency: "TWD",
          details: product.name,
          cardholder,
          remember: false,
        },
        {
          headers: {
            "Content-Type": "application/json",
            "x-api-key": partnerKey,
          },
          timeout: 30000,
        }
      );

      tappayResult = response.data || {};
    } catch (error) {
      console.error("❌ TapPay API 連線失敗", {
        message: error.message,
        response: error.response?.data,
      });

      throw new HttpsError(
        "unavailable",
        "目前無法連接付款服務，請稍後再試"
      );
    }

    console.log("💳 TapPay 回傳結果", {
      uid,
      productId,
      status: tappayResult.status,
      msg: tappayResult.msg,
      recTradeId: tappayResult.rec_trade_id,
    });

    // TapPay status === 0 才代表交易成功
    if (tappayResult.status !== 0) {
      throw new HttpsError(
        "failed-precondition",
        tappayResult.msg || "付款未完成",
        {
          tappayStatus: tappayResult.status,
          tappayMessage: tappayResult.msg,
        }
      );
    }

    const recTradeId = String(
      tappayResult.rec_trade_id || ""
    ).trim();

    if (!recTradeId) {
      console.error("❌ TapPay 成功但沒有 rec_trade_id", tappayResult);

      throw new HttpsError(
        "internal",
        "付款結果缺少交易編號，請聯絡客服"
      );
    }

    const userRef = db.collection("users").doc(uid);

    // 用 TapPay 的交易編號當文件 ID，阻止同筆交易重複加點
    const paymentRef = db
      .collection("tappay_transactions")
      .doc(recTradeId);

    const flowerLogRef = userRef
      .collection("flower_logs")
      .doc(`tappay_${recTradeId}`);

    let transactionResponse = null;

    await db.runTransaction(async (transaction) => {
      // Firestore Transaction 規則：先讀完，再開始寫
      const paymentSnapshot = await transaction.get(paymentRef);
      const userSnapshot = await transaction.get(userRef);

      if (paymentSnapshot.exists) {
        const existing = paymentSnapshot.data() || {};

        transactionResponse = {
          success: true,
          duplicated: true,
          recTradeId,
          productId,
          pointsAdded: existing.pointsAdded || 0,
          message: "此筆付款已經完成入帳",
        };

        return;
      }

      if (!userSnapshot.exists) {
        throw new HttpsError(
          "not-found",
          "找不到玩家資料"
        );
      }

      const userData = userSnapshot.data() || {};

      const purchaseHistory =
        Array.isArray(userData.purchaseHistory)
          ? userData.purchaseHistory
          : [];

      const isFirstPurchase =
        !purchaseHistory.includes(productId);

      let pointsToAdd = product.points;
      let monthlySubEndDate = null;

      const userUpdate = {
        updatedAt: FieldValue.serverTimestamp(),

        totalSpent: FieldValue.increment(product.amount),

        purchaseHistory: FieldValue.arrayUnion(productId),
      };

      if (product.type === "points") {
        // 點數商品首購雙倍
        if (isFirstPurchase) {
          pointsToAdd = product.points * 2;
        }
      }

      if (product.type === "monthly_card") {
        const now = new Date();
        const storedEndDate =
          parseStoredDate(userData.monthlySubEndDate);

        // 尚未到期就在原到期日延長，已過期則從今天開始
        const baseDate =
          storedEndDate && storedEndDate > now
            ? storedEndDate
            : now;

        let newEndDate = addDays(baseDate, 30);

        // 最多保留約 180 天，避免無限制疊加
        const maximumEndDate = addDays(now, 180);

        if (newEndDate > maximumEndDate) {
          newEndDate = maximumEndDate;
        }

        monthlySubEndDate = newEndDate.toISOString();

        userUpdate.monthlySubEndDate =
          monthlySubEndDate;

        userUpdate.hasMonthlyPass = true;
      }

      userUpdate.flowerPoints =
        FieldValue.increment(pointsToAdd);

      transaction.update(userRef, userUpdate);

      transaction.create(paymentRef, {
        provider: "tappay",
        environment: "sandbox",
        uid,
        productId,
        productName: product.name,
        amount: product.amount,
        currency: "TWD",
        basePoints: product.points,
        pointsAdded: pointsToAdd,
        isFirstPurchase,
        type: product.type,
        recTradeId,
        bankTransactionId:
          tappayResult.bank_transaction_id || null,
        authCode:
          tappayResult.auth_code || null,
        status: tappayResult.status,
        tappayMessage: tappayResult.msg || "",
        createdAt:
          FieldValue.serverTimestamp(),
      });

      transaction.set(flowerLogRef, {
        title:
          product.type === "monthly_card"
            ? `${product.name}付款成功`
            : isFirstPurchase
                ? `${product.name}・首購雙倍`
                : `${product.name}付款成功`,

        amount: pointsToAdd,
        type: "purchase",
        provider: "tappay",
        productId,
        price: product.amount,
        currency: "TWD",
        recTradeId,
        isFirstPurchase,
        createdAt:
          FieldValue.serverTimestamp(),
      });

      transactionResponse = {
        success: true,
        duplicated: false,
        recTradeId,
        productId,
        productName: product.name,
        amount: product.amount,
        pointsAdded: pointsToAdd,
        isFirstPurchase,
        monthlySubEndDate,
        message: "付款成功，花花已經入帳",
      };
    });

    return transactionResponse;
  }
);

module.exports = {
  payByPrime,
};