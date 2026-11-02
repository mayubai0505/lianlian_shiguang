'use strict';
// Creator support authentication, authorization and notifications. Original logic preserved.
function createCreatorSupportAccess({db, HttpsError, REWARD_CAMPAIGN_ADMIN_UIDS, requireRewardCampaignAdmin, creatorFanMailVerified, sendToUserDevices, logger}) {
async function creatorSupportNotify(uid, title, body, caseId) {
  try { await sendToUserDevices(uid,{notification:{title,body},data:{type:'creator_support',caseId:String(caseId),click_action:'FLUTTER_NOTIFICATION_CLICK'}}); }
  catch(e){logger.warn('Creator support FCM failed', {code:e?.code||'',message:e?.message||''});}
}
async function creatorSupportNotifyAdmins(title,body,caseId) {
  await Promise.allSettled([...REWARD_CAMPAIGN_ADMIN_UIDS].map(uid=>creatorSupportNotify(uid,title,body,caseId)));
}
async function creatorSupportAuthorizeImage(request,caseId) {
  const uid=creatorSupportUid(request);
  if(!/^[A-Za-z0-9]{1,100}$/.test(caseId))throw new HttpsError('invalid-argument','案件ID無效');
  const ref=creatorSupportRoot().doc(caseId),snap=await ref.get();
  if(!snap.exists)throw new HttpsError('not-found','案件不存在');
  const isAdmin=REWARD_CAMPAIGN_ADMIN_UIDS.has(uid);
  if(!isAdmin){if(snap.data().creatorId!==uid)throw new HttpsError('permission-denied','無權使用此案件附件');await creatorSupportCreator(request);}
  return {ref,snap,isAdmin};
}
const creatorSupportRoot = () => db.collection('creator_support_cases');
function creatorSupportUid(request) { const uid=request.auth?.uid; if(!uid) throw new HttpsError('unauthenticated','請先登入'); return uid; }
function creatorSupportAdmin(request) { return requireRewardCampaignAdmin(request); }
async function creatorSupportCreator(request) {
 const uid=creatorSupportUid(request); const s=await db.collection('users').doc(uid).get();
 if(!s.exists || !creatorFanMailVerified(s.data()||{})) throw new HttpsError('permission-denied','目前沒有合作創作者權限');
 return {uid, data:s.data()||{}};
}

return {creatorSupportNotify, creatorSupportNotifyAdmins, creatorSupportAuthorizeImage, creatorSupportRoot, creatorSupportUid, creatorSupportAdmin, creatorSupportCreator};
}
module.exports={createCreatorSupportAccess};
