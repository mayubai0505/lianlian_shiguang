'use strict';
// Chat message / history formatting helpers. Extracted without changing the existing logic.
function createHistoryUtils({fixMojibake}) {
function limitPromptText(
                              text,
                              maxLength,
                              preserveTail = false
                          ) {
                              if (!text || typeof text !== "string") return "";

                              const cleaned = fixMojibake(text)
                                  .replace(/�/g, "")
                                  .trim();

                              if (cleaned.length <= maxLength) {
                                  return cleaned;
                              }

                              // 劇情／沉浸的 AI 歷史：
                              // 保留前段正文，也保留尾端狀態欄。
                              if (preserveTail) {
                                  const tailLength = Math.min(
                                      350,
                                      Math.floor(maxLength * 0.6)
                                  );

                                  const headLength =
                                      maxLength - tailLength - 4;

                                  const head = cleaned
                                      .slice(0, headLength)
                                      .trim();

                                  const tail = cleaned
                                      .slice(-tailLength)
                                      .trim();

                                  return `${head}\n……\n${tail}`;
                              }

                              const suffix = "……";

                              return cleaned
                                  .slice(0, maxLength - suffix.length)
                                  .trim() + suffix;
                          }
function normalizeDailyAssistantHistory(content) {
                                      let text = String(content || "").trim();

                                      text = text.replace(
                                          /（([^（）]+)）\s*([^「\n][^\n]*)/g,
                                          (match, action, dialogue) => {
                                              const cleanDialogue = String(dialogue || "").trim();

                                              if (!cleanDialogue) {
                                                  return `（${action}）`;
                                              }

                                              return `（${action}）\n\n「${cleanDialogue}」`;
                                          }
                                      );

                                      return text;
                                  }
function duplicateReplyFingerprint(value) {
                                      return String(value || "")
                                          .replace(
                                              /^\s*時間\s*[：:][^\r\n]*\r?\n\s*地點\s*[：:][^\r\n]*\r?\n?/i,
                                              ""
                                          )
                                          .replace(/\s+/g, "")
                                          .trim()
                                          .slice(0, 360);
                                  }
return {limitPromptText, normalizeDailyAssistantHistory, duplicateReplyFingerprint};
}
module.exports = {createHistoryUtils};
