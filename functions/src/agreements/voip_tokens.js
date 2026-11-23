 'use strict';
const crypto = require('crypto');
function createRegisterVoipToken({db,HttpsError,FieldValue}) {
  return async request => {
    const uid=request.auth?.uid;
    if(!uid) throw new HttpsError('unauthenticated','請先登入');
    const token=String(request.data?.token||'').toLowerCase();
    if(!/^[a-f0-9]{64,256}$/.test(token)) throw new HttpsError('invalid-argument','無效 VoIP token');
    const docId=crypto.createHash('sha256').update(token).digest('hex');
    // 只存在美國可信任後端維護的位置，不落在 users 的寬鬆遞迴規則。
    await db.collection('role_voip_tokens').doc(uid).collection('devices').doc(docId).set({
      token,platform:'ios',updatedAt:FieldValue.serverTimestamp(),
    },{merge:true});
    return {ok:true};
  };
}
module.exports={createRegisterVoipToken};
