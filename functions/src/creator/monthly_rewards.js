'use strict';

// V28: Creator monthly reward bookkeeping and callable handlers.
// Dependencies injected from core to keep current Firebase runtime/configuration.
function createCreatorMonthlyRewards({ db, APP_ID, REGION, HttpsError, Timestamp, FieldValue, onDocumentCreated, onCall, creatorFanMailVerified }) {
  const exports = {};
  // ============================================================
  // 官方合作創作者 v1.6：每月「新建且首次公開」3 位角色，手動領 300 花
  // 僅伺服器建立的事件帳本用於領獎，前端無權寫入以下集合。
  // 啟用前必須限制 client 對 creator_character_origins / creator_character_publications /
  // creator_monthly_rewards 的讀寫：一般玩家僅允許透過 callable 取得進度，完全禁止直寫。
  // ============================================================
  const CREATOR_MONTH_REWARD_AMOUNT = 300;
  function creatorRewardMonth(date = new Date()) {
    const parts = new Intl.DateTimeFormat('en-US', {timeZone:'Asia/Taipei',year:'numeric',month:'2-digit'}).formatToParts(date);
    const m = Object.fromEntries(parts.map(x=>[x.type,x.value]));
    return `${m.year}-${m.month}`;
  }
  function creatorRewardError(code,msg) {throw new HttpsError(code,msg);}
  function creatorRewardOriginRef(uid, charId) {
    return db.collection('creator_character_origins').doc(`${uid}_${charId}`);
  }
  async function recordCreatorOrigin(uid, charId, eventTime, kind) {
    if (!uid || !charId) return;
    await creatorRewardOriginRef(uid,charId).create({uid,charId,firstSeenAt:Timestamp.fromDate(eventTime),firstSeenMonth:creatorRewardMonth(eventTime),source:kind}).catch(e=>{
      if (Number(e.code) !== 6 && e.code !== 'already-exists') throw e;
    });
  }
  // 草稿的建立事件由後端記錄；後續搬到公開集合時不會重設出生月份。
  exports.creatorRewardTrackDraftBirth = onDocumentCreated({document:'draft_characters/{characterId}',region:REGION},async(event)=>{
    const d=event.data?.data()||{};
    const uid=String(d.createdBy||'');
    if(uid) await recordCreatorOrigin(uid,event.params.characterId,new Date(event.time),'draft');
  });
  exports.creatorRewardTrackPrivateBirth = onDocumentCreated({document:'artifacts/{appId}/users/{userId}/private_characters/{characterId}',region:REGION},async(event)=>{
    if(event.params.appId!==APP_ID) return;
    const d=event.data?.data()||{};
    const uid=event.params.userId;
    if(String(d.createdBy||uid)!==uid)return;
    await recordCreatorOrigin(uid,event.params.characterId,new Date(event.time),'private');
  });
  exports.creatorRewardTrackPublicBirth = onDocumentCreated({document:'artifacts/{appId}/public_characters/{characterId}',region:REGION},async(event)=>{
    if(event.params.appId!==APP_ID)return;
    const d=event.data?.data()||{};
    const uid=String(d.createdBy||''); const charId=event.params.characterId;
    if(!uid || d.isPublic===false)return;
    const publishedAt=new Date(event.time);
    const publishedMonth=creatorRewardMonth(publishedAt);
    const pubRef=db.collection('creator_character_publications').doc(`${uid}_${charId}`);
    // 純新公開建立者使用真正 Firestore serverTimestamp() 當出生時間。
    // 由私人/草稿搬家者必須依賴先前出生事件；如事件延遲，必須之後重試。
    const recordedCreatedAt=d.createdAt;
    const createdMs=recordedCreatedAt?.toMillis?.()??0;
    const cleanNewPublic=createdMs>0 && Math.abs(publishedAt.getTime()-createdMs)<5*60*1000;
    const origRef=creatorRewardOriginRef(uid,charId);
    await db.runTransaction(async tx=>{
      const [orig,pub]=await Promise.all([tx.get(origRef),tx.get(pubRef)]);
      if(pub.exists)return;
      // 若先前有私人/草稿建立事件，優先使用該首次建立月份。
      // 若無且 createdAt ~= 真正發佈事件才視為直接新建公開角色。
      const birthMonth=orig.exists?orig.data().firstSeenMonth:(cleanNewPublic?publishedMonth:null);
      if(!orig.exists && cleanNewPublic) tx.create(origRef,{uid,charId,firstSeenAt:Timestamp.fromDate(publishedAt),firstSeenMonth:publishedMonth,source:'public'});
      tx.create(pubRef,{uid,charId,firstPublishedAt:Timestamp.fromDate(publishedAt),firstPublishedMonth:publishedMonth,
        firstCreatedMonth:birthMonth, eligibleAtPublication:birthMonth===publishedMonth,
        createdAtClient:recordedCreatedAt??null});
    });
  });
  async function creatorRewardEligible(uid,month) {
    // 一個月最多按 Firestore 文件配額讀取 200 個候選；未滿 3 個無法領。
    const records=await db.collection('creator_character_publications').where('uid','==',uid)
      .limit(500).get();
    const candidates=records.docs.filter(d=>d.data().firstPublishedMonth===month && d.data().eligibleAtPublication===true && d.data().firstCreatedMonth===month);
    const valid=[];
    for(const chunkStart of Array.from({length:Math.ceil(candidates.length/25)},(_,i)=>i*25)) {
      const chunk=candidates.slice(chunkStart,chunkStart+25);
      const snaps=await Promise.all(chunk.map(d=>db.collection('artifacts').doc(APP_ID).collection('public_characters').doc(d.data().charId).get()));
      snaps.forEach((s,i)=>{if(s.exists && s.data()?.createdBy===uid && s.data()?.isPublic!==false && s.data()?.isDraft!==true)valid.push(chunk[i].data().charId);});
    }
    return valid;
  }
  exports.getCreatorMonthlyReward = onCall({region:REGION,timeoutSeconds:60},async request=>{
    const uid=request.auth?.uid;if(!uid)creatorRewardError('unauthenticated','請先登入');
    const user=await db.collection('users').doc(uid).get();
    if(!user.exists||!creatorFanMailVerified(user.data()||{}))creatorRewardError('permission-denied','沒有合作創作者權限');
    const month=creatorRewardMonth();
    const [ids,claimed]=await Promise.all([creatorRewardEligible(uid,month),db.collection('creator_monthly_rewards').doc(`${uid}_${month}`).get()]);
    return {month,qualifyingCount:Math.min(ids.length,3),claimed:claimed.exists,reward:CREATOR_MONTH_REWARD_AMOUNT};
  });
  exports.claimCreatorMonthlyReward = onCall({region:REGION,timeoutSeconds:90},async request=>{
    const uid=request.auth?.uid;if(!uid)creatorRewardError('unauthenticated','請先登入');
    const month=creatorRewardMonth();
    const ids=await creatorRewardEligible(uid,month);
    if(ids.length<3)creatorRewardError('failed-precondition','本月尚未完成 3 位新建且公開的角色');
    const userRef=db.collection('users').doc(uid);
    const rewardRef=db.collection('creator_monthly_rewards').doc(`${uid}_${month}`);
    const result=await db.runTransaction(async tx=>{
      const [user,reward,...publicDocs]=await Promise.all([
        tx.get(userRef),tx.get(rewardRef),...ids.slice(0,3).map(id=>tx.get(db.collection('artifacts').doc(APP_ID).collection('public_characters').doc(id)))]);
      if(reward.exists)return {claimed:true,alreadyClaimed:true,month};
      if(!user.exists||!creatorFanMailVerified(user.data()||{}))creatorRewardError('permission-denied','合作資格已暫停或取消');
      if(publicDocs.some(d=>!d.exists||d.data()?.createdBy!==uid||d.data()?.isPublic===false))creatorRewardError('failed-precondition','角色公開狀態已變動，請重新整理');
      tx.create(rewardRef,{uid,month,amount:CREATOR_MONTH_REWARD_AMOUNT,characterIds:ids.slice(0,3),createdAt:FieldValue.serverTimestamp()});
      tx.update(userRef,{flowerPoints:FieldValue.increment(CREATOR_MONTH_REWARD_AMOUNT)});
      tx.create(userRef.collection('flower_logs').doc(`creator_monthly_reward_${month}`),{
        type:'creator_monthly_reward',title:`${month} 合作創作者每月創作獎勵`,amount:CREATOR_MONTH_REWARD_AMOUNT,
        rewardMonth:month,createdAt:FieldValue.serverTimestamp()});
      return {claimed:true,alreadyClaimed:false,month,amount:CREATOR_MONTH_REWARD_AMOUNT};
    });
    return result;
  });
  return exports;
}

module.exports = { createCreatorMonthlyRewards };
