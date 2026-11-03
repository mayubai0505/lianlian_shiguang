'use strict';

// Build per-call memory using the originating chat room only.
// Business rules and existing prompt text are intentionally unchanged.
function createCallScopedMemoryContext({db, APP_ID, resolveEffectivePlayerProfileId, resolvePlayerIdentityFromUserData, loadScopedMemoryEntries}) {
async function buildCallScopedMemoryContext({
    userId,
    sessionId,
    characterId,
    memoryScopeVersion = 0,
}) {
    if (Number(memoryScopeVersion || 0) < 1) {
        return "";
    }

    const safeUserId = String(userId || "").trim();
    const safeSessionId = String(sessionId || "").trim();
    const requestedCharacterId = String(characterId || "").trim();

    if (!safeUserId || !safeSessionId) {
        return "";
    }

    const roomSnapshot = await db
        .collection("artifacts")
        .doc(APP_ID)
        .collection("chat_sessions")
        .doc(safeSessionId)
        .get();

    if (!roomSnapshot.exists) {
        console.warn("📞 找不到通話來源聊天室，略過三層記憶：", {
            userId: safeUserId,
            sessionId: safeSessionId,
        });
        return "";
    }

    const roomData = roomSnapshot.data() || {};
    const roomOwner = String(roomData.userId || "").trim();
    const roomCharacterId = String(roomData.characterId || "").trim();

    if (roomOwner !== safeUserId) {
        const error = new Error("CALL_ROOM_FORBIDDEN");
        error.code = "CALL_ROOM_FORBIDDEN";
        throw error;
    }

    if (
        requestedCharacterId &&
        roomCharacterId &&
        requestedCharacterId !== roomCharacterId
    ) {
        const error = new Error("CALL_CHARACTER_MISMATCH");
        error.code = "CALL_CHARACTER_MISMATCH";
        throw error;
    }

    const effectiveCharacterId =
        roomCharacterId || requestedCharacterId;

    if (!effectiveCharacterId) {
        return "";
    }

    const userSnapshot = await db
        .collection("users")
        .doc(safeUserId)
        .get();

    const userData = userSnapshot.data() || {};

    const effectiveProfileId =
        await resolveEffectivePlayerProfileId({
            appId: APP_ID,
            userId: safeUserId,
            characterId: effectiveCharacterId,
            sessionId: safeSessionId,
            requestedProfileId:
                String(roomData.playerProfileId || "").trim(),
            userData,
        });

    const identity =
        resolvePlayerIdentityFromUserData(
            userData,
            effectiveProfileId
        );

    const entries =
        await loadScopedMemoryEntries({
            appId: APP_ID,
            userId: safeUserId,
            characterId: effectiveCharacterId,
            playerProfileId: effectiveProfileId,
            sessionId: safeSessionId,
            perScopeLimit: 8,
        });

    const identityLines = [
        `目前玩家檔案：${identity.name || "你"}`,
        identity.gender && identity.gender !== "未設定"
            ? `玩家性別設定：${identity.gender}`
            : "",
        identity.birthday && identity.birthday !== "未設定"
            ? `玩家生日設定：${identity.birthday}`
            : "",
    ].filter(Boolean);

    const memoryLines = entries
        .slice(0, 18)
        .map((entry, index) => {
            const scopeLabel =
                entry.scope === "session"
                    ? "本聊天室"
                    : entry.scope === "character"
                    ? "你們之間"
                    : "玩家檔案";

            return `${index + 1}. [${scopeLabel}] ${entry.content}`;
        });

    if (memoryLines.length === 0 && identityLines.length === 0) {
        return "";
    }

    return `
【本次電話綁定的玩家檔案與聊天室記憶｜既定事實】
${identityLines.join("\n")}
${memoryLines.join("\n")}

【通話記憶規則】
- 這通電話屬於 sessionId=${safeSessionId} 的同一條世界線。
- 本聊天室(Session)事實優先於角色共用(Character)，角色共用再優先於玩家檔案(Profile)。
- 不得自行引用其他聊天室的世界線、身份、關係或稱呼。
- 若近期通話 history 與長期記憶看似衝突，先自然回應最新對話，不要假裝沒看見玩家剛說過的內容。
`.trim();
}
  return buildCallScopedMemoryContext;
}

module.exports = {createCallScopedMemoryContext};
