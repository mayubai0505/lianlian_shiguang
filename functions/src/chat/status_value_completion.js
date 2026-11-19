'use strict';

// Shared by both chat paths. These values are never successful state data.
function isMissingStatusValue(value) {
  const text = String(value ?? '').trim().replace(/^[（(\s]+|[）)\s]+$/gu, '').trim();
  return !text || /^(?:[-—–─_…\.\s]+|未知|不明|未設定|無資料|待確認|無法判斷|尚未確認|本輪狀態未能確認|N\/A|null|undefined)$/iu.test(text);
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
  return blocks(status).filter(row => incompleteStatusRow(row, template)).map(row => row.lines[0]);
}
// Inputs have already been aligned to the creator's template. Never replace a
// completed field, and keep multi-line repair details together with their row.
function mergeMissingStatus(status, repaired, template = '') {
  const pending = new Set(missingStatusRows(status, template));
  const candidates = new Map(blocks(repaired).filter(row => !incompleteStatusRow(row, template))
    .map(row => [row.prefix.trim(), row.lines.join('\n').trimEnd()]));
  let skip = false;
  const output = [];
  for (const line of String(status).split('\n')) {
    const row = line.match(/^([^：:\n]+[：:][ \t]*)(.*)$/u);
    if (row && !/^[（(]/u.test(line.trim())) {
      let replacement = pending.has(line) && candidates.get(row[1].trim());
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
const completionInstruction = '只補指定缺欄。若創作者要求百分比加括號描述，兩者必須同時輸出，保留本輪已有百分比並補上符合本輪劇情的描述。保留創作者欄名、順序與格式，不新增欄位、不重寫正文。依創作者規則與已確認的本輪劇情填寫；不得代替玩家新增動作或心聲。不得填空白、橫線或占位符。沒有證據不得捏造數值、物品或事件，也不得把不知道寫成沒有；確實無法確認時填「本輪狀態未能確認」。';
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
module.exports = {dedupeStatusHeading,trimWorldStatusBoundary,isMissingStatusValue,missingStatusRows,mergeMissingStatus,markUnresolvedStatus,completionInstruction};
