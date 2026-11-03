'use strict';
// V89: original scoped character lookups, injected with the existing Firestore instance.
function createAutoReplyLookups({db}) {
                          async function loadAutoReplyCharacter(appId, characterId) {
                              const safeCharacterId = String(characterId || "").trim();
                              if (!safeCharacterId) return null;

                              const ref = db
                                  .collection("artifacts")
                                  .doc(appId)
                                  .collection("public_characters")
                                  .doc(safeCharacterId);

                              const snap = await ref.get();
                              if (!snap.exists) return null;

                              const data = snap.data() || {};
                              if (data.autoReplyEnabled !== true) return null;

                              return {
                                  id: snap.id,
                                  ref,
                                  data,
                              };
                          }

                          async function findNamedRecentCharacters({appId, userId, content}) {
                              const safeContent = String(content || "").trim();
                              if (!safeContent) return [];

                              const sessionsSnapshot = await db
                                  .collection("artifacts")
                                  .doc(appId)
                                  .collection("chat_sessions")
                                  .where("userId", "==", userId)
                                  .limit(40)
                                  .get();

                              const characterIds = Array.from(
                                  new Set(
                                      sessionsSnapshot.docs
                                          .map((doc) => String(doc.data()?.characterId || "").trim())
                                          .filter(Boolean)
                                  )
                              ).slice(0, 20);

                              const characterDocs = await Promise.all(
                                  characterIds.map((characterId) =>
                                      db
                                          .collection("artifacts")
                                          .doc(appId)
                                          .collection("public_characters")
                                          .doc(characterId)
                                          .get()
                                  )
                              );

                              return characterDocs
                                  .filter((snap) => snap.exists)
                                  .map((snap) => ({
                                      characterId: snap.id,
                                      name: String(snap.data()?.name || "").trim(),
                                  }))
                                  .filter((item) => item.name && safeContent.includes(item.name));
                          }

  return {loadAutoReplyCharacter, findNamedRecentCharacters};
}
module.exports = {createAutoReplyLookups};
