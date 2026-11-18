'use strict';

function createWorldLikeHandler({db, APP_ID, FieldValue, HttpsError}) {
  return async request => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', '請先登入');
    const worldId = String(request.data?.worldId || '').trim();
    const liked = request.data?.liked;
    if (!/^[\w-]{1,160}$/.test(worldId) || typeof liked !== 'boolean') {
      throw new HttpsError('invalid-argument', '世界編號或喜歡狀態不正確');
    }
    const root = db.collection('artifacts').doc(APP_ID);
    const publicRef = root.collection('public_worlds').doc(worldId);
    // Separate from public_worlds: worldPublish replaces the public projection.
    const statsRef = root.collection('world_engagement').doc(worldId);
    const likerRef = statsRef.collection('likers').doc(uid);
    const noticeRef = statsRef.collection('like_notifications_sent').doc(uid);
    const userRef = db.collection('users').doc(uid);
    const indexRef = userRef.collection('liked_works').doc(`world_${worldId}`);
    return db.runTransaction(async tx => {
      const [worldSnap, statsSnap, likerSnap, noticeSnap, userSnap, indexSnap] = await Promise.all(
        [publicRef, statsRef, likerRef, noticeRef, userRef, indexRef].map(ref => tx.get(ref)));
      const world = worldSnap.data() || {};
      const creatorId = String(world.createdBy || '').trim();
      if (liked) {
        if (!worldSnap.exists || world.isPublic !== true || world.status !== 'public' || world.publicPlayable !== true)
          throw new HttpsError('failed-precondition', '世界目前未公開');
        if (!creatorId || creatorId.includes('/') || creatorId === uid)
          throw new HttpsError('failed-precondition', '不能喜歡自己的世界');
      }
      const rawCount = statsSnap.data()?.likesCount;
      const oldCount = Number.isSafeInteger(rawCount) && rawCount >= 0 ? rawCount : 0;
      const count = Math.max(0, oldCount + (likerSnap.exists === liked ? 0 : liked ? 1 : -1));
      if (likerSnap.exists !== liked) {
        tx.set(statsRef, {likesCount: count}, {merge:true});
        if (liked) tx.set(likerRef, {timestamp: FieldValue.serverTimestamp()});
        else tx.delete(likerRef);
      }
      if (liked && !indexSnap.exists) tx.set(indexRef, {type:'world', worldId,
        likedAt: likerSnap.data()?.timestamp || FieldValue.serverTimestamp()});
      if (!liked && indexSnap.exists) tx.delete(indexRef);
      let notificationCreated = false;
      if (liked && !noticeSnap.exists) {
        tx.set(noticeRef, {firstLikedAt:FieldValue.serverTimestamp()});
        const user = userSnap.data() || {};
        const playerName = String(user.nickname || user.displayName || '玩家').trim() || '玩家';
        const emailRef = db.collection('users').doc(creatorId).collection('mailbox')
          .doc(`world_like_${worldId}_${uid}`);
        tx.set(emailRef, {type:'like', title:'開放世界收到喜歡',
          body:`${playerName} 喜歡了你的開放世界「${String(world.name || '開放世界')}」！`,
          fromUserId:uid, fromName:playerName, worldId, isRead:false, createdAt:FieldValue.serverTimestamp()});
        notificationCreated = true;
      }
      return {success:true, liked, likesCount:count, notificationCreated};
    });
  };
}

// Synchronize legacy direct writes as well as new callable writes; re-read the
// current relation inside a transaction so delayed/out-of-order events are safe.
async function syncCharacterLikeIndex({db, APP_ID, FieldValue, characterId, uid}) {
  const likerRef = db.collection('artifacts').doc(APP_ID).collection('public_characters')
    .doc(characterId).collection('likers').doc(uid);
  const indexRef = db.collection('users').doc(uid).collection('liked_works').doc(`character_${characterId}`);
  return db.runTransaction(async tx => {
    const [liker, index] = await Promise.all([tx.get(likerRef), tx.get(indexRef)]);
    if (!liker.exists) {
      if (index.exists) tx.delete(indexRef);
      return index.exists ? 'removed' : 'unchanged';
    }
    if (!index.exists) {
      tx.set(indexRef, {type:'character', characterId, likedAt:liker.data()?.timestamp || FieldValue.serverTimestamp()});
      return 'created';
    }
    return 'unchanged';
  });
}

module.exports = {createWorldLikeHandler, syncCharacterLikeIndex};
