'use strict';
// Google Play RTDN offline recovery. Never log raw tokens, URLs or Google error objects.
const crypto = require('node:crypto');
const {GoogleAuth} = require('google-auth-library');
const {onMessagePublished} = require('firebase-functions/v2/pubsub');
const {onSchedule} = require('firebase-functions/v2/scheduler');
const {defineSecret} = require('firebase-functions/params');
const {createFulfillHandler, productInfo} = require('./google_play');

const TOPIC = 'lianlian-play-rtdn';
const PACKAGE = 'com.yubaimo.lianlian_shiguang';
const SERVICE_ACCOUNT = '892791360631-compute@developer.gserviceaccount.com';
const RETRY_SECRET = defineSecret('GOOGLE_PLAY_RETRY_KEY');
const sha = x => crypto.createHash('sha256').update(x).digest('hex');
const auth = new GoogleAuth({scopes: ['https://www.googleapis.com/auth/androidpublisher']});
const COLLECTION = 'google_play_pending_recovery';
const BINDINGS = 'google_play_account_bindings';

function safeError(err, phase) {
  const status = err?.response?.status;
  const googleStatus = err?.response?.data?.error?.status;
  console.warn('GOOGLE_PLAY_RECOVERY_FAILURE', {
    phase,
    httpStatus: Number.isInteger(status) ? status : null,
    googleStatus: typeof googleStatus === 'string' && /^[A-Z_]{1,45}$/.test(googleStatus) ? googleStatus : null,
  });
}
function secretKey(secret) {
  if (!/^[0-9a-f]{64}$/i.test(secret || '')) throw new Error('GOOGLE_PLAY_RETRY_KEY must be a 64-character hex secret');
  return Buffer.from(secret, 'hex');
}
function encrypt(token, secret) {
  const iv = crypto.randomBytes(12);
  const cipher = crypto.createCipheriv('aes-256-gcm', secretKey(secret), iv);
  const payload = Buffer.concat([cipher.update(token, 'utf8'), cipher.final()]);
  return {iv: iv.toString('base64'), data: payload.toString('base64'), tag: cipher.getAuthTag().toString('base64')};
}
function decrypt(box, secret) {
  const decipher = crypto.createDecipheriv('aes-256-gcm', secretKey(secret), Buffer.from(box.iv, 'base64'));
  decipher.setAuthTag(Buffer.from(box.tag, 'base64'));
  return Buffer.concat([decipher.update(Buffer.from(box.data, 'base64')), decipher.final()]).toString('utf8');
}
function parseNotification(message) {
  let body;
  if (message?.json && typeof message.json === 'object') body = message.json;
  else if (typeof message?.data === 'string') body = JSON.parse(Buffer.from(message.data, 'base64').toString('utf8'));
  else return null;
  if (body.packageName !== PACKAGE) return null;
  const item = body.oneTimeProductNotification;
  if (!item || ![1,2].includes(item.notificationType) ||
      typeof item.sku !== 'string' || !productInfo(item.sku) ||
      typeof item.purchaseToken !== 'string' || !item.purchaseToken || item.purchaseToken.length > 8192) return null;
  return {productId: item.sku, token: item.purchaseToken, type:item.notificationType};
}
function retryAt(minutes) { return new Date(Date.now() + minutes * 60000); }
function delayFor(attempts) { return Math.min(120, Math.max(2, Math.pow(2, Math.min(6, attempts)))); }

// Only authenticated callers can register an account hash; no purchase token needed.
// The hash is the same applicationUserName that existing Flutter buyProduct() sends.
async function registerAccountBinding(db, uid, FieldValue) {
  if (typeof uid !== 'string' || !uid || uid.length > 256) throw new Error('invalid UID');
  const ref = db.collection(BINDINGS).doc(sha(uid));
  await db.runTransaction(async tx => {
    const doc = await tx.get(ref);
    if (doc.exists && doc.data().uid !== uid) throw new Error('account binding collision');
    if (!doc.exists) tx.create(ref, {uid, createdAt:FieldValue.serverTimestamp()});
  });
}

