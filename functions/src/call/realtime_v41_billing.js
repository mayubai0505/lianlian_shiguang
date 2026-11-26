'use strict';
const {loadCallRecordRoom,writeCallRecord}=require('../agreements/call_record');
// V4.1 billing: reserve 20 flowers, refund unconnected calls, idempotent settlement.
// Client-reported first audio is not independently verified by provider: review before scale.
const COST=20, PENDING_MS=120000, TALK_MS=60000;
const validId=x=>typeof x==='string'&&/^[a-f0-9]{32}$/.test(x);
function createV41Billing({db,APP_ID="lianlianshiguang",FieldValue,HttpsError,requireTester,now=Date.now}) {
  const col=db.collection('call_realtime_v41_billing');
  const ref=(uid,id)=>col.doc(`${uid}_${id}`);
  function check(id){if(!validId(id))throw new HttpsError('invalid-argument','通話編號錯誤');}
  const agreementRef=(uid,characterId,agreementId)=>db.collection('users').doc(uid).collection('characters').doc(characterId).collection('role_agreements').doc(agreementId);
  async function reserve(uid,id,sessionId,characterId,{agreementId,jobRef}={}){
    check(id); const t=now(), r=ref(uid,id), u=db.collection('users').doc(uid);
    return db.runTransaction(async tx=>{
      const prior=await tx.get(r); if(prior.exists)throw new HttpsError('failed-precondition','此通話已處理，請重新撥號');
      const user=await tx.get(u); const points=user.data()?.flowerPoints;
      let agreementContent='', openingLine='', openingPrepared=false, aRef=null;
      if(agreementId){
        aRef=agreementRef(uid,characterId,agreementId);
        const [a,j]=await Promise.all([tx.get(aRef),tx.get(jobRef)]);
        const v=a.data()||{}, job=j.data()||{};
        if(!a.exists||v.confirmedBy!==uid||v.characterId!==characterId||v.sessionId!==sessionId||v.method!=='call')throw new HttpsError('not-found','來電不存在');
        if(v.status!=='ringing'||!j.exists||job.uid!==uid||job.characterId!==characterId||job.agreementId!==agreementId||job.state!=='ringing'||!(job.nextActionAt?.toMillis()>t))throw new HttpsError('failed-precondition','來電已結束或尚未到時間');
        agreementContent=String(v.reminderContent||v.content||'').trim().slice(0,500);
        openingLine=typeof v.openingLine==='string'?v.openingLine.trim().slice(0,180):'';
        openingPrepared=v.openingPrepared===true && !!openingLine;
        if(!agreementContent)throw new HttpsError('failed-precondition','約定內容不存在');
      }
      if(!user.exists||!Number.isSafeInteger(points)||points<COST)throw new HttpsError('failed-precondition','花花不足');
      tx.update(u,{flowerPoints:FieldValue.increment(-COST)});
      tx.set(r,{uid,id,sessionId,characterId,state:'pending',cost:COST,createdAt:t,expiresAt:t+PENDING_MS,...(agreementId?{agreementId}:{})});
      tx.set(u.collection('flower_logs').doc(`call_v41_${id}_charge`),{title:agreementId?'拾光約定來電':'電話通話',amount:-COST,createdAt:FieldValue.serverTimestamp(),source:'call_realtime_v41',callId:id,...(agreementId?{agreementId}:{})});
      if(aRef){
        tx.update(aRef,{status:'accepted',billingMode:'v41',billingCallId:id,chargedFlowers:COST,acceptedAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp()});
        // Billing sweep now owns recovery. Remove the legacy scheduler job atomically.
        tx.delete(jobRef);
      }
      return {agreementContent,openingLine,openingPrepared};
    });
  }
  async function ensurePending(uid,id){
    const s=(await ref(uid,id).get()).data();
    if(s?.state!=='pending'||s.expiresAt<=now())throw new HttpsError('cancelled','通話已取消或逾時');
  }
  async function settle(uid,id,action,{expiredOnly=false,expectedAgreementId,expectedCharacterId}={}){
    check(id);const r=ref(uid,id),u=db.collection('users').doc(uid),t=now();
    return db.runTransaction(async tx=>{
      const snap=await tx.get(r),s=snap.data();
      if(!s){
        if(action==='cancel'&&!expiredOnly){tx.set(r,{uid,id,state:'cancelled',cost:0,createdAt:t,closedAt:t});return {state:'cancelled'};}
        return {state:'missing'};
      }
      if(s.uid!==uid)throw new HttpsError('permission-denied','通話權限錯誤');
      if(expectedAgreementId && s.state!=='cancelled' && (s.agreementId!==expectedAgreementId||s.characterId!==expectedCharacterId))throw new HttpsError('permission-denied','通話與約定不符');
      const aRef=s.agreementId?agreementRef(uid,s.characterId,s.agreementId):null;
      const a=aRef?(await tx.get(aRef)).data():null;
      const room=a&&action!=='connect'&&['pending','connected'].includes(s.state)?await loadCallRecordRoom(tx,{db,APP_ID,uid,characterId:s.characterId,agreement:a}):null;
      const updateAgreement=(status,refundedFlowers)=>{
        if(a?.billingMode==='v41'&&a.billingCallId===id&&a.status==='accepted'){
          tx.update(aRef,{status,refundedFlowers,finishedAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp()});
          writeCallRecord(tx,{room,FieldValue,agreementId:s.agreementId,agreement:a,status,durationSeconds:status==='completed'?(t-s.connectedAt)/1000:null,now:t});
        }
      };
      if(expiredOnly){
        if(s.state==='connected'){
          if(s.deadlineAt>t)return {state:s.state};
          tx.update(r,{state:'ended',closedAt:t,endReason:'deadline'});updateAgreement('completed',0);return {state:'ended'};
        }
        if(s.state!=='pending'||s.expiresAt>t)return {state:s.state};
      }
      if(action==='connect'){
        if(s.state==='connected')return {state:s.state,deadlineAt:s.deadlineAt,remainingMs:Math.max(0,s.deadlineAt-t)};
        if(s.state!=='pending'||s.expiresAt<=t)throw new HttpsError('failed-precondition','通話已取消或逾時');
        const deadlineAt=t+TALK_MS;
        tx.update(r,{state:'connected',connectedAt:t,deadlineAt});
        return {state:'connected',deadlineAt,remainingMs:TALK_MS};
      }
      // A pending call is never billable, even if the client sent 'end'.
      if(s.state==='pending'){
        const user=await tx.get(u);if(!user.exists)throw new HttpsError('failed-precondition','退款帳戶不存在');
        tx.update(u,{flowerPoints:FieldValue.increment(COST)});
        tx.set(u.collection('flower_logs').doc(`call_v41_${id}_refund`),{title:'電話未接通退款',amount:COST,source:'call_realtime_v41',callId:id,createdAt:FieldValue.serverTimestamp()});
        tx.update(r,{state:'refunded',closedAt:t});updateAgreement('connection_failed',COST);return {state:'refunded'};
      }
      if(s.state==='connected'){tx.update(r,{state:'ended',closedAt:t});updateAgreement('completed',0);return {state:'ended'};}
      return {state:s.state};
    });
  }
  async function sweep(){
    // Recover expired reservations and connected-call deadlines.
    const [pending,connected]=await Promise.all([col.where('state','==','pending').limit(200).get(),col.where('state','==','connected').limit(200).get()]);
    const expired=[...pending.docs.filter(d=>d.data().expiresAt<=now()),...connected.docs.filter(d=>d.data().deadlineAt<=now())];
    const results=await Promise.allSettled(expired.map(d=>settle(d.data().uid,d.data().id,'cancel',{expiredOnly:true})));
    if(results.some(r=>r.status==='rejected')){console.error('CALL_V41_SWEEP_FAILED',{count:results.filter(r=>r.status==='rejected').length});throw new Error('call billing sweep partially failed');}
  }
  return {reserve,ensurePending,settle,sweep,handler:async request=>{
      const {callId,action,agreementId,characterId}=request.data||{};
      let uid;
      if(agreementId!==undefined && agreementId!==null){
        uid=request.auth?.uid;
        if(!uid)throw new HttpsError('unauthenticated','請先登入');
        check(callId);
        if(typeof agreementId!=='string'||!/^[a-f0-9]{64}$/.test(agreementId)||typeof characterId!=='string'||!/^[^/\s]{1,160}$/.test(characterId))throw new HttpsError('invalid-argument','約定資料錯誤');
        const a=(await agreementRef(uid,characterId,agreementId).get()).data();
        if(!a||a.confirmedBy!==uid||a.characterId!==characterId||a.method!=='call')throw new HttpsError('permission-denied','約定權限不足');
        const existing=(await ref(uid,callId).get()).data();
        if(existing && existing.state!=='cancelled' && (existing.agreementId!==agreementId||existing.characterId!==characterId))throw new HttpsError('permission-denied','通話與約定不符');
        if(!existing&&action!=='cancel')throw new HttpsError('failed-precondition','尚未建立通話');
      }else uid=requireTester(request);
    if(!['connect','cancel','end'].includes(action))throw new HttpsError('invalid-argument','通話操作錯誤');
    return settle(uid,callId,action,{expectedAgreementId:agreementId,expectedCharacterId:characterId});
  }};
}
module.exports={createV41Billing,validId};
