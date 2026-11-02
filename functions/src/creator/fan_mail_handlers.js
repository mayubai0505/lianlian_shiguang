'use strict';
// V64: Reuse the original Fan Mail handlers without changing transaction semantics.
function createCreatorFanMailHandlers(deps) {
  const {db, HttpsError, FieldValue, Timestamp, crypto, admin, logger, onCall, onSchedule, REGION,
    creatorFanMailDayKey, creatorFanMailVerified, creatorFanMailValidate,
    creatorFanMailUsageRef, CREATOR_FAN_MAIL_LIMITS} = deps;
  const handlers = {};
handlers.getCreatorFanMailOverview = onCall({region: REGION, timeoutSeconds:30}, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', '請先登入');
  const [creator, usage, jobs] = await Promise.all([
    db.collection('users').doc(uid).get(),
    creatorFanMailUsageRef(uid, creatorFanMailDayKey()).get(),
    db.collection('creator_fan_mail_jobs').where('creatorUid','==',uid).orderBy('createdAt','desc').limit(20).get(),
  ]);
  if (!creator.exists || !creatorFanMailVerified(creator.data() || {})) {
    throw new HttpsError('permission-denied', '目前沒有合作創作者寄信資格');
  }
  const counters = usage.data() || {};
  return {day:creatorFanMailDayKey(), singleUsed:Number(counters.singleUsed||0),
    broadcastUsed:Number(counters.broadcastUsed||0), singleLimit:30, broadcastLimit:5,
    jobs:jobs.docs.map(x => {const d=x.data()||{};return {id:x.id, mode:d.mode, title:d.title,
      status:d.status, delivered:Number(d.delivered||0), createdAt:d.createdAt?.toDate?.()?.toISOString()||null,
      finishedAt:d.finishedAt?.toDate?.()?.toISOString()||null, error:String(d.error||'')};})};
});

handlers.sendCreatorFanMail = onCall({region: REGION, timeoutSeconds:60, maxInstances:20}, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', '請先登入');
  const mode = String(request.data?.mode||'');
  const title = String(request.data?.title||'').trim();
  const body = String(request.data?.body||'').trim();
  const recipientUid = String(request.data?.recipientUid||'').trim();
  const requestId = String(request.data?.requestId||'').trim();
  if (!['single','broadcast'].includes(mode)) throw new HttpsError('invalid-argument','無效寄信類型');
  if (!/^[a-zA-Z0-9_-]{12,80}$/.test(requestId)) throw new HttpsError('invalid-argument','寄送識別碼無效');
  creatorFanMailValidate(title,body);
  if (mode==='single' && (!recipientUid || recipientUid===uid || recipientUid.includes('/'))) {
    throw new HttpsError('invalid-argument','請選擇有效粉絲');
  }
  const day=creatorFanMailDayKey();
  const creatorRef=db.collection('users').doc(uid);
  const usageRef=creatorFanMailUsageRef(uid,day);
  const jobRef=db.collection('creator_fan_mail_jobs').doc(`${uid}_${requestId}`);
  const result=await db.runTransaction(async tx => {
    const [creator,usage,job,follower] = await Promise.all([
      tx.get(creatorRef),tx.get(usageRef),tx.get(jobRef),
      mode==='single' ? tx.get(creatorRef.collection('followers').doc(recipientUid)) : Promise.resolve(null),
    ]);
    if (!creator.exists || !creatorFanMailVerified(creator.data()||{})) {
      throw new HttpsError('permission-denied','合作資格已失效');
    }
    if (job.exists) {
      const prev=job.data()||{};
      if (prev.mode!==mode || prev.title!==title || prev.body!==body || (prev.recipientUid||'')!== (mode==='single'?recipientUid:'')) {
        throw new HttpsError('already-exists','寄送識別碼已被其他內容使用');
      }
      return {jobId:jobRef.id,status:prev.status||'queued',alreadySubmitted:true};
    }
    if (mode==='single' && !follower?.exists) throw new HttpsError('failed-precondition','該玩家目前未追蹤妳');
    const u=usage.data()||{};
    const key=mode==='single'?'singleUsed':'broadcastUsed';
    const limit=CREATOR_FAN_MAIL_LIMITS[mode];
    if (Number(u[key]||0)>=limit) throw new HttpsError('resource-exhausted',`今日${mode==='single'?'單人私信':'群發'}次數已達上限`);
    tx.set(usageRef,{creatorUid:uid,day,[key]:FieldValue.increment(1),updatedAt:FieldValue.serverTimestamp()},{merge:true});
    const displayName=String(creator.data()?.nickname || creator.data()?.displayName || '合作創作者').slice(0,80);
    tx.create(jobRef,{creatorUid:uid,mode,recipientUid:mode==='single'?recipientUid:'',title,body,
      creatorName:displayName,status:'queued',delivered:0,lastFollowerId:'',
      createdAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp(),day});
    return {jobId:jobRef.id,status:'queued',alreadySubmitted:false};
  });
  return result;
});

