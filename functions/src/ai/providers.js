'use strict';
// 原樣移出 core.js 的 API 供應商呼叫與模型路由；透過依賴注入取得 Firebase Secrets。
function createAiProviders({anthropicApiKey, geminiApiKey, xaiApiKey, openRouterApiKey}) {
async function callOpenRouter({
    apiUrl,
    apiKey,
    modelId,
    requestBody,
    abortController,
    timeoutMs = 95_000,
}) {
    const timeoutController = new AbortController();

    const timer = setTimeout(() => {
        timeoutController.abort();
    }, timeoutMs);

    let finalSignal = timeoutController.signal;

    if (abortController?.signal) {
        finalSignal = AbortSignal.any([
            abortController.signal,
            timeoutController.signal,
        ]);
    }

    let response;
    let rawText = "";
    const requestStartedAt = Date.now();

    try {
        const finalBody = {
            ...requestBody,
            model: modelId,
        };

        console.log("🚀 AI REQUEST:", {
            apiUrl,
            model: modelId,
            timeoutMs,
            messageCount: finalBody.messages?.length,
            max_tokens: finalBody.max_tokens,
        });

        response = await fetch(apiUrl, {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${apiKey}`,
                "Content-Type": "application/json",
            },
            body: JSON.stringify(finalBody),
            signal: finalSignal,
        });

        rawText = await response.text();

        console.log("⏱️ V5.7.6 PROVIDER RESPONSE:", {
            model: modelId,
            latencyMs: Date.now() - requestStartedAt,
            status: response.status,
            responseBytes: Buffer.byteLength(rawText, "utf8"),
        });
        console.log("🧪 AI HTTP STATUS:", response.status);
        console.log("🧪 AI RAW LENGTH:", rawText.length);
    } catch (err) {
        const playerDisconnected =
            abortController?.signal?.aborted === true;

        const requestTimedOut =
            timeoutController.signal.aborted === true;

        console.error("🚨 AI fetch failed:", {
            name: err?.name,
            message: err?.message,
            model: modelId,
            playerDisconnected,
            requestTimedOut,
            timeoutMs,
            elapsedMs: Date.now() - requestStartedAt,
        });

        if (playerDisconnected) {
            const error = new Error("PLAYER_DISCONNECTED");
            error.code = "PLAYER_DISCONNECTED";
            throw error;
        }

        if (
            requestTimedOut ||
            err?.name === "AbortError" ||
            err?.name === "TimeoutError"
        ) {
            const error = new Error(
                "AI 回覆時間太久，已主動中止"
            );
            error.code = "AI_TIMEOUT";
            throw error;
        }

        const error = new Error("AI 連線暫時不穩");
        error.code = "AI_NETWORK_ERROR";
        error.cause = err;
        throw error;
    } finally {
        clearTimeout(timer);
    }

    let data = null;

    try {
        data = rawText ? JSON.parse(rawText) : null;
    } catch (err) {
        console.error("🚨 AI returned non-JSON:", {
            status: response?.status,
            rawText: rawText.slice(0, 2000),
            parseMessage: err?.message,
        });

        throw new Error("AI 回傳格式異常");
    }

    if (!response.ok) {
        const errorMessage =
            data?.error?.message ||
            data?.message ||
            `AI HTTP ERROR ${response.status}`;

        console.error("🚨 AI HTTP ERROR:", {
            status: response.status,
            errorMessage,
            data,
            rawText: rawText.slice(0, 2000),
        });

        const error = new Error(errorMessage);
        error.statusCode = response.status;
        error.result = data;

        throw error;
    }

    if (!data?.choices || data.choices.length === 0) {
        console.error("🚨 AI 沒有 choices:", {
            status: response.status,
            data,
            rawText: rawText.slice(0, 2000),
        });

        throw new Error(
            data?.error?.message ||
            data?.message ||
            "AI 斷線或沒有回傳 choices"
        );
    }

    return data;
}

// Claude 官方 Messages API；轉成既有 OpenAI-compatible 結果格式以保留後端解析流程。
async function callAnthropicDirect({modelId, requestBody, abortController, timeoutMs = 95_000}) {
    const timeoutController = new AbortController();
    const timer = setTimeout(() => timeoutController.abort(), timeoutMs);
    const signal = abortController?.signal
        ? AbortSignal.any([timeoutController.signal, abortController.signal])
        : timeoutController.signal;
    try {
        const sourceMessages = Array.isArray(requestBody?.messages) ? requestBody.messages : [];
        const systemParts = [];
        const messages = [];
        for (const msg of sourceMessages) {
            const content = typeof msg.content === "string" ? msg.content :
                (Array.isArray(msg.content) ? msg.content.map(p => p?.text || "").join("\n") : String(msg.content || ""));
            if (msg.role === "system" || msg.role === "developer") {
                if (content.trim()) systemParts.push(content);
                continue;
            }
            const role = msg.role === "assistant" ? "assistant" : "user";
            if (messages.length && messages[messages.length - 1].role === role) {
                messages[messages.length - 1].content += "\n\n" + content;
            } else {
                messages.push({role, content});
            }
        }
        if (messages.length === 0 || messages[0].role !== "user") {
            messages.unshift({role: "user", content: "請依照系統設定開始回覆。"});
        }
        const body = {
            model: modelId,
            max_tokens: Number(requestBody.max_tokens) || 2600,
            messages,
        };
        if (systemParts.length) body.system = systemParts.join("\n\n");
        // Sonnet 5.5 不接受非預設 temperature；故不轉送 temperature/response_format/reasoning_effort。
        const response = await fetch("https://api.anthropic.com/v1/messages", {
            method: "POST",
            headers: {
                "x-api-key": anthropicApiKey.value(),
                "anthropic-version": "2023-06-01",
                "content-type": "application/json",
            },
            body: JSON.stringify(body),
            signal,
        });
        const raw = await response.text();
        let data;
        try {
            data = JSON.parse(raw);
        } catch (_) {
            // Only log metadata; provider bodies may contain sensitive user content.
            console.warn("ANTHROPIC_INVALID_RESPONSE", {
                model: modelId,
                httpStatus: response.status,
                contentType: response.headers?.get("content-type") || null,
                responseBytes: Buffer.byteLength(raw, "utf8"),
            });
            const error = new Error("Anthropic 回傳格式異常");
            error.code = "AI_INVALID_RESPONSE";
            error.statusCode = response.status;
            throw error;
        }
        if (!response.ok) {
            const error = new Error(data?.error?.message || `Anthropic HTTP ${response.status}`);
            error.statusCode = response.status;
            error.result = data;
            throw error;
        }
        // A valid JSON literal such as null is not a valid Messages API response.
        if (!data || typeof data !== "object" || Array.isArray(data)) {
            const error = new Error("Anthropic 回傳格式異常");
            error.code = "AI_INVALID_RESPONSE";
            error.statusCode = response.status;
            throw error;
        }
        const content = Array.isArray(data.content)
            ? data.content.filter(block => block?.type === "text").map(block => block.text || "").join("\n") : "";
        return {
            model: data.model || modelId,
            usage: {
                prompt_tokens: Number(data.usage?.input_tokens || 0),
                completion_tokens: Number(data.usage?.output_tokens || 0),
                total_tokens: Number(data.usage?.input_tokens || 0) + Number(data.usage?.output_tokens || 0),
            },
            choices: [{
                message: {role: "assistant", content},
                finish_reason: data.stop_reason === "max_tokens" ? "length" :
                    data.stop_reason === "refusal" ? "content_filter" : "stop",
            }],
        };
    } catch (err) {
        // 取消生成絕不能進備援；供應商 timeout 則可由 retry_handler 切備援。
        if (abortController?.signal?.aborted) {
            const cancelled = new Error("PLAYER_DISCONNECTED");
            cancelled.code = "PLAYER_DISCONNECTED";
            throw cancelled;
        }
        if (timeoutController.signal.aborted || err?.name === "AbortError" || err?.name === "TimeoutError") {
            const timedOut = new Error("AI 回覆時間太久，已主動中止");
            timedOut.code = "AI_TIMEOUT";
            throw timedOut;
        }
        // 僅將 fetch 連線階段的 TypeError / socket error 視為暫時性網路錯誤。
        // 不吞掉 HTTP 400 / 401 / 403 等具有 statusCode 的供應商錯誤。
        const code = String(err?.cause?.code || err?.code || "");
        if (!err?.statusCode && (err instanceof TypeError ||
            ["ECONNRESET", "ETIMEDOUT", "EAI_AGAIN", "ECONNREFUSED", "UND_ERR_CONNECT_TIMEOUT", "UND_ERR_SOCKET"].includes(code))) {
            const networkError = new Error("AI 連線暫時不穩");
            networkError.code = "AI_NETWORK_ERROR";
            networkError.cause = err;
            throw networkError;
        }
        throw err;
    } finally {
        clearTimeout(timer);
    }
}

function isGeminiDirectModel(modelId) {
    const id = String(modelId || "");
    return id.startsWith("google/gemini") || id.startsWith("gemini-");
}

function isXaiDirectModel(modelId) {
    const id = String(modelId || "");
    return id.startsWith("xai/grok-") || id.startsWith("grok-");
}

function normalizeModelIdForRequest(modelId) {
    const id = String(modelId || "");

    if (id.startsWith("google/")) {
        return id.replace(/^google\//, "");
    }

    if (id.startsWith("xai/")) {
        return id.replace(/^xai\//, "");
    }

    return id;
}

function getAiProviderConfig(modelId) {
    const isGemini = isGeminiDirectModel(modelId);
    const isXai = isXaiDirectModel(modelId);
    const isAnthropic = String(modelId || "").startsWith("claude-");

    if (isAnthropic) {
        return {provider: "anthropic", apiUrl: "https://api.anthropic.com/v1/messages", modelIdForRequest: modelId};
    }

    if (isGemini) {
        return {
            provider: "gemini",
            apiUrl: "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions",
            apiKey: geminiApiKey.value(),
            modelIdForRequest: normalizeModelIdForRequest(modelId),
        };
    }

    if (isXai) {
        return {
            provider: "xai",
            apiUrl: "https://api.x.ai/v1/chat/completions",
            apiKey: xaiApiKey.value(),
            modelIdForRequest: normalizeModelIdForRequest(modelId),
        };
    }

    return {
        provider: "openrouter",
        apiUrl: "https://openrouter.ai/api/v1/chat/completions",
        apiKey: openRouterApiKey.value(),
        modelIdForRequest: modelId,
    };
}


return {callOpenRouter, callAnthropicDirect, getAiProviderConfig};
}
module.exports = {createAiProviders};
