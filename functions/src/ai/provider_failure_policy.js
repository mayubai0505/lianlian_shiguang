'use strict';
// Common provider failure classification. Never use another model to bypass a refusal.
function isCancelled(error, signal) {
  return Boolean(signal?.aborted || ['PLAYER_DISCONNECTED','cancelled','CANCELLED'].includes(error?.code) || error?.message === 'PLAYER_DISCONNECTED');
}
function isSafetyFailure(error) {
  const result = error?.result;
  const blockReason = String(result?.promptFeedback?.blockReason || '');
  if (blockReason && blockReason !== 'BLOCK_REASON_UNSPECIFIED') return true;
  const codes = [error?.code, error?.message, result?.promptFeedback?.blockReason,
    ...(Array.isArray(error?.finishReasons) ? error.finishReasons : []),
    ...(Array.isArray(result?.choices) ? result.choices.map(c => c?.finish_reason) : [])];
  const upstream = Array.isArray(result) ? result[0]?.error : result?.error;
  if (typeof upstream === 'string') codes.push(upstream);
  else if (upstream) codes.push(upstream.code, upstream.type, upstream.message, upstream.status);
  if (Array.isArray(result?.choices) && result.choices.some(c => c?.message?.refusal)) return true;
  return codes.some(v => /AI_CONTENT_FILTERED|content[_ -]?filter|prohibited[_ -]?content|\bsafety\b|safety[_ -]?policy|policy[_ -]?violation|moderation|blocked[_ -]?content|blocklist|\bSPII\b|recitation|image[_ -]?safety|model[_ -]?armor|\brefusal\b|cannot (?:help|assist|comply)|can['’]t (?:help|assist|comply)/i.test(String(v || '')));
}
function mayFallbackProvider(error, signal) {
  if (!error || isCancelled(error, signal) || isSafetyFailure(error)) return false;
  const status = Number(error.statusCode || error.status || 0);
  // Unknown 403 may be a policy refusal. Only explicitly identified billing/credit errors qualify.
  if (status === 403) {
    const upstream = Array.isArray(error.result) ? error.result[0]?.error : error.result?.error;
    const detail = [error.message, typeof upstream === 'string' ? upstream : upstream?.message].join(' ');
    return /used all available credits|monthly spending limit|prepayment credits are depleted|insufficient credits|insufficient balance/i.test(detail);
  }
  if (status >= 400 && status <= 599) return true;
  if (['AI_TIMEOUT','AI_NETWORK_ERROR','AI_EMPTY_RESPONSE','AI_INVALID_RESPONSE','AI_PROVIDER_BUSY'].includes(error.code)) return true;
  if (/AI 回覆時間太久|AI 服務暫時忙碌|AI 連線暫時不穩|AI 回傳格式異常|AI 斷線或沒有回傳 choices/.test(String(error.message || ''))) return true;
  // Unclassified local programming exceptions are not a provider outage.
  return false;
}
module.exports = {isCancelled, isSafetyFailure, mayFallbackProvider};
