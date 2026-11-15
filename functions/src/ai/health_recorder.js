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
  failureCode = "",
  failureStatusCode = null,
  failureMessage = "",
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

    // 僅統計最終失敗原因；不記錄原始玩家訊息或供應商回傳內容。
    // 403 不等於確定的內容審查；獨立歸為 HTTP 拒絕。
    const code = String(failureCode || "");
    const status = Number(failureStatusCode) || 0;
    const message = String(failureMessage || "");
    const failureType = success || cancelled ? "" : (
      status === 403 ? "http403" :
      status === 429 ? "http429" :
      status === 401 ? "http401" :
      (status >= 500 && status <= 599) ? "http5xx" :
      code === "AI_TIMEOUT" || /AI 回覆時間太久/.test(message) ? "timeout" :
      code === "AI_NETWORK_ERROR" ? "network" :
      code === "AI_CONTENT_FILTERED" ? "contentFiltered" :
      code === "AI_EMPTY_RESPONSE" ? "emptyResponse" :
      code === "AI_INVALID_RESPONSE" || /AI 回傳格式異常/.test(message) ? "invalidResponse" :
      "other"
    );
    // Firestore map key 需避開模型 ID 內的斜線及句點。
    const failedModelKey = String(modelId || "unknown")
      .replace(/[^a-zA-Z0-9_-]/g, "_").slice(0, 120) || "unknown";

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

      // 新增計數與原有成功率公式獨立，舊資料無需回填。
      ...(failureType ? {
        failureReasonCounts: { [failureType]: FieldValue.increment(1) },
        failureModelCounts: { [failedModelKey]: FieldValue.increment(1) },
        lastFailureModelId: String(modelId || "").slice(0, 300),
        lastFailureType: failureType,
      } : {}),

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
