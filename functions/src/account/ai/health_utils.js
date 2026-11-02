'use strict';

// Pure AI health statistics helpers extracted from core.js.
function getAiHealthTaipeiDateKey(date = new Date()) {
  const parts = new Intl.DateTimeFormat(
    "en-US",
    {
      timeZone: "Asia/Taipei",
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
    }
  ).formatToParts(date);

  const values = {};

  for (const part of parts) {
    if (
      part.type === "year" ||
      part.type === "month" ||
      part.type === "day"
    ) {
      values[part.type] = part.value;
    }
  }

  return `${values.year}-${values.month}-${values.day}`;
}

function extractAiUsage(result) {
  const usage = result?.usage || {};

  const inputTokens = Number(
    usage.prompt_tokens ??
    usage.input_tokens ??
    0
  );

  const outputTokens = Number(
    usage.completion_tokens ??
    usage.output_tokens ??
    0
  );

  const totalTokens = Number(
    usage.total_tokens ??
    inputTokens + outputTokens
  );

  return {
    inputTokens:
      Number.isFinite(inputTokens)
        ? Math.max(0, Math.trunc(inputTokens))
        : 0,

    outputTokens:
      Number.isFinite(outputTokens)
        ? Math.max(0, Math.trunc(outputTokens))
        : 0,

    totalTokens:
      Number.isFinite(totalTokens)
        ? Math.max(0, Math.trunc(totalTokens))
        : 0,
  };
}

module.exports = {getAiHealthTaipeiDateKey, extractAiUsage};
