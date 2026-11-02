'use strict';
// Extracted verbatim from V67; Firebase deployment options remain in core.js.
function createMemoryAdminHandlers({db,APP_ID,HttpsError,FieldValue,requireRewardCampaignAdmin}) {
  async function getMemoryHealthDiagnosticsUs(request) {
        requireRewardCampaignAdmin(request);

        const appId = String(
            request.data?.appId || APP_ID || "lianlianshiguang"
        ).trim() || "lianlianshiguang";

        const targetUserId = String(request.data?.userId || "").trim();
        let characterId = String(request.data?.characterId || "").trim();
        const sessionId = String(request.data?.sessionId || "").trim();
        let playerProfileId = String(request.data?.playerProfileId || "").trim();

        if (!targetUserId) {
            throw new HttpsError("invalid-argument", "請提供玩家 UID");
        }

        const userRef = db.collection("users").doc(targetUserId);
        const userSnapshot = await userRef.get();

        if (!userSnapshot.exists) {
            throw new HttpsError("not-found", "找不到這個玩家");
        }

        const userData = userSnapshot.data() || {};

        if (sessionId) {
            const sessionSnapshot = await db
                .collection("artifacts")
                .doc(appId)
                .collection("chat_sessions")
                .doc(sessionId)
                .get();

            if (sessionSnapshot.exists) {
                const sessionData = sessionSnapshot.data() || {};
                const sessionOwner = String(sessionData.userId || "").trim();

                if (sessionOwner && sessionOwner !== targetUserId) {
                    throw new HttpsError(
                        "permission-denied",
                        "這個聊天室不屬於指定玩家"
                    );
                }

                if (!characterId) {
                    characterId = String(sessionData.characterId || "").trim();
                }
                if (!playerProfileId) {
                    playerProfileId = String(sessionData.playerProfileId || "").trim();
                }
            }
        }

        if (!playerProfileId) {
            playerProfileId = String(
                userData.activeProfileId ||
                userData.defaultProfileId ||
                "default"
            ).trim() || "default";
        }

        const profileRef = userRef
            .collection("profile_memories")
            .doc(playerProfileId)
            .collection("memories");

        const profileSnapshot = await profileRef
            .orderBy("timestamp", "desc")
            .limit(200)
            .get();

        let characterSnapshot = null;
        if (characterId) {
            characterSnapshot = await userRef
                .collection("profile_memories")
                .doc(playerProfileId)
                .collection("characters")
                .doc(characterId)
                .collection("memories")
                .orderBy("timestamp", "desc")
                .limit(200)
                .get();
        }

        let sessionMemorySnapshot = null;
        if (sessionId) {
            sessionMemorySnapshot = await db
                .collection("artifacts")
                .doc(appId)
                .collection("chat_sessions")
                .doc(sessionId)
                .collection("memories")
                .orderBy("timestamp", "desc")
                .limit(200)
                .get();
        }

        const [jobsSnapshot, debugSnapshot] = await Promise.all([
            db.collection("artifacts")
                .doc(appId)
                .collection("memory_jobs")
                .where("userId", "==", targetUserId)
                .limit(200)
                .get(),
            db.collection("artifacts")
                .doc(appId)
                .collection("memory_debug_logs")
                .where("userId", "==", targetUserId)
                .limit(100)
                .get(),
        ]);

        function tsMillis(value) {
            try {
                return value?.toMillis?.() || 0;
            } catch (_) {
                return 0;
            }
        }

        function normalizeMemoryDoc(doc, fallbackScope) {
            const data = doc.data() || {};
            return {
                id: doc.id,
                scope: String(data.scope || fallbackScope || ""),
                text: String(data.text || data.content || ""),
                factKey: String(data.factKey || ""),
                factValue: String(data.factValue || ""),
                category: String(data.category || ""),
                confidence: Number(data.confidence || 0),
                active: data.active !== false,
                important: data.important === true,
                sourceMessage: String(data.sourceMessage || ""),
                timestampMs: tsMillis(data.timestamp || data.updatedAt),
            };
        }

        function memoryStats(snapshot, scope) {
            const rows = snapshot
                ? snapshot.docs.map((doc) => normalizeMemoryDoc(doc, scope))
                : [];
            return {
                totalLoaded: rows.length,
                active: rows.filter((row) => row.active).length,
                inactive: rows.filter((row) => !row.active).length,
                rows: rows.slice(0, 100),
            };
        }

        const jobs = jobsSnapshot.docs
            .map((doc) => {
                const data = doc.data() || {};
                return {
                    id: doc.id,
                    status: String(data.status || "unknown"),
                    characterId: String(data.characterId || ""),
                    sessionId: String(data.sessionId || ""),
                    playerProfileId: String(data.playerProfileId || ""),
                    userMessage: String(data.userMessage || ""),
                    attempts: Number(data.attempts || 0),
                    memoryCreated: data.memoryCreated === true,
                    memoryId: String(data.memoryId || ""),
                    errorCode: String(data.errorCode || ""),
                    errorMessage: String(data.errorMessage || ""),
                    createdAtMs: tsMillis(data.createdAt),
                    completedAtMs: tsMillis(data.completedAt),
                };
            })
            .sort((a, b) => b.createdAtMs - a.createdAtMs);

        const jobCounts = {};
        for (const job of jobs) {
            jobCounts[job.status] = Number(jobCounts[job.status] || 0) + 1;
        }

        const debugLogs = debugSnapshot.docs
            .map((doc) => {
                const data = doc.data() || {};
                return {
                    id: doc.id,
                    characterId: String(data.characterId || ""),
                    sessionId: String(data.sessionId || ""),
                    playerProfileId: String(data.playerProfileId || ""),
                    chatMode: String(data.chatMode || ""),
                    retrievalQuery: String(data.retrievalQuery || ""),
                    candidateCounts: data.candidateCounts || {},
                    selectedLores: Array.isArray(data.selectedLores)
                        ? data.selectedLores
                        : [],
                    selectedMemories: Array.isArray(data.selectedMemories)
                        ? data.selectedMemories
                        : [],
                    createdAtMs: tsMillis(data.createdAt),
                };
            })
            .sort((a, b) => b.createdAtMs - a.createdAtMs)
            .slice(0, 30);

        return {
            success: true,
            target: {
                userId: targetUserId,
                characterId,
                sessionId,
                playerProfileId,
            },
            debugEnabled: userData.memoryDebugEnabled === true,
            limits: {
                currentRagCandidateReadPerScope: 20,
                currentRagSelectedMemories: 3,
                currentRagSelectedMemoriesResonance: 4,
                diagnosticsLoadCapPerScope: 200,
            },
            profile: memoryStats(profileSnapshot, "profile"),
            character: memoryStats(characterSnapshot, "character"),
            session: memoryStats(sessionMemorySnapshot, "session"),
            jobs: {
                totalLoaded: jobs.length,
                counts: jobCounts,
                rows: jobs.slice(0, 100),
            },
            ragDebugLogs: debugLogs,
        };

  }
  async function setMemoryDebugEnabledUs(request) {
        requireRewardCampaignAdmin(request);

        const targetUserId = String(request.data?.userId || "").trim();
        const enabled = request.data?.enabled === true;

        if (!targetUserId) {
            throw new HttpsError("invalid-argument", "請提供玩家 UID");
        }

        await db.collection("users").doc(targetUserId).set(
            {
                memoryDebugEnabled: enabled,
                memoryDebugUpdatedAt: FieldValue.serverTimestamp(),
            },
            {merge: true}
        );

        return {success: true, enabled};

  }
  return {getMemoryHealthDiagnosticsUs,setMemoryDebugEnabledUs};
}
module.exports={createMemoryAdminHandlers};
