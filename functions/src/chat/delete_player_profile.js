"use strict";

// Shared identity deletion: authenticated owner only, no message or memory deletion.
function createDeletePlayerProfileHandler({db, APP_ID, FieldValue, HttpsError}) {
  const idOf = v => String(v ?? '');
  const legacyIdentity = p => [['height','身高'], ['appearance','外貌'],
    ['occupation','職業'], ['intro','關於這個我']]
    .filter(([key]) => idOf(p?.[key]).trim())
    .map(([key,label]) => `${label}：${p[key]}`).join('\n').trim();
  return async request => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', '請先登入');
    const profileId = request.data?.profileId;
    if (typeof profileId !== 'string' || !profileId.trim() || profileId.length > 128 || profileId === 'default')
      throw new HttpsError('invalid-argument', '身分 ID 無效');
    const userRef = db.collection('users').doc(uid);
    const root = db.collection('artifacts').doc(APP_ID);
    return db.runTransaction(async tx => {
      const user = await tx.get(userRef);
      if (!user.exists) throw new HttpsError('not-found', '找不到玩家資料');
      const data = user.data() || {};
      if (!Array.isArray(data.profiles)) throw new HttpsError('failed-precondition', '身分清單異常');
      const target = data.profiles.find(p => idOf(p?.id) === profileId);
      const profiles = data.profiles.filter(p => idOf(p?.id) !== profileId);
      const originalRooms = data.roomProfiles && typeof data.roomProfiles === 'object' && !Array.isArray(data.roomProfiles) ? data.roomProfiles : {};
      const rooms = Object.fromEntries(Object.entries(originalRooms).map(([k,v]) => [k,idOf(v) === profileId ? 'default' : v]));
      // Queries restricted to the authenticated owner. All reads precede writes.
      const [normal, worlds] = await Promise.all([
        tx.get(root.collection('chat_sessions').where('userId','==',uid)),
        tx.get(root.collection('world_chat_sessions').where('userId','==',uid)),
      ]);
      const changes = [];
      for (const doc of normal.docs) {
        if (idOf(doc.data()?.playerProfileId) === profileId) {
          changes.push([doc.ref,{playerProfileId:'default'}]);
          if (!Object.hasOwn(rooms,doc.id)) rooms[doc.id] = 'default';
        }
      }
      let ambiguousLegacyRooms = 0;
      for (const doc of worlds.docs) {
        const room = doc.data() || {};
        const saved = room.playerWorldProfile || {};
        const key = `world_${idOf(room.worldId)}`;
        const matches = p => idOf(saved.nickname).trim() === idOf(p?.name).trim() && idOf(saved.identity).trim() === legacyIdentity(p);
        const legacyCandidate = !saved.profileId && target && (saved.nickname || saved.identity) && matches(target);
        // Legacy snapshots have no ID. Only clear a uniquely matching selected identity.
        const legacyMatch = legacyCandidate && idOf(originalRooms[key]) === profileId && !profiles.some(matches);
        if (legacyCandidate && !legacyMatch) ambiguousLegacyRooms++;
        if (idOf(saved.profileId) === profileId || legacyMatch) {
          changes.push([doc.ref,{playerWorldProfile:FieldValue.delete(),profileUpdatedAt:FieldValue.serverTimestamp()}]);
          if (!Object.hasOwn(rooms,key)) rooms[key] = 'default';
        }
      }
      // Avoid partial deletion if the single atomic transaction is too large.
      if (changes.length > 499) throw new HttpsError('resource-exhausted','套用房間過多，請聯絡客服');
      tx.update(userRef, {profiles,roomProfiles:rooms,
        ...(idOf(data.activeProfileId) === profileId ? {activeProfileId:FieldValue.delete()} : {})});
      for (const [ref, patch] of changes) tx.update(ref,patch);
      return {ok:true, profiles, roomProfiles:rooms, clearedRooms:changes.length, ambiguousLegacyRooms};
    });
  };
}
module.exports = {createDeletePlayerProfileHandler};
