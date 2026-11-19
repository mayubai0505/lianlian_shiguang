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
  const safetyMarker = v => /AI_CONTENT_FILTERED|content[_ -]?filter|prohibited[_ -]?content|\bsafety\b|safety[_ -]?policy|policy[_ -]?violation|moderation|blocked[_ -]?content|blocklist|\bSPII\b|recitation|image[_ -]?safety|model[_ -]?armor|\brefusal\b|cannot (?:help|assist|comply)|can['’]t (?:help|assist|comply)/i.test(String(v || ''));
  if (codes.some(safetyMarker)) return true;
  // Some HTTP clients preserve upstream metadata in response.data rather than result.
  // Inspect structured refusal metadata only; never inspect or log player/chat text.
  for (const payload of [result, error?.response?.data]) {
    const items = Array.isArray(payload) ? payload : [payload];
    for (const item of items) {
      if (!item || typeof item !== 'object') continue;
      const block = String(item.promptFeedback?.blockReason || '');
      if (block && block !== 'BLOCK_REASON_UNSPECIFIED') return true;
      const upstreamError = item.error;
      const metadata = [item.code, item.type, item.status, item.finish_reason, item.finishReason,
        typeof item.message === 'string' ? item.message : '',
        typeof upstreamError === 'string' ? upstreamError : upstreamError?.code,
        upstreamError?.type, upstreamError?.status, upstreamError?.message];
      if (metadata.some(safetyMarker)) return true;
      for (const choice of Array.isArray(item.choices) ? item.choices : []) {
        if (choice?.message?.refusal || safetyMarker(choice?.finish_reason)) return true;
      }
      for (const candidate of Array.isArray(item.candidates) ? item.candidates : []) {
        if (safetyMarker(candidate?.finishReason) ||
            (Array.isArray(candidate?.safetyRatings) && candidate.safetyRatings.some(r => r?.blocked === true))) return true;
      }
    }
  }
  return false;
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
// World writer uses its own bounded tier loop. Keep the ordinary chat fallback
// decision above unchanged for existing non-world callers.
function classifyWorldProviderFailure(error, signal) {
  const status = [error?.statusCode, error?.status, error?.response?.status]
    .map(Number).find(value => Number.isInteger(value) && value >= 100 && value <= 599) || null;
  const code = String(error?.code || '');
  const classification = (allowFallback, reason) => ({allowFallback, reason, statusCode:status});
  if (isCancelled(error, signal)) return classification(false, 'cancelled');
  if (!error) return classification(false, 'unclassified_error');
  if (isSafetyFailure(error)) return classification(false, 'provider_content_filtered');
  if (status === 451) return classification(false, 'provider_legal_restriction');
  if (status === 403) {
    // Unknown forbidden may be legal/policy-related. Only explicit account,
    // credential or billing failures can use a different provider.
    const values = [error.result, error.response?.data].flatMap(item =>
      Array.isArray(item) ? item : [item]);
    const metadata = [code, error.message];
    for (const item of values) {
      const upstream = item?.error;
      metadata.push(item?.code, item?.type, item?.status,
        typeof upstream === 'string' ? upstream : upstream?.message,
        upstream?.code, upstream?.type, upstream?.status);
    }
    const billing = /used all available credits|monthly spending limit|prepayment credits are depleted|insufficient credits|insufficient balance|insufficient[_ ]quota|billing[_ ]hard[_ ]limit[_ ]reached|credit[_ ]balance[_ ]exhausted|payment[_ ]required/i;
    const credentials = /invalid[_ ]api[_ ]key|api[_ ]key[_ ](?:invalid|expired|not[_ ]valid)|api key (?:is |was )?(?:invalid|expired|not valid)|authentication[_ ]error|invalid[_ ]credentials|expired[_ ]credentials|invalid[_ ]authentication[_ ]credentials|incorrect api key|\bUNAUTHENTICATED\b/i;
    if (metadata.some(v => billing.test(String(v || '')))) return classification(true, 'provider_billing');
    if (metadata.some(v => credentials.test(String(v || '')))) return classification(true, 'provider_credentials');
    return classification(false, 'provider_forbidden_unclassified');
  }
  if (status === 402) return classification(true, 'provider_billing');
  if (status === 401) return classification(true, 'provider_credentials');
  if (status === 429) return classification(true, 'provider_rate_limited');
  if (status === 408 || status === 504) return classification(true, 'provider_timeout');
  if (status >= 500 && status <= 599) return classification(true, 'provider_http_5xx');
  // Preserve existing HTTP 4xx fallback for non-refusal provider errors.
  if (status >= 400 && status <= 499) return classification(true, 'provider_http_4xx');
  const transportCodes = [code, String(error?.cause?.code || '')];
  if (transportCodes.some(v => ['AI_TIMEOUT','ETIMEDOUT','ECONNABORTED','ERR_SOCKET_TIMEOUT',
    'UND_ERR_CONNECT_TIMEOUT','UND_ERR_HEADERS_TIMEOUT','UND_ERR_BODY_TIMEOUT'].includes(v)) ||
    /AI 回覆時間太久|\b(?:timeout|timed out)\b/i.test(String(error.message || ''))) {
    return classification(true, 'provider_timeout');
  }
  if (transportCodes.some(v => ['AI_NETWORK_ERROR','ECONNRESET','ECONNREFUSED','EPIPE',
    'ENOTFOUND','EAI_AGAIN','ENETUNREACH','EHOSTUNREACH','ERR_NETWORK','UND_ERR_SOCKET',
    'ERR_TLS_CERT_ALTNAME_INVALID','CERT_HAS_EXPIRED','UNABLE_TO_VERIFY_LEAF_SIGNATURE'].includes(v)) ||
    /^(?:fetch failed|network error|socket hang up)$/i.test(String(error.message || '').trim()) ||
    /AI 連線暫時不穩/.test(String(error.message || ''))) {
    return classification(true, 'provider_network');
  }
  if (code === 'AI_EMPTY_RESPONSE' || code === 'AI_INVALID_RESPONSE' ||
    /AI 回傳格式異常|AI 斷線或沒有回傳 choices/.test(String(error.message || ''))) {
    return classification(true, 'provider_invalid_response');
  }
  if (code === 'AI_PROVIDER_BUSY' || /AI 服務暫時忙碌/.test(String(error.message || ''))) {
    return classification(true, 'provider_busy');
  }
  // Do not turn programming exceptions into model calls.
  return classification(false, 'unclassified_error');
}
module.exports = {isCancelled, isSafetyFailure, mayFallbackProvider, classifyWorldProviderFailure};
