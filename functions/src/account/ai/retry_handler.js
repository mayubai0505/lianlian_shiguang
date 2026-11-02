'use strict';
// 原樣移出 core.js 的重試、備援與健康監測協作；透過依賴注入保留原行為。
function createAiRetryHandler({getAiProviderConfig, callOpenRouter, callAnthropicDirect,
  isAiContentFiltered, hasUsableAiContent, isAiTimeoutError, recordAiHealth}) {
async function callAiWithRetry({
  modelId,
  fallbackModelId,
  requestBody,
  abortController,
  timeoutMs = 95_000,
  retryPrimary = true,
}) {
  const startedAt = Date.now();

  let apiAttempts = 0;
  let usedFallback = false;
  let finalModelId = modelId;

  async function callCurrentAiModel(
    targetModelId
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
      ...requestBody,
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
          timeoutMs,
        })
      : await callOpenRouter({
          apiUrl: providerConfig.apiUrl,
          apiKey: providerConfig.apiKey,
          modelId: providerConfig.modelIdForRequest,
          requestBody: providerRequestBody,
          abortController,
          timeoutMs,
        });

    // HTTP 200 不代表模型真的成功產生內容。
    // Gemini 會用 200 + finish_reason=content_filter: PROHIBITED_CONTENT 擋掉回覆；
    // 其他 provider 也可能回 choices 但 content 為空。
    // 這兩種情況都必須在這一層視為 provider failure，
    // 才能讓所有模式統一進入 fallback，而不是外層一直重撞同一模型。
    if (isAiContentFiltered(result)) {
      const finishReasons = (result?.choices || [])
        .map((choice) => String(choice?.finish_reason || ""))
        .filter(Boolean);

      const error = new Error("AI_CONTENT_FILTERED");
      error.code = "AI_CONTENT_FILTERED";
      error.result = result;
      error.provider = providerConfig.provider;
      error.modelId = targetModelId;
      error.finishReasons = finishReasons;

      console.warn(
        "🛡️ AI provider content filter，改走 fallback:",
        {
          provider: providerConfig.provider,
          modelId: targetModelId,
          finishReasons,
        }
      );

      throw error;
    }

    if (!hasUsableAiContent(result)) {
      const finishReasons = (result?.choices || [])
        .map((choice) => String(choice?.finish_reason || ""))
        .filter(Boolean);

      const error = new Error("AI_EMPTY_RESPONSE");
      error.code = "AI_EMPTY_RESPONSE";
      error.result = result;
      error.provider = providerConfig.provider;
      error.modelId = targetModelId;
      error.finishReasons = finishReasons;

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

  async function finishSuccess(
    result,
    selectedModelId
  ) {
    finalModelId =
      selectedModelId;

    await recordAiHealth({
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
    const cancelled =
      error?.message ===
      "PLAYER_DISCONNECTED";

    await recordAiHealth({
      success: false,

      latencyMs:
        Date.now() - startedAt,

      apiAttempts:
        Math.max(1, apiAttempts),

      usedFallback,

      contentFiltered:
        error?.code === "AI_CONTENT_FILTERED" ||
        isAiContentFiltered(error?.result),

      timedOut:
        isAiTimeoutError(error),

      cancelled,

      result:
        error?.result || null,

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
        error.message ===
        "PLAYER_DISCONNECTED"
      ) {
        return await finishFailure(
          error
        );
      }

      const retryable =
        error.statusCode === 429 ||
        error.statusCode === 500 ||
        error.statusCode === 502 ||
        error.statusCode === 503 ||
        error.statusCode === 504 ||
        error.message ===
          "AI_PROVIDER_BUSY" ||
        error.message?.includes(
          "AI 回覆時間太久"
        ) ||
        error.message?.includes(
          "AI 服務暫時忙碌"
        ) ||
        error.message?.includes(
          "AI 連線暫時不穩"
        ) ||
        error.message?.includes(
          "AI 回傳格式異常"
        ) ||
        error.message?.includes(
          "AI 斷線或沒有回傳 choices"
        ) ||
        error?.code === "AI_CONTENT_FILTERED" ||
        error?.code === "AI_EMPTY_RESPONSE" ||
        error?.message === "AI_CONTENT_FILTERED" ||
        error?.message === "AI_EMPTY_RESPONSE";

      if (!retryable) {
        return await finishFailure(
          error
        );
      }

      // v2.4.6：Writer 主路由不重撞同供應商。
      // Gemini / Grok 失敗後直接切 OpenRouter DeepSeek v3.2；
      // fallback 也失敗就結束，不再切第三模型。
      if (!retryPrimary) {
        if (!fallbackModelId) {
          return await finishFailure(
            error
          );
        }

        usedFallback = true;
        finalModelId =
          fallbackModelId;

        console.warn(
          "🚑 Writer 主模型失敗，直接切換最後 fallback:",
          {
            modelId,
            fallbackModelId,
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
              fallbackModelId
            );

          return await finishSuccess(
            fallbackResult,
            fallbackModelId
          );
        } catch (fallbackError) {
          console.error(
            "🧯 Writer fallback 也失敗，本輪結束且不再切第三模型:",
            {
              fallbackModelId,
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
          retryError.message ===
          "PLAYER_DISCONNECTED"
        ) {
          return await finishFailure(
            retryError
          );
        }

        if (!fallbackModelId) {
          return await finishFailure(
            retryError
          );
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
              fallbackModelId
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
