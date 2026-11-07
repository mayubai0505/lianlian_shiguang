'use strict';
// Background memory_jobs handler. Preserve the legacy processing and error semantics.
function createMemoryJobHandler({FieldValue, db, savePlayerMemoryIfNeeded}) {
  return async (event) => {
        const snapshot = event.data;

        if (!snapshot) {
            console.warn(
                "⚠️ processMemoryJob 沒有收到文件資料"
            );
            return;
        }

        const jobRef = snapshot.ref;
        const currentSnapshot = typeof jobRef.get === 'function' ? await jobRef.get() : snapshot;
        const jobData = currentSnapshot.data() || {};
        if (jobData.status === 'completed' || jobData.status === 'skipped' || Number(jobData.attempts || 0) >= 3) return;

        const appId =
            event.params.appId;

        const jobId =
            event.params.jobId;

        const userId =
            String(jobData.userId || "").trim();

        const characterId =
            String(
                jobData.characterId || ""
            ).trim();

        const playerName =
            String(
                jobData.playerName || "對方"
            ).trim() || "對方";

        const playerProfileId =
            String(jobData.playerProfileId || "").trim();

        const sessionId =
            String(jobData.sessionId || "").trim();

        const userMessage =
            String(
                jobData.userMessage || ""
            ).trim();
        const chatMode = String(jobData.chatMode || "");

        const memoryScopeVersion =
            Number(jobData.memoryScopeVersion || 0);

        console.log(
            "🧠 開始處理長期記憶背景工作：",
            {
                appId,
                jobId,
                userId,
                characterId,
                messageLength:
                    userMessage.length,
            }
        );

        // ==========================================
        // 0. 三層記憶版本 gate
        // ==========================================
        if (memoryScopeVersion < 1) {
            console.log(
                "🧠 memoryScopeVersion < 1：略過新版三層記憶背景工作。",
                { jobId, memoryScopeVersion }
            );

            await jobRef.set(
                {
                    status: "skipped",
                    errorCode: "MEMORY_SCOPE_VERSION_DISABLED",
                    errorMessage: "舊版 App 未啟用新版三層記憶。",
                    completedAt: FieldValue.serverTimestamp(),
                },
                { merge: true }
            );

            return;
        }

        // ==========================================
        // 1. 基本資料防禦
        // ==========================================
        if (
            !userId ||
            !characterId ||
            (!userMessage && !String(jobData.assistantMessage || '').trim())
        ) {
            console.warn(
                "🛑 長期記憶工作資料不完整，停止處理：",
                {
                    jobId,
                    userId,
                    characterId,
                    hasMessage:
                        Boolean(userMessage),
                }
            );

            await jobRef.set(
                {
                    status: "skipped",
                    errorCode:
                        "INVALID_MEMORY_JOB",

                    errorMessage:
                        "缺少 userId、characterId 或 userMessage。",

                    completedAt:
                        FieldValue.serverTimestamp(),
                },
                {
                    merge: true,
                }
            );

            return;
        }

        // ==========================================
        // 2. 標記處理中
        // ==========================================
        await jobRef.set(
            {
                status: "processing",

                attempts:
                    FieldValue.increment(1),

                startedAt:
                    FieldValue.serverTimestamp(),
            },
            {
                merge: true,
            }
        );

        try {
            // 背景函式不依賴玩家 HTTP 連線，
            // 因此不傳 getAiResponse 的 abortController。
            let assistantMessage = String(jobData.assistantMessage || '');
            const sourceMessageId = String(jobData.sourceMessageId || '');
            const userMessageId = String(jobData.userMessageId || '');
            let sourceTimestamp = jobData.createdAt || null;
            const sourceHashes = {};
            if (db && sessionId && sourceMessageId) {
                const sessionRef = db.collection('artifacts').doc(appId).collection('chat_sessions').doc(sessionId);
                const room = await sessionRef.get();
                const roomData = room.data() || {};
                if (!room.exists || roomData.userId !== userId || String(roomData.characterId || '') !== characterId) {
                    throw new Error('MEMORY_SESSION_SCOPE_MISMATCH');
                }
                const source = await sessionRef.collection('messages').doc(sourceMessageId).get();
                if (!source.exists) {
                    await jobRef.set({status:'skipped', errorCode:'SOURCE_REMOVED',completedAt:FieldValue.serverTimestamp()},{merge:true});
                    return;
                }
                const data = source.data() || {};
                assistantMessage = String(data.text || '');
                sourceTimestamp = data.timestamp || sourceTimestamp;
                sourceHashes.assistant = require('crypto').createHash('sha256').update(assistantMessage).digest('hex');
                if (userMessageId) {
                    const userSource = await sessionRef.collection('messages').doc(userMessageId).get();
                    if (!userSource.exists) {
                        await jobRef.set({status:'skipped',errorCode:'USER_SOURCE_REMOVED',completedAt:FieldValue.serverTimestamp()},{merge:true});
                        return;
                    }
                    sourceHashes.user = require('crypto').createHash('sha256').update(String(userSource.data()?.text || '')).digest('hex');
                }
            }
            const savedMemory =
                await savePlayerMemoryIfNeeded({
                    appId,
                    userId,
                    characterId,
                    playerProfileId,
                    sessionId,
                    userMessage,
                    playerName,
                    chatMode,
                    assistantMessage,
                    recentHistory: jobData.recentHistory || [],
                    sourceMessageId, userMessageId, sourceTimestamp, sourceHashes,
                    abortController: null,
                });

            // ======================================
            // 3. 完成
            // ======================================
            await jobRef.set(
                {
                    status: "completed",

                    memoryCreated:
                        savedMemory != null,

                    memoryId:
                        savedMemory?.id || null,
                    memoryIds: savedMemory?.ids || [],
                    savedCount: savedMemory?.savedCount || 0,

                    completedAt:
                        FieldValue.serverTimestamp(),

                    errorCode:
                        FieldValue.delete(),

                    errorMessage:
                        FieldValue.delete(),
                },
                {
                    merge: true,
                }
            );

            console.log(
                savedMemory
                    ? "✅ 長期記憶背景工作完成，已保存記憶："
                    : "✅ 長期記憶背景工作完成，本輪無需保存：",
                {
                    jobId,
                    memoryId:
                        savedMemory?.id || null,
                    userId,
                    characterId,
                }
            );
        } catch (error) {
            console.error(
                "❌ 長期記憶背景工作失敗：",
                {
                    jobId,
                    userId,
                    characterId,
                    message:
                        error?.message,
                    stack:
                        error?.stack,
                }
            );

            await jobRef.set(
                {
                    status: "error",

                    errorCode:
                        "MEMORY_PROCESS_FAILED",

                    errorMessage:
                        String(
                            error?.message ||
                            "未知錯誤"
                        ).slice(0, 1000),

                    failedAt:
                        FieldValue.serverTimestamp(),
                },
                {
                    merge: true,
                }
            );
            throw error;
        }
    };
}
module.exports = {createMemoryJobHandler};
