'use strict';

// V29: Creator monthly reward bookkeeping and callable handlers.
// Public characters + public worlds share ONE monthly 300-flower reward.
function createCreatorMonthlyRewards({
  db, APP_ID, REGION, HttpsError, Timestamp, FieldValue,
  onDocumentCreated, onCall, creatorFanMailVerified,
  sendToUserDevices = null, logger = console,
}) {
  const exports = {};

  // ============================================================
  // 官方合作創作者 v1.7：
  // 每月「本月新建且首次公開」的公開角色 + 公開世界，合計 3 個，
  // 手動領取同一筆 300 花花。兩種作品共用同一 reward doc，絕不重複發獎。
  // ============================================================
  const CREATOR_MONTH_REWARD_AMOUNT = 300;
  const TARGET_COUNT = 3;

  function creatorRewardMonth(date = new Date()) {
    const parts = new Intl.DateTimeFormat('en-US', {
      timeZone:'Asia/Taipei', year:'numeric', month:'2-digit',
    }).formatToParts(date);
    const m = Object.fromEntries(parts.map(x=>[x.type,x.value]));
    return `${m.year}-${m.month}`;
  }

  function creatorRewardError(code,msg) {
    throw new HttpsError(code,msg);
  }

  function creatorRewardOriginRef(uid, charId) {
    return db.collection('creator_character_origins').doc(`${uid}_${charId}`);
  }

  function creatorWorldPublicationRef(uid, worldId) {
    return db.collection('creator_world_publications').doc(`${uid}_${worldId}`);
  }

  function creatorRewardNoticeRef(uid, month) {
    return db.collection('creator_monthly_reward_notices').doc(`${uid}_${month}`);
  }

  async function recordCreatorOrigin(uid, charId, eventTime, kind) {
    if (!uid || !charId) return;
    await creatorRewardOriginRef(uid,charId).create({
      uid,
      charId,
      firstSeenAt:Timestamp.fromDate(eventTime),
      firstSeenMonth:creatorRewardMonth(eventTime),
      source:kind,
    }).catch(e=>{
      if (Number(e.code) !== 6 && e.code !== 'already-exists') throw e;
    });
  }

  // 草稿的建立事件由後端記錄；後續搬到公開集合時不會重設出生月份。
  exports.creatorRewardTrackDraftBirth = onDocumentCreated({
    document:'draft_characters/{characterId}',
    region:REGION,
  }, async(event)=>{
    const d=event.data?.data()||{};
    const uid=String(d.createdBy||'');
    if(uid) await recordCreatorOrigin(uid,event.params.characterId,new Date(event.time),'draft');
  });

  exports.creatorRewardTrackPrivateBirth = onDocumentCreated({
    document:'artifacts/{appId}/users/{userId}/private_characters/{characterId}',
    region:REGION,
  }, async(event)=>{
    if(event.params.appId!==APP_ID) return;
    const d=event.data?.data()||{};
    const uid=event.params.userId;
    if(String(d.createdBy||uid)!==uid)return;
    await recordCreatorOrigin(uid,event.params.characterId,new Date(event.time),'private');
  });

  async function recordPublicCharacter(event) {
    if(event.params.appId!==APP_ID)return null;
    const d=event.data?.data()||{};
    const uid=String(d.createdBy||'');
    const charId=event.params.characterId;
    if(!uid || d.isPublic===false)return null;

    const publishedAt=new Date(event.time);
    const publishedMonth=creatorRewardMonth(publishedAt);
    const pubRef=db.collection('creator_character_publications').doc(`${uid}_${charId}`);

    const recordedCreatedAt=d.createdAt;
    const createdMs=recordedCreatedAt?.toMillis?.()??0;
    const cleanNewPublic=createdMs>0 && Math.abs(publishedAt.getTime()-createdMs)<5*60*1000;
    const origRef=creatorRewardOriginRef(uid,charId);

    await db.runTransaction(async tx=>{
      const [orig,pub]=await Promise.all([tx.get(origRef),tx.get(pubRef)]);
      if(pub.exists)return;

      const birthMonth=orig.exists
        ? orig.data().firstSeenMonth
        : (cleanNewPublic?publishedMonth:null);

      if(!orig.exists && cleanNewPublic) {
        tx.create(origRef,{
          uid,charId,
          firstSeenAt:Timestamp.fromDate(publishedAt),
          firstSeenMonth:publishedMonth,
          source:'public',
        });
      }

      tx.create(pubRef,{
        uid,charId,
        firstPublishedAt:Timestamp.fromDate(publishedAt),
        firstPublishedMonth:publishedMonth,
        firstCreatedMonth:birthMonth,
        eligibleAtPublication:birthMonth===publishedMonth,
        createdAtClient:recordedCreatedAt??null,
      });
    });

    return {uid, month:publishedMonth};
  }

  exports.creatorRewardTrackPublicBirth = onDocumentCreated({
    document:'artifacts/{appId}/public_characters/{characterId}',
    region:REGION,
  }, async(event)=>{
    const recorded = await recordPublicCharacter(event);
    if(recorded) await maybeNotifyCreatorRewardReady(recorded.uid, recorded.month);
  });

  // 公開世界第一次進入 public_worlds 時建立不可重複的首次公開帳本。
  // 是否符合「本月新建 + 本月首次公開」以來源 worlds/{worldId}.createdAt 為準。
  async function recordPublicWorld(event) {
    if(event.params.appId!==APP_ID)return null;
    const d=event.data?.data()||{};
    const uid=String(d.createdBy||'');
    const worldId=event.params.worldId;
    if(!uid || d.isPublic===false || d.publicPlayable===false || d.isDraft===true)return null;

    const publishedAt=new Date(event.time);
    const publishedMonth=creatorRewardMonth(publishedAt);
    const worldRef=db.collection('artifacts').doc(APP_ID).collection('worlds').doc(worldId);
    const publicationRef=creatorWorldPublicationRef(uid,worldId);

    const worldSnap=await worldRef.get();
    if(!worldSnap.exists)return null;
    const world=worldSnap.data()||{};
    if(String(world.createdBy||'')!==uid)return null;

    const rawCreatedAt=world.createdAt;
    const createdDate=rawCreatedAt?.toDate?.();
    const createdMonth=createdDate instanceof Date && !Number.isNaN(createdDate.getTime())
      ? creatorRewardMonth(createdDate)
      : null;

    await publicationRef.create({
      uid,
      worldId,
      firstPublishedAt:Timestamp.fromDate(publishedAt),
      firstPublishedMonth:publishedMonth,
      firstCreatedMonth:createdMonth,
      eligibleAtPublication:createdMonth===publishedMonth,
    }).catch(e=>{
      if (Number(e.code) !== 6 && e.code !== 'already-exists') throw e;
    });

    return {uid, month:publishedMonth};
  }

  exports.creatorRewardTrackPublicWorldBirth = onDocumentCreated({
    document:'artifacts/{appId}/public_worlds/{worldId}',
    region:REGION,
  }, async(event)=>{
    const recorded=await recordPublicWorld(event);
    if(recorded) await maybeNotifyCreatorRewardReady(recorded.uid, recorded.month);
  });

  async function creatorRewardEligibleCharacters(uid,month) {
    const records=await db.collection('creator_character_publications')
      .where('uid','==',uid).limit(500).get();

    const candidates=records.docs.filter(d=>{
      const x=d.data();
      return x.firstPublishedMonth===month &&
        x.eligibleAtPublication===true &&
        x.firstCreatedMonth===month;
    });

    const valid=[];
    for(let start=0; start<candidates.length; start+=25) {
      const chunk=candidates.slice(start,start+25);
      const snaps=await Promise.all(chunk.map(d=>
        db.collection('artifacts').doc(APP_ID)
          .collection('public_characters').doc(d.data().charId).get()
      ));
      snaps.forEach((s,i)=>{
        if(s.exists &&
          s.data()?.createdBy===uid &&
          s.data()?.isPublic!==false &&
          s.data()?.isDraft!==true) {
          valid.push(chunk[i].data().charId);
        }
      });
    }
    return valid;
  }

  async function creatorRewardEligibleWorlds(uid,month) {
    const records=await db.collection('creator_world_publications')
      .where('uid','==',uid).limit(500).get();

    const candidates=records.docs.filter(d=>{
      const x=d.data();
      return x.firstPublishedMonth===month &&
        x.eligibleAtPublication===true &&
        x.firstCreatedMonth===month;
    });

    const valid=[];
    for(let start=0; start<candidates.length; start+=25) {
      const chunk=candidates.slice(start,start+25);
      const snaps=await Promise.all(chunk.map(d=>
        db.collection('artifacts').doc(APP_ID)
          .collection('public_worlds').doc(d.data().worldId).get()
      ));
      snaps.forEach((s,i)=>{
        const w=s.data()||{};
        if(s.exists &&
          w.createdBy===uid &&
          w.isPublic===true &&
          w.publicPlayable===true &&
          w.status==='public' &&
          w.isDraft!==true) {
          valid.push(chunk[i].data().worldId);
        }
      });
    }
    return valid;
  }

  // 相容已在本月公開、但本功能部署前已存在的世界：
  // 若尚無 world publication ledger，get/claim 時會以 public_worlds + worlds.createdAt
  // 補建帳本。只補「本月新建且目前公開」的世界，不把舊世界重新公開算成新作品。
  async function backfillCurrentMonthWorldPublications(uid,month) {
    const publicSnap=await db.collection('artifacts').doc(APP_ID)
      .collection('public_worlds').where('createdBy','==',uid).limit(500).get();

    for(const publicDoc of publicSnap.docs) {
      const p=publicDoc.data()||{};
      if(p.isPublic!==true || p.publicPlayable!==true || p.status!=='public' || p.isDraft===true)continue;

      const worldId=publicDoc.id;
      const pubRef=creatorWorldPublicationRef(uid,worldId);
      const existing=await pubRef.get();
      if(existing.exists)continue;

      const worldSnap=await db.collection('artifacts').doc(APP_ID).collection('worlds').doc(worldId).get();
      if(!worldSnap.exists)continue;
      const world=worldSnap.data()||{};
      if(String(world.createdBy||'')!==uid)continue;

      const createdDate=world.createdAt?.toDate?.();
      const publishedDate=world.publishedAt?.toDate?.();
      if(!(createdDate instanceof Date) || Number.isNaN(createdDate.getTime()))continue;
      if(!(publishedDate instanceof Date) || Number.isNaN(publishedDate.getTime()))continue;

      const createdMonth=creatorRewardMonth(createdDate);
      const publishedMonth=creatorRewardMonth(publishedDate);
      if(createdMonth!==month || publishedMonth!==month)continue;

      await pubRef.create({
        uid,worldId,
        firstPublishedAt:world.publishedAt,
        firstPublishedMonth:publishedMonth,
        firstCreatedMonth:createdMonth,
        eligibleAtPublication:true,
        backfilled:true,
      }).catch(e=>{
        if(Number(e.code)!==6 && e.code!=='already-exists')throw e;
      });
    }
  }

  async function creatorRewardEligible(uid,month) {
    await backfillCurrentMonthWorldPublications(uid,month);
    const [characterIds,worldIds]=await Promise.all([
      creatorRewardEligibleCharacters(uid,month),
      creatorRewardEligibleWorlds(uid,month),
    ]);
    return {
      characterIds,
      worldIds,
      total:characterIds.length+worldIds.length,
    };
  }

  async function maybeNotifyCreatorRewardReady(uid,month) {
    if(typeof sendToUserDevices!=='function')return;

    try {
      const [eligible,rewardSnap,userSnap]=await Promise.all([
        creatorRewardEligible(uid,month),
        db.collection('creator_monthly_rewards').doc(`${uid}_${month}`).get(),
        db.collection('users').doc(uid).get(),
      ]);

      if(eligible.total<TARGET_COUNT || rewardSnap.exists)return;
      if(!userSnap.exists || !creatorFanMailVerified(userSnap.data()||{}))return;

      const noticeRef=creatorRewardNoticeRef(uid,month);
      let shouldSend=false;

      await db.runTransaction(async tx=>{
        const notice=await tx.get(noticeRef);
        if(notice.exists)return;
        tx.create(noticeRef,{
          uid,month,
          characterCount:eligible.characterIds.length,
          worldCount:eligible.worldIds.length,
          qualifyingCount:eligible.total,
          createdAt:FieldValue.serverTimestamp(),
        });
        shouldSend=true;
      });

      if(!shouldSend)return;

      await sendToUserDevices(uid,{
        notification:{
          title:'🦋 創作者獎勵已解鎖',
          body:'你本月已完成 3 個公開作品！300 朵花花已準備好，前往創作者後台領取吧。',
        },
        data:{
          type:'creator_monthly_reward_ready',
          month:String(month),
          click_action:'FLUTTER_NOTIFICATION_CLICK',
        },
        android:{
          priority:'high',
          notification:{
            channelId:'high_importance_channel',
            sound:'default',
            defaultVibrateTimings:true,
          },
        },
        apns:{
          payload:{aps:{sound:'default',badge:0}},
        },
      });
    } catch(error) {
      logger?.warn?.('creator monthly reward ready push failed',{
        uid,
        month,
        code:String(error?.code||error?.message||'unknown').slice(0,120),
      });
    }
  }

  const _getCreatorMonthlyRewardHandler = async request=>{
    const uid=request.auth?.uid;
    if(!uid)creatorRewardError('unauthenticated','請先登入');

    const user=await db.collection('users').doc(uid).get();
    if(!user.exists||!creatorFanMailVerified(user.data()||{})) {
      creatorRewardError('permission-denied','沒有合作創作者權限');
    }

    const month=creatorRewardMonth();
    const [eligible,claimed]=await Promise.all([
      creatorRewardEligible(uid,month),
      db.collection('creator_monthly_rewards').doc(`${uid}_${month}`).get(),
    ]);

    // 若是舊作品補帳後剛好達標，開頁面時也補送一次通知。
    if(eligible.total>=TARGET_COUNT && !claimed.exists) {
      await maybeNotifyCreatorRewardReady(uid,month);
    }

    return {
      month,
      qualifyingCount:Math.min(eligible.total,TARGET_COUNT),
      characterCount:eligible.characterIds.length,
      worldCount:eligible.worldIds.length,
      claimed:claimed.exists,
      reward:CREATOR_MONTH_REWARD_AMOUNT,
    };
  };
  exports.getCreatorMonthlyReward = onCall({
    region:REGION,timeoutSeconds:60,
  }, _getCreatorMonthlyRewardHandler);
  exports.getCreatorMonthlyRewardUs = onCall({
    region:'us-central1',timeoutSeconds:60,
    memory:'256MiB',cpu:'gcf_gen1',concurrency:1,minInstances:0,maxInstances:3,
  }, _getCreatorMonthlyRewardHandler);

  const _claimCreatorMonthlyRewardHandler = async request=>{
    const uid=request.auth?.uid;
    if(!uid)creatorRewardError('unauthenticated','請先登入');

    const month=creatorRewardMonth();
    const eligible=await creatorRewardEligible(uid,month);
    if(eligible.total<TARGET_COUNT) {
      creatorRewardError('failed-precondition','本月尚未完成 3 個符合資格的公開作品');
    }

    // 取前 3 個資格作品；角色優先只是固定順序，不影響混合計數。
    const chosen=[
      ...eligible.characterIds.map(id=>({type:'character',id})),
      ...eligible.worldIds.map(id=>({type:'world',id})),
    ].slice(0,TARGET_COUNT);

    const userRef=db.collection('users').doc(uid);
    const rewardRef=db.collection('creator_monthly_rewards').doc(`${uid}_${month}`);

    const result=await db.runTransaction(async tx=>{
      const userPromise=tx.get(userRef);
      const rewardPromise=tx.get(rewardRef);
      const workPromises=chosen.map(item=>{
        const collection=item.type==='character'?'public_characters':'public_worlds';
        return tx.get(db.collection('artifacts').doc(APP_ID).collection(collection).doc(item.id));
      });

      const [user,reward,...workDocs]=await Promise.all([
        userPromise,rewardPromise,...workPromises,
      ]);

      if(reward.exists)return {claimed:true,alreadyClaimed:true,month};
      if(!user.exists||!creatorFanMailVerified(user.data()||{})) {
        creatorRewardError('permission-denied','合作資格已暫停或取消');
      }

      const invalid=workDocs.some((doc,index)=>{
        if(!doc.exists)return true;
        const data=doc.data()||{};
        if(data.createdBy!==uid)return true;
        if(chosen[index].type==='character') {
          return data.isPublic===false || data.isDraft===true;
        }
        return data.isPublic!==true ||
          data.publicPlayable!==true ||
          data.status!=='public' ||
          data.isDraft===true;
      });
      if(invalid) {
        creatorRewardError('failed-precondition','公開作品狀態已變動，請重新整理');
      }

      const characterIds=chosen.filter(x=>x.type==='character').map(x=>x.id);
      const worldIds=chosen.filter(x=>x.type==='world').map(x=>x.id);

      tx.create(rewardRef,{
        uid,month,
        amount:CREATOR_MONTH_REWARD_AMOUNT,
        characterIds,
        worldIds,
        qualifyingWorks:chosen,
        createdAt:FieldValue.serverTimestamp(),
      });

      tx.update(userRef,{
        flowerPoints:FieldValue.increment(CREATOR_MONTH_REWARD_AMOUNT),
      });

      tx.create(userRef.collection('flower_logs').doc(`creator_monthly_reward_${month}`),{
        type:'creator_monthly_reward',
        title:`${month} 合作創作者每月創作獎勵`,
        amount:CREATOR_MONTH_REWARD_AMOUNT,
        rewardMonth:month,
        characterCount:characterIds.length,
        worldCount:worldIds.length,
        createdAt:FieldValue.serverTimestamp(),
      });

      return {
        claimed:true,
        alreadyClaimed:false,
        month,
        amount:CREATOR_MONTH_REWARD_AMOUNT,
      };
    });

    return result;
  };
  exports.claimCreatorMonthlyReward = onCall({
    region:REGION,timeoutSeconds:90,
  }, _claimCreatorMonthlyRewardHandler);
  exports.claimCreatorMonthlyRewardUs = onCall({
    region:'us-central1',timeoutSeconds:90,
  }, _claimCreatorMonthlyRewardHandler);

  return exports;
}

module.exports = { createCreatorMonthlyRewards };
