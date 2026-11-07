'use strict';
const {publicChatCount,isPublicChatRoom}=require('./chat_count');
const ADMIN_UID='B71k2kyooubYsOtIO1nkiBwyBXt2';
function atOrBefore(value,cutoff){
  return Number.isInteger(value?.seconds) && Number.isInteger(value?.nanoseconds) &&
    (value.seconds<cutoff.seconds || (value.seconds===cutoff.seconds && value.nanoseconds<=cutoff.nanoseconds));
}
function classifyMessage(message,cutoff){
  if(message?.sender!=='user')return 'excluded';
  if(!Number.isInteger(message.timestamp?.seconds)||!Number.isInteger(message.timestamp?.nanoseconds))return 'uncertain';
  if(!atOrBefore(message.timestamp,cutoff))return 'excluded';
  if(message.billingType && message.billingType!=='chat')return 'excluded';
  if(message.operation && message.operation!=='send')return 'excluded';
  if(message.interactionType || message.giftType || typeof message.text!=='string' || !message.text.trim())return 'excluded';
  // Without the server-written chat billing marker, old generated interactions
  // cannot always be distinguished from text sends. Report, never guess.
  return message.billingType==='chat' ? 'confirmed':'uncertain';
}
function correctionPlan({baseline,observed,current,baseRevision,currentRevision}){
  if(baseRevision!==currentRevision || current<baseline)throw Error('stale-audit');
  const delta=Math.max(0,observed-baseline);
  return {delta,next:current+delta};
}
function report(id,data){return {jobId:id,worldId:data.worldId,status:data.status,
  baseline:data.baseline,confirmed:data.confirmed||0,uncertain:data.uncertain||0,
  scanned:data.scanned||0,roomsChecked:data.roomsChecked||0,excludedRooms:data.excludedRooms||0,
  delta:Math.max(0,(data.confirmed||0)-data.baseline),
  ...(data.appliedCount!=null?{appliedCount:data.appliedCount}:{})};}
