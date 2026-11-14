'use strict';
// V50: Creator studio actions. Dependencies are injected from core.js.
function createCreatorStudioHandlers({db,HttpsError,creatorFanMailVerified,APP_ID,FieldValue,crypto,requireRewardCampaignAdmin}) {
async function requireCreatorStudioUid(request) {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', '請先登入');
  const snap = await db.collection('users').doc(uid).get();
  if (!snap.exists || !creatorFanMailVerified(snap.data() || {})) {
    throw new HttpsError('permission-denied', '沒有有效的合作創作者資格');
  }
  return uid;
}

const promoRef = uid => db.collection('artifacts').doc(APP_ID).collection('creator_promo_banners').doc(uid);

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
    await promoRef(uid).set({enabled:false, bannerImageUrl:'', updatedAt:FieldValue.serverTimestamp()}, {merge:true});
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
  const imageHash = crypto.createHash('sha256').update(buffer).digest('hex');
  const previousPromo = (await promoRef(uid).get()).data() || {};
  const isBanned = previousPromo.banned === true;
  const sameRejectedImage = previousPromo.rejectedImageHash === imageHash;
  const token = crypto.randomUUID();
  const contentType = jpg ? 'image/jpeg' : 'image/png';
  await file.save(buffer, {resumable: false, metadata: {contentType,
    metadata: {firebaseStorageDownloadTokens: token}}, validation: 'md5'});
  const url = `https://firebasestorage.googleapis.com/v0/b/${encodeURIComponent(file.bucket.name)}/o/${encodeURIComponent(file.name)}?alt=media&token=${token}`;
  await userRef.update({creatorBannerUrl: url, creatorBannerUpdatedAt: FieldValue.serverTimestamp()});
  // 推薦候選清單以創作者 UID 為文件 ID；禁止推薦或同張違規圖不能靠重新上傳繞過。
  const creatorData = (await userRef.get()).data() || {};
  const nickname = String(creatorData.nickname || creatorData.displayName || '').trim();
  await promoRef(uid).set({creatorId:uid, creatorName:nickname, bannerImageUrl:url,
    imageHash, enabled:!isBanned && !sameRejectedImage, banned:isBanned,
    updatedAt:FieldValue.serverTimestamp()}, {merge:true});
  return {success:true, recommendationEnabled:!isBanned && !sameRejectedImage};
};




// 管理員專用：下架目前橫幅、永久取消推薦資格或恢復資格。
// 禁止由玩家端直接寫入管理欄位；通知與資料異動同一 batch 提交。
const manageCreatorPromotionHandler = async request => {
  const adminUid = requireRewardCampaignAdmin(request);
  const uid = String(request.data?.creatorId || '').trim();
  const action = String(request.data?.action || '').trim();
  const reason = String(request.data?.reason || '').trim();
  if (!/^[a-zA-Z0-9_-]{6,128}$/.test(uid)) throw new HttpsError('invalid-argument','創作者 UID 無效');
  if (!['remove','ban','restore'].includes(action)) throw new HttpsError('invalid-argument','操作無效');
  if (action !== 'restore' && (reason.length < 3 || reason.length > 500)) {
    throw new HttpsError('invalid-argument','請填寫 3～500 字的具體原因');
  }
  const ref = promoRef(uid);
  const snap = await ref.get();
  if (!snap.exists) throw new HttpsError('not-found','找不到推薦橫幅紀錄');
  const data = snap.data() || {};
  const creatorSnap = await db.collection('users').doc(uid).get();
  if (!creatorSnap.exists) throw new HttpsError('not-found','找不到創作者');
  if (action === 'remove' && data.banned === true) {
    throw new HttpsError('failed-precondition','此創作者已取消推薦資格');
  }
  if (action === 'restore' && !creatorFanMailVerified(creatorSnap.data() || {})) {
    throw new HttpsError('failed-precondition','創作者資格已失效');
  }
  const batch = db.batch();
  const change = {updatedAt:FieldValue.serverTimestamp(), reviewedAt:FieldValue.serverTimestamp(), reviewedBy:adminUid};
  if (action === 'remove') {
    change.enabled = false;
    change.rejectedImageHash = String(data.imageHash || '');
    change.violationCount = FieldValue.increment(1);
    change.lastReason = reason;
  } else if (action === 'ban') {
    change.enabled = false;
    change.banned = true;
    change.rejectedImageHash = String(data.imageHash || '');
    change.violationCount = FieldValue.increment(1);
    change.lastReason = reason;
  } else {
    change.banned = false;
    // 解除創作者資格限制不等於核准被下架的舊圖片。
    // 只有保留中的圖片從未被下架，才能恢復為推薦候選。
    const currentHash = String(data.imageHash || '').trim();
    const rejectedHash = String(data.rejectedImageHash || '').trim();
    const hasImage = !!String(data.bannerImageUrl || '').trim();
    change.enabled = hasImage && !!currentHash && currentHash !== rejectedHash;
    // 必須保留 rejectedImageHash，避免創作者重傳同一張違規圖繞過限制。
  }
  batch.update(ref, change);
  if (action !== 'restore') {
    const title = action === 'ban' ? '創作者推薦資格取消通知' : '創作者宣傳橫幅下架通知';
    const body = action === 'ban'
      ? `您的官方推薦曝光資格已被取消。\n原因：${reason}\n如需申訴，請透過創作者客服中心聯絡官方。`
      : `您目前的宣傳橫幅已從官方推薦頁下架。\n原因：${reason}\n請至「創作者工作室 → 橫幅管理」修改並上傳新圖片。重傳同一張圖片不會恢復推薦。如屢次不改善，官方可能取消推薦資格。`;
    const mailbox = db.collection('users').doc(uid).collection('mailbox').doc();
    batch.set(mailbox,{type:'creator_promo_notice', title, body, isRead:false,
      createdAt:FieldValue.serverTimestamp(), source:'creator_promotion', adminUid});
  }
  const history = ref.collection('moderation_logs').doc();
  batch.set(history,{action,reason:action === 'restore' ? '' : reason, adminUid,
    creatorId:uid, imageHash:String(data.imageHash || ''), createdAt:FieldValue.serverTimestamp()});
  await batch.commit();
  return {success:true,action};
};

return {removeCreatorFollowerHandler,updateCreatorPortfolioHandler,updateCreatorBannerHandler,manageCreatorPromotionHandler};
}
module.exports={createCreatorStudioHandlers};
