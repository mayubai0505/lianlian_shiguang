'use strict';
const isDefaultProfile = value => !String(value || '').trim() || String(value).trim() === 'default';
function defaultCharacterMemories(db, userId, characterId) {
  return db.collection('users').doc(userId).collection('characters').doc(String(characterId)).collection('memories');
}
// Only migrate records attributable to this character. Keep an archived source
// receipt so deleting the destination in the App cannot resurrect the memory.
async function prepareDefaultCharacterMemory({db, userId, characterId, playerProfileId}) {
  if (!isDefaultProfile(playerProfileId)) return;
  const profile = db.collection('users').doc(userId).collection('profile_memories').doc('default');
  const destination = defaultCharacterMemories(db, userId, characterId);
  const sources = [
    profile.collection('memories').where('characterId', '==', String(characterId)),
    profile.collection('characters').doc(String(characterId)).collection('memories'),
  ];
  const millis = value => typeof value?.toMillis === 'function' ? value.toMillis() : value instanceof Date ? value.getTime() : 0;
  for (const source of sources) {
    // A bounded batch per request; remaining records migrate on subsequent chats.
    const page = await source.where('active', '==', true).limit(100).get();
    for (const item of page.docs) {
      await db.runTransaction(async tx => {
        const fresh = await tx.get(item.ref);
        const data = fresh.data() || {};
        if (!fresh.exists || data.active !== true || data.migratedTo) return;
        if (data.characterId && String(data.characterId) !== String(characterId)) return;
        const target = destination.doc(item.id);
        const existing = await tx.get(target);
        const old = existing.data() || {};
        if (!existing.exists || millis(data.sourceTimestamp || data.timestamp) > millis(old.sourceTimestamp || old.timestamp)) {
          tx.set(target, {...data, scope:'character', playerProfileId:'default', characterId:String(characterId)});
        }
        tx.set(item.ref, {active:false, retrievalTerms:[], migratedTo:target.path}, {merge:true});
      });
    }
  }
}
module.exports = {isDefaultProfile, defaultCharacterMemories, prepareDefaultCharacterMemory};
