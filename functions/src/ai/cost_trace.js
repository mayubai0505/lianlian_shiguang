'use strict';
// Verbatim AI cost estimation and display formatting. Observation only; no flower billing.
function createAiCostTrace({extractAiUsage}) {
// Display-only reference exchange rate; not a settlement exchange rate.
const AI_COST_USD_TO_TWD_ESTIMATE = 32.62;
const asNonNegativeNumber = (value) => {
  if (value === null || value === undefined || value === '') return null;
  const number = Number(value);
  return Number.isFinite(number) && number >= 0 ? number : null;
};

function estimateAiCallCost({
  modelId = "",
  result = null,
}) {
  const usage = (typeof extractAiUsage === 'function' ? extractAiUsage(result) : null) || {};
  const rawUsage = result?.usage || {};
  const normalizedModel = String(
    result?.model || modelId || ""
  ).toLowerCase();

  const inputTokens = Number(
    rawUsage.prompt_tokens ??
    rawUsage.input_tokens ??
    usage.inputTokens ??
    0
  ) || 0;

  const visibleOutputTokens = Number(
    rawUsage.completion_tokens ??
    rawUsage.output_tokens ??
    usage.outputTokens ??
    0
  ) || 0;

  const totalTokens = Number(
    rawUsage.total_tokens ??
    usage.totalTokens ??
    (inputTokens + visibleOutputTokens)
  ) || 0;

  const explicitReasoningTokens = asNonNegativeNumber(
    rawUsage.completion_tokens_details?.reasoning_tokens ??
    rawUsage.output_tokens_details?.reasoning_tokens ??
    rawUsage.reasoning_tokens
  ) || 0;

  // completion_tokens/output_tokens already include reasoning on most APIs.
  // If total_tokens explicitly exceeds input + completion, the excess may
  // represent separately-reported tokens. Do not add reasoning twice.
  const unaccountedTokens = Math.max(0, totalTokens - inputTokens - visibleOutputTokens);
  const reasoningTokens = Math.max(explicitReasoningTokens, unaccountedTokens);
  const billableOutputTokens = visibleOutputTokens + unaccountedTokens;

  const hasAnyUsage = inputTokens > 0 || visibleOutputTokens > 0 || totalTokens > 0;

  // xAI: 1 USD = 1e10 cost ticks.
  const xaiTicks = asNonNegativeNumber(rawUsage.cost_in_usd_ticks);

  if (Number.isFinite(xaiTicks) && xaiTicks >= 0) {
    const usd = xaiTicks / 10_000_000_000;
    return {
      modelId: normalizedModel || String(modelId || ""),
      inputTokens,
      outputTokens: visibleOutputTokens,
      reasoningTokens,
      billableOutputTokens,
      totalTokens,
      usd,
      twd: usd * AI_COST_USD_TO_TWD_ESTIMATE,
      source: "provider_exact_xai_ticks",
    };
  }

  // OpenRouter can expose actual USD cost in usage.cost.
  const providerCost = asNonNegativeNumber(rawUsage.cost);
  if (Number.isFinite(providerCost) && providerCost >= 0) {
    const usd = providerCost;
    return {
      modelId: normalizedModel || String(modelId || ""),
      inputTokens,
      outputTokens: visibleOutputTokens,
      reasoningTokens,
      billableOutputTokens,
      totalTokens,
      usd,
      twd: usd * AI_COST_USD_TO_TWD_ESTIMATE,
      source: "provider_reported_usage_cost",
    };
  }

  let inputUsdPerMillion = null;
  let outputUsdPerMillion = null;

  if (normalizedModel.includes("gemini-3.1-pro")) {
    const longContext = inputTokens > 200_000;
    inputUsdPerMillion = longContext ? 4.0 : 2.0;
    outputUsdPerMillion = longContext ? 18.0 : 12.0;
  } else if (normalizedModel.includes("gemini-3-flash")) {
    inputUsdPerMillion = 0.50;
    outputUsdPerMillion = 3.00;
    } else if (normalizedModel.includes("claude-sonnet-5-5")) {
     inputUsdPerMillion = 2.0;
     outputUsdPerMillion = 10.0;
   } else if (normalizedModel.includes("moonshotai/kimi-k2.5") || normalizedModel === "kimi-k2.5") {
    // Reference only: OpenRouter displayed starting prices as of 2026-11-09.
    // Provider routing and cache discounts may change the billed amount.
    inputUsdPerMillion = 0.45;
    outputUsdPerMillion = 2.25;
  } else if (normalizedModel.includes("deepseek-v3.2")) {
    // Reference only: OpenRouter displayed starting prices as of 2026-11-09.
    inputUsdPerMillion = 0.2088;
    outputUsdPerMillion = 0.3096;
  } else if (normalizedModel.includes("grok-4.6")) {
    // Usually overridden by xAI's exact cost ticks above.
    const longContext = inputTokens >= 200_000;
    inputUsdPerMillion = longContext ? 4.0 : 2.0;
    outputUsdPerMillion = longContext ? 12.0 : 6.0;
  }

  if (
    inputUsdPerMillion == null ||
    outputUsdPerMillion == null
  ) {
    return {
      modelId: normalizedModel || String(modelId || ""),
      inputTokens,
      outputTokens: visibleOutputTokens,
      reasoningTokens,
      billableOutputTokens,
      totalTokens,
      usd: null,
      twd: null,
      source: "unknown_pricing",
    };
  }

  if (!hasAnyUsage) {
    return {
      modelId: normalizedModel || String(modelId || ""),
      inputTokens, outputTokens:visibleOutputTokens, reasoningTokens,
      billableOutputTokens, totalTokens, usd:null, twd:null,
      source:"missing_usage",
    };
  }

  const usd =
    (inputTokens / 1_000_000) * inputUsdPerMillion +
    (billableOutputTokens / 1_000_000) * outputUsdPerMillion;

  return {
    modelId: normalizedModel || String(modelId || ""),
    inputTokens,
    outputTokens: visibleOutputTokens,
    reasoningTokens,
    billableOutputTokens,
    totalTokens,
    usd,
    twd: usd * AI_COST_USD_TO_TWD_ESTIMATE,
    source: "token_estimate_including_reasoning",
  };
}

function formatAiCostTraceLine(cost) {
  const usdText = Number.isFinite(cost?.usd)
    ? `$${cost.usd.toFixed(6)}`
    : "N/A";

  const twdText = Number.isFinite(cost?.twd)
    ? `NT$${cost.twd.toFixed(3)}`
    : "N/A";

  return {
    model: cost?.modelId || "",
    inputTokens: cost?.inputTokens || 0,
    outputTokens: cost?.outputTokens || 0,
    reasoningTokens: cost?.reasoningTokens || 0,
    billableOutputTokens: cost?.billableOutputTokens || 0,
    totalTokens: cost?.totalTokens || 0,
    usd: usdText,
    twdApprox: twdText,
    source: cost?.source || "",
  };
}


return {estimateAiCallCost,formatAiCostTraceLine};
}
module.exports = {createAiCostTrace};
