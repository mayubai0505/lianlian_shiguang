'use strict';

const FIELD = /^(\s*(?:[-*•]\s*)?([^：:\n]{1,48}?)[ \t]*[：:][ \t]*)(.*)$/u;
const HEADING = /^\s*【([^】]+)】\s*$/u;
const CONDITIONAL = /隱藏|不顯示|不輸出|僅在|才顯示|才輸出|查詢後|查詢時/u;

function labelKey(label) {
  return String(label).replace(/^[\s\-*•\p{Extended_Pictographic}\p{Emoji_Presentation}\uFE0F｜|]+/u, '').replace(/\s/gu, '');
}

// The first named display block defines fields. Later rule sections only
// describe how values change; they do not declare additional display fields.
function parseNamedStatus(template) {
  const lines = String(template || '').split(/\r?\n/u);
  const start = lines.findIndex(line => {
    const match = line.match(HEADING);
    return match && /狀態欄$/u.test(match[1]) && !/規則|說明|範例/u.test(match[1]);
  });
  if (start < 0) return null;
  const fields = [];
  for (const line of lines.slice(start + 1)) {
    if (HEADING.test(line)) break;
    if (!line.trim()) continue;
    if (CONDITIONAL.test(line)) return null;
    const match = line.match(FIELD);
    if (match && !/^[（(]/u.test(line.trim())) {
      const key = labelKey(match[2]);
      if (!key || fields.some(field => field.key === key)) return null;
      fields.push({key, label:match[2].trim(), prefix:match[1], multiline:false});
    } else if (fields.length && /^[（(].*[）)]\s*$/u.test(line.trim())) {
      fields[fields.length - 1].multiline = true;
    } else {
      return null;
    }
  }
  return fields.length ? {heading:lines[start].trim(),fields} : null;
}

function renderNamedStatus(spec, status) {
  const values = new Map();
  let active = null;
  for (const line of String(status || '').split(/\r?\n/u)) {
    if (!line.trim()) continue;
    if (HEADING.test(line)) { active = null; continue; }
    const row = line.match(FIELD);
    if (row && !/^[（(]/u.test(line.trim())) {
      const key = labelKey(row[2]);
      active = spec.fields.find(field => field.key === key) || null;
      if (active && !values.has(key)) values.set(key, [row[3].trim()]);
      else active = null;
      continue;
    }
    // Only creator-authored multi-line slots accept a parenthesized detail.
    // Other headings, extra fields and their continuations terminate the slot.
    if (active?.multiline && /^[（(].*[）)]\s*$/u.test(line.trim())) {
      values.get(active.key).push(line.trim());
    } else {
      active = null;
    }
  }
  return [spec.heading,...spec.fields.map(field => {
    const parts = values.get(field.key) || ['—'];
    return field.prefix + (parts[0] || '—') +
      (parts.length > 1 ? '\n' + parts.slice(1).join('\n') : '');
  })].join('\n');
}

function formatNamedStatusReply(template, reply) {
  const spec = parseNamedStatus(template);
  if (!spec) return null;
  const lines = String(reply || '').split(/\r?\n/u);
  let start = lines.findIndex(line => line.trim() === spec.heading);
  if (start < 0) start = lines.findIndex(line => {
    const row = line.match(FIELD);
    return row && spec.fields.some(field => field.key === labelKey(row[2]));
  });
  // Some replies replace the entire footer with unrelated emoji fields.
  // Accept only a contiguous, clearly structured tail, never dialogue/prose.
  const emojiField = /^\s*(?:[-*•]\s*)?[\p{Extended_Pictographic}\p{Emoji_Presentation}][^：:\n]{0,48}[：:]/u;
  const candidates = lines.map((line,index) => emojiField.test(line) ? index : -1)
    .filter(index => index >= 0 && (start < 0 || index < start));
  for (const candidate of candidates) {
    const tail = lines.slice(candidate);
    const fieldCount = tail.filter(line => emojiField.test(line)).length;
    const structured = tail.every(line => !line.trim() || FIELD.test(line) ||
      HEADING.test(line) || /^[（(].*[）)]\s*$/u.test(line.trim()) ||
      /^[-─━—=_*]+$/u.test(line.trim()));
    if (fieldCount >= 2 && structured) { start = candidate; break; }
  }
  if (start < 0) return null; // Let the existing missing-status repair run.
  while (start > 0 && !lines[start - 1].trim()) start--;
  if (start > 0 && lines[start - 1].trim() === spec.heading) start--;
  const body = lines.slice(0,start).join('\n').trimEnd();
  return [body,renderNamedStatus(spec,lines.slice(start).join('\n'))]
    .filter(Boolean).join('\n\n');
}
module.exports = {parseNamedStatus,renderNamedStatus,formatNamedStatusReply};
