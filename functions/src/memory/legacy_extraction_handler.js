'use strict';

// Legacy memory extraction HTTP endpoint. Behaviour preserved; dependencies are injected.
// This endpoint intentionally requires memoryScopeVersion >= 1 and an identifiable
// session/profile scope before writing any memory.
function createLegacyMemoryExtractionHandler({
  cors, getAuth, db, APP_ID,
  resolveEffectivePlayerProfileId,
  resolvePlayerIdentityFromUserData,
  savePlayerMemoryIfNeeded,
}) {
  return (req, res) => {
    return cors(req, res, async () => {
        try {
            if (req.method === "OPTIONS") {
                return res.status(204).send("");
            }

            if (req.method !== "POST") {
                return res.status(405).json({
                    status: "error",
                    errorMessage: "Method not allowed",
                });
            }

            const authHeader = req.headers.authorization || "";
            const idToken = authHeader.startsWith("Bearer ")
                ? authHeader.substring("Bearer ".length)
                : null;

            if (!idToken) {
                return res.status(401).json({
                    status: "error",
                    errorMessage: "Missing Authorization token",
                });
            }

            const decodedToken = await getAuth().verifyIdToken(idToken);
            const userId = decodedToken.uid;
            const body = req.body || {};

            const appId =
                String(body.appId || APP_ID).trim() || APP_ID;
            const characterId =
                String(body.characterId || "").trim();
            const sessionId =
                String(body.sessionId || "").trim();
            const requestedProfileId =
                String(body.playerProfileId || "").trim();
            const userMessage =
                String(body.userMessage || "").trim();
            const memoryScopeVersion =
                Number(body.memoryScopeVersion || 0);

            // 舊 App 若仍呼叫這支相容 API，也不允許偷偷進入新版三層記憶。
            if (memoryScopeVersion < 1) {
                return res.status(200).json({
                    status: "success",
                    saved: false,
                    reason: "memory_scope_version_disabled",
                });
            }

            if (!characterId || !userMessage) {
                return res.status(400).json({
                    status: "error",
                    errorMessage: "Missing characterId or userMessage",
                });
            }

            if (userMessage.length < 4) {
                return res.status(200).json({
                    status: "success",
                    saved: false,
                    reason: "too_short",
                });
            }

            // 這支 API 是舊版相容入口。沒有任何可辨識的玩家檔案／聊天室範圍時，
            // 寧可不存，也不要再寫回 users/{uid}/characters/{characterId}/memories。
            if (!sessionId && !requestedProfileId) {
                console.log(
                    "🧠 extractUserMemory 缺少 sessionId / playerProfileId，略過未分流記憶寫入"
                );
                return res.status(200).json({
                    status: "success",
                    saved: false,
                    reason: "missing_memory_scope",
                });
            }

            const userSnapshot = await db
                .collection("users")
                .doc(userId)
                .get();
            const userData = userSnapshot.data() || {};

            const effectiveProfileId =
                await resolveEffectivePlayerProfileId({
                    appId,
                    userId,
                    characterId,
                    sessionId,
                    requestedProfileId,
                    userData,
                });

            const playerIdentity =
                resolvePlayerIdentityFromUserData(
                    userData,
                    effectiveProfileId
                );

            const savedMemory =
                await savePlayerMemoryIfNeeded({
                    appId,
                    userId,
                    characterId,
                    playerProfileId: effectiveProfileId,
                    sessionId,
                    userMessage,
                    playerName: playerIdentity.name,
                    abortController: null,
                });

            return res.status(200).json({
                status: "success",
                saved: savedMemory != null,
                memory: savedMemory?.memory || "",
                scope: savedMemory?.scope || "none",
                playerProfileId: effectiveProfileId,
                reason:
                    savedMemory != null
                        ? "saved"
                        : "not_worth_saving",
            });
        } catch (error) {
            console.error("🧠 extractUserMemory 發生錯誤:", error);

            // 記憶擷取失敗不要影響聊天主流程，所以回 200
            return res.status(200).json({
                status: "success",
                saved: false,
                reason: "server_error_but_ignored",
            });
        }
    });
};
}

module.exports = {createLegacyMemoryExtractionHandler};
