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



// Preserve only the creator's *literal presentation prefix* (emoji, symbols,
// kaomoji, punctuation, authored labels). Never transplant a template value,
// instruction, or placeholder into generated story state.
const TEMPLATE_SEPARATOR = /[：:]/u;
const LITERAL_DECORATION = /[^\p{L}\p{N}\s]/u;
const GENERATED_PREFIX = /^\s*([^\n：:]{1,48})\s*([：:])(.*)$/u;

function creatorStatusRows(template) {
  return String(template || '').replace(/\r\n?/g, '\n').split('\n')
    .map(raw => {
      const match=raw.match(GENERATED_PREFIX);
      if (!match) return null;
      const prefix=match[1];
      // The template may contain instructional sentences or merely samples.
      // Only protect authored *symbolic* prefixes, not full arbitrary text.
      if (!LITERAL_DECORATION.test(prefix) || isCreatorGuidance(raw)) return null;
      if (PLACEHOLDER.test(prefix)) return null;
      return {prefix:prefix.trim(), separator:match[2], raw};
    }).filter(Boolean);
}

function generatedStatusRows(generated) {
  return String(generated || '').replace(/\r\n?/g, '\n').split('\n')
    .map((raw,index) => {
      const match=raw.match(GENERATED_PREFIX);
      return match && !isCreatorGuidance(raw)
        ? {index, raw, prefix:match[1].trim(), separator:match[2], value:match[3]}
        : null;
    }).filter(Boolean);
}

function protectCreatorStatusSymbols(template, generated) {
  const rows=creatorStatusRows(template);
  if (!rows.length || !String(generated || '').trim()) return generated;
  const input=String(generated).replace(/\r\n?/g,'\n').split('\n');
  const outputRows=generatedStatusRows(generated);
  if (!outputRows.length) return generated;

  // If *all* output fields match the template field count, order is reliable
  // even when a model translated an emoji into 'Zombie'. Never attempt this
  // alignment if conditional sections added or removed fields.
  const sameCount=rows.length === outputRows.length;
  const hasAnchor=rows.length === 1 || outputRows.some((r,i)=>r.prefix===rows[i]?.prefix);
  const reordered=outputRows.some((r,i)=>r.prefix!==rows[i]?.prefix && rows.some((t,j)=>j!==i && t.prefix===r.prefix));
  const fullAlignment=sameCount && hasAnchor && !reordered;
  const used=new Set();
  for (let i=0;i<outputRows.length;i++) {
    const current=outputRows[i];
    let expected=null;
    if (fullAlignment) expected=rows[i];
    else {
      // With conditional layouts, change only prefixes that match exactly.
      // No guessing from index: that could attach the wrong icon to a field.
      const candidates=rows.filter((r,j)=>!used.has(j) && r.prefix===current.prefix);
      if (candidates.length===1) expected=candidates[0];
    }
    if (!expected) {
      // An AI may prepend a translated English name to an unchanged authored
      // symbol, e.g. "Zombie🧟". Match by the exact creator prefix suffix,
      // only when it identifies one unique creator row. Never translate text.
      const candidates=rows.filter((r,j)=>!used.has(j) &&
        r.prefix!==current.prefix && current.prefix.endsWith(r.prefix) &&
        /^[\p{Script=Latin}\s_-]{1,48}$/u.test(current.prefix.slice(0,-r.prefix.length)));
      if(candidates.length===1)expected=candidates[0];
    }
    if (!expected) continue;
    const templateIndex=rows.indexOf(expected);
    used.add(templateIndex);
    // Keep model-generated value exactly, including natural-language contents.
    // Preserve the author's original field name / emoji and its separator.
    const leading=current.raw.match(/^\s*/u)?.[0] || '';
    input[current.index]=leading+expected.prefix+expected.separator+current.value;
  }
  return input.join('\n');
}

// Use only a validated server clock to refresh explicit time fields. Do not
// change decorative text, dialogue, free-form dynamic columns or date-only rows.
// A time field has to be a standalone line; a compound row is left unchanged.
function applyServerStatusTime(template, generated, timeText) {
  const clock=String(timeText||'').trim();
  if(!clock || clock==='尚未確認')return generated;
  const source=String(generated||'');
  const templateLines=String(template||'').split(/\r?\n/u);
  const timeHeader=/^\s*(?:(?:[\p{Extended_Pictographic}\u2600-\u27BF]\uFE0F?\s*)?(?:時間|時刻|故事時間|目前時間|現在時間|日期時間)|(?:📅|📆|🗓️?|⏰|🕒))\s*[:：]/u;
  const hasTimeField=templateLines.some(line=>timeHeader.test(line));
  if(!hasTimeField)return generated;
  // A creator may combine day, time and location on one row. Keep the
  // location/other fields unchanged, and change only a recognizable time token.
  const serverClock=clock.match(/(?:^|\s|，)([01]?\d|2[0-3])[:：]([0-5]\d)\s*$/u);
  if(!serverClock)return generated; // Ancient branches and unknown clocks stay untouched.
  const hhmm=`${serverClock[1].padStart(2,'0')}:${serverClock[2]}`;
  // The displayed fictional day must agree with the persisted server clock.
  // Preserve the creator's original 日/天 suffix; only change an explicit
  // fictional day token. Do not touch arbitrary narrative prose or locations.
  const fictionalDay=clock.match(/^第([零〇一二兩三四五六七八九十百千\d]{1,8})[日天][，,、\s]+(?:[01]?\d|2[0-3])[:：][0-5]\d$/u)?.[1] || '';
  return source.split('\n').map(line=>{
    const m=line.match(/^(\s*[^\n：:]{1,48}[：:]\s*)(.*)$/u);
    if(!m||!timeHeader.test(line))return line;
    const body=m[2];
    const split=body.match(/^([^｜|]*)([｜|].*)?$/u);
    if(!split)return line;
    let leading=split[1];
    const tail=split[2]||'';
    // The model may silently jump to 第二天 while the server remains on
    // 第一天. Correct only an explicitly labeled fictional day inside a
    // recognized status time row, keeping all surrounding formatting.
    if(fictionalDay) {
      leading=leading.replace(/^(\s*)第[零〇一二兩三四五六七八九十百千\d]{1,8}([日天])(?=\s*[,，、])/u,
        (_,spaces,unit)=>`${spaces}第${fictionalDay}${unit}`);
    }
    // Keep fictional day labels; overwrite only the numeric clock or a bare
    // daypart when the backend already knows an exact current time.
    const numeric=/(?:[01]?\d|2[0-3])[:：][0-5]\d/u;
    if(numeric.test(leading)) {
      leading=leading.replace(numeric,hhmm);
    } else if(/^(?:\s*第[零〇一二兩三四五六七八九十百千\d]{1,8}[日天]\s*[,，、]?\s*)?(?:上午|早上|下午|晚上|凌晨|中午|傍晚|清晨)(?:[。．.!！]?\s*)$/u.test(leading.trim())) {
      leading=leading.replace(/(?:上午|早上|下午|晚上|凌晨|中午|傍晚|清晨)/u,hhmm);
    } else {
      return line;
    }
    return m[1]+leading+tail;
  }).join('\n');
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
  return applyServerStatusTime(template, protectCreatorStatusSymbols(template, out.join('\n').trim()), options.timeText).slice(0,10000);
}
module.exports={parseFields, lockCreatorStatus, describeCreatorTemplate, isCreatorGuidance, protectCreatorStatusSymbols};
