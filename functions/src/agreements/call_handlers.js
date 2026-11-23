'use strict';
function createRoleAgreementCallHandlers({db,APP_ID,HttpsError,FieldValue}) {
 const jobs=db.collection('artifacts').doc(APP_ID).collection('role_agreement_jobs');
 function refs(request) {
   const uid=request.auth?.uid;
   if(!uid) throw new HttpsError('unauthenticated','請先登入');
   const characterId=String(request.data?.characterId||'');
   const agreementId=String(request.data?.agreementId||'');
   if(!/^[^/]{1,160}$/.test(characterId)||!/^[a-f0-9]{64}$/.test(agreementId))
     throw new HttpsError('invalid-argument','約定資料無效');
   return {uid,characterId,agreementId,ref:db.collection('role_agreements').doc(uid).collection('characters')
     .doc(characterId).collection('items').doc(agreementId), job:jobs.doc(agreementId)};
 }
 async function decline(request) {
   const p=refs(request);
   return db.runTransaction(async tx => {
     const snap=await tx.get(p.ref);
     if(!snap.exists||snap.data().confirmedBy!==p.uid) throw new HttpsError('not-found','約定不存在');
     if(snap.data().status==='missed'||snap.data().status==='cancelled') return {success:true};
     if(snap.data().status!=='ringing') throw new HttpsError('failed-precondition','目前無來電可拒接');
     tx.update(p.ref,{status:'missed',updatedAt:FieldValue.serverTimestamp()});
     tx.delete(p.job);
     return {success:true};
   });
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
        job.data()?.state!=='ringing'||job.data().nextActionAt.toMillis()<=Date.now())
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
     if(a.status==='completed'||a.status==='connection_failed') return {success:true,refunded:false};
     if(a.status!=='accepted') throw new HttpsError('failed-precondition','沒有已接聽來電');
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
