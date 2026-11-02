'use strict';
// V65: Original creator-to-fan flower gifting logic, moved without altering transactions.
function createCreatorFlowerGiftHandlers(deps) {
  const {db, HttpsError, FieldPath, FieldValue, crypto, onCall, REGION, creatorFanMailVerified, creatorFanMailCharCount} = deps;
  const handlers = {};
// ============================================================
// 官方合作創作者 v1.4：以創作者自己的花花贈送目前追蹤的粉絲
// 1~20 位，每人 1~1000 朵、單筆最多 5000 朵。
// 全程 Firestore transaction；requestId 固定，重試不重扣。
// ============================================================
const CREATOR_GIFT_MAX_RECIPIENTS = 20;
const CREATOR_GIFT_MAX_PER_FAN = 1000;
const CREATOR_GIFT_MAX_TOTAL = 5000;

// 創作者送花收件人搜尋：以追蹤關係文件 ID 游標分頁，
// 伺服器分批取得真實玩家暱稱。無全量資料下載至手機。
// Firestore 不支援跨 followers/users join；暱稱包含搜尋會逐批掃描，
// 因此搜尋結果以「繼續搜尋」載入後續批次，不能視為一次查完全部粉絲。
handlers.searchCreatorGiftFollowers = onCall({region: REGION, timeoutSeconds: 60, maxInstances: 15}, async (request) => {
  const creatorUid = request.auth?.uid;
  if (!creatorUid) throw new HttpsError('unauthenticated', '請先登入');
  const data = request.data || {};
  const keyword = String(data.keyword || '').trim().toLocaleLowerCase('zh-Hant');
  if (keyword.length > 80) throw new HttpsError('invalid-argument', '搜尋文字過長');
  const pageSize = Number(data.pageSize || 20);
  if (!Number.isSafeInteger(pageSize) || pageSize < 1 || pageSize > 30) {
    throw new HttpsError('invalid-argument', '每頁筆數不正確');
  }
  const cursor = data.cursor == null ? '' : String(data.cursor);
  if (cursor && (cursor.length > 128 || cursor.includes('/'))) {
    throw new HttpsError('invalid-argument', '分頁游標無效');
  }
  const creatorSnap = await db.collection('users').doc(creatorUid).get();
  if (!creatorSnap.exists || !creatorFanMailVerified(creatorSnap.data() || {})) {
    throw new HttpsError('permission-denied', '目前沒有合作創作者資格');
  }
  const followers = db.collection('users').doc(creatorUid).collection('followers');
  const scanLimit = keyword ? 150 : pageSize;
  let query = followers.orderBy(FieldPath.documentId()).limit(scanLimit + 1);
  if (cursor) query = query.startAfter(cursor);
  const snapshot = await query.get();
  const scannedDocs = snapshot.docs.slice(0, scanLimit);
  const hasMore = snapshot.docs.length > scanLimit;
  const items = [];
  let lastProcessedId = null;
  let processedCount = 0;
  // 取得滿 pageSize 位符合者就停止；下一次從最後處理的 UID 接續。
  for (let i = 0; i < scannedDocs.length && items.length < pageSize; i += 30) {
    const batch = scannedDocs.slice(i, i + Math.min(30, pageSize - items.length));
    const profiles = await db.getAll(...batch.map(doc => db.collection('users').doc(doc.id)));
    for (let j = 0; j < batch.length; j++) {
      lastProcessedId = batch[j].id;
      processedCount++;
      const u = profiles[j];
      if (!u.exists) continue;
      const profile = u.data() || {};
      const name = String(profile.nickname || profile.displayName || profile.name || '').trim() || '未設定暱稱的玩家';
      const avatar = String(profile.avatarPath || profile.photoURL || profile.photoUrl || profile.avatarUrl || '').trim();
      const uid = batch[j].id;
      if (!keyword || name.toLocaleLowerCase('zh-Hant').includes(keyword) || uid.toLowerCase().includes(keyword)) {
        items.push({uid, name: name.slice(0, 120), avatar: avatar.slice(0, 2048)});
      }
    }
  }
  const more = !!lastProcessedId && (hasMore || processedCount < scannedDocs.length);
  return {
    items,
    nextCursor: more ? lastProcessedId : null,
    scanned: processedCount,
  };
});

handlers.giftCreatorFlowers = onCall({region: REGION, timeoutSeconds: 60, maxInstances: 15}, async (request) => {
  const creatorUid = request.auth?.uid;
  if (!creatorUid) throw new HttpsError('unauthenticated', '請先登入');
  const input = request.data || {};
  const requestId = String(input.requestId || '').trim();
  const amount = input.amount;
  const note = String(input.note || '').trim();
  const recipients = input.recipientUids;
  if (!/^[a-zA-Z0-9_-]{12,80}$/.test(requestId)) throw new HttpsError('invalid-argument', '交易識別碼無效');
  if (!Array.isArray(recipients) || recipients.length < 1 || recipients.length > CREATOR_GIFT_MAX_RECIPIENTS ||
      !recipients.every(x => typeof x === 'string' && x.length > 0 && x.length <= 128 && !x.includes('/'))) {
    throw new HttpsError('invalid-argument', '請選擇 1～20 位有效粉絲');
  }
  if (new Set(recipients).size !== recipients.length || recipients.includes(creatorUid)) {
    throw new HttpsError('invalid-argument', '粉絲名單重複或包含自己');
  }
  if (!Number.isSafeInteger(amount) || amount < 1 || amount > CREATOR_GIFT_MAX_PER_FAN) {
    throw new HttpsError('invalid-argument', '每位粉絲花花須為 1～1000 朵');
  }
  const total = amount * recipients.length;
  if (total > CREATOR_GIFT_MAX_TOTAL) throw new HttpsError('invalid-argument', '單次最多可贈送 5000 朵花花');
  if (creatorFanMailCharCount(note) > 300) throw new HttpsError('invalid-argument', '祝福文字最多 300 字');

  const normalizedRecipients = [...recipients].sort();
  const contentHash = crypto.createHash('sha256').update(JSON.stringify({normalizedRecipients, amount, note})).digest('hex');
  const creatorRef = db.collection('users').doc(creatorUid);
  const giftRef = db.collection('creator_flower_gifts').doc(`${creatorUid}_${requestId}`);
  const userRefs = normalizedRecipients.map(uid => db.collection('users').doc(uid));
  const followerRefs = normalizedRecipients.map(uid => creatorRef.collection('followers').doc(uid));
  const result = await db.runTransaction(async tx => {
    // 交易內先讀所有文件，再做任何寫入。
    const snapshots = await Promise.all([
      tx.get(creatorRef), tx.get(giftRef),
      ...followerRefs.map(ref => tx.get(ref)),
      ...userRefs.map(ref => tx.get(ref)),
    ]);
    const creatorSnap = snapshots[0];
    const existing = snapshots[1];
    if (existing.exists) {
      const prior = existing.data() || {};
      if (prior.contentHash !== contentHash) throw new HttpsError('already-exists', '這個交易識別碼已用於另一筆贈送');
      return {success:true, alreadySubmitted:true, giftId:giftRef.id, total:Number(prior.total||total), recipientCount:recipients.length};
    }
    if (!creatorSnap.exists || !creatorFanMailVerified(creatorSnap.data() || {})) {
      throw new HttpsError('permission-denied', '目前沒有官方合作創作者資格');
    }
    const creatorData = creatorSnap.data() || {};
    const balance = Number(creatorData.flowerPoints);
    if (!Number.isSafeInteger(balance) || balance < 0) throw new HttpsError('failed-precondition', '花花餘額資料異常');
    if (balance < total) throw new HttpsError('failed-precondition', '花花餘額不足', {
      reason: 'insufficient_balance', balance, required:total, shortage:total - balance,
    });
    const followerSnapshots = snapshots.slice(2, 2 + recipients.length);
    const receiverSnapshots = snapshots.slice(2 + recipients.length);
    if (followerSnapshots.some(s => !s.exists) || receiverSnapshots.some(s => !s.exists)) {
      throw new HttpsError('failed-precondition', '粉絲名單已變更，請重新選擇');
    }
    const displayName = String(creatorData.nickname || creatorData.displayName || '合作創作者').slice(0, 80);
    tx.update(creatorRef, {flowerPoints: FieldValue.increment(-total)});
    const timestamp = FieldValue.serverTimestamp();
    tx.create(giftRef, {creatorUid, recipientUids:normalizedRecipients, amountPerRecipient:amount,
      total, note, creatorName:displayName, contentHash, status:'pending_claim', claimMode:'mailbox', createdAt:timestamp});
    tx.create(creatorRef.collection('flower_logs').doc(`creator_gift_out_${requestId}`), {
      type:'creator_gift_out', title:'贈送粉絲花花', amount:-total, recipientCount:recipients.length,
      giftId:giftRef.id, createdAt:timestamp,
    });
    for (let i=0; i<userRefs.length; i++) {
      const receiverUid = normalizedRecipients[i];
      const receiverRef = userRefs[i];
      tx.create(receiverRef.collection('mailbox').doc(`creator_gift_${giftRef.id}`), {
        type:'creator_flower_gift', title:`${displayName} 贈送了 ${amount} 朵花花`,
        body: note ? `妳有 ${amount} 朵花花待領取，請開啟信件領取。\n\n${note}` : `妳有 ${amount} 朵花花待領取，請開啟信件領取。`,
        creatorUid, creatorName:displayName, flowerAmount:amount, giftId:giftRef.id,
        claimStatus:'pending', claimed:false,
        isRead:false, read:false, createdAt:timestamp,
      });
    }
    return {success:true, alreadySubmitted:false, giftId:giftRef.id, total, recipientCount:recipients.length};
  });
  return result;
});


// 玩家從自己的信箱手動領取創作者贈送的花花；單一信件交易保證不可重領。
// 2026-10-19 之前已直接入帳的舊信件不含 claimStatus=pending，因此不允許再領。
handlers.claimCreatorFlowerGift = onCall({region: REGION, timeoutSeconds: 30}, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', '請先登入');
  const giftId = String(request.data?.giftId || '').trim();
  if (!/^[a-zA-Z0-9_-]{12,200}$/.test(giftId)) throw new HttpsError('invalid-argument', '禮物識別碼無效');
  const receiverRef = db.collection('users').doc(uid);
  const mailRef = receiverRef.collection('mailbox').doc(`creator_gift_${giftId}`);
  const giftRef = db.collection('creator_flower_gifts').doc(giftId);
  const logRef = receiverRef.collection('flower_logs').doc(`creator_gift_in_${giftId}`);
  return await db.runTransaction(async tx => {
    const [mailSnap, giftSnap, receiverSnap] = await Promise.all([
      tx.get(mailRef), tx.get(giftRef), tx.get(receiverRef),
    ]);
    if (!mailSnap.exists || !giftSnap.exists || !receiverSnap.exists) {
      throw new HttpsError('not-found', '找不到可領取的花花');
    }
    const mail = mailSnap.data() || {};
    const gift = giftSnap.data() || {};
    if (mail.type !== 'creator_flower_gift' || mail.giftId !== giftId ||
        gift.claimMode !== 'mailbox' || gift.status !== 'pending_claim' ||
        !Array.isArray(gift.recipientUids) || !gift.recipientUids.includes(uid) ||
        Number(mail.flowerAmount) !== Number(gift.amountPerRecipient)) {
      throw new HttpsError('failed-precondition', '此信件不屬於可領取的花花禮物');
    }
    if (mail.claimStatus === 'claimed' || mail.claimed === true) {
      return {success:true, alreadyClaimed:true, amount:Number(mail.flowerAmount)};
    }
    if (mail.claimStatus !== 'pending') {
      throw new HttpsError('failed-precondition', '此禮物不可領取');
    }
    const amount = Number(mail.flowerAmount);
    if (!Number.isSafeInteger(amount) || amount < 1 || amount > CREATOR_GIFT_MAX_PER_FAN) {
      throw new HttpsError('failed-precondition', '花花數量異常');
    }
    tx.update(receiverRef, {flowerPoints:FieldValue.increment(amount)});
    tx.update(mailRef, {claimStatus:'claimed', claimed:true, claimedAt:FieldValue.serverTimestamp()});
    tx.create(logRef, {
      type:'creator_gift_in', title:'合作創作者贈送', amount,
      creatorUid:gift.creatorUid, creatorName:gift.creatorName,
      giftId, createdAt:FieldValue.serverTimestamp(),
    });
    return {success:true, alreadyClaimed:false, amount};
  });
});



  return handlers;
}
module.exports = {createCreatorFlowerGiftHandlers};
