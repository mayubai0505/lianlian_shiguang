'use strict';
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
    abortController,
  });

  const confidence = Number(extracted.confidence || 0);
  let memoryText = String(extracted.memory || "").trim();
  let memoryScope = String(extracted.scope || "none").trim().toLowerCase();
  const factKey = canonicalizeMemoryFactKey(extracted.factKey, {
    userMessage,
    category: extracted.category,
  });
  const factValue = String(extracted.factValue || "").trim().slice(0, 240);

  memoryScope = repairMemoryScope({
    scope: memoryScope,
    shouldRemember: extracted.shouldRemember,
    factKey,
    userMessage,
  });

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
    const recentSnapshot = await memoriesRef
      .orderBy("timestamp", "desc")
      .limit(30)
      .get();

    const normalizedNewMemory = memoryText
      .replace(/[，。！？、\s]/g, "")
      .toLowerCase();

    const activeDocs = recentSnapshot.docs.filter(
      (doc) => doc.data()?.active !== false
    );

    const alreadyExists = activeDocs.some((doc) => {
      const oldData = doc.data() || {};
      const oldText = String(oldData.text || "")
        .replace(/[，。！？、\s]/g, "")
        .toLowerCase();

      if (oldText === normalizedNewMemory) return true;

      const oldFactKey = canonicalizeMemoryFactKey(oldData.factKey, {
        userMessage: oldData.sourceMessage || "",
        category: oldData.category,
      });
      const oldFactValue = normalizeMemoryFactValue(oldData.factValue);
      const newFactValue = normalizeMemoryFactValue(factValue);

      return Boolean(
        factKey &&
        oldFactKey === factKey &&
        newFactValue &&
        oldFactValue === newFactValue
      );
    });

    if (alreadyExists) {
      console.log("🧠 相同記憶已存在，略過新增：", {
        factKey: factKey || null,
        text: memoryText,
      });
      return null;
    }

    const conflictingDocs = factKey
      ? activeDocs.filter(
          (doc) =>
            canonicalizeMemoryFactKey(doc.data()?.factKey, {
              userMessage: doc.data()?.sourceMessage || "",
              category: doc.data()?.category,
            }) === factKey
        )
      : [];

    const memoryRef = memoriesRef.doc();
    const batch = db.batch();

    batch.set(memoryRef, {
      text: memoryText,
      scope: memoryScope,
      playerProfileId: safeProfileId || null,
      characterId,
      sessionId: safeSessionId || null,
      category: extracted.category || "personal",
      factKey: factKey || null,
      factValue: factValue || null,
      confidence,
      source: "auto",
      sourceMessage: String(userMessage || "").trim().slice(0, 500),
      isFavorite: false,
      active: true,
      supersedes:
        conflictingDocs.length > 0
          ? conflictingDocs.map((doc) => doc.id)
          : [],
      timestamp: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });

    for (const oldDoc of conflictingDocs) {
      batch.set(
        oldDoc.ref,
        {
          active: false,
          supersededBy: memoryRef.id,
          supersededAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),
        },
        {merge: true}
      );
    }

    await batch.commit();

    console.log("✅ 已自動保存玩家記憶：", {
      id: memoryRef.id,
      scope: memoryScope,
      playerProfileId: safeProfileId || null,
      factKey: factKey || null,
      supersededCount: conflictingDocs.length,
      text: memoryText,
      category: extracted.category,
      confidence,
    });

    return {
      id: memoryRef.id,
      ...extracted,
      scope: memoryScope,
    };
  } catch (error) {
    console.error("⚠️ 儲存玩家記憶失敗：", error);
    return null;
  }
}
return savePlayerMemoryIfNeeded;
}
module.exports = {createPlayerMemorySaver};
