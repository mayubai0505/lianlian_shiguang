'use strict';
const {parseNamedStatus,renderNamedStatus} = require('./creator_named_status');

// Only infer a layout when every line is an unconditional scalar field or
// decoration. Instruction manuals and nested transcripts have their own guards.
function literalCreatorStatus(template, status, context = {}) {
  const named = parseNamedStatus(template);
  if (named) return renderNamedStatus(named,status);
  let rows = String(template || '').trim().split(/\r?\n/u);
  // An explicit mandatory list may follow narrative instructions. Only its
  // contiguous final emoji rows define the visible fields.
  const mandatoryIndex = rows.findIndex(line =>
    /每次回覆/u.test(line) && /不可省略任何一項/u.test(line) &&
    /狀態欄/u.test(line));
  let heading = '';
  let separator = false;
  const authoredValues = new Map();
  const conditional = /隱藏|不顯示|不輸出|僅在|只有|觸發|如果|若|查詢|才顯示|才輸出|HIDDEN|QUERY/iu;
  if (mandatoryIndex >= 0) {
    const instruction = rows[mandatoryIndex];
    const candidate = rows.slice(mandatoryIndex + 1).filter(line => line.trim());
    if (conditional.test(rows.slice(0, mandatoryIndex + 1).join('\n')) ||
        !candidate.length || candidate.some(line =>
          !/^\s*[\p{Extended_Pictographic}\p{Emoji_Presentation}]/u.test(line) ||
          !/^[^：:\n]{1,48}[：:]/u.test(line.trim()) ||
          conditional.test(line))) return null;
    rows = candidate;
    heading = instruction.match(/【([^】]*狀態欄)】/u)?.[0] || '';
    separator = /分隔線\s*---/u.test(instruction);
  }
  const field = /^(\s*([^：:\n]{1,48}?)[ \t]*[：:][ \t]*)(.*)$/u;
  const complex = /隱藏|不顯示|不輸出|省略|秘密|條件|僅在|只有|觸發|如果|若|查詢|指令|範例|示範|規則|備註|說明|群組|群聊|聊天室|每回合|分行|下一行|HIDDEN|QUERY|\b(?:if|when|only|example)\b/iu;
  if (mandatoryIndex < 0 && complex.test(template)) return null;
  const layout = [];
  const keys = new Set();
  for (const raw of rows) {
    if (/^[\s─━—=_*-]*$/u.test(raw)) {
      layout.push({raw});
      continue;
    }
    const match = raw.match(field);
    if (!match || /[。！？【】「」]/u.test(match[2]) || /當.+時|才顯示|才輸出/u.test(raw)) return null;
    const key = match[2].trim();
    if (!key || keys.has(key)) return null;
    keys.add(key);
    layout.push({key, prefix:match[1]});
    authoredValues.set(key, match[3].trim());
  }
  if (!keys.size) return null;
  const values = new Map();
  for (const raw of String(status || '').split(/\r?\n/u)) {
    if (/^[\s─━—=_*-]*$/u.test(raw)) continue;
    if (heading && raw.trim() === heading) continue;
    const match = raw.match(field);
    if (!match) return null; // Preserve multi-line content for its existing renderer.
    const key = match[2].trim();
    const normalized = key.replace(/^[\p{Extended_Pictographic}\uFE0F｜|\s]+/u,'');
    const target = keys.has(key) ? key : [...keys].find(k => k.replace(/^[\p{Extended_Pictographic}\uFE0F｜|\s]+/u,'') === normalized && normalized);
    if (target && !values.get(target)) {
      const value = match[3].trim();
      const copiedInstruction = mandatoryIndex >= 0 &&
        value === authoredValues.get(target) && /例如|精準顯示|即時新增|用一句話|隨行動|數值＋/u.test(value);
      if (!copiedInstruction) values.set(target,value);
    }
  }
  const rendered = layout.map(item => {
    if (!item.key) return item.raw;
    const label = item.key.replace(/^[\p{Extended_Pictographic}\uFE0F｜|\s]+/u,'');
    let value = values.get(item.key);
    if (!value && /^(?:時間|故事時間|時刻)$/u.test(label)) value=context.time;
    if (!value && /^(?:位置|地點)$/u.test(label)) value=context.location;
    return item.prefix + (value || '—');
  }).join('\n');
  return [separator ? '---' : '', heading, rendered].filter(Boolean).join('\n');
}
module.exports = {literalCreatorStatus};
