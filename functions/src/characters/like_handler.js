"use strict";

// 同一玩家可以重複喜歡／取消喜歡；通知採永久寫入的獨立去重標記。
// 所有改動在同一 Firestore transaction 內完成，不能透過重複送出多領讚數。
function createCharacterLikeHandler({db, APP_ID, FieldValue, HttpsError}) {
  return async function setCharacterLike(request) {
    const userId = request.auth?.uid;
    if (!userId) throw new HttpsError('unauthenticated', '請先登入');

    const characterId = String(request.data?.characterId || '').trim();
    const desiredLike = request.data?.liked;
    if (!characterId || characterId.includes('/') || characterId.length > 200 ||
        typeof desiredLike !== 'boolean') {
      throw new HttpsError('invalid-argument', '角色編號或喜歡狀態不正確');
    }

    const charRef = db.collection('artifacts').doc(APP_ID)
      .collection('public_characters').doc(characterId);
    const likerRef = charRef.collection('likers').doc(userId);
    // 與按讚關係分開，取消喜歡不刪除，永久記住是否曾經通知。
    const notifiedRef = charRef.collection('like_notifications_sent').doc(userId);
    const userRef = db.collection('users').doc(userId);

    const result = await db.runTransaction(async (tx) => {
      // 所有讀取都先完成，再進行任何寫入。
      const [charSnap, likerSnap, notifiedSnap, userSnap] = await Promise.all([
        tx.get(charRef), tx.get(likerRef), tx.get(notifiedRef), tx.get(userRef),
      ]);
      if (!charSnap.exists) throw new HttpsError('not-found', '找不到角色');
      const character = charSnap.data() || {};
      const creatorId = String(character.createdBy || '').trim();
      if (!creatorId || creatorId.includes('/')) {
        throw new HttpsError('failed-precondition', '角色缺少創作者資料');
      }
      if (creatorId === userId) throw new HttpsError('failed-precondition', '不能喜歡自己的角色');
      if (character.isPublic !== true || character.status !== 'published') {
        throw new HttpsError('failed-precondition', '角色目前未公開');
      }

      const notificationRef = db.collection('users').doc(creatorId)
        .collection('mailbox').doc(`character_like_${characterId}_${userId}`);
      // 相容舊版已寄出的通知：不因升級而重新寄一次。
      const oldNotificationSnap = desiredLike && !notifiedSnap.exists
        ? await tx.get(notificationRef) : null;

      const currentlyLiked = likerSnap.exists;
      let notificationCreated = false;
      if (currentlyLiked !== desiredLike) {
        tx.update(charRef, {likesCount: FieldValue.increment(desiredLike ? 1 : -1)});
        if (desiredLike) {
          tx.set(likerRef, {timestamp: FieldValue.serverTimestamp()});
        } else {
          tx.delete(likerRef);
        }
      }

      if (desiredLike && !notifiedSnap.exists) {
        tx.set(notifiedRef, {
          userId, characterId, creatorId, firstLikedAt: FieldValue.serverTimestamp(),
        });
        if (!oldNotificationSnap?.exists) {
          const player = userSnap.data() || {};
          const name = String(player.nickname || player.displayName || '玩家').trim() || '玩家';
          tx.set(notificationRef, {
            type: 'like',
            title: '角色收到喜歡',
            body: `${name} 喜歡了你的角色「${String(character.name || '角色')}」！`,
            fromUserId: userId,
            fromName: name,
            characterId,
            isRead: false,
            createdAt: FieldValue.serverTimestamp(),
          });
          notificationCreated = true;
        }
      }
      return {liked: desiredLike, notificationCreated};
    });
    return {success: true, ...result};
  };
}

module.exports = {createCharacterLikeHandler};
