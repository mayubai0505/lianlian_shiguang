'use strict';
const {literalCreatorStatus} = require('./literal_creator_status');
const {parseNamedStatus} = require('./creator_named_status');

// Shared by both chat paths. These values are never successful state data.
function isMissingStatusValue(value) {
  const text = String(value ?? '').trim().replace(/^[（(\s]+|[）)\s]+$/gu, '').trim();
  return !text || /^(?:[-—–─_…\.\s]+|未確認|未顯示|暫未確認|待更新|未知|不明|未設定|無資料|待確認|無法判斷|尚未確認|本輪狀態未能確認|N\/A|null|undefined)$/iu.test(text);
}

function blocks(status) {
  const result = [];
  for (const line of String(status || '').split('\n')) {
    const match = line.match(/^([^：:\n]+[：:][ \t]*)(.*)$/u);
    if (match && !/^[（(]/u.test(line.trim())) result.push({prefix:match[1], value:match[2], lines:[line]});
    else if (result.length) result[result.length - 1].lines.push(line);
  }
  return result;
}
function statusLabel(prefix) {
  return prefix.replace(/^[\s\-*•\p{Extended_Pictographic}\p{Emoji_Presentation}\uFE0F]+/u, '')
    .replace(/[：:\s]/gu, '');
}

function percentage(value) {
  const match = value.match(/(?:^|\s)(\d+(?:\.\d+)?)\s*[%％]/u);
  return match && Number(match[1]) <= 100 ? Number(match[1]) : null;
}

function incompleteStatusRow(row, template) {
  if (isMissingStatusValue(row.value)) return true;
  const namedField = parseNamedStatus(template)?.fields.find(field =>
    statusLabel(field.prefix) === statusLabel(row.prefix));
  if (namedField?.multiline) {
    const detail = row.lines.slice(1).join('\n').match(/[（(]([^（）()]+)[）)]/u)?.[1];
    if (!detail || isMissingStatusValue(detail)) return true;
  }
  const definition = blocks(template).find(field => statusLabel(field.prefix) === statusLabel(row.prefix));
  if (!definition) return false;
  const instruction = definition.value.split(/例如|範例|示例/u)[0];
  const requiresDescription = /[%％]/u.test(instruction) &&
    /[＋+]\s*(?:簡短)?(?:心理狀態|反應|描述|說明|心聲|心理描寫)/u.test(instruction);
  if (!requiresDescription) return false;
  const description = row.lines.join('\n').slice(row.prefix.length)
    .match(/[（(]([^（）()]+)[）)]/u)?.[1];
  return percentage(row.value) === null || !description ||
    isMissingStatusValue(description) || !/\p{L}/u.test(description);
}

function missingStatusRows(status, template = '') {
  const current = blocks(status);
  const missing = current.filter(row => incompleteStatusRow(row, template)).map(row => row.lines[0]);
  // Infer only layouts accepted by the existing unconditional-template parser.
  const baseline = literalCreatorStatus(template, '');
  if (baseline !== null) for (const row of blocks(baseline)) {
    if (!current.some(found => statusLabel(found.prefix) === statusLabel(row.prefix))) missing.push(row.lines[0]);
  }
  return missing;
}
// Inputs have already been aligned to the creator's template. Never replace a
// completed field, and keep multi-line repair details together with their row.
function mergeMissingStatus(status, repaired, template = '') {
  // Recreate missing fields from the template, without carrying old turn values.
  status = literalCreatorStatus(template, status) ?? status;
  const pending = new Set(missingStatusRows(status, template));
  const candidates = new Map(blocks(repaired).filter(row => !incompleteStatusRow(row, template))
    .map(row => [statusLabel(row.prefix), row.lines.join('\n').trimEnd()]));
  let skip = false;
  const output = [];
  for (const line of String(status).split('\n')) {
    const row = line.match(/^([^：:\n]+[：:][ \t]*)(.*)$/u);
    if (row && !/^[（(]/u.test(line.trim())) {
      let replacement = pending.has(line) && candidates.get(statusLabel(row[1]));
      if (replacement) replacement = row[1] + replacement.slice(replacement.indexOf(replacement.match(/[：:]/u)[0]) + 1).trimStart();
      // A description repair must preserve a percentage already shown this turn.
      const currentPercentage = percentage(row[2]);
      if (replacement && currentPercentage !== null) {
        replacement = replacement.replace(/([：:][ \t]*)\d+(?:\.\d+)?\s*[%％]/u,
          '$1' + currentPercentage + '%');
      }
      skip = Boolean(replacement);
      output.push(replacement || line);
    } else if (!skip) output.push(line);
  }
  return output.join('\n');
}
function markUnresolvedStatus(status) {
  return String(status).split('\n').map(line => {
    const row = line.match(/^([^：:\n]+[：:][ \t]*)(.*)$/u);
    return row && !/^[（(]/u.test(line.trim()) && isMissingStatusValue(row[2])
      ? row[1] + '本輪狀態未能確認' : line;
  }).join('\n');
}
function statusRepairTokens(template, missing) {
  return Math.min(3000, Math.max(900, (missing?.length || 1) * 160, Math.ceil(String(template || '').length * 0.6)));
}
const completionInstruction = [
  '你負責補齊創作者狀態欄，只輸出缺少欄位的純文字，保留欄名及多行格式，不輸出 JSON、程式碼框或正文。',
  'currentStatus 是本輪已完成欄位，不能更動。previousStatus 只是同房間歷史參考：依本輪玩家輸入與 scene 判斷變化，不得直接沿用過時時間、危機或心聲。',
  '數值欄需描述時，必須同時輸出數值與括號說明；本輪已有數值則保留它，只補描述。',
  '角色的心情、心聲、反應及創作者要求的虛構評量可依人物設定和本輪劇情合理生成，並非必須在正文逐字出現。不可因正文沒寫心聲就填未確認。角色不能知道未公開的秘密。',
  '第一輪優先採用創作者明確初始值；範例不是初始值。若創作者授權隨劇情更新的虛構評量未設起始值，可依其量尺和本輪劇情建立合理初值。既有有效數值則依事件增減，不任意重置。',
  '物品、地點、已發生事件及玩家資料必須有設定或劇情依據。未變動的既有事實可保留。不可為填欄新增玩家動作、對白、情緒、心聲或同意。',
  '空白、橫線、未確認及其他占位字都不是成功補值。若缺乏必要事實且不能合理生成，省略該缺欄讓系統辨識失敗，不得冒充已完成；不得把未知寫成沒有。',
].join('\n');
// Collapse adjacent copies only when an actual status field follows them.
function dedupeStatusHeading(text) {
  return text.replace(/^(?:[ \t]*---[ \t]*\r?\n(?:[ \t]*\r?\n)*)*([ \t]*【[^【】\r\n]{0,72}狀態欄】[ \t]*)(?:\r?\n(?:[ \t]*\r?\n|[ \t]*---[ \t]*\r?\n)*\1)*(?=\r?\n(?:[ \t]*\r?\n)*[^\r\n：:]{1,48}[：:])/gmu,
    (block, heading) => (/^[ \t]*---[ \t]*$/mu.test(block) ? '---\n' : '') + heading);
}

// The world writer emits narrative and status as separate segments.
function trimWorldStatusBoundary(segments, status) {
  const heading = status.match(/^(?:\s*---\s*)?\s*(【[^【】\r\n]{0,72}狀態欄】)(?=\s*\n)/u)?.[1];
  if (!heading) return;
  let hadSeparator = false;
  for (let i = segments.length - 1; i >= 0; i--) {
    const segment = segments[i];
    if (segment.kind !== 'narrator' || typeof segment.text !== 'string') break;
    const lines = segment.text.split(/\r?\n/u);
    let removed = false;
    while (lines.length) {
      const line = lines.at(-1).trim();
      if (line && line !== heading && line !== '---') break;
      if (line) removed = true;
      if (line === '---') hadSeparator = true;
      lines.pop();
    }
    if (!removed) break;
    if (lines.length) { segment.text = lines.join('\n').trimEnd(); break; }
    segments.splice(i, 1);
  }
  return hadSeparator && !status.trimStart().startsWith('---') ? '---\n' + status : status;
}
module.exports = {statusRepairTokens,dedupeStatusHeading,trimWorldStatusBoundary,isMissingStatusValue,missingStatusRows,mergeMissingStatus,markUnresolvedStatus,completionInstruction};
