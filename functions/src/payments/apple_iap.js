'use strict';
const crypto = require('node:crypto');
const {productInfo} = require('./google_play');
const hash = s => crypto.createHash('sha256').update(s).digest('hex');
function accountToken(uid) {
  const h = hash(`lianlian:apple:${uid}`).slice(0,32).split('');
  h[12]='8'; h[16]=((parseInt(h[16],16)&3)|8).toString(16);
  const s=h.join('');
  return `${s.slice(0,8)}-${s.slice(8,12)}-${s.slice(12,16)}-${s.slice(16,20)}-${s.slice(20)}`;
}
function createAppleFulfillHandler({db, FieldValue, HttpsError, verifyTransaction, now=()=>new Date()}) {
  return async request => {
    const uid=request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated','請先登入。');
    const jws=request.data?.signedTransaction;
    if (typeof jws !== 'string' || jws.length>100000 || jws.split('.').length!==3) {
      throw new HttpsError('invalid-argument','缺少 Apple 簽章交易資料。');
    }
    const v=await verifyTransaction(jws);
    const info=productInfo(v.productId);
    if (!info || !/^\d+$/.test(String(v.transactionId)) || v.revocationDate != null ||
        v.type!=='Consumable' || v.quantity!==1 || v.inAppOwnershipType==='FAMILY_SHARED') {
      throw new HttpsError('failed-precondition','此 Apple 交易無法自動發放。');
    }
    const id=String(v.transactionId), environment=v.environment;
    if (!['Production','Sandbox'].includes(environment)) {
      throw new HttpsError('failed-precondition','不支援的 Apple 環境。');
    }
    const key=hash(`${environment}:${id}`);
    const receiptRef=db.collection('apple_iap_receipts').doc(key);
    const approvalRef=db.collection('apple_iap_legacy_approvals').doc(`${environment}_${id}`);
    const userRef=db.collection('users').doc(uid);
    const testerRef=db.collection('iap_sandbox_testers').doc(uid);
    return db.runTransaction(async tx=>{
      const [receipt, approval, tester, userSnap]=await Promise.all([
        tx.get(receiptRef),tx.get(approvalRef),tx.get(testerRef),tx.get(userRef)]);
      if (environment==='Sandbox' && !(tester.exists && tester.data().enabled===true)) {
        throw new HttpsError('permission-denied','測試訂單僅開放指定測試帳號。');
      }
      if (receipt.exists) {
        const r=receipt.data();
        if (r.uid!==uid || r.productId!==v.productId) {
          throw new HttpsError('permission-denied','交易已綁定其他玩家。');
        }
        return {fulfilled:true,alreadyFulfilled:true,points:0};
      }
      const legacy=approval.exists ? approval.data() : null;
      const approved=legacy?.uid===uid && ['grant','manual'].includes(legacy.disposition);
      if (v.appAccountToken && v.appAccountToken.toLowerCase()!==accountToken(uid)) {
        throw new HttpsError('permission-denied','請登入購買時使用的玩家帳號。');
      }
      if (!v.appAccountToken && !approved) {
        throw new HttpsError('failed-precondition','舊版 Apple 訂單需客服核對歸屬與是否已發放。');
      }
      const stamp=FieldValue.serverTimestamp();
      const record={uid,transactionId:id,productId:v.productId,environment,createdAt:stamp};
      if (approved && legacy.disposition==='manual') {
        tx.set(receiptRef,{...record,status:'manually_fulfilled'});
        return {fulfilled:true,alreadyFulfilled:true,points:0};
      }
      if (!userSnap.exists) throw new HttpsError('failed-precondition','玩家資料尚未建立。');
      const user=userSnap.data();
      const first=!(Array.isArray(user.purchaseHistory) && user.purchaseHistory.includes(v.productId));
      const amount=info.base*(info.monthly || !first ? 1 : 2);
      const update={flowerPoints:FieldValue.increment(amount),totalSpent:FieldValue.increment(info.price),
        purchaseHistory:FieldValue.arrayUnion(v.productId)};
      if (info.monthly) {
        const current=now(), raw=user.monthlySubEndDate;
        const end=typeof raw?.toDate==='function' ? raw.toDate() : new Date(raw||0);
        const active=Number.isFinite(end.getTime()) && end>current;
        Object.assign(update,{isMonthlySubscribed:true,monthlyCardStatus:'active',maxRegenerateCount:20,
          monthlySubEndDate:new Date(Math.min((active?end:current).getTime()+30*86400000,
            current.getTime()+180*86400000)).toISOString()});
        if (!active) update.regenerateCount=20;
      }
      tx.set(userRef,update,{merge:true});
      tx.set(userRef.collection('flower_logs').doc(`apple_${key}`),{
        title:info.monthly?'啟動：星光契約（月卡立即贈點）':`儲值：${amount} 點${first?'（含首購雙倍）':''}`,
        amount,type:'purchase',provider:'apple_iap',productId:v.productId,purchaseId:id,
        environment,price:info.price,currency:'TWD',priceSource:'catalog',createdAt:stamp});
      tx.set(receiptRef,{...record,status:'fulfilled',points:amount});
      return {fulfilled:true,alreadyFulfilled:false,points:amount,isFirstTime:first};
    });
  };
}
function createApplePurchaseFunction({onCall,HttpsError,db,FieldValue}) {
  const {SignedDataVerifier,Environment}=require('@apple/app-store-server-library');
  const fs=require('node:fs'),path=require('node:path');
  const root=fs.readFileSync(path.join(__dirname,'certs','AppleRootCA-G3.cer'));
  const bundleId='com.yubaimo.lianlianshiguang.mac';
  const verifiers=[Environment.PRODUCTION,Environment.SANDBOX].map(env=>
    new SignedDataVerifier([root],true,env,bundleId,env===Environment.PRODUCTION?6773677178:undefined));
  const verifyTransaction=async jws=>{
    // No trust is placed in a client-decoded payload; only Apple's library
    // can authenticate the certificate chain, signature, bundle and environment.
    for (const verifier of verifiers) {
      try {return await verifier.verifyAndDecodeTransaction(jws);} catch (_) { /* try other environment */ }
    }
    throw new HttpsError('failed-precondition','Apple 簽章驗證未完成，保留交易供重試或客服查核。');
  };
  return onCall({region:'asia-east1',timeoutSeconds:60,maxInstances:3},
    createAppleFulfillHandler({db,FieldValue,HttpsError,verifyTransaction}));
}
module.exports={createApplePurchaseFunction,createAppleFulfillHandler,accountToken};
