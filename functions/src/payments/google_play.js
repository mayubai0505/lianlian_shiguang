'use strict';
const crypto = require('node:crypto');
const hash = value => crypto.createHash('sha256').update(value).digest('hex');
const points = {90:90,215:215,370:370,590:590,780:780,1030:1030,1420:1420,
  1650:1650,2200:2200,2300:2300,2350:2300,2400:2400,2680:2680,3200:3200,
  3400:3400,3450:3400,4200:4200,4300:4300,6400:6400,10000:10000};
const prices = {90:30,215:70,370:120,590:190,780:250,1030:330,1420:450,
  1650:520,2200:690,2300:720,2350:720,2400:750,2680:830,3200:990,
  3400:1050,3450:1050,4200:1290,4300:1314,6400:1930,10000:2990};
// Confirmed manually compensated by the developer. Verify against Google's
// order ID, NEVER against a client-supplied order ID. Do not grant again.
const manuallyFulfilledOrders = new Set(['GPA.3348-7669-0637-19774']);
function productInfo(productId) {
  if (['com_lianlian_monthly_card','com_lianlian_monthly_card_250'].includes(productId)) {
    return {base:250, price:250, monthly:true};
  }
  const match = /^com\.lianlian\.points_(\d+)$/.exec(productId);
  if (!match || !points[match[1]]) return null;
  return {base:points[match[1]], price:prices[match[1]], monthly:false};
}
function createFulfillHandler({db, FieldValue, HttpsError, verifyPurchase, now = () => new Date()}) {
  return async request => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', '請先登入。');
    const {productId, purchaseToken} = request.data || {};
    const info = typeof productId === 'string' && productInfo(productId);
    if (!info || typeof purchaseToken !== 'string' || !purchaseToken || purchaseToken.length > 8192) {
      throw new HttpsError('invalid-argument', '購買資料不完整。');
    }
    // Google alone decides whether the transaction is paid.
    const verified = await verifyPurchase(productId, purchaseToken);
    if (verified.purchaseState !== 0) {
      throw new HttpsError('failed-precondition', '訂單尚未付款成功或已取消。');
    }
    const orderId = verified.orderId;
    if (typeof orderId !== 'string' || !/^GPA\.[0-9.-]+$/.test(orderId)) {
      throw new HttpsError('failed-precondition', '缺少可核對的 Google 訂單編號。');
    }
    const tokenHash = hash(purchaseToken);
    const receiptRef = db.collection('google_play_receipts').doc(tokenHash);
    const orderRef = db.collection('google_play_orders').doc(orderId);
    const userRef = db.collection('users').doc(uid);
    const approvalRef = db.collection('google_play_legacy_approvals').doc(orderId);
    const logRef = userRef.collection('flower_logs').doc(`google_${tokenHash}`);
    return db.runTransaction(async tx => {
      const [receipt, order, approval] = await Promise.all([
        tx.get(receiptRef), tx.get(orderRef), tx.get(approvalRef)]);
      const existing = receipt.exists ? receipt.data() : order.exists ? order.data() : null;
      if (existing) {
        if (existing.uid !== uid) throw new HttpsError('permission-denied', '此訂單已綁定其他玩家。');
        if (existing.productId !== productId || existing.tokenHash !== tokenHash) {
          throw new HttpsError('failed-precondition', '訂單資料不一致。');
        }
        return {fulfilled:true, alreadyFulfilled:true, points:0};
      }
      const binding = verified.obfuscatedExternalAccountId;
      const legacy = approval.exists ? approval.data() : null;
      const manual = manuallyFulfilledOrders.has(orderId) ||
        (legacy?.uid === uid && legacy?.disposition === 'manual');
      if (binding && binding !== hash(uid)) {
        throw new HttpsError('permission-denied', '請登入購買時使用的玩家帳號。');
      }
      if (!manual && !binding && !(legacy?.uid === uid && legacy?.disposition === 'grant')) {
        // Old builds did not bind purchases to an app account. Never assign
        // those blindly to whoever happens to be logged in after a restart.
        throw new HttpsError('failed-precondition', '舊版訂單需客服確認歸屬，請提供訂單編號。');
      }
      if (!manual && verified.consumptionState === 1) {
        throw new HttpsError('failed-precondition', '已消耗的舊訂單需人工核對。');
      }
      if ((verified.quantity ?? 1) !== 1) {
        throw new HttpsError('failed-precondition', '多件購買需人工核對。');
      }
      const stamp = FieldValue.serverTimestamp();
      const record = {uid, productId, orderId, tokenHash, createdAt:stamp,
        status:manual ? 'manually_fulfilled' : 'fulfilled'};
      if (manual) {
        // A separate ledger marker; no balance, first-purchase, or log mutation.
        tx.set(receiptRef, record); tx.set(orderRef, record);
        return {fulfilled:true, alreadyFulfilled:true, points:0};
      }
      const userSnap = await tx.get(userRef);
      if (!userSnap.exists) throw new HttpsError('failed-precondition', '玩家資料尚未建立。');
      const user = userSnap.data();
      const first = !(Array.isArray(user.purchaseHistory) && user.purchaseHistory.includes(productId));
      const amount = info.monthly ? info.base : info.base * (first ? 2 : 1);
      const update = {flowerPoints:FieldValue.increment(amount),
        totalSpent:FieldValue.increment(info.price),
        purchaseHistory:FieldValue.arrayUnion(productId)};
      if (info.monthly) {
        const current = now();
        const rawEnd = user.monthlySubEndDate;
        const parsed = typeof rawEnd?.toDate === 'function' ? rawEnd.toDate() : new Date(rawEnd || 0);
        const active = Number.isFinite(parsed.getTime()) && parsed > current;
        const end = new Date(Math.min((active ? parsed : current).getTime() + 30*86400000,
          current.getTime() + 180*86400000));
        Object.assign(update, {isMonthlySubscribed:true, monthlySubEndDate:end.toISOString(),
          monthlyCardStatus:'active', maxRegenerateCount:20});
        if (!active) update.regenerateCount = 20;
      }
      tx.set(userRef, update, {merge:true});
      tx.set(logRef, {title:info.monthly ? '啟動：星光契約（月卡立即贈點）' :
        `儲值：${amount} 點${first ? '（含首購雙倍）' : ''}`,
        amount, type:'purchase', provider:'google_play', productId, orderId,
        // Existing totalSpent remains a TWD catalog value, not store settlement.
        price:info.price, currency:'TWD', priceSource:'catalog', createdAt:stamp});
      tx.set(receiptRef, {...record, points:amount});
      tx.set(orderRef, {...record, points:amount});
      return {fulfilled:true, alreadyFulfilled:false, points:amount, isFirstTime:first};
    });
  };
}
function createGooglePlayPurchaseFunction({onCall, HttpsError, db, FieldValue}) {
  const {defineString} = require('firebase-functions/params');
  const packageName = defineString('GOOGLE_PLAY_PACKAGE_NAME', {
    default: 'com.yubaimo.lianlian_shiguang',
  });
  const {GoogleAuth} = require('google-auth-library');
  const auth = new GoogleAuth({scopes:['https://www.googleapis.com/auth/androidpublisher']});
  const verifyPurchase = async (productId, token) => {
    try {
      const client = await auth.getClient();
      const segment = encodeURIComponent;
      const response = await client.request({
        url:`https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${segment(packageName.value())}/purchases/products/${segment(productId)}/tokens/${segment(token)}`,
        method:'GET', timeout:20000,
      });
      return response.data;
    } catch (error) {
      // Do not log raw HTTP errors: their URL contains a secret purchase token.
      const status = error.response?.status;
      if (status === 400 || status === 404 || status === 410) {
        throw new HttpsError('failed-precondition', 'Google 無法確認此訂單，請客服核對。');
      }
      throw new HttpsError('unavailable', 'Google 訂單驗證暫時無法使用，請稍後重試。');
    }
  };
  return onCall({region:'asia-east1', timeoutSeconds:60, maxInstances:3},
    createFulfillHandler({db, FieldValue, HttpsError, verifyPurchase}));
}
module.exports = {createGooglePlayPurchaseFunction, createFulfillHandler, productInfo};
