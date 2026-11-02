'use strict';
// V49: Preserves creator support attachment and case-creation behavior.
function createCreatorSupportAttachments({creatorSupportAuthorizeImage,creatorSupportImageData,creatorSupportCreator,creatorSupportText,creatorSupportRoot,creatorSupportNotifyAdmins,creatorFanMailDayKey,CREATOR_SUPPORT_MAX_IMAGE_BYTES,CREATOR_SUPPORT_CATEGORIES,db,APP_ID,FieldValue,HttpsError}) {
 async function uploadCreatorSupportImageHandler(request) {
  const caseId=String(request.data?.caseId||'');const {ref}=await creatorSupportAuthorizeImage(request,caseId);
  const {bytes,contentType}=creatorSupportImageData(request.data?.imageBase64);
  const messageId=String(request.data?.messageId||'').trim();
  if(messageId&&!/^[A-Za-z0-9]{1,100}$/.test(messageId))throw new HttpsError('invalid-argument','訊息 ID 無效');
  if(messageId){
   const msg=await ref.collection('messages').doc(messageId).get();
   if(!msg.exists)throw new HttpsError('not-found','找不到這則回覆');
   if(msg.data()?.senderId!==request.auth?.uid)throw new HttpsError('permission-denied','只能為自己發出的回覆附圖');
   if(msg.data()?.recalledAt)throw new HttpsError('failed-precondition','訊息已收回');
  }
  const images=await ref.collection('images').get();
  if(images.size>=60)throw new HttpsError('resource-exhausted','這個案件的圖片已達上限');
  if(images.docs.filter(d=>String(d.data().messageId||'')===messageId).length>=3)throw new HttpsError('resource-exhausted','每則訊息最多 3 張截圖');
  const imgRef=ref.collection('images').doc();
  const bucket=require('firebase-admin/storage').getStorage().bucket();
  const file=bucket.file(`creator_support/${caseId}/${imgRef.id}`);
  await file.save(bytes,{resumable:false,validation:'md5',metadata:{contentType,cacheControl:'private,no-store'}});
  try {await imgRef.create({path:file.name,messageId,contentType,size:bytes.length,createdAt:FieldValue.serverTimestamp()});}
  catch(e){await file.delete({ignoreNotFound:true});throw e;}
  return {imageId:imgRef.id};
 }
 async function getCreatorSupportImageHandler(request) {
  const caseId=String(request.data?.caseId||''),imageId=String(request.data?.imageId||'');
  const {ref}=await creatorSupportAuthorizeImage(request,caseId);
  if(!/^[A-Za-z0-9]{1,100}$/.test(imageId))throw new HttpsError('invalid-argument','圖片ID無效');
  const doc=await ref.collection('images').doc(imageId).get();if(!doc.exists)throw new HttpsError('not-found','找不到圖片');
  const mid=String(doc.data()?.messageId||'');if(mid){const m=await ref.collection('messages').doc(mid).get();if(!m.exists||m.data()?.recalledAt||(m.data()?.hiddenFor||[]).includes(request.auth.uid))throw new HttpsError('not-found','圖片已不可查看');}
  const path=String(doc.data()?.path||'');if(!path.startsWith(`creator_support/${caseId}/`))throw new HttpsError('permission-denied','圖片路徑異常');
  const [bytes]=await require('firebase-admin/storage').getStorage().bucket().file(path).download();
  if(bytes.length>CREATOR_SUPPORT_MAX_IMAGE_BYTES)throw new HttpsError('resource-exhausted','圖片超出限制');
  return {imageBase64:bytes.toString('base64'),contentType:doc.data().contentType||'image/jpeg'};
 }
 async function createCreatorSupportCaseHandler(request) {
 const {uid,data}=await creatorSupportCreator(request);
 const d=request.data||{}; const category=creatorSupportText(d.category,32,'分類'); if(!CREATOR_SUPPORT_CATEGORIES.has(category)) throw new HttpsError('invalid-argument','問題分類無效');
 const title=creatorSupportText(d.title,80,'標題'); const description=creatorSupportText(d.description,3000,'問題描述');
 const characterId=creatorSupportText(d.characterId,160,'角色ID',false);
 if(characterId){const ch=await db.collection('artifacts').doc(APP_ID).collection('public_characters').doc(characterId).get();if(!ch.exists||ch.data()?.createdBy!==uid)throw new HttpsError('permission-denied','只能選擇自己的角色');}
 const day=creatorFanMailDayKey();const limitRef=db.collection('creator_support_daily').doc(`${uid}_${day}`);const ref=creatorSupportRoot().doc();const first=ref.collection('messages').doc();
 await db.runTransaction(async tx=>{
  const snap=await tx.get(limitRef);if(Number(snap.data()?.count||0)>=5)throw new HttpsError('resource-exhausted','今天新增案件已達 5 件，仍可回覆既有案件');
  tx.set(limitRef,{count:FieldValue.increment(1),updatedAt:FieldValue.serverTimestamp()},{merge:true});
  tx.create(ref,{creatorId:uid,creatorName:String(data.nickname||data.displayName||'合作創作者').slice(0,80),category,characterId,title,description,status:'pending',createdAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp(),lastReplyAt:FieldValue.serverTimestamp(),lastReplyBy:'creator',adminUnreadCount:1,creatorUnreadCount:0,internalNote:''});
  tx.create(first,{senderId:uid,senderRole:'creator',body:description,createdAt:FieldValue.serverTimestamp()});
 }); await creatorSupportNotifyAdmins('新創作者問題回報',title,ref.id); return {caseId:ref.id};
 }
 return {uploadCreatorSupportImageHandler,getCreatorSupportImageHandler,createCreatorSupportCaseHandler};
}
module.exports={createCreatorSupportAttachments};
