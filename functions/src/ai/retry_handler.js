'use strict';
const {isCancelled, isSafetyFailure, mayFallbackProvider} = require('./provider_failure_policy');
// 原樣移出 core.js 的重試、備援與健康監測協作；透過依賴注入保留原行為。
function createAiRetryHandler({getAiProviderConfig, callOpenRouter, callAnthropicDirect,
  isAiContentFiltered, hasUsableAiContent, isAiTimeoutError, recordAiHealth}) {
async function callAiWithRetry({
  modelId,
  fallbackModelId,
  requestBody,
  fallbackRequestBody = null,
  timeoutFallbackModelId = null,
  abortController,
  timeoutMs = 95_000,
  fallbackTimeoutMs = timeoutMs,
  retryPrimary = true,
}) {
  const startedAt = Date.now();

  let apiAttempts = 0;
  let usedFallback = false;
  let finalModelId = modelId;

  async function callCurrentAiModel(
    targetModelId,
    attemptTimeoutMs = timeoutMs,
    attemptRequestBody = requestBody
  ) {
    apiAttempts++;

    const providerConfig =
      getAiProviderConfig(
        targetModelId
      );

    console.log(
      "🧭 AI PROVIDER ROUTE:",
      {
        originalModelId:
          targetModelId,

        provider:
          providerConfig.provider,

        apiUrl:
          providerConfig.apiUrl,

        modelIdForRequest:
          providerConfig.modelIdForRequest,
      }
    );

    // 每一次嘗試都依「實際 provider」重建 reasoning 設定，
    // 這樣 primary / retry / fallback 換供應商時不會沿用錯誤參數。
    const providerRequestBody = {
      ...attemptRequestBody,
    };

    delete providerRequestBody.reasoning;
    delete providerRequestBody.reasoning_effort;

    if (providerConfig.provider === "gemini") {
      providerRequestBody.reasoning_effort = "low";
    } else if (providerConfig.provider === "xai") {
      // Grok 4.6 預設 reasoning 偏高；寫作場景固定 low，避免延遲與隱藏 token 暴增。
      providerRequestBody.reasoning_effort = "low";
    } else if (providerConfig.provider === "openrouter") {
      providerRequestBody.reasoning = {
        effort: "none",
      };
    }

    const result = providerConfig.provider === "anthropic"
      ? await callAnthropicDirect({
          modelId: providerConfig.modelIdForRequest,
          requestBody: providerRequestBody,
          abortController,
          timeoutMs: attemptTimeoutMs,
        })
      : await callOpenRouter({
          apiUrl: providerConfig.apiUrl,
          apiKey: providerConfig.apiKey,
          modelId: providerConfig.modelIdForRequest,
          requestBody: providerRequestBody,
          abortController,
          timeoutMs: attemptTimeoutMs,
        });

    // HTTP 200 不代表模型真的成功產生內容。
    // Gemini 會用 200 + finish_reason=content_filter: PROHIBITED_CONTENT 擋掉回覆；
    // 其他 provider 也可能回 choices 但 content 為空。
    // 此處區分服務異常（可備援）與明確內容拒絕（不可備援）。
    if (isAiContentFiltered(result) || isSafetyFailure({result})) {
      const finishReasons = (Array.isArray(result?.choices) ? result.choices : [])
        .map((choice) => String(choice?.finish_reason || ""))
        .filter(Boolean);

      const error = new Error("AI_CONTENT_FILTERED");
      error.code = "AI_CONTENT_FILTERED";
      error.result = result;
      error.provider = providerConfig.provider;
      error.modelId = targetModelId;
      error.finishReasons = finishReasons;

      console.warn(
        "🛡️ AI provider content filter，停止備援:",
        {
          provider: providerConfig.provider,
          modelId: targetModelId,
          finishReasons,
        }
      );

      throw error;
    }

    if (!hasUsableAiContent(result)) {
      const finishReasons = (Array.isArray(result?.choices) ? result.choices : [])
        .map((choice) => String(choice?.finish_reason || ""))
        .filter(Boolean);

      const invalidShape = result?.choices != null && !Array.isArray(result.choices);
      const failureCode = invalidShape ? "AI_INVALID_RESPONSE" : "AI_EMPTY_RESPONSE";
      const error = new Error(failureCode);
      error.code = failureCode;
      error.result = result;
      error.provider = providerConfig.provider;
      error.modelId = targetModelId;
      error.finishReasons = finishReasons;

      // Google/OpenAI-compatible 可能回傳 HTTP 200 + 空 content。
      // 僅記錄安全的結構資訊，避免輸出玩家對話、模型回覆或隱藏推理。
      const choices = Array.isArray(result?.choices) ? result.choices : [];
      console.warn("AI_PROVIDER_EMPTY_DIAGNOSTIC", {
        provider: providerConfig.provider,
        modelId: targetModelId,
        choicesCount: choices.length,
        finishReasons,
        promptBlockReason: String(result?.promptFeedback?.blockReason || "").slice(0, 80),
        candidateContentTypes: choices.slice(0, 3).map(choice => {
          const content = choice?.message?.content;
          return Array.isArray(content) ? "array" : typeof content;
        }),
        candidateContentLengths: choices.slice(0, 3).map(choice => {
          const content = choice?.message?.content;
          return typeof content === "string" ? content.length :
            (Array.isArray(content) ? content.length : 0);
        }),
        candidateHasRefusal: choices.slice(0, 3).map(choice => Boolean(choice?.message?.refusal)),
      });
      console.warn(
        "🫥 AI provider 回傳空內容，改走 fallback:",
        {
          provider: providerConfig.provider,
          modelId: targetModelId,
          finishReasons,
        }
      );

      throw error;
    }

    return result;
  }

  async function safeRecordAiHealth(data) {
    try { await recordAiHealth(data); }
    catch (error) { console.warn('AI_HEALTH_RECORD_FAILED', {code:String(error?.code || 'unknown')}); }
  }

  async function finishSuccess(
    result,
    selectedModelId
  ) {
    finalModelId =
      selectedModelId;

    await safeRecordAiHealth({
      success: true,

      latencyMs:
        Date.now() - startedAt,

      apiAttempts,

      usedFallback,

      contentFiltered:
        isAiContentFiltered(result),

      timedOut: false,

      cancelled: false,

      result,

      modelId:
        finalModelId,
    });

    return result;
  }

  async function finishFailure(
    error
  ) {
    const cancelled = isCancelled(error, abortController?.signal);

    await safeRecordAiHealth({
      success: false,

      latencyMs:
        Date.now() - startedAt,

      apiAttempts:
        Math.max(1, apiAttempts),

      usedFallback,

      contentFiltered:
        error?.code === "AI_CONTENT_FILTERED" ||
        isSafetyFailure(error) || isAiContentFiltered(error?.result),

      timedOut:
        isAiTimeoutError(error),

      cancelled,

      result:
        error?.result || null,

      // 診斷資料：只記錄最終錯誤，不改變原本的重試／備援判斷。
      failureCode: String(isSafetyFailure(error) ? "AI_CONTENT_FILTERED" : error?.code || ""),
      failureStatusCode: Number(error?.statusCode || error?.status) || null,
      failureMessage: String(error?.message || ""),

      modelId:
        finalModelId,
    });

    throw error;
  }

  try {
    try {
      const result =
        await callCurrentAiModel(
          modelId
        );

      return await finishSuccess(
        result,
        modelId
      );
    } catch (error) {
      if (
        error?.message === "PLAYER_DISCONNECTED" ||
        error?.code === "PLAYER_DISCONNECTED" ||
        abortController?.signal?.aborted
      ) {
        return await finishFailure(
          error
        );
      }

      if (!mayFallbackProvider(error, abortController?.signal)) {
        return await finishFailure(error);
      }
      const status = Number(error?.statusCode || error?.status || 0);
      // Permanent provider/billing failures must never retry the same primary.
      const directFallback = status >= 400 && status < 500 && status !== 408 && status !== 429;

      // v2.4.6：Writer 主路由不重撞同供應商。
      // Gemini / Grok 失敗後直接切 OpenRouter DeepSeek v3.2；
      // fallback 也失敗就結束，不再切第三模型。
      if (!retryPrimary || directFallback) {
        // Explicit opt-in for transport timeouts only; other failure routes stay unchanged.
        const selectedFallbackModelId = error?.code === "AI_TIMEOUT" && timeoutFallbackModelId
          ? timeoutFallbackModelId : fallbackModelId;
        if (!selectedFallbackModelId) {
          return await finishFailure(
            error
          );
        }

        if (abortController?.signal?.aborted) {
          const cancelled = new Error("PLAYER_DISCONNECTED");
          cancelled.code = "PLAYER_DISCONNECTED";
          return await finishFailure(cancelled);
        }
        usedFallback = true;
        finalModelId =
          selectedFallbackModelId;

        console.warn(
          "🚑 Writer 主模型失敗，直接切換最後 fallback:",
          {
            modelId,
            fallbackModelId: selectedFallbackModelId,
            message:
              error?.message,
            code:
              error?.code || "",
            statusCode:
              error?.statusCode,
            finishReasons:
              error?.finishReasons || [],
          }
        );

        try {
          const fallbackResult =
            await callCurrentAiModel(
              selectedFallbackModelId,
              fallbackTimeoutMs,
              fallbackRequestBody || requestBody
            );

          return await finishSuccess(
            fallbackResult,
            selectedFallbackModelId
          );
        } catch (fallbackError) {
          console.error(
            "🧯 Writer fallback 也失敗，本輪結束且不再切第三模型:",
            {
              fallbackModelId: selectedFallbackModelId,
              message:
                fallbackError?.message,
              code:
                fallbackError?.code || "",
              statusCode:
                fallbackError?.statusCode,
              finishReasons:
                fallbackError?.finishReasons || [],
            }
          );

          return await finishFailure(
            fallbackError
          );
        }
      }

      console.warn(
        "🌧️ 主模型忙線、逾時或回傳異常，先重試一次:",
        {
          modelId,
          message:
            error?.message,
          statusCode:
            error?.statusCode,
        }
      );

      await new Promise(
        (resolve) =>
          setTimeout(
            resolve,
            1200
          )
      );

      if (abortController?.signal?.aborted) {
        const cancelled = new Error("PLAYER_DISCONNECTED");
        cancelled.code = "PLAYER_DISCONNECTED";
        return await finishFailure(cancelled);
      }
      try {
        const retryResult =
          await callCurrentAiModel(
            modelId
          );

        return await finishSuccess(
          retryResult,
          modelId
        );
      } catch (retryError) {
        if (
          retryError?.message === "PLAYER_DISCONNECTED" ||
          retryError?.code === "PLAYER_DISCONNECTED" ||
          abortController?.signal?.aborted
        ) {
          return await finishFailure(
            retryError
          );
        }

        if (!mayFallbackProvider(retryError, abortController?.signal) || !fallbackModelId) {
          return await finishFailure(retryError);
        }

        if (abortController?.signal?.aborted) {
          const cancelled = new Error("PLAYER_DISCONNECTED");
          cancelled.code = "PLAYER_DISCONNECTED";
          return await finishFailure(cancelled);
        }
        usedFallback = true;
        finalModelId =
          fallbackModelId;

        console.warn(
          "🚑 主模型重試失敗，切換 fallback:",
          {
            fallbackModelId,
            message:
              retryError?.message,
            statusCode:
              retryError?.statusCode,
          }
        );

        try {
          const fallbackResult =
            await callCurrentAiModel(
              fallbackModelId,
              fallbackTimeoutMs,
              fallbackRequestBody || requestBody
            );

          return await finishSuccess(
            fallbackResult,
            fallbackModelId
          );
        } catch (fallbackError) {
          return await finishFailure(
            fallbackError
          );
        }
      }
    }
  } catch (error) {
    throw error;
  }
}


return {callAiWithRetry};
}
module.exports = {createAiRetryHandler};
