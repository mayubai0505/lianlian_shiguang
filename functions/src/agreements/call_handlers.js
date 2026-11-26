'use strict';
const {loadCallRecordRoom,writeCallRecord}=require('./call_record');
const {queueMissedFollowup,createMissedFollowup}=require('./missed_followup');
const {FieldPath}=require('firebase-admin/firestore');
function createRoleAgreementCallHandlers({db,APP_ID,HttpsError,FieldValue,openRouterApiKey,secureOpenRouterBody,logger=console}) {
 const processFollowup=createMissedFollowup({db,APP_ID,FieldValue,openRouterApiKey,secureOpenRouterBody});
 const jobs=db.collection('artifacts').doc(APP_ID).collection('role_agreement_jobs');
 function refs(request) {
   const uid=request.auth?.uid;
   if(!uid) throw new HttpsError('unauthenticated','請先登入');
   const characterId=String(request.data?.characterId||'');
   const agreementId=String(request.data?.agreementId||'');
   if(!/^[^/]{1,160}$/.test(characterId)||!/^[a-f0-9]{64}$/.test(agreementId))
     throw new HttpsError('invalid-argument','約定資料無效');
   return {uid,characterId,agreementId,ref:db.collection('users').doc(uid).collection('characters')
     .doc(characterId).collection('role_agreements').doc(agreementId), job:jobs.doc(agreementId)};
 }
 async function decline(request) {
   const uid=request.auth?.uid;
   if(!uid)throw new HttpsError('unauthenticated','請先登入');
   const action=request.data?.action||'declined';
   if(!['declined','unanswered','nativeAccepted'].includes(action))throw new HttpsError('invalid-argument','來電操作錯誤');
   // Native timeout contains only the UUID (first 32 hex chars of agreement ID).
   // Resolve a narrow document-ID range server-side; never trust another user's job.
   let input=request;
   if(action==='unanswered'&&request.data?.nativeCallId){
     const nativeId=String(request.data.nativeCallId).toLowerCase();
     if(!/^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/.test(nativeId))throw new HttpsError('invalid-argument','來電編號錯誤');
     const prefix=nativeId.replace(/-/g,'');
     const matches=await jobs.orderBy(FieldPath.documentId()).startAt(prefix).endAt(prefix+'\uf8ff').limit(5).get();
     const own=matches.docs.filter(d=>/^[a-f0-9]{64}$/.test(d.id)&&d.data().uid===uid&&d.data().agreementId===d.id);
     if(own.length!==1)return {success:true,ignored:true};
     input={auth:request.auth,data:{agreementId:own[0].id,characterId:own[0].data().characterId}};
   }
   const p=refs(input);
   const result=await db.runTransaction(async tx => {
     const [snap,jobSnap]=await Promise.all([tx.get(p.ref),tx.get(p.job)]);
     const a=snap.data()||{}, job=jobSnap.data()||{};
     if(!snap.exists||a.confirmedBy!==p.uid||a.characterId!==p.characterId||a.method!=='call')throw new HttpsError('not-found','約定不存在');
     if(['missed','cancelled','accepted','completed','connection_failed','suppressed_dnd','delivery_failed'].includes(a.status))return {success:true,ignored:true};
     if(a.status!=='ringing'||!jobSnap.exists||job.state!=='ringing'||job.uid!==p.uid||job.characterId!==p.characterId||job.agreementId!==p.agreementId)throw new HttpsError('failed-precondition','目前無有效來電');
     if(action==='nativeAccepted'){
       // OS accept is not paid accept. Extend once, never charge or start audio here.
       if(!job.nativeAcceptedAt)tx.update(p.job,{nativeAcceptedAt:FieldValue.serverTimestamp(),nextActionAt:new Date(Date.now()+10*60000)});
       return {success:true};
     }
     if(action==='unanswered'&&job.nativeAcceptedAt)return {success:true,ignored:true};
     const room=await loadCallRecordRoom(tx,{db,APP_ID,uid:p.uid,characterId:p.characterId,agreement:a});
     writeCallRecord(tx,{room,FieldValue,agreementId:p.agreementId,agreement:a,status:'missed'});
     tx.update(p.ref,{status:'missed',missedReason:action,updatedAt:FieldValue.serverTimestamp()});
     const task=queueMissedFollowup(tx,{jobRef:p.job,room,uid:p.uid,characterId:p.characterId,agreementId:p.agreementId,reason:action,immediate:true});
     return {success:true,task,agreement:a};
   });
   // Record committed before model IO; lease gives scheduler recovery on failure.
   if(result.task){try{await processFollowup(p.job,result.task,result.agreement);}catch(e){logger.warn('role agreement immediate followup deferred',{id:p.agreementId,error:String(e)});}}
   return {success:true,ignored:result.ignored===true};
 }
 async function accept(request) {
   const p=refs(request),userRef=db.collection('users').doc(p.uid);
   return db.runTransaction(async tx => {
     const [agreement,user,job]=await Promise.all([tx.get(p.ref),tx.get(userRef),tx.get(p.job)]);
     const data=agreement.data()||{};
     if(!agreement.exists||data.confirmedBy!==p.uid||data.characterId!==p.characterId||data.method!=='call')
       throw new HttpsError('not-found','來電不存在');
     if(data.status==='accepted') throw new HttpsError('already-exists','這通電話已被接聽');
     if(data.status!=='ringing'||!job.exists ||
        job.data()?.state!=='ringing'||job.data().uid!==p.uid ||
         job.data().characterId!==p.characterId || job.data().agreementId!==p.agreementId ||
         !job.data().nextActionAt || job.data().nextActionAt.toMillis()<=Date.now())
       throw new HttpsError('failed-precondition','來電已結束或尚未到時間');
     if(!user.exists || !Number.isFinite(user.data().flowerPoints) || user.data().flowerPoints<20)
       throw new HttpsError('failed-precondition','花花不足 20，無法接聽');
     tx.update(userRef,{flowerPoints:FieldValue.increment(-20)});
     tx.create(userRef.collection('flower_logs').doc(p.agreementId+'_rolecall_charge'),{
       type:'role_agreement_call',amount:-20,characterId:p.characterId,
       agreementId:p.agreementId,createdAt:FieldValue.serverTimestamp()});
     tx.update(p.ref,{status:'accepted',chargedFlowers:20,acceptedAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp()});
     tx.update(p.job,{state:'accepted',nextActionAt:new Date(Date.now()+5*60000)});
     return {success:true,charged:true,sessionId:data.sessionId};
   });
 }
 async function finish(request) {
   const p=refs(request);
   const connected=request.data?.connected===true;
   const userRef=db.collection('users').doc(p.uid);
   return db.runTransaction(async tx => {
     const snap=await tx.get(p.ref);
     if(!snap.exists||snap.data().confirmedBy!==p.uid) throw new HttpsError('not-found','約定不存在');
     const a=snap.data();
     if(a.billingMode==='v41')throw new HttpsError('failed-precondition','請由即時通話結算');
     if(a.status==='completed'||a.status==='connection_failed') return {success:true,refunded:false};
     if(a.status!=='accepted') throw new HttpsError('failed-precondition','沒有已接聽來電');
     const room=await loadCallRecordRoom(tx,{db,APP_ID,uid:p.uid,characterId:p.characterId,agreement:a});
     writeCallRecord(tx,{room,FieldValue,agreementId:p.agreementId,agreement:a,status:connected?'completed':'connection_failed'});
     if(!connected && a.chargedFlowers===20) {
       tx.update(userRef,{flowerPoints:FieldValue.increment(20)});
       tx.create(userRef.collection('flower_logs').doc(p.agreementId+'_rolecall_refund'),{
         type:'role_agreement_call_refund',amount:20,characterId:p.characterId,
         agreementId:p.agreementId,createdAt:FieldValue.serverTimestamp()});
     }
     tx.delete(p.job);
     tx.update(p.ref,{status:connected?'completed':'connection_failed',
       refundedFlowers:connected?0:20,finishedAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp()});
     return {success:true,refunded:!connected};
   });
 }
 return {accept,decline,finish};
}
module.exports={createRoleAgreementCallHandlers};
