"use strict";
// V3：只辨識創作者「自訂結尾狀態欄」，不改寫正文、人物設定與 JSON statusBar。
// 未成立的條件欄位不屬於必填；無條件的欄位必須全部保留（不再只檢查前兩欄）。
const DIRECTIVE_HEADING = /^\s*(?:#{1,6}\s*)?(?:每回合|每輪|以下為|狀態欄格式|固定生成|【?狀態欄規則)/u;
const FIELD = /^\s*([^\r\n：:]{1,48})\s*[：:]\s*(.*)$/u;
const CONDITIONAL = /(?:隱藏|不顯示|不輸出|省略該欄|不要顯示|才顯示|才輸出|有(?:比賽|賽事|勃起|事件)時)/u;
// A creator's condition can be rephrased by the model; these are never player-facing state values.
const HIDE_DIRECTIVE = /(?:未勃起|無勃起|沒有勃起|無其他\s*NPC|沒有其他\s*NPC|無\s*NPC|沒有\s*NPC|無人(?:在場|發言)|(?:自動|應|需|請)?\s*(?:隱藏|不顯示|不輸出|省略))(?:.{0,25}(?:隱藏|不顯示|不輸出))?/iu;
const PURE_NO_NPC = /^[（(]?\s*(?:無|沒有)(?:其他)?\s*NPC(?:在場|發言|出現)?\s*[）)]?$/iu;
function isHideInstruction(value) {
  const v=String(value||'').trim();
  if (!v) return false;
  if (PURE_NO_NPC.test(v)) return true;
  // Only treat a negative condition as hiding when it is written as an instruction,
  // not when a legitimate dynamic status says e.g. '目前未勃起' as game data.
  return /(?:隱藏|不顯示|不輸出|省略)/u.test(v) && HIDE_DIRECTIVE.test(v);
}
const TEMPLATE_INSTRUCTION = /^(?:\s*[（(]?\s*)(?:無.{0,36}(?:隱藏|不顯示|不輸出)|若.{0,60}(?:隱藏|不顯示|不輸出|才顯示|才輸出)|(?:此欄|該欄|此狀態欄).{0,50}(?:隱藏|不顯示|不輸出)|請(?:系統|描述|依|輸出|填寫)|顯示目前|自動不顯示)/u;
const GENERIC_INSTRUCTION = /^\s*(?:#{1,6}\s*)?(?:每回合固定生成|每輪固定生成|請系統|請描述|請依|若當前|此狀態欄自動不顯示)/u;

function canonicalLabel(label) {
  return String(label || "")
    .normalize("NFKC")
    .replace(/[\uFE0E\uFE0F\u200B-\u200D]/gu, "")
    .replace(/[\s\u3000]/gu, "")
    .replace(/[：:]+$/u, "")
    .trim();
}
function parseTemplate(template) {
  const fields = [];
  let insideNpcDetailSection = false;
  for (const sourceLine of String(template || "").split(/\r?\n/)) {
    const line = sourceLine.trim();
    if (!line || DIRECTIVE_HEADING.test(line) || /^[-=—_]{3,}$/.test(line)) continue;
    const match = line.match(FIELD);
    if (!match) continue;
    const label = match[1].trim();
    const sample = match[2].trim();
    // 「💭內心：」和「📱群組：」底下常有 NPC 名稱當範例，
    // 並非創作者要求每輪所有 NPC 都逐一發言／提供內心話。
    // 僅在這類區塊中忽略非 Emoji 的 NPC 子行，不影響一般文字欄位。
    const emojiHeading = /^[\p{Extended_Pictographic}\p{Emoji_Presentation}]/u.test(label);
    if (emojiHeading) {
      insideNpcDetailSection = /(?:內心|群組|聊天|對話|訊息|聊天室|心聲)/u.test(label) || (!sample && /^(?:💭|📱)/u.test(label));
    } else if (insideNpcDetailSection) {
      if (/^(?:日期|時間|地點|位置|天氣|衣著|服裝|關係|好感度|心情|狀態)$/u.test(label)) {
        insideNpcDetailSection = false;
      } else {
        continue;
      }
    }
    if (!label || /^\s*(?:規則|範例|說明|格式)/.test(label)) continue;
    const optional = CONDITIONAL.test(sample);
    if (!fields.some(f => canonicalLabel(f.label) === canonicalLabel(label))) fields.push({label, optional});
  }
  return fields;
}
function extractLabel(line) {
  const match = String(line).match(FIELD);
  return match ? {label: match[1].trim(), value: match[2].trim()} : null;
}
function isPlaceholder(value) {
  const v = String(value || "").trim();
  if (!v) return false;
  const plain = v.replace(/^[（(\s]+|[）)\s]+$/g, "").trim();
  return isHideInstruction(plain) || TEMPLATE_INSTRUCTION.test(plain) || /^無.{0,32}(?:隱藏|不顯示|不輸出)$/u.test(plain);
}
// Only for creator-defined footer text. Do not strip normal story/dialogue.
const META_LINE = /^(?:範例(?:[⬇↓:]|$)|示範(?:對話|如下|[：:]|$)|(?:[-•]\s*)?(?:成員固定為|依劇情生成|每次顯示|不必四人|可包含|可發貼圖|男性請使用|女性用|不得重複|禁止全部|嚴禁顯示|若無NPC|若無比賽|限\d+字|\(?\{char\}內心話))/u;
const INLINE_META = /(?:若無.{0,30}(?:不顯示|隱藏)|若沒有.{0,30}(?:不顯示|隱藏)|無.{0,20}則不顯示|(?:比賽進度即時更新|當前場景在場所有角色心裡話|每人一段禁止|禁止全部疊在一起|嚴禁顯示|\{char\}內心話|限\d+字內|每次顯示\d+|成員固定為|依劇情生成|不得重複一樣的話題))/u;
const normalizeSample = str => String(str || "").normalize("NFKC").replace(/\s+/gu, "").trim();
function createCustomStatusGuard(template) {
  const fields = parseTemplate(template);
  // Template examples are reference material, not dialogue to publish verbatim.
  const sampleLines = new Set();
  let insideExample = false;
  let groupSample = false;
  for (const raw of String(template || "").split(/\r?\n/)) {
    const line = raw.trim();
    if (/^範例(?:[⬇↓:]|$)/u.test(line) || /^示範(?:對話|如下|[：:]|$)/u.test(line)) {
      insideExample = true;
      continue;
    }
    const field = extractLabel(line);
    if (field && /^[\p{Extended_Pictographic}\p{Emoji_Presentation}]/u.test(field.label)) {
      groupSample = insideExample && /(?:群組|聊天|對話|訊息|聊天室|老二出廠)/u.test(field.label);
      insideExample = false;
      continue;
    }
    if (META_LINE.test(line)) groupSample = false;
    if ((insideExample || groupSample) && line && !META_LINE.test(line)) sampleLines.add(normalizeSample(line));
  }
  const labels = new Set(fields.map(f => canonicalLabel(f.label)));
  const required = fields.filter(f => !f.optional);
  // Creator-defined multi-message chat requirements are structural, not merely a nonempty field.
  // E.g. 「每次顯示2–5則訊息」: one isolated message is an incomplete group footer.
  const countMatch = String(template || '').match(/每次顯示\s*([2-9])\s*(?:[-–—~～至到]\s*\d+)?\s*則/u);
  const groupMinimum = countMatch ? Number(countMatch[1]) : 1;
  const isGroupField = label => /(?:📱|群組|群聊|聊天室|家庭群|老二出廠)/u.test(String(label || ''));
  function pruneIncompleteGroupBlocks(lines) {
    if (groupMinimum <= 1) return lines;
    const result = [];
    for (let i=0;i<lines.length;) {
      const field=extractLabel(lines[i]);
      if (!field || !labels.has(canonicalLabel(field.label)) || !isGroupField(field.label)) {
        result.push(lines[i++]);
        continue;
      }
      const block=[lines[i++]];
      while (i<lines.length) {
        const other=extractLabel(lines[i]);
        if (other && labels.has(canonicalLabel(other.label))) break;
        block.push(lines[i++]);
      }
      // Only actual speaker:message pairs count, never examples, blank lines, or instructions.
      const speakerMessages=block.slice(1).filter(line => {
        const pair=extractLabel(line);
        return pair && pair.label.length <= 24 && pair.value && !unknownValue(pair.value)
          && !isPlaceholder(pair.value) && !INLINE_META.test(pair.value)
          && !sampleLines.has(normalizeSample(line));
      });
      if (speakerMessages.length >= groupMinimum) result.push(...block);
    }
    return result;
  }
  function footerStart(lines) {
    // 必須是行首的狀態欄標籤，不匹配正文中提到的 Emoji 或欄名。
    // 從最後一個狀態欄連續區段搜尋，兼容條件欄被隱藏、群組聊天包含多行。
    const hits = [];
    for (let i = 0; i < lines.length; i++) {
      const part = extractLabel(lines[i]);
      if (part && labels.has(canonicalLabel(part.label))) hits.push(i);
    }
    if (!hits.length) return -1;
    // 檢查最後區段以避免誤把正文內的「時間：」當作結尾狀態欄。
    const last = hits[hits.length - 1];
    let start = hits[0];
    for (let j=hits.length-2;j>=0;j--) {
      if (hits[j+1] - hits[j] > 45) { start = hits[j+1]; break; }
    }
    // 如無自訂欄位標籤，絕不修改。
    return start <= last ? start : -1;
  }
  function statusParts(text) {
    const lines = String(text || "").split(/\r?\n/);
    const start = footerStart(lines);
    return {lines,start};
  }
  const unknownValue = v => /^(?:未知|不明|未設定|無資料|待確認|N\/A|無法判斷)$/iu.test(String(v || "").trim().replace(/^[（(\s]+|[）)\s]+$/gu, ""));
  function missing(text) {
    if (!required.length) return [];
    const {lines:startLines,start} = statusParts(text);
    const lines = pruneIncompleteGroupBlocks(startLines);
    if (start < 0) return required.map(f=>f.label);
    const cleanStart = footerStart(lines);
    if (cleanStart < 0) return required.map(f=>f.label);
    const tail = lines.slice(cleanStart);
    return required.filter(f => !tail.some((line, i) => {
      const value = extractLabel(line);
      if (!value || canonicalLabel(value.label) !== canonicalLabel(f.label)) return false;
      if (value.value && !unknownValue(value.value) && !isPlaceholder(value.value) && !INLINE_META.test(value.value)) return true;
      // 群組/內心標題常見「💭內心：\n溫梨：...」；下一行有真正內容即算完整。
      if (value.value && (unknownValue(value.value) || isPlaceholder(value.value))) return false;
      for (let j=i+1;j<tail.length;j++) {
        const next=tail[j].trim();
        if (!next) continue;
        const nextField=extractLabel(next);
        if (nextField && labels.has(canonicalLabel(nextField.label))) break;
        if (DIRECTIVE_HEADING.test(next) || GENERIC_INSTRUCTION.test(next) || META_LINE.test(next) || INLINE_META.test(next) || sampleLines.has(normalizeSample(next))) continue;
        return true;
      }
      return false;
    })).map(f=>f.label);
  }
  function validate(text) {
    return !missing(clean(text)).length;
  }
  function clean(text) {
    const {lines,start} = statusParts(text);
    if (start < 0) return String(text || "").trim();
    const next=[];
    let inExample=false;
    let suppressedConditional=false;
    // A blank 💭 field followed by '(無其他NPC在場，不顯示)' is a single hidden block.
    // The legacy parser only inspected the same line and leaked the next-line directive.
    for (let i=0;i<lines.length;i++) {
      const raw=lines[i];
      const stripped=raw.trim();
      if (i < start && !(i >= start-3 && DIRECTIVE_HEADING.test(stripped))) {
        next.push(raw);
        continue;
      }
      if (DIRECTIVE_HEADING.test(stripped) || GENERIC_INSTRUCTION.test(stripped)) continue;
      const part=extractLabel(raw);
      if (part && labels.has(canonicalLabel(part.label))) {
        inExample=false;
        suppressedConditional=false;
        const field=fields.find(f => canonicalLabel(f.label)===canonicalLabel(part.label));
        const value=part.value;
        // Unknown is not a confirmed state: remove the placeholder rather than publishing it.
        if (unknownValue(value)) { suppressedConditional=true; continue; }
        let nextNonEmpty='';
        if (!value) {
          for(let j=i+1;j<lines.length;j++) {
            const candidate=lines[j].trim();
            if (!candidate) continue;
            nextNonEmpty=candidate;
            break;
          }
        }
        // Never render a hidden field, irrespective of whether parseTemplate
        // recognized the creator's condition as optional.
        if (isHideInstruction(value) || (!value && isHideInstruction(nextNonEmpty))) {
          suppressedConditional=true;
          continue;
        }
        const explanatory=Boolean(isPlaceholder(value) || INLINE_META.test(value) || META_LINE.test(value));
        if (explanatory && field?.optional) {
          suppressedConditional=true;
          continue;
        }
        next.push(explanatory ? `${part.label}：` : raw);
        continue;
      }
      if (suppressedConditional) {
        // Consume a hidden block's explanatory lines, never arbitrary story text.
        if (!stripped || isHideInstruction(stripped) || META_LINE.test(stripped) || INLINE_META.test(stripped)) continue;
        suppressedConditional=false;
      }
      if (/^範例(?:[⬇↓:]|$)/u.test(stripped) || /^示範(?:對話|如下|[：:]|$)/u.test(stripped)) {
        inExample=true;
        continue;
      }
      if (META_LINE.test(stripped) || INLINE_META.test(stripped) || isHideInstruction(stripped)) continue;
      if (inExample) continue;
      if (sampleLines.has(normalizeSample(stripped))) continue;
      next.push(raw);
    }
    return pruneIncompleteGroupBlocks(next).join("\n").replace(/\n{3,}/g,"\n\n").trim();
  }
  // V5.7.15: merge individually validated new footer blocks with valid old
  // blocks. A repair must not erase a legitimate relation or inner thought just
  // because it failed to generate one unrelated group chat.
  function mergeRepair(originalText, repairText) {
    const prior = clean(originalText);
    const candidate = clean(repairText);
    const priorLines = prior.split(/\r?\n/);
    const newLines = candidate.split(/\r?\n/);
    function blocks(lines) {
      const start = footerStart(lines);
      const found = new Map();
      if (start < 0) return found;
      for (let i = start; i < lines.length;) {
        const field = extractLabel(lines[i]);
        const key = field ? canonicalLabel(field.label) : '';
        if (!field || !labels.has(key)) { i++; continue; }
        const block = [lines[i++]];
        while (i < lines.length) {
          const next = extractLabel(lines[i]);
          if (next && labels.has(canonicalLabel(next.label))) break;
          block.push(lines[i++]);
        }
        const chunk = block.join('\n');
        // The status guard checks 2-5 message requirements; a partial group
        // never replaces another group's valid complete content.
        if (!missing(chunk).includes(field.label)) found.set(key, chunk);
      }
      return found;
    }
    const oldBlocks = blocks(priorLines);
    const newBlocks = blocks(newLines);
    const body = bodyOnly(prior).trimEnd();
    const output = [];
    for (const field of fields) {
      const key = canonicalLabel(field.label);
      const value = newBlocks.get(key) || oldBlocks.get(key);
      if (value) output.push(value);
    }
    const combined = clean([body, ...output].filter(Boolean).join('\n\n'));
    return { text: combined, missing: missing(combined), complete: validate(combined),
      restoredFields: fields.filter(f => !newBlocks.has(canonicalLabel(f.label)) && oldBlocks.has(canonicalLabel(f.label))).map(f => f.label) };
  }
  // AI 專用修復仍未成功時的「零額外 API」保底：
  // 保留已生成的正文與合法欄位，只補真正缺漏的非條件欄位。
  // 優先使用上一輪可靠值；無可靠依據則留缺欄並記錄降級，不向玩家輸出「未知」。
  function salvage(text, previousText = "", context = {}) {
    let working = clean(text);
    const pending = missing(working);
    if (!pending.length) return {text: working, added: [], complete: true};
    const priorLines = String(previousText || "").split(/\r?\n/);
    const currentLines = working.split(/\r?\n/);
    function existingValue(label, lines) {
      const wanted = canonicalLabel(label);
      for (let i = lines.length - 1; i >= 0; i--) {
        const field = extractLabel(lines[i]);
        if (!field || canonicalLabel(field.label) !== wanted || isPlaceholder(field.value)) continue;
        if (field.value) return field.value;
        const replies = [];
        for (let j = i + 1; j < lines.length; j++) {
          const next = lines[j].trim();
          if (!next) continue;
          const labelAtNext = extractLabel(next);
          if (labelAtNext && labels.has(canonicalLabel(labelAtNext.label))) break;
          if (DIRECTIVE_HEADING.test(next) || GENERIC_INSTRUCTION.test(next) || META_LINE.test(next) || INLINE_META.test(next) || sampleLines.has(normalizeSample(next))) continue;
          replies.push(lines[j]);
        }
        if (replies.length) return `\n${replies.join("\n")}`;
      }
      return "";
    }
    const linesToAdd = [];
    const unresolved = [];
    for (const label of pending) {
      const normalized = canonicalLabel(label);
      let value = "";
      if (/^(?:📅|日期|時間)$/u.test(normalized)) value = String(context.time || "").trim();
      if (/^(?:📍|地點|位置)$/u.test(normalized)) value = String(context.location || "").trim();
      // Dynamic blocks cannot be copied from the previous round as fresh events.
      const dynamic = /(?:群組|聊天|對話|訊息|聊天室|內心|心聲|老二出廠)/u.test(normalized);
      if (!value && !dynamic) value = existingValue(label, priorLines);
      if (unknownValue(value)) value = "";
      if (!value) { unresolved.push(label); continue; }
      linesToAdd.push(`${label}：${value}`);
    }
    if (linesToAdd.length) working = `${working.trimEnd()}\n${linesToAdd.join("\n")}`;
    return {text: clean(working), added: linesToAdd.map(line => line.split("：")[0]), unresolved, complete: validate(working)};
  }
  // V5.7.3: only copy confirmed prior STATE values, never prior narrative or creator examples.
  // A completed previous reply is not permission to replay its events as today's story.
  function carryForward(text, previousText = "", context = {}) {
    const current = clean(text);
    const previous = clean(previousText);
    if (!previous || !fields.length) return {text: current, reused: []};
    const priorLines = previous.split(/\r?\n/);
    const currentLines = current.split(/\r?\n/);
    const currentStart = footerStart(currentLines);
    const priorStart = footerStart(priorLines);
    if (currentStart < 0 || priorStart < 0) return {text: current, reused: []};
    const priorFields = new Map();
    for (let i = priorStart; i < priorLines.length; i++) {
      const f = extractLabel(priorLines[i]);
      if (!f || !labels.has(canonicalLabel(f.label))) continue;
      const value = f.value.trim();
      if (!value || isPlaceholder(value) || INLINE_META.test(value) || META_LINE.test(value)
          || /^(?:未知|不明|未設定|無資料|待確認|N\/A|無法判斷)$/iu.test(value)
          || sampleLines.has(normalizeSample(priorLines[i]))) continue;
      priorFields.set(canonicalLabel(f.label), value);
    }
    const evidence = String(context.evidence || "");
    // Only explicit narrative changes justify changing a previously established outfit.
    // This does not invent a new outfit and never modifies the player.
    const changedClothing = /(?:換上|換成|換了|換裝|換衣|改穿|穿上|穿著換成|脫下|脫掉|套上|披上|改成穿)/u.test(evidence);
    const stableAppearance = /(?:服裝|穿著|穿搭|衣著|衣服|上衣|下身|褲子|裙子|外套|鞋子|造型|髮型|髮色|外貌|配戴|飾品)/u;
    const changingAppearance = /(?:染髮|剪髮|理髮|綁髮|紮髮|摘下|戴上|取下|卸妝|化妝)/u.test(evidence);
    const reused = [];
    for (let i = currentStart; i < currentLines.length; i++) {
      const currentField = extractLabel(currentLines[i]);
      if (!currentField) continue;
      const key = canonicalLabel(currentField.label);
      if (!labels.has(key) || !priorFields.has(key)) continue;
      if (/^(?:📅|📍|時間|日期|地點|位置)$/u.test(key)) continue;
      // Do not overwrite chat messages, character thoughts, relationship scores or dynamic events.
      if (/(?:群組|聊天|對話|訊息|內心|心聲|好感|賽事|比賽|心情|情緒)/u.test(key)) continue;
      const value = currentField.value.trim();
      const absent = !value || isPlaceholder(value) || /^(?:未知|不明|未設定|無資料|待確認)$/u.test(value);
      const isAppearance = stableAppearance.test(key);
      const noEvidenceOfChange = isAppearance && !(changedClothing || changingAppearance);
      if (!absent && !noEvidenceOfChange) continue;
      if (value === priorFields.get(key)) continue;
      currentLines[i] = `${currentField.label}：${priorFields.get(key)}`;
      reused.push(currentField.label);
    }
    return {text: clean(currentLines.join("\n")), reused};
  }
  function bodyOnly(text) {
    const lines = String(text || "").split(/\r?\n/);
    const start = footerStart(lines);
    return (start < 0 ? lines : lines.slice(0, start)).join("\n");
  }
  return {fields,missing,validate,clean,salvage,carryForward,bodyOnly,mergeRepair};
}
module.exports={createCustomStatusGuard};
