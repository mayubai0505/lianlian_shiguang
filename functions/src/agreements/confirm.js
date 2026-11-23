'use strict';
const crypto = require('crypto');
function createConfirmRoleAgreementHandler({db,APP_ID,HttpsError,FieldValue}) {
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
    const id = crypto.createHash('sha256').update(`${uid}\0${sessionId}\0${requestId}`).digest('hex');
    const ref = db.collection('role_agreements').doc(uid).collection('characters').doc(characterId)
      .collection('items').doc(id);
    const job = db.collection('artifacts').doc(APP_ID).collection('role_agreement_jobs').doc(id);
    const created = await db.runTransaction(async tx => {
      const old = await tx.get(ref);
      if (old.exists) return false;
      tx.create(ref, {
        characterId, sessionId, sourceRequestId:requestId, content,
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
