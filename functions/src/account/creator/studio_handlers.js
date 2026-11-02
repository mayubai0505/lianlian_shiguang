'use strict';
// V50: Creator studio actions. Dependencies are injected from core.js.
function createCreatorStudioHandlers({db,HttpsError,creatorFanMailVerified,APP_ID,FieldValue,crypto}) {
async function requireCreatorStudioUid(request) {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', '請先登入');
  const snap = await db.collection('users').doc(uid).get();
  if (!snap.exists || !creatorFanMailVerified(snap.data() || {})) {
    throw new HttpsError('permission-denied', '沒有有效的合作創作者資格');
  }
  return uid;
}

const removeCreatorFollowerHandler = async request => {
  const uid = await requireCreatorStudioUid(request);
  const followerUid = String(request.data?.followerUid || '').trim();
  if (!followerUid || followerUid === uid || !/^[a-zA-Z0-9_-]{6,128}$/.test(followerUid)) {
    throw new HttpsError('invalid-argument', '無效的追蹤者');
  }
  const follower = db.collection('users').doc(uid).collection('followers').doc(followerUid);
  const following = db.collection('users').doc(followerUid).collection('following').doc(uid);
  const result = await db.runTransaction(async tx => {
    const doc = await tx.get(follower);
    if (!doc.exists) return {removed: false};
    tx.delete(follower);
    tx.delete(following);
    return {removed: true};
  });
  return result;
};

const updateCreatorPortfolioHandler = async request => {
  const uid = await requireCreatorStudioUid(request);
  const ids = request.data?.characterIds;
  if (!Array.isArray(ids) || ids.length > 300 || ids.some(x => typeof x !== 'string' || !x || x.length > 200) || new Set(ids).size !== ids.length) {
    throw new HttpsError('invalid-argument', '作品清單無效');
  }
  const chars = await db.collection('artifacts').doc(APP_ID).collection('public_characters')
    .where('createdBy', '==', uid).get();
  const allowed = new Set(chars.docs.map(d => d.id));
  if (ids.some(x => !allowed.has(x))) throw new HttpsError('permission-denied', '作品不屬於此創作者');
  await db.collection('users').doc(uid).update({creatorPortfolioOrder: ids});
  return {success: true};
};

const updateCreatorBannerHandler = async request => {
  const uid = await requireCreatorStudioUid(request);
  const op = String(request.data?.operation || '');
  const userRef = db.collection('users').doc(uid);
  const file = require('firebase-admin/storage').getStorage().bucket().file(`creator_banners/${uid}/banner`);
  if (op === 'remove') {
    await userRef.update({creatorBannerUrl: FieldValue.delete()});
    await file.delete({ignoreNotFound: true});
    return {success: true};
  }
  if (op !== 'upload') throw new HttpsError('invalid-argument', '無效操作');
  const raw = request.data?.imageBase64;
  if (typeof raw !== 'string' || raw.length > 3100000 || raw.length < 80 || !/^[a-zA-Z0-9+/=]+$/.test(raw)) {
    throw new HttpsError('invalid-argument', '圖片資料格式或大小不符');
  }
  const buffer = Buffer.from(raw, 'base64');
  if (buffer.length > 2200000) throw new HttpsError('invalid-argument', '圖片需小於 2.2 MB');
  const jpg = buffer[0] === 0xFF && buffer[1] === 0xD8 && buffer[2] === 0xFF;
  const png = buffer.subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10]));
  if (!jpg && !png) throw new HttpsError('invalid-argument', '僅支援 JPEG 或 PNG');
  const token = crypto.randomUUID();
  const contentType = jpg ? 'image/jpeg' : 'image/png';
  await file.save(buffer, {resumable: false, metadata: {contentType,
    metadata: {firebaseStorageDownloadTokens: token}}, validation: 'md5'});
  const url = `https://firebasestorage.googleapis.com/v0/b/${encodeURIComponent(file.bucket.name)}/o/${encodeURIComponent(file.name)}?alt=media&token=${token}`;
  await userRef.update({creatorBannerUrl: url, creatorBannerUpdatedAt: FieldValue.serverTimestamp()});
  return {success: true};
};



return {removeCreatorFollowerHandler,updateCreatorPortfolioHandler,updateCreatorBannerHandler};
}
module.exports={createCreatorStudioHandlers};
