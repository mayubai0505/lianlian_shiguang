'use strict';
const {randomUUID} = require('node:crypto');
const TYPES = Object.freeze({'image/jpeg':{kind:'image',ext:'jpg',max:10*1024*1024},'image/png':{kind:'image',ext:'png',max:10*1024*1024},'image/webp':{kind:'image',ext:'webp',max:10*1024*1024},'video/mp4':{kind:'video',ext:'mp4',max:50*1024*1024},'video/quicktime':{kind:'video',ext:'mov',max:50*1024*1024}});
const safeId = x=>typeof x==='string' && /^[A-Za-z0-9_-]{1,160}$/.test(x);
const safeMime = x=>typeof x==='string' && Object.hasOwn(TYPES,x);
const str=(x,n)=>typeof x==='string'?x.trim().slice(0,n):'';
function validHeader(mime,b) {
  if (mime==='image/jpeg') return b.length>=3 && b[0]===255 && b[1]===216 && b[2]===255;
  if (mime==='image/png') return b.subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10]));
  if (mime==='image/webp') return b.length>=12 && b.toString('ascii',0,4)==='RIFF' && b.toString('ascii',8,12)==='WEBP';
  if (mime==='video/mp4'||mime==='video/quicktime') return b.length>=12 && ['ftyp','moov','mdat','wide','free'].includes(b.toString('ascii',4,8));
  return false;
}
function createPromotionSubmissions({db,APP_ID,FieldValue,HttpsError,requireAdmin,getBucket,logger}) {
  const root=db.collection('artifacts').doc(APP_ID), requests=root.collection('creator_social_promotions');
  const err=(code,msg)=>{throw new HttpsError(code,msg);};
  async function checkWork(tx,uid,type,id) {
    const work=await tx.get(root.collection(type==='character'?'public_characters':'worlds').doc(id));
    const w=work.data()||{};
    if (!work.exists || w.createdBy!==uid || w.isPublic===false || w.isDraft===true || w.isCompleted===false || (type==='character' && ![undefined,null,'','published','approved','public'].includes(w.status) && w.moderationStatus!=='approved') || ['rejected','violation'].includes(w.moderationStatus)) err('failed-precondition','作品必須為本人已公開的作品');
    if(type==='world'){
      const p=await tx.get(root.collection('public_worlds').doc(id));
      if(w.isPublic!==true||w.publicPlayable!==true||w.status!=='public'||!p.exists||p.data().createdBy!==uid||p.data().publicPlayable!==true) err('failed-precondition','世界尚未正式發布');
    }
    const name=str(w.name,200); if(!name) err('failed-precondition','作品名稱不存在'); return name;
  }
  function key(data){const type=data.workType,id=data.workId;if(!['character','world'].includes(type)||!safeId(id))err('invalid-argument','作品識別碼不正確');return {type,id,ref:requests.doc(`${type}_${id}`)};}
  async function removeOld(path){if(!path)return;try{await getBucket().file(path).delete({ignoreNotFound:true});}catch(e){logger.warn('promotion old upload cleanup failed',{code:e.code});}}
  async function creator(request){
    const uid=request.auth?.uid;if(!uid)err('unauthenticated','請先登入');
    const d=request.data||{}, {type,id,ref}=key(d);
    if(d.action==='prepare'){
      if(!safeMime(d.mime)||!Number.isInteger(d.size)||d.size<=0||d.size>TYPES[d.mime].max||d.consent!==true)err('invalid-argument','素材格式、大小或授權不正確');
      const text=typeof d.text==='string'?d.text.trim():'';if(!text||text.length>2200)err('invalid-argument','請填寫宣傳內文（最多 2200 字元）');
      const ticket=randomUUID(), path=`creator_promotion_uploads/${uid}/${type}_${id}/${ticket}.${TYPES[d.mime].ext}`;
      const result=await db.runTransaction(async tx=>{
        const name=await checkWork(tx,uid,type,id), old=await tx.get(ref), profile=await tx.get(db.collection('users').doc(uid));
        const existing=old.data()||{}, u=profile.data()||{};
        if(old.exists&&existing.creatorUid!==uid)err('permission-denied','無法操作此投稿');
        if(['pending','published'].includes(existing.status))err('already-exists','此作品已投稿');
        const creatorName=str(u.nickname,100)||str(u.displayName,100), creatorId=str(u.playerID,100);
        if(!creatorName||!creatorId)err('failed-precondition','請先設定暱稱及玩家 ID');
        const prior=existing.status==='returned'?existing:existing.priorReturn||null;
        tx.set(ref,{workType:type,workId:id,workName:name,creatorUid:uid,creatorName,creatorId,rawText:text,
          text:`${text}\n\n創作者：${creatorName}\n創作者 ID：${creatorId}`,mime:d.mime,size:d.size,mediaType:TYPES[d.mime].kind,
          storagePath:path,ticket,status:'uploading',consent:true,consentVersion:1,consentedAt:FieldValue.serverTimestamp(),
          revision:(Number(existing.revision)||0)+1,updatedAt:FieldValue.serverTimestamp(),
          ...(prior?{priorReturn:{reason:str(prior.reason,500)}}:{})});
        return {ticket,storagePath:path,oldPath:existing.status==='uploading'||existing.status==='returned'?existing.storagePath:null,oldAsset:existing.status==='uploading'||existing.status==='returned'?(existing.assetPath||String(existing.storagePath||'').replace(/^creator_promotion_uploads\//,'creator_promotion_assets/')):null};
      });
      if(result.oldPath&&result.oldPath!==result.storagePath)await removeOld(result.oldPath);
      if(result.oldAsset&&result.oldAsset.startsWith('creator_promotion_assets/'))await removeOld(result.oldAsset);
      return {ticket:result.ticket,storagePath:result.storagePath};
    }
    if(d.action==='submit'){
      const prev=await ref.get(), p=prev.data()||{};
      if(!prev.exists||p.creatorUid!==uid)err('permission-denied','投稿不存在');
      if(p.ticket!==d.ticket)err('failed-precondition','投稿已更新，請重新選擇素材');
      if(p.status==='pending'||p.status==='published')return {status:p.status};
      if(p.status!=='uploading'||!safeMime(p.mime))err('failed-precondition','請重新準備投稿');
      const bucket=getBucket(), file=bucket.file(p.storagePath);let meta, header, pinned;
      const assetPath=p.storagePath.replace(/^creator_promotion_uploads\//,'creator_promotion_assets/');
      const asset=bucket.file(assetPath);
      // A retry after a successful storage copy but before Firestore commit can reuse
      // the immutable server-only asset. A client can never write the final object.
      let assetMeta;
      try {[assetMeta]=await asset.getMetadata();} catch(e){if(Number(e.code)!==404)throw e;}
      if(!assetMeta){
        try{[meta]=await file.getMetadata();pinned=bucket.file(p.storagePath,{generation:String(meta.generation)});[header]=await pinned.download({start:0,end:31,validation:false});}catch(e){if(Number(e.code)===404){const current=(await ref.get()).data()||{};if(current.ticket===p.ticket&&['pending','published'].includes(current.status))return {status:current.status};err('failed-precondition','尚未收到上傳素材');}throw e;}
        if(meta.contentType!==p.mime||Number(meta.size)!==p.size||p.size>TYPES[p.mime].max||!validHeader(p.mime,header))err('invalid-argument','素材內容與檔案格式不符');
        try{await pinned.copy(asset,{preconditionOpts:{ifGenerationMatch:0},contentType:p.mime,metadata:{promotionTicket:p.ticket}});}catch(e){if(Number(e.code)!==412)throw e;}
        [assetMeta]=await asset.getMetadata();
      }
      if(assetMeta.metadata?.promotionTicket!==p.ticket||assetMeta.contentType!==p.mime||Number(assetMeta.size)!==p.size)err('failed-precondition','素材存檔驗證失敗');
      const finalized=await db.runTransaction(async tx=>{
        const name=await checkWork(tx,uid,type,id), current=await tx.get(ref), c=current.data()||{};
        if(c.creatorUid!==uid||c.ticket!==p.ticket)err('failed-precondition','投稿已更新');
        if(c.status==='pending'||c.status==='published')return {status:c.status};
        if(c.status!=='uploading')err('failed-precondition','投稿狀態已變更');
        tx.update(ref,{workName:name,status:'pending',assetPath,generation:String(assetMeta.generation),submittedAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp(),priorReturn:FieldValue.delete()});
        return {status:'pending'};
      });
      await removeOld(p.storagePath);
      return finalized;
    }
    err('invalid-argument','未知操作');
  }
  async function admin(request){
    const adminUid=requireAdmin(request), d=request.data||{}, {type,id,ref}=key(d);
    if(!['published','returned'].includes(d.action))err('invalid-argument','未知操作');
    const reason=typeof d.reason==='string'?d.reason.trim():'';
    if(d.action==='returned'&&(!reason||reason.length>500))err('invalid-argument','請填寫退回原因（最多 500 字元）');
    return db.runTransaction(async tx=>{
      const snap=await tx.get(ref), r=snap.data()||{};
      if(!snap.exists)err('not-found','投稿不存在');
      if(r.revision!==d.revision)err('aborted','投稿版本已更新，請重新查看');
      if(r.status===d.action)return {status:r.status};
      if(r.status!=='pending')err('failed-precondition','僅能處理待審核投稿');
      if(d.action==='published')await checkWork(tx,r.creatorUid,type,id);
      const ok=d.action==='published';
      tx.update(ref,{status:d.action,reason:ok?'':reason,reviewedBy:adminUid,reviewedAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp()});
      tx.create(db.collection('users').doc(r.creatorUid).collection('mailbox').doc(`social_promotion_${type}_${id}_${r.revision}`),{
        type:'creator_social_promotion_notice',source:'creator_social_promotion',fromName:'戀戀拾光官方',isRead:false,createdAt:FieldValue.serverTimestamp(),
        title:ok?'您的作品已完成官方宣傳！':'官方宣傳投稿需修改',body:ok?`《${r.workName}》已完成官方社群宣傳，謝謝您的創作！`:`《${r.workName}》投稿需修改。\n原因：${reason}\n請至創作者工作室重新投稿。`});
      return {status:d.action};
    });
  }
  return {creator,admin};
}
module.exports={createPromotionSubmissions,validHeader,TYPES};