async function googleGet(productId, token) {
  const client = await auth.getClient();
  const e = encodeURIComponent;
  return (await client.request({
    method:'GET', timeout:20000,
    url:`https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${e(PACKAGE)}/purchases/products/${e(productId)}/tokens/${e(token)}`,
  })).data;
}
async function googleConsume(productId, token) {
  const client = await auth.getClient();
  const e = encodeURIComponent;
  return client.request({
    method:'POST', timeout:20000, data:{},
    url:`https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${e(PACKAGE)}/purchases/products/${e(productId)}/tokens/${e(token)}:consume`,
  });
}
function statusUpdate(db, ref, status, extra = {}) {
  return ref.set({status, updatedAt:new Date(), ...extra}, {merge:true});
}
function createProcessor({db, FieldValue, HttpsError, verify = googleGet, consume = googleConsume, secret = () => RETRY_SECRET.value()}) {
  async function processDoc(ref) {
    // Lease reduces duplicate processing during scheduler overlap or Pub/Sub redelivery.
    const claim = await db.runTransaction(async tx => {
      const snap = await tx.get(ref);
      if (!snap.exists) return null;
      const row = snap.data();
      if (!['pending','awaiting_binding','consuming'].includes(row.status) ||
          (row.nextRetryAt?.toDate?.() || new Date(row.nextRetryAt || 0)) > new Date()) return null;
      tx.update(ref, {nextRetryAt:retryAt(3), updatedAt:new Date()});
      return row;
    });
    if (!claim) return 'skipped';
    const attempt = (claim.attempts || 0) + 1;
    let token;
    try { token = decrypt(claim.encryptedToken, secret()); }
    catch (error) {
      await statusUpdate(db,ref,'manual_review',{reason:'decrypt_failed',nextRetryAt:null});
      console.warn('GOOGLE_PLAY_RECOVERY_REVIEW',{reason:'decrypt_failed'});
      return 'review';
    }
    const fail = async (phase, error) => {
      safeError(error,phase);
      await statusUpdate(db,ref,'pending',{attempts:attempt,nextRetryAt:retryAt(delayFor(attempt))});
      return 'retry';
    };
    let verified;
    try { verified = await verify(claim.productId,token); }
    catch (error) { return fail('verify',error); }
    // No grants for pending/canceled purchases, or quantities requiring manual review.
    if (verified.purchaseState !== 0 || (verified.quantity ?? 1) !== 1) {
      await statusUpdate(db,ref,'manual_review',{reason:'purchase_not_eligible',nextRetryAt:null});
      return 'review';
    }
    if (verified.obfuscatedExternalAccountId && !/^[a-f0-9]{64}$/i.test(verified.obfuscatedExternalAccountId)) {
      await statusUpdate(db,ref,'manual_review',{reason:'unrecognized_account_binding',nextRetryAt:null});
      return 'review';
    }
    const hashUid = verified.obfuscatedExternalAccountId;
    if (!hashUid) {
      await statusUpdate(db,ref,'manual_review',{reason:'unbound_legacy_purchase',nextRetryAt:null});
      return 'review';
    }
    const binding = await db.collection(BINDINGS).doc(hashUid).get();
    if (!binding.exists || !binding.data()?.uid || sha(binding.data().uid)!==hashUid) {
      await statusUpdate(db,ref,'awaiting_binding',{attempts:attempt,nextRetryAt:retryAt(5)});
      return 'awaiting_binding';
    }
    const uid = binding.data().uid;
    // Reuses the EXACT original transactional receipts/orders/first-purchase rules.
    // Never grants from an RTDN alone; verified Google response is required.
    const fulfill = createFulfillHandler({db,FieldValue,HttpsError,verifyPurchase:async()=>verified});
    let result;
    try {
      result = await fulfill({auth:{uid},data:{productId:claim.productId,purchaseToken:token}});
    } catch (error) {
      // Existing manual review and account/consumption guards must not be bypassed.
      const code = error?.code;
      if (['failed-precondition','permission-denied','invalid-argument'].includes(code)) {
        await statusUpdate(db,ref,'manual_review',{reason:'fulfillment_rejected',nextRetryAt:null});
        return 'review';
      }
      return fail('fulfill', error);
    }
    if (result.fulfilled !== true) return fail('fulfill_unknown',null);
    // Ledger is durable before attempting consumption. If this fails, retry
    // and the original receipt prevents duplicate flower grants.
    if (verified.consumptionState !== 1) {
      try { await consume(claim.productId,token); }
      catch (error) { return fail('consume',error); }
    }
    await statusUpdate(db,ref,'fulfilled',{uid,orderId:verified.orderId||null,
      pointsGranted:result.points||0,alreadyFulfilled:result.alreadyFulfilled===true,
      encryptedToken:FieldValue.delete(),nextRetryAt:null,completedAt:new Date()});
    console.info('GOOGLE_PLAY_RECOVERY_COMPLETED', {alreadyFulfilled:result.alreadyFulfilled===true});
    return 'fulfilled';
  }
  async function receive(notification) {
    const id = sha(notification.token);
    const ref = db.collection(COLLECTION).doc(id);
    const existing = await ref.get();
    if (existing.exists && notification.type === 2) {
      const current = existing.data();
      await statusUpdate(db,ref,current.status === 'fulfilled' ? 'refund_review' : 'canceled',
        {reason:'google_canceled_notification',nextRetryAt:null});
      console.warn('GOOGLE_PLAY_RECOVERY_REVIEW',{reason:'google_canceled_notification'});
      return 'review';
    }
    if (existing.exists) {
      if (existing.data().productId !== notification.productId) {
        console.warn('GOOGLE_PLAY_RECOVERY_REVIEW',{reason:'token_product_conflict'});
        return 'review';
      }
      // Do not replay completed, canceled or manually reviewed transactions.
      if (['fulfilled','manual_review','canceled','refund_review'].includes(existing.data().status)) return 'skipped';
      return processDoc(ref);
    }
    const canceled = notification.type === 2;
    const newRow = {productId:notification.productId,tokenHash:id,
      encryptedToken:encrypt(notification.token,secret()),
      status:canceled?'canceled':'pending',attempts:0,createdAt:new Date(),
      updatedAt:new Date(),nextRetryAt:canceled?null:new Date()};
    try { await ref.create(newRow); }
    catch (e) { if (e.code !== 6 && e.code !== 'already-exists') throw e; }
    return canceled ? 'canceled' : processDoc(ref);
  }
  async function scheduled(limit=40) {
    const snaps = await db.collection(COLLECTION).where('nextRetryAt','<=',new Date()).limit(limit).get();
    let completed=0,review=0;
    for (const doc of snaps.docs) {
      const result = await processDoc(doc.ref);
      if (result==='fulfilled') completed++;
      if (result==='review') review++;
    }
    console.info('GOOGLE_PLAY_RECOVERY_SWEEP',{scanned:snaps.size,completed,review});
  }
  return {receive,scheduled,processDoc};
}
function createGooglePlayOfflineFunctions({db,FieldValue,HttpsError}) {
  const get = ()=>createProcessor({db,FieldValue,HttpsError});
  return {
    googlePlayRtdn: onMessagePublished({topic:TOPIC,region:'us-central1',
      serviceAccount:SERVICE_ACCOUNT, secrets:[RETRY_SECRET],retry:true,maxInstances:2},
    async event => {
      let data;
      try {data = parseNotification(event.data.message);} catch (_) {
        console.warn('GOOGLE_PLAY_RTND_BAD_MESSAGE'); return;
      }
      if (!data) return;
      await get().receive(data);
    }),
    retryGooglePlayOrders: onSchedule({schedule:'every 5 minutes',region:'us-central1',
      serviceAccount:SERVICE_ACCOUNT,secrets:[RETRY_SECRET],timeoutSeconds:240,maxInstances:1},
    async()=>get().scheduled()),
  };
}
module.exports = {createGooglePlayOfflineFunctions,registerAccountBinding,
  createProcessor,parseNotification,encrypt,decrypt};