function createWorldChatAudit({db,FieldValue,HttpsError,crypto,documentId,APP_ID='lianlianshiguang'}){
 const root=db.collection('artifacts').doc(APP_ID);
 const jobs=db.collection('world_chat_count_audits');
 const publicWorld=w=>w?.isPublic===true&&w?.publicPlayable===true&&w?.status==='public'&&w?.isDraft!==true;
 const revision=w=>Number.isSafeInteger(w?.chatCountAuditRevision)?w.chatCountAuditRevision:0;
 const validId=v=>typeof v==='string'&&/^[\w-]{1,160}$/.test(v);
 return async request=>{
  if(request.auth?.uid!==ADMIN_UID)throw new HttpsError('permission-denied','只有管理員可以核對聊天數。');
  const p=request.data||{},action=p.action;
  if(action==='list'){
   let q=root.collection('worlds').orderBy(documentId).limit(40);
   if(p.cursor){if(!validId(p.cursor))throw new HttpsError('invalid-argument','游標不正確');q=q.startAfter(p.cursor);}
   const snap=await q.get();
   return {worlds:snap.docs.filter(d=>publicWorld(d.data())).map(d=>({id:d.id,name:String(d.data().name||'未命名世界').slice(0,80),count:publicChatCount(d.data())})),
    cursor:snap.size===40?snap.docs[snap.docs.length-1].id:null};
  }
  if(action==='start'){
   if(!validId(p.worldId))throw new HttpsError('invalid-argument','世界 ID 不正確');
   const ref=jobs.doc(),worldRef=root.collection('worlds').doc(p.worldId);
   return db.runTransaction(async tx=>{
    const snap=await tx.get(worldRef);const w=snap.data();
    if(!snap.exists||!publicWorld(w))throw new HttpsError('failed-precondition','只核對目前公開的世界。');
    const state={worldId:p.worldId,creatorId:String(w.createdBy||''),baseline:publicChatCount(w),
     baseRevision:revision(w),cutoff:snap.readTime,startedAt:FieldValue.serverTimestamp(),
     status:'scanning',version:0,confirmed:0,uncertain:0,scanned:0,roomsChecked:0,excludedRooms:0,
     roomCursor:null,activeRoomId:null,messageCursor:null};
    tx.create(ref,state);return report(ref.id,state);
   });
  }
  if(!validId(p.jobId))throw new HttpsError('invalid-argument','核對工作 ID 不正確');
  const ref=jobs.doc(p.jobId);
  if(action==='status'){
   const snap=await ref.get();if(!snap.exists)throw new HttpsError('not-found','找不到核對工作');
   return report(ref.id,snap.data());
  }
  if(action==='step'){
   const lease=crypto.randomUUID();
   const state=await db.runTransaction(async tx=>{
    const snap=await tx.get(ref);if(!snap.exists)throw new HttpsError('not-found','找不到核對工作');
    const s=snap.data();if(s.status!=='scanning')return s;
    if(Number(s.leaseUntil||0)>Date.now())throw new HttpsError('aborted','正在掃描，請稍後繼續。');
    tx.update(ref,{leaseToken:lease,leaseUntil:Date.now()+120000});return s;
   });
   if(state.status!=='scanning')return report(ref.id,state);
   try{
    const worldSnap=await root.collection('worlds').doc(state.worldId).get();
    if(!worldSnap.exists||!publicWorld(worldSnap.data())||worldSnap.data().createdBy!==state.creatorId)
     throw new HttpsError('failed-precondition','世界公開狀態已變更，請重新掃描。');
    const sessions=root.collection('world_chat_sessions');
    let roomId=state.activeRoomId,roomSnap;
    const patch={};
    if(!roomId){
     let q=sessions.where('worldId','==',state.worldId).orderBy(documentId).limit(1);
     if(state.roomCursor)q=q.startAfter(state.roomCursor);
     const rooms=await q.get();
     if(rooms.empty){patch.status='ready';}
     else {roomSnap=rooms.docs[0];roomId=roomSnap.id;}
    }else roomSnap=await sessions.doc(roomId).get();
    if(roomId){
     const r=roomSnap?.data();
     if(!roomSnap?.exists || !isPublicChatRoom(r,worldSnap.data()) ||
       (r.createdAt && !atOrBefore(r.createdAt,state.cutoff))){
      Object.assign(patch,{roomCursor:roomId,activeRoomId:null,messageCursor:null,
       roomsChecked:state.roomsChecked+1,excludedRooms:state.excludedRooms+1});
     }else{
      let q=sessions.doc(roomId).collection('messages').orderBy(documentId).limit(250);
      if(state.activeRoomId && state.messageCursor)q=q.startAfter(state.messageCursor);
      const messages=await q.get();let confirmed=0,uncertain=0;
      for(const msg of messages.docs){const kind=classifyMessage(msg.data(),state.cutoff);if(kind==='confirmed')confirmed++;if(kind==='uncertain')uncertain++;}
      Object.assign(patch,{confirmed:state.confirmed+confirmed,uncertain:state.uncertain+uncertain,
       scanned:state.scanned+messages.size});
      if(messages.size<250)Object.assign(patch,{roomCursor:roomId,activeRoomId:null,messageCursor:null,roomsChecked:state.roomsChecked+1});
      else Object.assign(patch,{activeRoomId:roomId,messageCursor:messages.docs[messages.size-1].id});
     }
    }
    return await db.runTransaction(async tx=>{
     const latest=await tx.get(ref),s=latest.data();
     if(!latest.exists||s.leaseToken!==lease||s.version!==state.version)throw new HttpsError('aborted','工作進度已變更，請繼續掃描。');
     const next={...s,...patch,version:s.version+1,leaseUntil:0};
     tx.update(ref,{...patch,version:next.version,leaseToken:FieldValue.delete(),leaseUntil:0,updatedAt:FieldValue.serverTimestamp()});
     return report(ref.id,next);
    });
   }catch(error){
    await db.runTransaction(async tx=>{const snap=await tx.get(ref);if(snap.data()?.leaseToken===lease)tx.update(ref,{leaseUntil:0,leaseToken:FieldValue.delete()});}).catch(()=>{});
    throw error;
   }
  }
  if(action==='apply'){
   return db.runTransaction(async tx=>{
    const snap=await tx.get(ref);if(!snap.exists)throw new HttpsError('not-found','找不到核對工作');
    const state=snap.data();if(state.status==='applied')return report(ref.id,state);
    if(state.status!=='ready')throw new HttpsError('failed-precondition','請先完成掃描。');
    if(!atOrBefore(state.cutoff,{seconds:Math.floor(Date.now()/1000),nanoseconds:999999999})||
      Date.now()-state.cutoff.toMillis()>86400000)throw new HttpsError('failed-precondition','掃描超過一天，請重新核對。');
    const worldRef=root.collection('worlds').doc(state.worldId),publicRef=root.collection('public_worlds').doc(state.worldId);
    const [worldSnap,projection]=await Promise.all([tx.get(worldRef),tx.get(publicRef)]);
    const w=worldSnap.data();if(!worldSnap.exists||!publicWorld(w)||w.createdBy!==state.creatorId)
     throw new HttpsError('failed-precondition','世界狀態已變更，請重新核對。');
    let plan;
    try{plan=correctionPlan({baseline:state.baseline,observed:state.confirmed,current:publicChatCount(w),baseRevision:state.baseRevision,currentRevision:revision(w)});}
    catch(_){throw new HttpsError('failed-precondition','此世界已被其他核對工作修正，請重新掃描。');}
    if(plan.delta>0){
     tx.update(worldRef,{chatMessageCount:plan.next,chatCountAuditRevision:revision(w)+1,
      chatCountAuditJobId:ref.id,chatCountAuditedAt:FieldValue.serverTimestamp()});
     if(projection.exists)tx.update(publicRef,{chatMessageCount:plan.next,playCount:plan.next});
    }
    tx.update(ref,{status:'applied',appliedCount:plan.next,appliedDelta:plan.delta,appliedAt:FieldValue.serverTimestamp()});
    return report(ref.id,{...state,status:'applied',appliedCount:plan.next});
   });
  }
  throw new HttpsError('invalid-argument','不支援的核對操作');
 };
}
module.exports={createWorldChatAudit,classifyMessage,correctionPlan,atOrBefore};
