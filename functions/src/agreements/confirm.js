'use strict';
const crypto = require('crypto');
const {prepareReminder,isRepeatCall}=require('./reminder_content');
const {loadAgreementPersona}=require('./persona_context');
const {resolveRoleAgreementCharacterName}=require('./character_name');
function createConfirmRoleAgreementHandler({db,APP_ID,HttpsError,FieldValue,openRouterApiKey,secureOpenRouterBody}) {
  return async request => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated','請先登入');
    const input = request.data || {};
    const characterId = String(input.characterId || '').trim();
    const sessionId = String(input.sessionId || '').trim();
    const requestId = String(input.requestId || '').trim();
    const content = String(input.content || '').trim();
    const method = String(input.method || '');
    const when = Number(input.scheduledAtMs);
    if (!/^[^/]{1,160}$/.test(characterId) || !/^[^/]{1,160}$/.test(sessionId) ||
        !requestId || requestId.length > 200 || !content || content.length > 500 ||
        !['call','notification'].includes(method) || !Number.isSafeInteger(when) ||
        when < Date.now() + 60000 || when > Date.now() + 366 * 86400000) {
      throw new HttpsError('invalid-argument','約定資料或時間無效');
    }
    const session = await db.collection('artifacts').doc(APP_ID)
      .collection('chat_sessions').doc(sessionId).get();
    const data = session.data() || {};
    if (!session.exists || data.userId !== uid || data.characterId !== characterId || data.chatMode !== 'gemini') {
      throw new HttpsError('permission-denied','僅限本人角色閒聊房間建立約定');
    }
    const characterName=await resolveRoleAgreementCharacterName({db,APP_ID,uid,characterId,fallback:data.characterName});
    const id = crypto.createHash('sha256').update(`${uid}\0${sessionId}\0${requestId}`).digest('hex');
    const ref = db.collection('users').doc(uid).collection('characters').doc(characterId)
      .collection('role_agreements').doc(id);
    const job = db.collection('artifacts').doc(APP_ID).collection('role_agreement_jobs').doc(id);
    if ((await ref.get()).exists) return {success:true,id,created:false,deliveryEnabled:true};
    const root=db.collection('artifacts').doc(APP_ID);
    let character={name:characterName};
    try {
      let snap=await root.collection('public_characters').doc(characterId).get();
      if(!snap.exists)snap=await root.collection('users').doc(uid).collection('private_characters').doc(characterId).get();
      if(snap.exists)character=snap.data()||character;
    } catch (_) {}
    let inherited=null;
    const last=data.lastRoleAgreementCall;
    if(method==='call' && isRepeatCall(content) && last && /^[a-f0-9]{64}$/.test(last.agreementId||'') && ['missed','completed','connection_failed'].includes(last.status) && Number.isFinite(last.atMs) && last.atMs<=Date.now() && Date.now()-last.atMs<=7*86400000){
      const prev=(await ref.parent.doc(last.agreementId).get()).data();
      if(prev?.confirmedBy===uid && prev.characterId===characterId && prev.sessionId===sessionId && prev.method==='call' && ['missed','completed','connection_failed','declined'].includes(prev.status)){
        const task=String(prev.reminderContent||prev.content||'').trim().slice(0,500);
        if(task && !isRepeatCall(task)) inherited={id:last.agreementId,task};
      }
    }
    let context;
    try{context=await loadAgreementPersona({db,APP_ID,uid,characterId,sessionId,character,roomSnapshot:session});}catch(e){console.warn("AGREEMENT_PREPARE_CONTEXT_UNAVAILABLE");}
    const prepared=await prepareReminder({raw:inherited?.task||content,character,context,method,apiKey:openRouterApiKey,secureBody:secureOpenRouterBody});
    if(inherited){prepared.originalText=content;prepared.sourceAgreementId=inherited.id;prepared.reminderContent=inherited.task;}
    const created = await db.runTransaction(async tx => {
      const old = await tx.get(ref);
      if (old.exists) return false;
      tx.create(ref, {
        characterId, characterName, sessionId, sourceRequestId:requestId, content:prepared.reminderContent, ...prepared,
        scheduledAt:new Date(when), method, status:'scheduled', deliveryEnabled:true,
        confirmedBy:uid, confirmedAt:FieldValue.serverTimestamp(),
        createdAt:FieldValue.serverTimestamp(), updatedAt:FieldValue.serverTimestamp(),
      });
      tx.create(job, {uid,characterId,agreementId:id,method,
        scheduledAt:new Date(when),nextActionAt:new Date(when), state:'pending',attempts:0,
        createdAt:FieldValue.serverTimestamp()});
      return true;
    });
    return {success:true,id,created,deliveryEnabled:true};
  };
}
module.exports = {createConfirmRoleAgreementHandler};
