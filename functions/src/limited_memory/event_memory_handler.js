'use strict';
const crypto = require('crypto');
const {generateImage,detectMime}=require('./gemini_image');
const {buildLimitedMemoryPrompt}=require('./build_limited_memory_prompt');
function createEventMemoryHandlers({db,admin,APP_ID,FieldValue,HttpsError,reusableEventIsRunning,geminiApiKey}){
 const root=db.collection('artifacts').doc(APP_ID), jobs=root.collection('event_memory_generation_jobs');
 const fail=(code,msg)=>{throw new HttpsError(code,msg)};
 const id=v=>{if(typeof v!=='string'||!v||v.length>200||v.includes('/'))fail('invalid-argument','無效編號');return v;};
 const key=(...parts)=>crypto.createHash('sha256').update(JSON.stringify(parts)).digest('hex');
 const text=(v,max=1000)=>typeof v==='string'?v.trim().slice(0,max):'';
 const now=()=>FieldValue.serverTimestamp();
 async function refund(ref,attempt){return db.runTransaction(async tx=>{const snap=await tx.get(ref),j=snap.data();if(!j||j.status!=='pending'||j.attempt!==attempt)return false;const u=db.collection('users').doc(j.uid);if(j.cost>0){tx.update(u,{flowerPoints:FieldValue.increment(j.cost)});tx.set(u.collection('flower_logs').doc(`memory_refund_${attempt}`),{title:'限定回憶生成退款',amount:j.cost,type:'refund',reason:'event_memory_failed',createdAt:now()});}tx.update(ref,{status:'failed',finishedAt:now()});return true;});}
 async function inputBytes(url){
  const bucket=admin.storage().bucket(), u=new URL(url);
  if(u.protocol!=='https:'||u.hostname!=='firebasestorage.googleapis.com')throw Error('Reference requires a Firebase download URL');
  const match=u.pathname.match(/^\/v0\/b\/([^/]+)\/o\/(.+)$/);
  if(!match||decodeURIComponent(match[1])!==bucket.name)throw Error('Unexpected bucket');
  const path=decodeURIComponent(match[2]), token=u.searchParams.get('token');
  const denied=new Set(['feedback_images','user_uploads','world_images','environment_sounds','creator_promotion_uploads','creator_promotion_assets','limited_memories']);
  if(!path||!token||denied.has(path.split('/')[0]))throw Error('Reference path not permitted');
  const file=bucket.file(path), [meta]=await file.getMetadata();
  const tokens=String(meta.metadata?.firebaseStorageDownloadTokens||'').split(',');
  if(!tokens.includes(token))throw Error('Reference download token invalid');
  if(!Number.isFinite(Number(meta.size))||Number(meta.size)<=0||Number(meta.size)>5*1024*1024)throw Error('Image exceeds size limit');
  const [bytes]=await bucket.file(path,{generation:meta.generation}).download({validation:true});
  detectMime(bytes);return bytes;
 }
 async function handle(request){const uid=request.auth?.uid;if(!uid)fail('unauthenticated','請先登入');const d=request.data||{},eventId=id(d.eventId),memoryId=id(d.memoryId),characterId=id(d.characterId),isPrivate=d.isPrivate===true;
 const jobRef=jobs.doc(key(uid,eventId,memoryId,characterId,isPrivate)), userRef=db.collection('users').doc(uid), eventRef=root.collection('events').doc(eventId), memoryRef=eventRef.collection('memories').doc(memoryId),progressRef=root.collection('event_progress').doc(uid).collection('events').doc(eventId), characterRef=isPrivate?root.collection('users').doc(uid).collection('private_characters').doc(characterId):root.collection('public_characters').doc(characterId), collectionRef=userRef.collection('event_memories').doc('ai_'+jobRef.id);
 if(d.action==='status'){const j=(await jobRef.get()).data();return {status:j?.status||'none',...(j?.status==='ready'?{imageUrl:j.imageUrl}:{})};}
 if(d.action!=='generate')fail('invalid-argument','無效操作');
 // Release gate: keep paid image generation administrator-only until end-to-end tests pass.
 if(uid!== 'B71k2kyooubYsOtIO1nkiBwyBXt2')fail('permission-denied','限定回憶目前僅開放管理員測試');
 const attempt=crypto.randomUUID(), source=text(d.sourceImageUrl,4000);
 const reserved=await db.runTransaction(async tx=>{const [job,event,mem,user,progress,char,friend]=await Promise.all([tx.get(jobRef),tx.get(eventRef),tx.get(memoryRef),tx.get(userRef),tx.get(progressRef),tx.get(characterRef),tx.get(userRef.collection('friends').doc(characterId))]);const j=job.data();if(j?.status==='ready')return {status:'ready',imageUrl:j.imageUrl};if(j?.status==='pending')return {status:'pending'};
 const e=event.data(),m=mem.data(),u=user.data(),p=progress.data()||{},c=char.data();if(!e||!m||!u||!c)fail('not-found','資料不存在');if(!reusableEventIsRunning(e,new Date())||e.hasMemory===false||m.isActive===false||m.generationMode!=='ai')fail('failed-precondition','活動或回憶未開放');if(!isPrivate&&c.createdBy!==uid&&!friend.exists)fail('permission-denied','請先加入角色好友');
 const urls=new Set([c.avatarPath,...(Array.isArray(c.galleryPaths)?c.galleryPaths:[]),...(Array.isArray(c.gallery)?c.gallery.map(v=>v?.imageUrl||v?.url):[])].filter(v=>typeof v==='string').map(v=>v.trim()));if(!source||!urls.has(source))fail('invalid-argument','請選擇角色現有圖片');
 const target=text(m.unlockTargetId,200), n=Number(m.unlockValue||0);switch(m.unlockType||'free'){case 'free':break;case 'total_earned':if(!Number.isFinite(n)||n<0||Number(p.totalEarned||0)<n)fail('failed-precondition','未達解鎖條件');break;case 'shop_item':if(!target||Number(p.redeemedShopItems?.[target]||0)<=0)fail('failed-precondition','未兌換指定商品');break;case 'task':{if(!target||target.includes('/'))fail('failed-precondition','任務設定異常');const task=await tx.get(eventRef.collection('tasks').doc(target));if(!task.exists)fail('failed-precondition','任務不存在');const td=task.data();const required=Number(td.target)>0?Number(td.target):Number(String(td.title||'').match(/\d+/)?.[0]||1);if(p.claimedTasks?.[target]!==true&&Number(p.taskProgress?.[target]||0)<required)fail('failed-precondition','尚未完成任務');break;}default:fail('failed-precondition','解鎖設定異常');}
 const cost=m.costFlowers;if(!Number.isInteger(cost)||cost<0||cost>10000||d.expectedCost!==cost)fail('failed-precondition','費用已更新，請重新確認');if(!Number.isFinite(u.flowerPoints)||u.flowerPoints<cost)fail('failed-precondition','花花不足');
 const dateText=new Intl.DateTimeFormat('sv-SE',{timeZone:'Asia/Taipei',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date()).replace(/-/g,'.');
 if(cost>0){tx.update(userRef,{flowerPoints:FieldValue.increment(-cost)});tx.set(userRef.collection('flower_logs').doc(`memory_charge_${attempt}`),{title:'限定回憶生成',amount:-cost,type:'consume',reason:'event_memory_generate',eventId,memoryId,characterId,createdAt:now()});}tx.set(jobRef,{uid,eventId,memoryId,characterId,isPrivate,status:'pending',attempt,cost,expiresAt:new Date(Date.now()+10*60*1000),createdAt:now()});return {status:'reserved',cost,dateText,c,m};});
 if(reserved.status!=='reserved')return reserved;
 let file;try{const {c,m,dateText,cost}=reserved;const bytes=await inputBytes(source);const prompt=buildLimitedMemoryPrompt({characterName:text(c.name,120),characterTitle:text(c.occupation,120),personality:[text(c.detailedPersonality||c.personality,1800),text(c.appearance,1000),text(c.worldSetting,1000)].filter(Boolean).join('\n'),eventTitle:text(m.title,120),eventTheme:text(m.eventTheme,300),eventDecor:text(m.eventDecor,2000),dateText});const result=await generateImage({apiKey:geminiApiKey.value(),input:bytes,prompt});const bucket=admin.storage().bucket(),ext=result.mimeType==='image/png'?'png':result.mimeType==='image/webp'?'webp':'jpg',path=`limited_memories/${uid}/${jobRef.id}/${attempt}.${ext}`,token=crypto.randomUUID();file=bucket.file(path);await file.save(result.bytes,{metadata:{contentType:result.mimeType,metadata:{firebaseStorageDownloadTokens:token}},resumable:false});const imageUrl=`https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(path)}?alt=media&token=${token}`;
 await db.runTransaction(async tx=>{const snap=await tx.get(jobRef);if(snap.data()?.status!=='pending'||snap.data()?.attempt!==attempt)throw Error('Reservation expired');tx.set(collectionRef,{eventId,memoryId,characterId,characterName:text(c.name,120),memoryTitle:text(m.title,120),characterImageSnapshot:imageUrl,imageUrl,storagePath:path,generationMode:'ai',cardDateText:dateText,costFlowers:cost,collectedAt:now(),sceneSnapshot:[],finalText:''});tx.update(jobRef,{status:'ready',imageUrl,finishedAt:now()});tx.set(progressRef,{viewedMemories:{[memoryId]:{viewedAt:now()}},updatedAt:now()},{merge:true});});return {status:'ready',imageUrl};
 }catch(err){console.error('event memory generation failed',jobRef.id,String(err.message).slice(0,200));const j=(await jobRef.get()).data();if(j?.status==='ready'&&j.attempt===attempt)return {status:'ready',imageUrl:j.imageUrl};await refund(jobRef,attempt);if(file)await file.delete({ignoreNotFound:true}).catch(()=>{});fail('internal','生成失敗，已處理退款；請重新查詢狀態');}}
 async function recover(){const snap=await jobs.where('expiresAt','<=',new Date()).orderBy('expiresAt').limit(200).get();for(const doc of snap.docs){const j=doc.data();if(j.status==='pending')await refund(doc.ref,j.attempt); // clear expiry on finished jobs to avoid starvation
 await db.runTransaction(async tx=>{const d=(await tx.get(doc.ref)).data();if(d&&d.status!=='pending'&&d.expiresAt)tx.update(doc.ref,{expiresAt:FieldValue.delete()});});}}
 return {handle,recover};
}
module.exports={createEventMemoryHandlers};