// 每分鐘處理最多 5 個工作、每工作最多 120 位；不會在單次 callable 中掃描全部粉絲。
// Transaction 內完成「信件寫入 + 游標更新」，失敗回滾，不重複寄送。
handlers.processCreatorFanMailJobs = onSchedule({schedule:'every 1 minutes', timeZone:'Asia/Taipei',region:REGION,
  timeoutSeconds:540,memory:'512MiB'},async () => {
  const jobs=await db.collection('creator_fan_mail_jobs').where('status','in',['queued','processing']).limit(5).get();
  for (const job of jobs.docs) {
    const work=job.data()||{};
    const uid=String(work.creatorUid||'');
    if (!uid) continue;
    const lease=crypto.randomUUID();
    const claimed=await db.runTransaction(async tx=>{
      const snap=await tx.get(job.ref);
      const d=snap.data()||{};
      if (!['queued','processing'].includes(d.status))return false;
      const lock=d.leaseUntil?.toMillis?.()||0;
      if (lock>Date.now())return false;
      tx.update(job.ref,{status:'processing',leaseId:lease,
        leaseUntil:Timestamp.fromMillis(Date.now()+240000),updatedAt:FieldValue.serverTimestamp()});
      return true;
    });
    if (!claimed)continue;
    try {
      const creatorSnap=await db.collection('users').doc(uid).get();
      if (!creatorSnap.exists || !creatorFanMailVerified(creatorSnap.data()||{})) {
        await db.runTransaction(async tx=>{const j=await tx.get(job.ref);if(j.data()?.leaseId===lease)
          tx.update(job.ref,{status:'cancelled',leaseUntil:FieldValue.delete(),updatedAt:FieldValue.serverTimestamp(),
            error:'合作創作者資格失效'});});
        continue;
      }
      let followers=[];
      if(work.mode==='single') {
        const follow=await db.collection('users').doc(uid).collection('followers').doc(work.recipientUid).get();
        followers=follow.exists?[follow]:[];
      } else {
        let q=db.collection('users').doc(uid).collection('followers').orderBy(admin.firestore.FieldPath.documentId());
        if(work.lastFollowerId)q=q.startAfter(work.lastFollowerId);
        followers=(await q.limit(120).get()).docs;
      }
      if (!followers.length) {
        await db.runTransaction(async tx=>{const j=await tx.get(job.ref);if(j.data()?.leaseId===lease)
          tx.update(job.ref,{status:'completed',finishedAt:FieldValue.serverTimestamp(),
            leaseUntil:FieldValue.delete(),updatedAt:FieldValue.serverTimestamp()});});
        continue;
      }
      // 批次讀取封鎖設定並驗證使用者存在，避免寄給封鎖創作者的帳號。
      const recipientIds=followers.map(f=>f.id).filter(id=>id && id!==uid);
      const blockSnaps=await Promise.all(recipientIds.map(id=>db.collection('users').doc(id)
        .collection('blockedCreators').doc(uid).get()));
      const eligible=recipientIds.filter((_,i)=>!blockSnaps[i].exists);
      await db.runTransaction(async tx=>{
        const j=await tx.get(job.ref);
        if(j.data()?.leaseId!==lease) throw new Error('job lease lost');
        const creator=await tx.get(db.collection('users').doc(uid));
        if(!creator.exists||!creatorFanMailVerified(creator.data()||{}))throw new Error('creator revoked');
        const refs=eligible.map(id=>db.collection('users').doc(id).collection('mailbox').doc(`fan_${job.id}`));
        const existing=await Promise.all(refs.map(ref=>tx.get(ref)));
        let added=0;
        for(let i=0;i<refs.length;i++) {
          if(existing[i].exists)continue;
          tx.create(refs[i],{type:'creator_fan_mail',creatorUid:uid,creatorName:work.creatorName,
            title:work.title,body:work.body,mailJobId:job.id,read:false,isRead:false,
            createdAt:FieldValue.serverTimestamp()});
          added++;
        }
        const done=work.mode==='single'||followers.length<120;
        tx.update(job.ref,{lastFollowerId:followers[followers.length-1].id,
          delivered:FieldValue.increment(added),status:done?'completed':'processing',
          ...(done?{finishedAt:FieldValue.serverTimestamp()}:{}),
          leaseUntil:FieldValue.delete(),leaseId:FieldValue.delete(),updatedAt:FieldValue.serverTimestamp()});
      });
    }catch(error){
      logger.error('Creator fan mail processing failed',{jobId:job.id,error:String(error)});
      await db.runTransaction(async tx=>{const j=await tx.get(job.ref);if(j.data()?.leaseId===lease)
        tx.update(job.ref,{status:'failed',error:String(error).slice(0,300),leaseId:FieldValue.delete(),
          leaseUntil:FieldValue.delete(),updatedAt:FieldValue.serverTimestamp()});});
    }
  }
});



 return handlers;
}
module.exports={createCreatorFanMailHandlers};
