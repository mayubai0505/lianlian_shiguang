'use strict';
// Original writer response sanitation, JSON recovery and voice extraction; no behavioral changes.
function createWriterResponseUtils() {
                                                                           function sanitizeWriterArtifacts(rawText) {
                                                                               if (!rawText || typeof rawText !== "string") return rawText;

                                                                               let text = String(rawText);

                                                                               // 只修高度確定是模型抖字／標點殘留的情況；
                                                                               // 不做廣泛「重複中文字壓縮」，避免誤傷「微微／慢慢／看看／人人」等正常中文。
                                                                               const safeFixes = [
                                                                                   [/，，+/g, "，"],
                                                                                   [/。。+/g, "。"],
                                                                                   [/！！+/g, "！"],
                                                                                   [/？？+/g, "？"],
                                                                                   [/（（+/g, "（"],
                                                                                   [/））+/g, "）"],
                                                                                   [/手手指/g, "手指"],
                                                                                   [/溫熱熱水/g, "溫熱水"],
                                                                                   [/浴室室/g, "浴室"],
                                                                                   [/居高臨下下/g, "居高臨下"],
                                                                                   [/有有壓迫感/g, "有壓迫感"],
                                                                                   [/安靜得得/g, "安靜得"],
                                                                                   [/視視線/g, "視線"],
                                                                                   [/伸手就能能/g, "伸手就能"],
                                                                                   [/還還怕/g, "還怕"],
                                                                                   [/誠實實/g, "誠實"],
                                                                                   [/調調暗/g, "調暗"],

                                                                                   // v2.3：正式鏈路實測抓到的生成抖字。
                                                                                   // 只處理極少數高風險重複字，避免誤傷「微微／慢慢／輕輕」等正常疊字。
                                                                                   [/躁鬱鬱/g, "躁鬱"],
                                                                                   [/他他(?=[起開把將拿伸抬轉走坐站看盯靠往])/g, "他"],
                                                                                   [/她她(?=[起開把將拿伸抬轉走坐站看盯靠往])/g, "她"],
                                                                                   [/妳妳(?=[的也還又就再才])/g, "妳"],
                                                                                   [/你你(?=[的也還又就再才])/g, "你"],
                                                                                   [/幾幾(?=[分秒句步次個])/g, "幾"],
                                                                                   [/得得(?=[些很更太像])/g, "得"],

                                                                                   // v2.3.2：第二輪正式鏈路抓到的漏網抖字。
                                                                                   [/隨意意(?=[交疊放靠坐站])/g, "隨意"],
                                                                                   [/的的(?=[事話人東西情況問題])/g, "的"],
                                                                                   [/招了了手/g, "招了手"],
                                                                                   [/兩顆顆(?=[冰糖藥珠球塊])/g, "兩顆"],

                                                                                   // v2.3.5：最新正式鏈路實測。
                                                                                   [/香水水(?=[瞬味氣混散撲])/g, "香水"],
                                                                                   [/指指(?=[尖腹節端])/g, "指"],
                                                                                   [/麼麼(?=[做近遠樣久])/g, "麼"],

                                                                                   // v2.3.7：完整鏈路實測的高確定性修復。
                                                                                   [/依舊舊著/g, "依舊帶著"],
                                                                                   [/線條條光影下/g, "線條在光影下"],
                                                                                   [/浮動動淡淡/g, "浮動著淡淡"],
                                                                                   [/總總不自覺/g, "總不自覺"],
                                                                                   [/眼神神卻/g, "眼神卻"],
                                                                               ];

                                                                               for (const [pattern, replacement] of safeFixes) {
                                                                                   text = text.replace(pattern, replacement);
                                                                               }

                                                                               // 偶發的 API / 生成殘片：獨立一個 n 被插在段落中。
                                                                               // 同時處理實際換行與字串化的 \\n 殘片。
                                                                               text = text
                                                                                   // 單獨佔一行的 n：不依賴前後換行一起被 regex 吃到。
                                                                                   .replace(/^[ \t]*n[ \t]*$/gm, "")
                                                                                   .replace(/(?:\r?\n|\\n)\s*n\s*(?:\r?\n|\\n)/g, "\n\n")
                                                                                   .replace(/\n{3,}/g, "\n\n");

                                                                               return text;
                                                                           }

                                                                           // ==================================================
                                                                           // 🧪 v2.3.3 Final Quality Guard
                                                                           // --------------------------------------------------
                                                                           // 不把「看到一個錯字就永久加一條 regex」當主要策略。
                                                                           // 先找出清理後仍殘留的可疑生成抖字；若尚有 retry 額度，
                                                                           // 讓 Writer 重生整份回覆。第二次仍殘留時才做最後保守壓縮。
                                                                           // ==================================================
                                                                           function findResidualWriterArtifacts(rawText) {
                                                                               const text = String(rawText || "");
                                                                               const issues = [];
                                                                               if (!text) return issues;

                                                                               // 不再以 AA 疊字本身當錯誤：正常中文、擬聲詞、角色口癖
                                                                               // 都可能含「死死／草草／將將」，不能只靠 regex 斷言不自然。
                                                                               // 只攔截明確的連續生成循環，例如 4 字以上同字連發，
                                                                               // 或同一個 2～12 字片語連續重複 >= 4 次（長片語 >= 3 次）。
                                                                               // 保留對單一奇怪詞的觀測，交由後續語言品質評估處理，
                                                                               // 不會因為「難難」就讓玩家整則回覆失敗。
                                                                               if (/([\u3400-\u9fff])\1{3,}/u.test(text)) {
                                                                                   issues.push("repeat:long-single-character-run");
                                                                               }

                                                                               if (/([\u3400-\u9fff]{2,3})\1{3,}/u.test(text)) {
                                                                                   issues.push("repeat:short-phrase-loop");
                                                                               }

                                                                               if (/([\u3400-\u9fff]{4,12})\1{2,}/u.test(text)) {
                                                                                   issues.push("repeat:long-phrase-loop");
                                                                               }

                                                                               // 一整句連續複製三遍以上，屬於高信心生成循環；
                                                                               // 短的「哈哈」「不要不要」不在這個檢測範圍。
                                                                               if (/([^。！？\n]{6,}[。！？])\s*\1\s*\1/u.test(text)) {
                                                                                   issues.push("repeat:sentence-loop");
                                                                               }

                                                                               if (/(?:\r?\n|\\n)\s*n\s*(?:\r?\n|\\n)/.test(text)) {
                                                                                   issues.push("orphan:n");
                                                                               }

                                                                               if (/[，。！？]{2,}/.test(text)) {
                                                                                   issues.push("duplicate:punctuation");
                                                                               }

                                                                               if (/\b(?:indifferently|suddenly|softly|quietly)\b/i.test(text)) {
                                                                                   issues.push("stray:english-adverb");
                                                                               }

                                                                               return [...new Set(issues)];
                                                                           }

                                                                           function compressResidualWriterArtifacts(rawText) {
                                                                               let text = sanitizeWriterArtifacts(String(rawText || ""));

                                                                               // 不做全域「非白名單中文字重複 → 單字」。
                                                                               // 這種壓縮可能把缺字型錯誤變成另一個錯字，例如
                                                                               // 「初初的旅人」會被錯壓成「初的旅人」。
                                                                               text = text
                                                                                   .replace(/\b(?:indifferently|suddenly|softly|quietly)\b/gi, "")
                                                                                   .replace(/[ \t]{2,}/g, " ")
                                                                                   .replace(/\n{3,}/g, "\n\n");

                                                                               return text.trim();
                                                                           }

                                                                           function extractQuotedJsonField(raw, fieldName) {
                                                                               const text = String(raw || "");
                                                                               const field = String(fieldName || "")
                                                                                   .replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

                                                                               const quoted = new RegExp(
                                                                                   `["']?${field}["']?\\s*:\\s*"((?:[^"\\\\]|\\\\.)*)"`,
                                                                                   "i"
                                                                               ).exec(text);

                                                                               if (quoted?.[1] != null) {
                                                                                   try {
                                                                                       return JSON.parse(`"${quoted[1]}"`);
                                                                                   } catch (_) {
                                                                                       return quoted[1]
                                                                                           .replace(/\\n/g, "\n")
                                                                                           .replace(/\\"/g, '"')
                                                                                           .replace(/\\\\/g, "\\");
                                                                                   }
                                                                               }

                                                                               return "";
                                                                           }

                                                                           function extractNumberJsonField(raw, fieldName) {
                                                                               const text = String(raw || "");
                                                                               const field = String(fieldName || "")
                                                                                   .replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

                                                                               const match = new RegExp(
                                                                                   `["']?${field}["']?\\s*:\\s*(-?\\d+(?:\\.\\d+)?)`,
                                                                                   "i"
                                                                               ).exec(text);

                                                                               return match ? Number(match[1]) : null;
                                                                           }

                                                                           function extractDialogueVoiceText(responseText) {
                                                                               const source = String(responseText || "");

                                                                               // v2.3.7：先移除旁白，再抽取「」。
                                                                               // 否則旁白中的音效（例如「砰」「噹」）也會被誤當角色台詞送進 TTS。
                                                                               const dialogueOnlySource = source
                                                                                   .replace(/（[\s\S]*?）/g, " ");

                                                                               const dialogues = [
                                                                                   ...dialogueOnlySource.matchAll(/「([\s\S]*?)」/g)
                                                                               ]
                                                                                   .map((m) => String(m[1] || "").trim())
                                                                                   .filter(Boolean);

                                                                               if (dialogues.length > 0) {
                                                                                   return dialogues.join(" ");
                                                                               }

                                                                               return dialogueOnlySource
                                                                                   .replace(/^時間：[^\r\n]*(?:\r?\n)地點：[^\r\n]*(?:\r?\n|$)/, "")
                                                                                   .replace(/^時間：.*?\|\s*地點：.*?(?:\r?\n|$)/, "")
                                                                                   .replace(/\s+/g, " ")
                                                                                   .trim()
                                                                                   .slice(0, 600);
                                                                           }

                                                                           function salvageMalformedWriterJson(rawContent, safePlayerName = "") {
                                                                               const safeContent = String(rawContent || "");

                                                                               const response = cleanAiResponseText(
                                                                                   safeContent,
                                                                                   safePlayerName
                                                                               );

                                                                               const voiceText =
                                                                                   extractQuotedJsonField(safeContent, "voiceText") ||
                                                                                   extractDialogueVoiceText(response);

                                                                               const affectionChange =
                                                                                   extractNumberJsonField(
                                                                                       safeContent,
                                                                                       "affectionChange"
                                                                                   );

                                                                               const storyTime =
                                                                                   extractQuotedJsonField(safeContent, "storyTime");

                                                                               const storyLocation =
                                                                                   extractQuotedJsonField(safeContent, "storyLocation");

                                                                               return {
                                                                                   response,
                                                                                   affectionChange:
                                                                                       Number.isFinite(affectionChange)
                                                                                           ? affectionChange
                                                                                           : 0,
                                                                                   voiceText,
                                                                                   ...(storyTime ? { storyTime } : {}),
                                                                                   ...(storyLocation ? { storyLocation } : {}),
                                                                               };
                                                                           }

                                                                           function cleanAiResponseText(raw, safePlayerName = "") {
                                                                                                                           if (!raw) return "";

                                                                                                                           let text = String(raw)
                                                                                                                               .replace(/```json/g, "")
                                                                                                                               .replace(/```/g, "")
                                                                                                                               .trim();

                                                                                                                           // 1. 完整 JSON：正常解析
                                                                                                                           try {
                                                                                                                               const parsed = JSON.parse(text);

                                                                                                                               if (parsed && typeof parsed === "object") {
                                                                                                                                   if (typeof parsed.response === "string") {
                                                                                                                                       text = parsed.response;
                                                                                                                                   } else if (typeof parsed.text === "string") {
                                                                                                                                       text = parsed.text;
                                                                                                                                   } else if (typeof parsed.message === "string") {
                                                                                                                                       text = parsed.message;
                                                                                                                                   }
                                                                                                                               } else if (typeof parsed === "string") {
                                                                                                                                   text = parsed;
                                                                                                                               }
                                                                                                                           } catch (e) {
                                                                                                                               // 不是完整 JSON，往下救
                                                                                                                           }

                                                                                                                           // 2. 救被截斷的格式
                                                                                                                           const responseMatch = text.match(/"?response"?\s*:\s*"([\s\S]*)/);
                                                                                                                           if (responseMatch && responseMatch[1]) {
                                                                                                                               text = responseMatch[1];
                                                                                                                           }

                                                                                                                           // 3. 清掉尾巴殘留欄位與轉義字元
                                                                                                                           text = text
                                                                                                                               .replace(/",?\s*"affectionChange"\s*:\s*[\s\S]*$/g, "")
                                                                                                                               .replace(/",?\s*"voiceText"\s*:\s*"[\s\S]*$/g, "")
                                                                                                                               .replace(/",?\s*"reasoning"\s*:\s*"[\s\S]*$/g, "")
                                                                                                                               .replace(/",?\s*"reasoning_details"\s*:\s*\[[\s\S]*$/g, "")
                                                                                                                               .replace(/"\s*}\s*$/g, "")
                                                                                                                               .replace(/\\n/g, "\n")
                                                                                                                               .replace(/\\"/g, '"');

                                                                                                                           // 🌟🌟🌟 總裁專屬防線：自動偵測並砍掉中途重複出現的第二組「時間／地點」標頭！
                                                                                                                           // 原理：用正則找出第二次出現的時間地點標頭，直接把後面重複的截掉或合併
                                                                                                                           const duplicateHeaderRegex = /((?:時間：[^\r\n]*\r?\n地點：[^\r\n]*)|(?:時間：[^\r\n]*\|\s*地點：[^\r\n]*))\n\n[\s\S]*?\1/;
                                                                                                                           if (duplicateHeaderRegex.test(text)) {
                                                                                                                               // 如果抓到它自己複製貼上兩次，我們保留第一次，把第二次以後的雜訊清掉
                                                                                                                               text = text.replace(duplicateHeaderRegex, "$1");
                                                                                                                           }

                                                                                                                           // 也可以用更暴力的保底：如果文字中出現兩次「時間：」，直接從第二個「時間：」切掉前半段重複的
                                                                                                                           const firstIndex = text.indexOf("時間：");
                                                                                                                           if (firstIndex !== -1) {
                                                                                                                               const secondIndex = text.indexOf("時間：", firstIndex + 3);
                                                                                                                               if (secondIndex !== -1) {
                                                                                                                                   // 代表它真的鬼打牆寫了兩次！我們只取第二段接續下去的精華，或者把第一段拔掉
                                                                                                                                   // 這裡我們把第二個「時間：」開頭到之間的廢話拔掉，讓它變成流暢的一段
                                                                                                                                   text = text.substring(0, secondIndex) + text.substring(text.indexOf("（", secondIndex));
                                                                                                                               }
                                                                                                                           }

                                                                                                                           text = text.replace(/玩家/g, safePlayerName);

                                                                                                                           // 玩家名稱是後端已知真值，因此可安全修復
                                                                                                                           // 「首字重複、第二字遺失」這種生成抖字。
                                                                                                                           // 例：初識的旅人 → 模型誤生為 初初的旅人。
                                                                                                                           if (safePlayerName && safePlayerName.length >= 2) {
                                                                                                                               const first = safePlayerName[0];
                                                                                                                               const suffix = safePlayerName.slice(2);

                                                                                                                               if (suffix) {
                                                                                                                                   const brokenName =
                                                                                                                                       `${first}${first}${suffix}`;

                                                                                                                                   text =
                                                                                                                                       text.split(brokenName)
                                                                                                                                           .join(safePlayerName);
                                                                                                                               }
                                                                                                                           }

                                                                                                                           return text.trim();
                                                                                                                       }


return { sanitizeWriterArtifacts, findResidualWriterArtifacts, compressResidualWriterArtifacts, extractQuotedJsonField, extractNumberJsonField, extractDialogueVoiceText, salvageMalformedWriterJson, cleanAiResponseText };
}
module.exports = {createWriterResponseUtils};
