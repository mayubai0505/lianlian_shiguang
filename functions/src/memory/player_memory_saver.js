'use strict';
const {indexPayload} = require('./search_index');
// V83: original savePlayerMemoryIfNeeded body retained; dependencies are injected.
function createPlayerMemorySaver({extractPlayerMemory, canonicalizeMemoryFactKey, repairMemoryScope, APP_ID, resolveEffectivePlayerProfileId, db, normalizeMemoryFactValue, FieldValue}) {
async function savePlayerMemoryIfNeeded({
  chatMode = "",
  appId,
  userId,
  characterId,
  playerProfileId,
  sessionId,
  userMessage,
  playerName,
  recentHistory = [],
  assistantMessage = "",
  sourceMessageId = "",
  userMessageId = "",
  sourceTimestamp = null,
  sourceHashes = {},
  abortController,
}) {
  if (!userId || !characterId) {
    console.warn("⚠️ 缺少 userId 或 characterId，略過記憶提取");
    return null;
  }

  const extracted = await extractPlayerMemory({
    userMessage,
    playerName,
    chatMode,
    recentHistory, assistantMessage,
    abortController,
  });

  const items = Array.isArray(extracted.memories) ? extracted.memories.slice(0, 4) : [extracted];
  const results = [];
  for (const item of items) {
    const result = await persistMemory(item);
    if (result) results.push(result);
  }
  return results.length ? {...results[0], ids: results.map(item => item.id), savedCount: results.length} : null;

  async function persistMemory(extracted) {
  const sourceRole = extracted.sourceRole === 'assistant' ? 'assistant' : 'user';
  const evidenceText = String(extracted.evidence || '').trim();
  const evidenceSource = sourceRole === 'assistant' ? String(assistantMessage || '') : String(userMessage || '');
  // Old callers retain single-player extraction compatibility; contextual records require quoted evidence.
  const shortConfirmation = sourceRole === 'user' && /^(好|嗯|對|是|行)$/.test(evidenceText) && recentHistory.length > 0;
  if ((assistantMessage || recentHistory.length) &&
      ((!shortConfirmation && evidenceText.length < 2) || !evidenceSource.includes(evidenceText))) return null;
  const confidence = Number(extracted.confidence || 0);
  let memoryText = String(extracted.memory || "").trim();
  let memoryScope = String(extracted.scope || "none").trim().toLowerCase();
  const factKey = canonicalizeMemoryFactKey(extracted.factKey, {
    userMessage: evidenceText || userMessage,
    category: extracted.category,
  });
  const factValue = String(extracted.factValue || "").trim().slice(0, 240);

  memoryScope = repairMemoryScope({
    scope: memoryScope,
    shouldRemember: extracted.shouldRemember,
    factKey,
    userMessage: String(userMessage || evidenceText || ""),
  });
  if (sourceRole === "assistant") {
    if (!/^(worldline\.event\.|relationship\.event\.)/.test(factKey)) return null;
    memoryScope = "session";
  }
  if (/^(relationship\.|worldline\.|important_event\.)/.test(factKey)) memoryScope = "session";

  const safeMemoryName =
      String(playerName || "對方").trim() || "對方";

  memoryText = memoryText.replace(/^玩家/, safeMemoryName);

  if (!["profile", "character", "session"].includes(memoryScope)) {
    memoryScope = "none";
  }

  // 第一版先採較保守門檻，避免亂存
  if (
    extracted.shouldRemember !== true ||
    confidence < (["immersive", "resonance"].includes(chatMode) ? 0.68 : 0.75) ||
    memoryText.length < 4 ||
    memoryScope === "none" ||
    !factKey
  ) {
    console.log("🧠 本輪沒有需要保存的玩家記憶", {
      shouldRemember: extracted.shouldRemember,
      scope: memoryScope,
      factKey: factKey || null,
      confidence,
    });

    return null;
  }

  const safeSessionId = String(sessionId || "").trim();
  const safeAppId = String(appId || APP_ID).trim() || APP_ID;
  const safeProfileId = await resolveEffectivePlayerProfileId({
    appId: safeAppId,
    userId,
    characterId,
    sessionId: safeSessionId,
    requestedProfileId: playerProfileId,
  });

  let memoriesRef;

  if (memoryScope === "profile") {
    memoriesRef = db
      .collection("users")
      .doc(userId)
      .collection("profile_memories")
      .doc(safeProfileId)
      .collection("memories");
  } else if (memoryScope === "character") {
    memoriesRef = db
      .collection("users")
      .doc(userId)
      .collection("profile_memories")
      .doc(safeProfileId)
      .collection("characters")
      .doc(characterId)
      .collection("memories");
  } else if (memoryScope === "session") {
    if (!safeSessionId) {
      console.warn("⚠️ Session Memory 缺少 sessionId，為避免串世界線，本輪不保存");
      return null;
    }

    memoriesRef = db
      .collection("artifacts")
      .doc(safeAppId)
      .collection("chat_sessions")
      .doc(safeSessionId)
      .collection("memories");
  }

  if (!memoriesRef) return null;

  try {
    const crypto = require('crypto');
    const nowSource = sourceTimestamp || FieldValue.serverTimestamp();
    const chosenMessageId = sourceRole === 'user' ? userMessageId : sourceMessageId;
    const evidenceFields = {
      sourceRole, evidence: evidenceText,
      sourceMessageId: String(chosenMessageId || ''),
      sourceSessionId: safeSessionId,
      sourceAppId: safeAppId,
      sourceHash: String(sourceHashes[sourceRole] || ''),
      sourceTimestamp: nowSource,
    };
    const primaryRef = memoriesRef.doc('fact_' + crypto.createHash('sha256').update(factKey).digest('hex').slice(0, 40));
    const millis = value => typeof value?.toMillis === 'function' ? value.toMillis() :
      value instanceof Date ? value.getTime() : typeof value === 'number' ? value : 0;
    return await db.runTransaction(async transaction => {
      const exact = await transaction.get(memoriesRef.where('factKey', '==', factKey).limit(100));
      // Compatibility: include older free-key aliases in a recent bounded window.
      const recent = await transaction.get(memoriesRef.orderBy('timestamp', 'desc').limit(60));
      const primarySnapshot = await transaction.get(primaryRef);
      const byId = new Map([...exact.docs, ...recent.docs].map(doc => [doc.id, doc]));
      if (primarySnapshot.exists) byId.set(primarySnapshot.id, primarySnapshot);
      const conflicts = [...byId.values()].filter(doc => doc.data()?.active !== false &&
        canonicalizeMemoryFactKey(doc.data()?.factKey, {category: doc.data()?.category}) === factKey);
      const latest = conflicts.sort((a,b) => millis(b.data()?.sourceTimestamp || b.data()?.timestamp) - millis(a.data()?.sourceTimestamp || a.data()?.timestamp))[0];
      if (latest && millis(sourceTimestamp) && millis(latest.data()?.sourceTimestamp || latest.data()?.timestamp) > millis(sourceTimestamp)) return null;
      const old = latest?.data() || {};
      const same = latest && normalizeMemoryFactValue(old.factValue) === normalizeMemoryFactValue(factValue);
      transaction.set(primaryRef, {
        text: memoryText.slice(0, 900), scope: memoryScope,
        playerProfileId: safeProfileId || null, characterId, sessionId: safeSessionId || null,
        category: extracted.category || 'personal', factKey, factValue: factValue || null,
        confidence, source: 'auto', sourceMessage: String(userMessage || '').slice(0, 500),
        isFavorite: old.isFavorite === true, important: /^(relationship\.|worldline\.|important_event\.)/.test(factKey),
        active: true, ...evidenceFields,
        ...indexPayload({text:memoryText.slice(0,900), factKey, factValue, active:true}),
        supersedes: conflicts.filter(doc => doc.id !== primaryRef.id).map(doc => doc.id),
        timestamp: FieldValue.serverTimestamp(), updatedAt: FieldValue.serverTimestamp(),
      });
      for (const doc of conflicts) if(doc.id !== primaryRef.id) transaction.set(doc.ref, {
        active: false, retrievalTerms: [], searchIndexVersion: 1,
        supersededBy: primaryRef.id, supersededAt: FieldValue.serverTimestamp(),
      }, {merge:true});
      return {id: primaryRef.id, ...extracted, scope: memoryScope, refreshed: Boolean(same)};
    });

  } catch (error) {
    console.error("⚠️ 儲存玩家記憶失敗：", error);
    throw error;
  }
  }
}
return savePlayerMemoryIfNeeded;
}
module.exports = {createPlayerMemorySaver};
