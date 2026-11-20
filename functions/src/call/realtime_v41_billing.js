'use strict';
// Administrator device test only. The client reports first audio readiness;
// production needs a server-owned transport/verified provider lifecycle.
const COST=20, PENDING_MS=120000, TALK_MS=60000;
const validId=x=>typeof x==='string'&&/^[a-f0-9]{32}$/.test(x);
function createV41Billing({db,FieldValue,HttpsError,requireTester,now=Date.now}) {
  const col=db.collection('call_realtime_v41_billing');
  const ref=(uid,id)=>col.doc(`${uid}_${id}`);
  function check(id){if(!validId(id))throw new HttpsError('invalid-argument','通話編號錯誤');}
  async function reserve(uid,id,sessionId,characterId){
    check(id); const t=now(), r=ref(uid,id), u=db.collection('users').doc(uid);
    return db.runTransaction(async tx=>{
      const prior=await tx.get(r); if(prior.exists)throw new HttpsError('failed-precondition','此通話已處理，請重新撥號');
      const user=await tx.get(u); const points=user.data()?.flowerPoints;
      if(!user.exists||!Number.isSafeInteger(points)||points<COST)throw new HttpsError('failed-precondition','花花不足');
      tx.update(u,{flowerPoints:FieldValue.increment(-COST)});
      tx.set(r,{uid,id,sessionId,characterId,state:'pending',cost:COST,createdAt:t,expiresAt:t+PENDING_MS});
      tx.set(u.collection('flower_logs').doc(`call_v41_${id}_charge`),{title:'電話通話',amount:-COST,createdAt:FieldValue.serverTimestamp(),source:'call_realtime_v41',callId:id});
    });
  }
  async function ensurePending(uid,id){
    const s=(await ref(uid,id).get()).data();
    if(s?.state!=='pending'||s.expiresAt<=now())throw new HttpsError('cancelled','通話已取消或逾時');
  }
  async function settle(uid,id,action,{expiredOnly=false}={}){
    check(id);const r=ref(uid,id),u=db.collection('users').doc(uid),t=now();
    return db.runTransaction(async tx=>{
      const snap=await tx.get(r),s=snap.data();
      if(!s){
        if(action==='cancel'&&!expiredOnly){tx.set(r,{uid,id,state:'cancelled',cost:0,createdAt:t,closedAt:t});return {state:'cancelled'};}
        return {state:'missing'};
      }
      if(s.uid!==uid)throw new HttpsError('permission-denied','通話權限錯誤');
      if(expiredOnly){
        if(s.state==='connected'){
          if(s.deadlineAt>t)return {state:s.state};
          tx.update(r,{state:'ended',closedAt:t,endReason:'deadline'});return {state:'ended'};
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
      if(s.state==='pending'&&action==='end'){tx.update(r,{state:'ended',closedAt:t});return {state:'ended'};}
      if(s.state==='pending'){
        const user=await tx.get(u);if(!user.exists)throw new HttpsError('failed-precondition','退款帳戶不存在');
        tx.update(u,{flowerPoints:FieldValue.increment(COST)});
        tx.set(u.collection('flower_logs').doc(`call_v41_${id}_refund`),{title:'電話未接通退款',amount:COST,source:'call_realtime_v41',callId:id,createdAt:FieldValue.serverTimestamp()});
        tx.update(r,{state:'refunded',closedAt:t});return {state:'refunded'};
      }
      if(s.state==='connected'){tx.update(r,{state:'ended',closedAt:t});return {state:'ended'};}
      return {state:s.state};
    });
  }
  async function sweep(){
    // Test-administrator queue is limited to 30 attempts/day.
    const [pending,connected]=await Promise.all([col.where('state','==','pending').limit(200).get(),col.where('state','==','connected').limit(200).get()]);
    const expired=[...pending.docs.filter(d=>d.data().expiresAt<=now()),...connected.docs.filter(d=>d.data().deadlineAt<=now())];
    const results=await Promise.allSettled(expired.map(d=>settle(d.data().uid,d.data().id,'cancel',{expiredOnly:true})));
    if(results.some(r=>r.status==='rejected')){console.error('CALL_V41_SWEEP_FAILED',{count:results.filter(r=>r.status==='rejected').length});throw new Error('call billing sweep partially failed');}
  }
  return {reserve,ensurePending,settle,sweep,handler:async request=>{
    const uid=requireTester(request),{callId,action}=request.data||{};
    if(!['connect','cancel','end'].includes(action))throw new HttpsError('invalid-argument','通話操作錯誤');
    return settle(uid,callId,action);
  }};
}
module.exports={createV41Billing,validId};
