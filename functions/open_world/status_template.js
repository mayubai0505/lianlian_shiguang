'use strict';
// Creator templates are free-form presentation guides, not a schema.
// Keep AI-generated layout/emoji/kaomoji intact and remove only clearly leaked instructions.
const CONTROL = /(?:reasoning_content|userRequestSummary|系統提示詞|內部提示詞|隱藏篇章|世界完整設定|檢查系統提示|回顧系統提示|現在開始正式寫作|於封禁狀態)/iu;
const NOTE_START = /^(?:請(?:在|用|依|先|把|將|根據)|(?:依照|根據)(?:劇情|當前|情況)|(?:此欄位|本欄位)(?:只|需|應)|(?:每回合|每輪)(?:都|要)|(?:不要|不可|不得|必須)(?:輸出|顯示|加入)|(?:範例|填寫規則|輸出規則|格式要求|備註)\s*[:：])/u;
const STRONG_GUIDANCE = /(?:一句話(?:形容|描述)(?:.{0,30})(?:狀態|情況)|適時加入(?:角色|事件)|(?:選擇|擇一)(?:以下|其中)?(?:選項|狀態)|(?:選項|狀態)[（(][^\n（）()]{1,100}[／/][^\n（）()]{1,100}[）)])/u;
const CHOICE_PHRASE = /[（(][^\n()（）]{1,70}(?:未勃起|完全勃起|半勃起|半硬|極硬)[^\n()（）]{0,70}[）)]/u;
const PLACEHOLDER = /(?:YYYY\s*[/.-]\s*MM\s*[/.-]\s*(?:NN|DD)|\bHH\s*[:：]\s*MM\b|\bXX\s*\/\s*XX\b)/iu;
const LEADING_DECOR = /^[\s\p{Extended_Pictographic}\u2600-\u27BF\uFE0F\u200D\uFE0E♡♥❤☆★♪♫ღ◇◆○●■□│┃║|｜\-─━═]+/u;

function isCreatorGuidance(value) {
  const text = String(value || '').trim();
  if (!text) return false;
  if (CONTROL.test(text)) return true;
  const body = text.replace(LEADING_DECOR, '').trim();
  // Full author instructions and unfilled choice menus, not harmless words such as 請 in dialogue.
  if (NOTE_START.test(body) && /(?:顯示|描述|字內|角色|劇情|格式|條|產生|輪迴|分隔|加入|內心話)/u.test(body)) return true;
  if (STRONG_GUIDANCE.test(body) || CHOICE_PHRASE.test(body)) return true;
  if (/[：:]\s*請(?:在|依|用|將|把)[^\n]{0,100}(?:字內|描述|顯示|產生|分隔|根據劇情)/u.test(body)) return true;
  if (/(?:隨機事件|角色進入劇情)[^\n]{0,50}(?:適時|加入)/u.test(body)) return true;
  return false;
}

function templateBlocks(template) {
  return String(template || '').replace(/\r\n?/g, '\n').split('\n').map(s => s.trim()).filter(Boolean);
}

function parseFields(template) {
  // Advisory labels only; never use this list as a whitelist that deletes other free-form sections.
  return templateBlocks(template).map((line, index) => {
    const explicit = line.match(/^([^：:\n]{1,50})[：:]/u);
    // For unnamed layouts, use a stable ordinal label rather than parsing HH:MM as field HH.
    const heading = explicit && !/^(?:📅)?\s*\d{1,4}[/-]|\bHH\s*$/iu.test(explicit[1])
      ? explicit[1].trim() : `自由區塊${index + 1}`;
    return {name:heading,time:/^(?:時間|日期時間|故事時間|目前時間)$/u.test(heading),date:/^(?:日期|故事日期|目前日期)$/u.test(heading)};
  });
}

function describeCreatorTemplate(template) {
  const blocks = templateBlocks(template);
  return {fields: parseFields(template).map(f => f.name), instructions: blocks.map((line, i) => ({
    field:`區塊${i+1}`, guidance:line.slice(0,600),
  }))};
}

function lockCreatorStatus(template, generated, options={}) {
  if (!String(template || '').trim()) return '';
  const source = String(generated || '').replace(/\r\n?/g, '\n');
  const templateLines = new Set(templateBlocks(template));
  const out=[];
  for (const line of source.split('\n')) {
    const trimmed = line.trim();
    if (!trimmed) {if(out.length && out[out.length-1] !== '') out.push(''); continue;}
    if (CONTROL.test(line)) continue;
    if (isCreatorGuidance(line)) continue;
    // Don't print unfilled template lines verbatim. Preserve purely decorative lines.
    if (templateLines.has(trimmed) && (PLACEHOLDER.test(trimmed) || /(?:請|描述|顯示|根據|根據劇情|讀取過去劇情|二十字|一百字|字內|違反規則：讀取)/u.test(trimmed))) continue;
    // Reject copied format placeholders only when they're evidently still unfilled.
    if (PLACEHOLDER.test(trimmed) && /(?:根據劇情|YYYY|HH\s*[:：]\s*MM)/iu.test(trimmed)) continue;
    out.push(line);
  }
  return out.join('\n').trim().slice(0,10000);
}
module.exports={parseFields, lockCreatorStatus, describeCreatorTemplate, isCreatorGuidance};
