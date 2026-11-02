'use strict';
// V48: Shared Taiwan/US creator support write handlers; source bodies unchanged.
function createCreatorSupportWriters({creatorSupportUid, creatorSupportText, creatorSupportRoot, creatorSupportCreator, creatorSupportAdmin, creatorSupportNotify, creatorSupportNotifyAdmins, REWARD_CAMPAIGN_ADMIN_UIDS, CREATOR_SUPPORT_STATUSES, HttpsError, crypto, db, FieldValue, logger}) {
  async function replyCreatorSupportCaseHandler(request) {
 const uid=creatorSupportUid(request);
 const id=String(request.data?.caseId||'').trim();
 if(!/^[A-Za-z0-9]{1,100}$/.test(id)) throw new HttpsError('invalid-argument','案件ID無效');
 const suppliedRequestId=String(request.data?.requestId||'').trim();
 if(suppliedRequestId && !/^[A-Za-z0-9_-]{12,100}$/.test(suppliedRequestId)) throw new HttpsError('invalid-argument','訊息識別碼無效');
 // Backwards compatibility: legacy clients can still reply; only updated clients get retry deduplication.
 const requestId=suppliedRequestId || crypto.randomUUID();
 const hasImages=request.data?.hasImages===true;
 const body=creatorSupportText(request.data?.body,3000,'回覆內容',!hasImages);
 if(!body&&!hasImages) throw new HttpsError('invalid-argument','請輸入文字或選擇圖片');
 const isAdmin=REWARD_CAMPAIGN_ADMIN_UIDS.has(uid)&&request.data?.asCreator!==true;
 const ref=creatorSupportRoot().doc(id);
 // Deterministic, unguessable document ID scoped to sender, case and request key.
 const messageId=crypto.createHash('sha256').update(JSON.stringify([id,uid,requestId])).digest('hex');
 const msg=ref.collection('messages').doc(messageId);
 let committed=false;
 try {
  // Check eligibility even on retries; access must never be granted by a cached receipt alone.
  if(!isAdmin) await creatorSupportCreator(request);
  const outcome=await db.runTransaction(async tx=>{
   const [caseSnap,priorSnap]=await Promise.all([tx.get(ref),tx.get(msg)]);
   if(!caseSnap.exists) throw new HttpsError('not-found','案件不存在');
   const d=caseSnap.data()||{};
   if(!isAdmin&&d.creatorId!==uid) throw new HttpsError('permission-denied','無權回覆此案件');
   if(priorSnap.exists){
    const prior=priorSnap.data()||{};
    // Do not replay the same key with different content, even after message edits.
    if(prior.senderId!==uid || prior.originalBody!==body || prior.originalHasImages!==hasImages || prior.senderRole!==(isAdmin?'admin':'creator'))
      throw new HttpsError('already-exists','此訊息識別碼已被不同內容使用');
    return {alreadySubmitted:true};
   }
   if(d.status==='resolved'&&!isAdmin) throw new HttpsError('failed-precondition','案件已結案，請由官方重新開啟');
   tx.create(msg,{senderRole:isAdmin?'admin':'creator',senderId:uid,body,
    originalBody:body,originalHasImages:hasImages,createdAt:FieldValue.serverTimestamp()});
   tx.update(ref,{updatedAt:FieldValue.serverTimestamp(),lastReplyAt:FieldValue.serverTimestamp(),lastReplyBy:isAdmin?'admin':'creator',
    status:!isAdmin&&d.status==='waiting_creator'?'in_progress':d.status,
    ...(isAdmin?{creatorUnreadCount:FieldValue.increment(1)}:{adminUnreadCount:FieldValue.increment(1)})});
   return {alreadySubmitted:false};
  });
  committed=true;
  logger.info('creator_support_reply_persisted',{caseId:id,messageId,actorRole:isAdmin?'admin':'creator',replayed:outcome.alreadySubmitted});
  if(!outcome.alreadySubmitted){
   // Notification is best effort; it must never turn a committed message into an INTERNAL error.
   try {
    if(isAdmin){
     const caseSnap=await ref.get();
     await creatorSupportNotify(caseSnap.data()?.creatorId,'創作者問題回報有新回覆','官方已回覆妳的案件',id);
    } else await creatorSupportNotifyAdmins('創作者有新回覆','有新的案件訊息待查看',id);
   } catch(notifyError){
    logger.warn('creator_support_reply_notification_failed',{caseId:id,messageId,code:notifyError?.code||'',error:String(notifyError?.message||notifyError)});
   }
  }
  return {success:true,messageId,alreadySubmitted:outcome.alreadySubmitted};
 } catch(error){
  logger.error('creator_support_reply_failed',{caseId:id,actorRole:isAdmin?'admin':'creator',committed,code:error?.code||'',error:String(error?.message||error)});
  if(error instanceof HttpsError) throw error;
  throw new HttpsError('internal','客服回覆暫時無法處理，請稍後重試');
 }
  }

  async function updateCreatorSupportCaseHandler(request) {
 creatorSupportAdmin(request);const id=String(request.data?.caseId||''),ref=creatorSupportRoot().doc(id);
 if(!/^[A-Za-z0-9]{1,100}$/.test(id))throw new HttpsError('invalid-argument','案件ID無效');
 const status=request.data?.status;const note=request.data?.internalNote;
 if(status===undefined&&note===undefined)throw new HttpsError('invalid-argument','沒有修改內容');
 const update={updatedAt:FieldValue.serverTimestamp()};
 if(status!==undefined){if(!CREATOR_SUPPORT_STATUSES.has(status))throw new HttpsError('invalid-argument','狀態無效');update.status=status;update.creatorUnreadCount=FieldValue.increment(1);}
 if(note!==undefined)update.internalNote=creatorSupportText(note,2000,'內部備註',false);
 await ref.update(update);if(status!==undefined)await creatorSupportNotify((await ref.get()).data().creatorId,'創作者案件狀態已更新',`案件狀態：${status}`,id);return {success:true};
  }

  async function manageCreatorSupportMessageHandler(request) {
 const uid=creatorSupportUid(request);
 const caseId=String(request.data?.caseId||'');
 const messageId=String(request.data?.messageId||'');
 const operation=String(request.data?.operation||'');
 if(!/^[A-Za-z0-9]{1,100}$/.test(caseId)||!/^[A-Za-z0-9]{1,100}$/.test(messageId))throw new HttpsError('invalid-argument','案件或訊息 ID 無效');
 if(!['edit','recall','delete'].includes(operation))throw new HttpsError('invalid-argument','操作類型無效');
 const ref=creatorSupportRoot().doc(caseId);
 const msgRef=ref.collection('messages').doc(messageId);
 const isAdmin=REWARD_CAMPAIGN_ADMIN_UIDS.has(uid)&&request.data?.asCreator!==true;
 if(!isAdmin)await creatorSupportCreator(request);
 await db.runTransaction(async tx=>{
  const caseSnap=await tx.get(ref);
  const msgSnap=await tx.get(msgRef);
  if(!caseSnap.exists||!msgSnap.exists)throw new HttpsError('not-found','案件或訊息不存在');
  if(!isAdmin&&caseSnap.data().creatorId!==uid)throw new HttpsError('permission-denied','無權操作案件');
  const m=msgSnap.data()||{};
  if(m.senderId!==uid)throw new HttpsError('permission-denied','只能操作自己發送的訊息');
  if(m.recalledAt)throw new HttpsError('failed-precondition','訊息已收回');
  if(operation==='delete'){
   tx.update(msgRef,{hiddenFor:FieldValue.arrayUnion(uid)});
   return;
  }
  if((m.hiddenFor||[]).includes(uid))throw new HttpsError('failed-precondition','訊息已刪除');
  if(operation==='edit'){
   const body=creatorSupportText(request.data?.body,3000,'訊息內容');
   if(!String(m.body||'').trim())throw new HttpsError('failed-precondition','純圖片訊息不能編輯文字');
   tx.update(msgRef,{body,editedAt:FieldValue.serverTimestamp()});
   return;
  }
  const sent=m.createdAt?.toMillis?.();
  if(!Number.isFinite(sent)||Date.now()-sent>60000||Date.now()<sent)
   throw new HttpsError('failed-precondition','已超過 60 秒收回期限');
  tx.update(msgRef,{body:'',recalledAt:FieldValue.serverTimestamp()});
 });
 return {success:true};
  }
  return {replyCreatorSupportCaseHandler, updateCreatorSupportCaseHandler, manageCreatorSupportMessageHandler};
}
module.exports={createCreatorSupportWriters};
