'use strict';
// Dependency-injected AI telemetry recorder; failures must not interrupt chats.
function createAiHealthRecorder({db,APP_ID,FieldValue,getAiHealthTaipeiDateKey,extractAiUsage}) {
async function recordAiHealth({
  success,
  latencyMs = 0,
  apiAttempts = 1,
  usedFallback = false,
  contentFiltered = false,
  timedOut = false,
  cancelled = false,
  result = null,
  modelId = "",
}) {
  try {
    const dateKey =
      getAiHealthTaipeiDateKey();

    const ref = db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("ai_usage_daily")
      .doc(dateKey);

    const usage =
      extractAiUsage(result);

    const update = {
      dateKey,

      requests:
        FieldValue.increment(1),

      apiAttempts:
        FieldValue.increment(
          Math.max(1, apiAttempts)
        ),

      successCount:
        FieldValue.increment(
          success ? 1 : 0
        ),

      failureCount:
        FieldValue.increment(
          !success && !cancelled ? 1 : 0
        ),

      cancelledCount:
        FieldValue.increment(
          cancelled ? 1 : 0
        ),

      fallbackCount:
        FieldValue.increment(
          usedFallback ? 1 : 0
        ),

      contentFilterCount:
        FieldValue.increment(
          contentFiltered ? 1 : 0
        ),

      timeoutCount:
        FieldValue.increment(
          timedOut ? 1 : 0
        ),

      totalLatencyMs:
        FieldValue.increment(
          Math.max(
            0,
            Math.trunc(latencyMs)
          )
        ),

      inputTokens:
        FieldValue.increment(
          usage.inputTokens
        ),

      outputTokens:
        FieldValue.increment(
          usage.outputTokens
        ),

      totalTokens:
        FieldValue.increment(
          usage.totalTokens
        ),

      lastModelId:
        String(modelId || "")
          .slice(0, 300),

      updatedAt:
        FieldValue.serverTimestamp(),
    };

    await ref.set(
      update,
      {
        merge: true,
      }
    );
  } catch (error) {
    // ⚠️ 監控失敗絕對不能害聊天失敗
    console.warn(
      "⚠️ AI 健康統計寫入失敗：",
      error
    );
  }
}
  return recordAiHealth;
}
module.exports={createAiHealthRecorder};
