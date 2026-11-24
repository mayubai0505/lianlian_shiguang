'use strict';
// US region minute scheduler. Firestore jobs contain no message secrets and
// all state changes are transaction-guarded to avoid duplicate deliveries.
function createRoleAgreementDelivery({db,APP_ID,FieldValue,sendToUserDevices,logger}) {
  // iOS PushKit bridge is optional during rollout. Android/ordinary FCM must still work if absent.
  let sendVoipToUser=null;
  try { ({sendVoipToUser}=require('./apns_voip')); } catch (_) { logger.warn('role agreement APNs VoIP module unavailable; using FCM fallback'); }
  const {getMessaging}=require('firebase-admin/messaging');
  async function sendAndroidIncoming(uid,message) {
    const list=await db.collection('users').doc(uid).collection('fcmTokens').get();
    const tokens=[...new Set(list.docs.filter(doc=>doc.data()?.platform==='android')
      .map(doc=>doc.data()?.token||doc.id).filter(t=>typeof t==='string'&&t.length>20))];
    if(!tokens.length)return {successCount:0};
    const response=await getMessaging().sendEachForMulticast({tokens,
      data:message.data,android:message.android});
    return {successCount:response.successCount};
  }
  const jobs = db.collection('artifacts').doc(APP_ID).collection('role_agreement_jobs');
  const agreementRef = job => db.collection('users').doc(job.uid).collection('characters')
    .doc(job.characterId).collection('role_agreements').doc(job.agreementId);
  return async () => {
    const now = Date.now();
    const due = await jobs.where('nextActionAt','<=',new Date(now)).orderBy('nextActionAt').limit(75).get();
    for (const document of due.docs) {
      try {
        const action = await db.runTransaction(async tx => {
          const snap = await tx.get(document.ref);
          if (!snap.exists) return null;
          const job = snap.data();
          if (!job.nextActionAt || job.nextActionAt.toMillis() > Date.now()) return null;
          const ref = agreementRef(job);
          const agreement = await tx.get(ref);
          if (!agreement.exists || ['cancelled','completed','missed','connection_failed'].includes(agreement.data().status)) {
            tx.delete(document.ref); return null;
          }
          if (job.state === 'accepted') {
            // App killed mid-call: settle the still-open reservation conservatively.
            // No sound confirmation reached the server; refund once to avoid orphan charges.
            if (agreement.data().status === 'accepted') {
              const userRef=db.collection('users').doc(job.uid);
              tx.update(userRef,{flowerPoints:FieldValue.increment(20)});
              tx.create(userRef.collection('flower_logs').doc(job.agreementId+'_rolecall_refund'),{
                type:'role_agreement_call_refund',amount:20,
                characterId:job.characterId,agreementId:job.agreementId,
                createdAt:FieldValue.serverTimestamp(),reason:'unsettled_call_timeout',
              });
              tx.update(ref,{status:'connection_failed',refundedFlowers:20,
                finishedAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp()});
            }
            tx.delete(document.ref);
            return null;
          }
          if (job.state === 'ringing') {
            tx.update(ref,{status:'missed',updatedAt:FieldValue.serverTimestamp()});
            tx.delete(document.ref); return null;
          }
          if (job.state === 'sending') {
            // Previous worker crashed. A lease expiration permits a safe retry.
            tx.update(document.ref,{state:'pending',nextActionAt:new Date()});
            return null;
          }
          if (job.state !== 'pending') return null;
          const attempts = (job.attempts||0)+1;
          // Claim the job before network IO; a lease recovers after crashes.
          tx.update(document.ref,{state:'sending',attempts,nextActionAt:new Date(Date.now()+120000)});
          return {job,agreement:agreement.data(),attempts};
        });
        if (!action) continue;
        const {job,agreement,attempts}=action;
        // User-controlled quiet hours (23:00-08:00 in the saved device offset).
        // Never wake the player or charge if DND is active at dispatch time.
        const userSnap = await db.collection('users').doc(job.uid).get();
        const userPrefs = userSnap.data()||{};
        const minuteOffset = Number(userPrefs.roleAgreementTimezoneOffsetMinutes ?? 480);
        const localHour = new Date(Date.now() + minuteOffset*60000).getUTCHours();
        if (userPrefs.roleAgreementDndEnabled === true && (localHour >= 23 || localHour < 8)) {
          await db.runTransaction(async tx => {
            const currentJob=await tx.get(document.ref);
            const ref=agreementRef(job);
            const currentAgreement=await tx.get(ref);
            if(!currentJob.exists||!currentAgreement.exists||currentJob.data().state!=='sending') return;
            tx.update(ref,{status:'suppressed_dnd',deliveryEnabled:false,
              updatedAt:FieldValue.serverTimestamp()});
            tx.delete(document.ref);
          });
          continue;
        }
        const call=job.method==='call';
        const message = {
          notification: call ? undefined : {
            title: call ? '📞 拾光約定・角色來電' : '🦋 拾光約定提醒',
            body: String(agreement.content||'約定時間到了').slice(0,140),
          },
          data: {
            type:call?'role_agreement_call':'role_agreement_reminder',
            characterId:job.characterId,agreementId:job.agreementId,
            sessionId:String(agreement.sessionId||''),
            characterName:String(agreement.characterName||'角色').slice(0,60),
          },
          android:call?{priority:'high',ttl:30000}:{priority:'high',notification:{channelId:'high_importance_channel'}},
          apns:{headers:{'apns-priority':'10'},payload:{aps:{sound:'default',alert:call?{title:'拾光約定・角色來電',body:String(agreement.content||'約定時間到了').slice(0,140)}:undefined}}},
        };
        let success=false;
        try {
          // Android: FCM high-priority data, iOS: PushKit VoIP 專用 APNs。
          // 普通 FCM 在 iOS 仍作備援通知，不可當作原生 CallKit 的傳輸。
          const result=call
            ? await sendAndroidIncoming(job.uid,message)
            : await sendToUserDevices(job.uid,message);
          success=result.successCount>0;
          if(call) {
            if (typeof sendVoipToUser === 'function') {
              const voip=await sendVoipToUser({db,userId:job.uid,payload:{
                type:'role_agreement_call',agreementId:job.agreementId,
                characterId:job.characterId,sessionId:String(agreement.sessionId||''),
                characterName:String(agreement.characterName||'角色').slice(0,60)
              },logger});
              success=success || voip.successCount>0;
            } else {
              // iOS/legacy fallback: ordinary high-priority FCM notification.
              // Android may receive this too; state transition remains transaction-idempotent.
              const fallback=await sendToUserDevices(job.uid,message);
              success=success || fallback.successCount>0;
            }
          }
        }
        catch(e) {logger.warn('role agreement push failed',{id:job.agreementId,error:String(e)});}
        await db.runTransaction(async tx => {
          const currentJob=await tx.get(document.ref);
          const ref=agreementRef(job);
          const currentAgreement=await tx.get(ref);
          if (!currentJob.exists || !currentAgreement.exists || currentJob.data().state!=='sending') return;
          if (currentAgreement.data().status!=='scheduled') {tx.delete(document.ref);return;}
          if (success) {
            if(call) {
              tx.update(ref,{status:'ringing',notifiedAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp()});
              tx.update(document.ref,{state:'ringing',nextActionAt:new Date(Date.now()+10*60000)});
            } else {
              tx.update(ref,{status:'completed',notifiedAt:FieldValue.serverTimestamp(),completedAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp()});
              tx.delete(document.ref);
            }
          } else if (attempts>=3) {
            tx.update(ref,{status:'delivery_failed',deliveryEnabled:false,updatedAt:FieldValue.serverTimestamp()});
            tx.delete(document.ref);
          } else {
            tx.update(document.ref,{state:'pending',nextActionAt:new Date(Date.now()+60000)});
          }
        });
      } catch(e) {logger.error('role agreement delivery iteration failed',{id:document.id,error:String(e)});}
    }
  };
}
module.exports={createRoleAgreementDelivery};
