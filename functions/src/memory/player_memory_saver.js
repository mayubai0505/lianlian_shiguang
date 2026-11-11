'use strict';
const {isDefaultProfile, defaultCharacterMemories, prepareDefaultCharacterMemory} = require('./default_character');
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
  playerLanguage = "",
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

  // V5.15: Resolve the profile BEFORE extraction. Never let the model or an
  // account nickname replace the selected custom-profile identity.
  const safeAppId = String(appId || APP_ID).trim() || APP_ID;
  const safeSessionId = String(sessionId || '').trim();
  const safeProfileId = await resolveEffectivePlayerProfileId({
    appId: safeAppId, userId, characterId, sessionId: safeSessionId,
    requestedProfileId: playerProfileId,
  });
  const ownerSnapshot = await db.collection('users').doc(userId).get();
  const ownerData = ownerSnapshot.data() || {};
  const knownProfiles = Array.isArray(ownerData.profiles) ? ownerData.profiles : [];
  const boundProfile = knownProfiles.find(item => item &&
    String(item.id || '').trim() === String(safeProfileId || '').trim());
  const boundName = String(boundProfile?.name || '').trim();
  const isDefault = isDefaultProfile(safeProfileId);
  const canonicalPlayerName = isDefault
    ? String(ownerData.nickname || playerName || '').trim()
    : boundName;
  if (!canonicalPlayerName || (!isDefault && !boundProfile)) {
    console.warn('MEMORY_PROFILE_NAME_UNRESOLVED_SKIP', {
      profileId: safeProfileId, sessionId: safeSessionId,
      defaultProfile: isDefault,
    });
    return null; // Never write a memory under an unverified custom-profile name.
  }

  const extracted = await extractPlayerMemory({
    userMessage,
    playerName: canonicalPlayerName,
    playerLanguage,
    chatMode,
    recentHistory, assistantMessage,
    abortController,
  });

  const items = Array.isArray(extracted.memories) ? extracted.memories.slice(0, 4) : [extracted];
  // A narrow, deterministic fallback for a plainly stated drink preference.
  // It never reads assistantMessage or infers a preference from character dialogue.
  const message = String(userMessage || '').trim();
  const drinkMatch = message.match(/(?:^|[\s（(，。！!\n])我(?:很|非常|超級|超|最)?喜歡喝(?:的)?[：: ]*([^，。！!？?；;\n）)\r]{1,32})/u);
  if (drinkMatch && !items.some(item => item && item.shouldRemember === true &&
      String(item.factKey || '').startsWith('preference.drink.'))) {
    const drink = drinkMatch[1].trim().replace(/(?:喔|啦|呀|啊|欸)$/u, '').trim();
    if (drink && !/^(?:什麼|什么|這個|那个|那個|飲料|饮料)$/u.test(drink)) {
      const evidence = drinkMatch[0].trim().replace(/^[（(，。！!\s]+/u, '');
      items.push({
        shouldRemember: true, memory: `喜歡喝${drink}`,
        scope: 'profile', category: 'preference',
        factKey: 'preference.drink.' +
          require('crypto').createHash('sha256').update(drink).digest('hex').slice(0, 12),
        factValue: `喜歡喝${drink}`, confidence: 0.99,
        sourceRole: 'user', evidence,
      });
      console.log('MEMORY_EXPLICIT_DRINK_PREFERENCE_FALLBACK', {
        sessionId: safeSessionId, profileId: safeProfileId,
      });
    }
  }
  const results = [];
  for (const item of (items.length > 4 ? [...items.slice(0, 3), items[items.length - 1]] : items)) {
    const result = await persistMemory(item);
    if (result) results.push(result);
  }
  return results.length ? {
    ...results[0],
    ids: results.map(item => item.id),
    savedCount: results.length,
    scopes: results.map(item => item.scope),
    paths: results.map(item => item.path),
    resolvedProfileId: results[0].resolvedProfileId,
  } : null;

  async function persistMemory(extracted) {
  // Player-facing memory must be anchored in this user's own message.
  if (extracted.sourceRole === 'assistant') return null;
  const sourceRole = 'user';
  const evidenceText = String(extracted.evidence || '').trim();
  const evidenceSource = String(userMessage || '');
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
  if (/^(relationship\.|worldline\.|important_event\.)/.test(factKey)) memoryScope = "session";

  // Display names come from Firestore's selected profile, never AI output.
  // Reject unexplained third-person names instead of silently changing a fact.
  const safeMemoryName = canonicalPlayerName;
  memoryText = memoryText.replace(/^(?:玩家|對方|我)(?=的|是|在|會|要|有|喜歡|不|早|晚|每|今|明|後|已|正|，|：|\s)/u, '').trim();
  if (!memoryText.startsWith(safeMemoryName)) {
    // A fabricated subject like 「妮妮喜歡...」 must not be saved as personal truth.
    if (/^[\p{Script=Han}]{2,8}(?=喜歡|討厭|不喜歡|承諾|認為|知道|需要|想要|打算|會去|要去|早上|下午|晚上|今天|明天|昨天|每週|每周)/u.test(memoryText)) {
      console.warn('MEMORY_SUBJECT_MISMATCH_REJECTED', {
        profileId: safeProfileId, factKey,
      });
      return null;
    }
    memoryText = /^(?:喜歡|討厭|不喜歡|不喝|不吃|會|要|在|有|早上|下午|晚上|今天|明天|每週|每周)/u.test(memoryText)
      ? `${safeMemoryName}${memoryText}`
      : `${safeMemoryName}：${memoryText}`;
  }

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


  await prepareDefaultCharacterMemory({db, userId, characterId, playerProfileId:safeProfileId});
  let memoriesRef;
  if (isDefaultProfile(safeProfileId) && memoryScope !== "session") {
    memoryScope = "character";
    memoriesRef = defaultCharacterMemories(db, userId, characterId);
  }


  if (memoriesRef) {
    // Default records use the character collection selected above.
  } else if (memoryScope === "profile") {
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
      return {
        id: primaryRef.id, ...extracted, scope: memoryScope,
        resolvedProfileId: safeProfileId,
        path: primaryRef.path,
        refreshed: Boolean(same),
      };
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
