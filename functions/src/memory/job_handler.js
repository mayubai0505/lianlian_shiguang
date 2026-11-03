'use strict';
// Background memory_jobs handler. Preserve the legacy processing and error semantics.
function createMemoryJobHandler({FieldValue, savePlayerMemoryIfNeeded}) {
  return async (event) => {
        const snapshot = event.data;

        if (!snapshot) {
            console.warn(
                "⚠️ processMemoryJob 沒有收到文件資料"
            );
            return;
        }

        const jobRef = snapshot.ref;
        const jobData = snapshot.data() || {};

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
            !userMessage
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
        }
    };
}
module.exports = {createMemoryJobHandler};
