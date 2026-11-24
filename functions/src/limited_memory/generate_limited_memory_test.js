'use strict';
const {onCall,HttpsError}=require('firebase-functions/v2/https');
const {defineSecret,defineString}=require('firebase-functions/params');
const {getApps,initializeApp}=require('firebase-admin/app');
const {getStorage}=require('firebase-admin/storage');
const {getFirestore,FieldValue}=require('firebase-admin/firestore');
const {randomUUID}=require('node:crypto');
const {buildLimitedMemoryPrompt}=require('./build_limited_memory_prompt');
const {generateImage,detectMime}=require('./gemini_image');
const key=defineSecret('LIMITED_MEMORY_GEMINI_KEY');
const adminUid=defineString('LIMITED_MEMORY_TEST_ADMIN_UID');
const generateLimitedMemoryTest=onCall({region:'us-central1',timeoutSeconds:240,memory:'512MiB',maxInstances:1,concurrency:1,secrets:[key]},async request=>{
  if (!request.auth) throw new HttpsError('unauthenticated','請先登入');
  if (!adminUid.value() || request.auth.uid!==adminUid.value()) throw new HttpsError('permission-denied','僅管理員可測試');
  const d=request.data || {};
  if (typeof d.imageBase64!=='string' || d.imageBase64.length>7*1024*1024 || !/^[A-Za-z0-9+/]+={0,2}$/.test(d.imageBase64)) throw new HttpsError('invalid-argument','請提供 5 MiB 以下的原始圖片 base64');
  const input=Buffer.from(d.imageBase64,'base64');
  try { if(input.length>5*1024*1024) throw Error(); detectMime(input); } catch (_) {throw new HttpsError('invalid-argument','只接受 PNG、JPEG、WebP 圖片');}
  const field=(name,max,fallback='')=>typeof d[name]==='string' ? d[name].trim().slice(0,max) : fallback;
  const characterName=field('characterName',60,'測試角色');
  const characterTitle=field('characterTitle',80);
  const personality=field('personality',1200,'溫柔、浪漫');
  if (!getApps().length) initializeApp();
  const db=getFirestore();
  // Taiwan calendar day, reserve a test slot before making the paid call.
  const day=new Date(Date.now()+8*3600000).toISOString().slice(0,10);
  const quota=db.collection('limited_memory_test_quota').doc(`${request.auth.uid}_${day}`);
  await db.runTransaction(async tx=>{const s=await tx.get(quota);const count=s.data()?.count||0;if(count>=10) throw new HttpsError('resource-exhausted','每日測試上限 10 次');tx.set(quota,{count:count+1,updatedAt:FieldValue.serverTimestamp()});});
  const id=randomUUID();
  try {
    const result=await generateImage({apiKey:key.value(),input,prompt:buildLimitedMemoryPrompt({characterName,characterTitle,personality})});
    const ext={'image/png':'png','image/jpeg':'jpg','image/webp':'webp'}[result.mimeType];
    const storagePath=`limited_memory_tests/${request.auth.uid}/${id}.${ext}`;
    const bucket=getStorage().bucket();
    await bucket.file(storagePath).save(result.bytes,{resumable:false,metadata:{contentType:result.mimeType,cacheControl:'private, no-store'}});
    console.info('[LM_TEST] success',{id,model:result.model,elapsedMs:result.elapsedMs,bytes:result.bytes.length,usage:result.usage});
    return {success:true,id,bucket:bucket.name,storagePath,mimeType:result.mimeType,elapsedMs:result.elapsedMs,usage:result.usage};
  } catch(e) {console.error('[LM_TEST] failed',{id,message:String(e.message).slice(0,200)});throw new HttpsError('internal','生成或儲存失敗，請查看 [LM_TEST] 日誌');}
});
module.exports={generateLimitedMemoryTest};
