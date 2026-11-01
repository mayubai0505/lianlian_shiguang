'use strict';
// 原樣移出 core.js 的供應商回應有效性判定，未修改原邏輯。
function isAiContentFiltered(result) {
  return (
    result?.choices?.some(
      (choice) => {
        const finishReason = String(
          choice?.finish_reason || ""
        ).toLowerCase();

        return (
          finishReason.includes("content_filter") ||
          finishReason.includes("prohibited_content") ||
          finishReason.includes("safety")
        );
      }
    ) === true
  );
}

function hasUsableAiContent(result) {
  if (!result?.choices?.length) return false;

  return result.choices.some((choice) => {
    const content = choice?.message?.content;

    if (typeof content === "string") {
      return content.trim().length > 0;
    }

    if (Array.isArray(content)) {
      return content.some((part) => {
        if (typeof part === "string") {
          return part.trim().length > 0;
        }

        const text = String(
          part?.text ||
          part?.content ||
          ""
        ).trim();

        return text.length > 0;
      });
    }

    return false;
  });
}

function isAiTimeoutError(error) {
  const message =
    String(error?.message || "").toLowerCase();

  return (
    message.includes("回覆時間太久") ||
    message.includes("timeout") ||
    message.includes("timed out")
  );
}


module.exports = {isAiContentFiltered, hasUsableAiContent, isAiTimeoutError};
