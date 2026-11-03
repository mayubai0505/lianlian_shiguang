'use strict';

// V81: Original task progress writer, with Firebase dependencies injected.
function createTaskProgressRecorder({db,APP_ID,FieldValue,reusableEventIsRunning,normalizeReusableEventTaskDefinition,reusableEventTaskMatchesAction,reusableEventProgressRef}) {
async function recordReusableEventTaskProgress({
    userId,
    sessionId,
    messageId,
    chatMode,
    billingType,
    interactionType = "",
    giftType = "",
    isTestChat = false,
    isRegenerate = false,
    isContinue = false,
    isQixiOpening = false,
}) {
    // 只有玩家真正完成一次正式互動才計入活動任務。
    if (
        !userId ||
        !messageId ||
        isTestChat ||
        isRegenerate ||
        isContinue ||
        isQixiOpening
    ) {
        return;
    }

    const now = new Date();

    const eventsSnapshot = await db
        .collection("artifacts")
        .doc(APP_ID)
        .collection("events")
        .where("isActive", "==", true)
        .limit(10)
        .get();

    for (const eventDoc of eventsSnapshot.docs) {
        const eventData = eventDoc.data() || {};
        if (!reusableEventIsRunning(eventData, now)) continue;
        if (eventData.hasTasks === false) continue;

        const tasksSnapshot = await eventDoc.ref
            .collection("tasks")
            .limit(50)
            .get();

        const action = {
            chatMode,
            billingType,
            interactionType,
            giftType,
        };

        const matchedTasks = tasksSnapshot.docs
            .map((taskDoc) =>
                normalizeReusableEventTaskDefinition(
                    taskDoc.id,
                    taskDoc.data() || {}
                )
            )
            .filter((task) =>
                reusableEventTaskMatchesAction(
                    task.taskType,
                    action
                )
            );

        if (matchedTasks.length === 0) continue;

        const progressRef =
            reusableEventProgressRef(
                userId,
                eventDoc.id
            );

        // 同一則 AI 訊息只允許計入一次，避免重試 / 重送造成重複進度。
        const safeActionId =
            `${sessionId || "session"}_${messageId}`
                .replace(/\//g, "_");

        const actionRef =
            progressRef
                .collection("actions")
                .doc(safeActionId);

        await db.runTransaction(async (transaction) => {
            const [
                actionSnapshot,
                progressSnapshot,
            ] = await Promise.all([
                transaction.get(actionRef),
                transaction.get(progressRef),
            ]);

            if (actionSnapshot.exists) {
                return;
            }

            const progressData =
                progressSnapshot.data() || {};

            const currentTaskProgress =
                progressData.taskProgress &&
                typeof progressData.taskProgress === "object"
                    ? { ...progressData.taskProgress }
                    : {};

            const changedTaskIds = [];

            for (const task of matchedTasks) {
                const current =
                    Number(
                        currentTaskProgress[
                            task.taskId
                        ] || 0
                    );

                const next = Math.min(
                    task.target,
                    Math.max(0, current) + 1
                );

                if (next !== current) {
                    currentTaskProgress[
                        task.taskId
                    ] = next;

                    changedTaskIds.push(
                        task.taskId
                    );
                }
            }

            transaction.set(
                progressRef,
                {
                    userId,
                    eventId: eventDoc.id,
                    currency:
                        Number(
                            progressData.currency || 0
                        ),
                    taskProgress:
                        currentTaskProgress,
                    updatedAt:
                        FieldValue.serverTimestamp(),
                    lastProgressAt:
                        FieldValue.serverTimestamp(),
                },
                { merge: true }
            );

            transaction.set(
                actionRef,
                {
                    userId,
                    eventId: eventDoc.id,
                    sessionId:
                        String(sessionId || ""),
                    messageId,
                    chatMode:
                        String(chatMode || ""),
                    billingType:
                        String(billingType || ""),
                    interactionType:
                        String(interactionType || ""),
                    giftType:
                        String(giftType || ""),
                    changedTaskIds,
                    createdAt:
                        FieldValue.serverTimestamp(),
                }
            );
        });
    }
}
  return recordReusableEventTaskProgress;
}

module.exports={createTaskProgressRecorder};
