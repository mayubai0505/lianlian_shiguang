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
function missingStatusRows(status) {
  return blocks(status).filter(row => isMissingStatusValue(row.value)).map(row => row.lines[0]);
}
// Inputs have already been aligned to the creator's template. Never replace a
// completed field, and keep multi-line repair details together with their row.
function mergeMissingStatus(status, repaired) {
  const candidates = new Map(blocks(repaired).filter(row => !isMissingStatusValue(row.value))
    .map(row => [row.prefix.trim(), row.lines.join('\n').trimEnd()]));
  let skip = false;
  const output = [];
  for (const line of String(status).split('\n')) {
    const row = line.match(/^([^：:\n]+[：:][ \t]*)(.*)$/u);
    if (row && !/^[（(]/u.test(line.trim())) {
      const replacement = isMissingStatusValue(row[2]) && candidates.get(row[1].trim());
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
const completionInstruction = '只補指定缺欄，保留創作者欄名、順序與格式，不新增欄位、不重寫正文。依創作者規則與已確認的本輪劇情填寫；不得代替玩家新增動作或心聲。不得填空白、橫線或占位符。沒有證據不得捏造數值、物品或事件，也不得把不知道寫成沒有；確實無法確認時填「本輪狀態未能確認」。';
module.exports = {isMissingStatusValue,missingStatusRows,mergeMissingStatus,markUnresolvedStatus,completionInstruction};
