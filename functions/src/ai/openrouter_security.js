"use strict";
// OpenRouter provider policy for 2026-11 security incident containment.
// Route constraints are applied to EVERY request path (including fallbacks).
const BLOCKED = Object.freeze(["gmicloud", "minimax"]);
function secureOpenRouterBody(body) {
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    throw new TypeError("OpenRouter request body must be an object");
  }
  // MiniMax-model requests can be forwarded to MiniMax by another provider.
  // Do not send these at all during the ongoing investigation.
  if (/(^|\/)minimax(?:\/|-|$)/i.test(String(body.model || ""))) {
    const error = new Error("MINIMAX_MODEL_BLOCKED_SECURITY_POLICY");
    error.code = "AI_PROVIDER_SECURITY_BLOCKED";
    throw error;
  }
  const previous = body.provider && typeof body.provider === "object" ? body.provider : {};
  const ignore = [...new Set([...(Array.isArray(previous.ignore) ? previous.ignore : []), ...BLOCKED])];
  return {...body, provider: {...previous, ignore}};
}
module.exports = {secureOpenRouterBody, BLOCKED};
