'use strict';
// 由玩家本人取消已確認的約定，伺服器檢查所有權，具冪等性。
function createCancelRoleAgreementHandler({db,APP_ID,HttpsError,FieldValue}) {
  return async request => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', '請先登入');
    const characterId = String(request.data?.characterId || '').trim();
    const agreementId = String(request.data?.agreementId || '').trim();
    if (!/^[^/]{1,160}$/.test(characterId) || !/^[a-f0-9]{64}$/.test(agreementId)) {
      throw new HttpsError('invalid-argument', '約定編號無效');
    }
    const ref = db.collection('role_agreements').doc(uid).collection('characters')
      .doc(characterId).collection('items').doc(agreementId);
    return db.runTransaction(async tx => {
      const snapshot = await tx.get(ref);
      if (!snapshot.exists) throw new HttpsError('not-found','找不到約定');
      const current = snapshot.data() || {};
      if (current.characterId !== characterId || current.confirmedBy !== uid) {
        throw new HttpsError('permission-denied','無權操作其他玩家約定');
      }
      if (current.status === 'cancelled') return {success:true,alreadyCancelled:true};
      if (!['pending_delivery','scheduled','ringing'].includes(current.status)) {
        throw new HttpsError('failed-precondition','此約定已執行或無法取消');
      }
      tx.delete(db.collection('artifacts').doc(APP_ID).collection('role_agreement_jobs').doc(agreementId));
      tx.update(ref, {status:'cancelled',deliveryEnabled:false,
        cancelledAt:FieldValue.serverTimestamp(), updatedAt:FieldValue.serverTimestamp()});
      return {success:true,alreadyCancelled:false};
    });
  };
}
module.exports = {createCancelRoleAgreementHandler};
