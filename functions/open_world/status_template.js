'use strict';
// Keep creator-authored visible labels, order and decoration. Never render notes as values.
const LABEL = /^(\s*(?:[-*•]\s*)?)([^：:\n｜|]{1,36}?)(\s*[:：]\s*)(.*)$/u;
const TIME_LABEL = /^(?:時間|日期時間|故事時間|當前時間|目前時間)$/u;
const DATE_LABEL = /^(?:日期|故事日期|當前日期|目前日期)$/u;
const INSTRUCTION = /(?:希望|請|依劇情|每回合|每輪|推進|顯示|使用|格式|自動|更新|進行|不可|不要|以.+(?:時辰|分鐘)|設定|字內|例如|舉例|視情況|需承接|不准|必須|開始|個別對玩家|一句真實內心話)/u;
const UNSAFE = /(?:nickname|identity|reasoning_content|userRequestSummary|請系統|請描述|顯示目前|系統提示詞|內部提示詞|隱藏篇章|世界完整設定)/iu;
const EMOJI = /[\p{Extended_Pictographic}\u2600-\u27BF\uFE0F]/u;
const KAOMOJI = /(?:[（(][^\n]{1,30}[）)]|[♡♥❤☆★♪♫ღ])/u;
const PLACEHOLDER = /^(?:未確認|不確定|未知|無|待確認|待更新|XX(?:\/XX)*|hh:mm|\.{2,}|…+|[-—_]+)$/iu;
// Describe intent to the writer without allowing creator notes to become visible values.
// The writer interprets free-form instructions; server-side rendering validates labels/values.
function describeCreatorTemplate(template) {
  const fields=parseFields(template);
  const lines=String(template||'').replace(/\r/g,'').split('\n');
  const result=[];let active='';
  for(const line of lines) {
    const fs=fieldsInLine(line);
    if(fs.length){
      for(const f of fs){
        active=f.name;
        result.push({field:f.name, guidance:String(f.sample||'').trim().slice(0,350)});
      }
    } else if(active && line.trim() && !isDecoration(line)) {
      const last=result[result.length-1];
      if(last && last.field===active) last.guidance=(last.guidance+'\n'+line.trim()).slice(0,600);
    }
  }
  return {fields:fields.map(f=>f.name),instructions:result};
}

function cleanInstructionNotes(value) {
  let text=String(value||'').trim();
  // Remove parenthetical author instructions, not normal character dialogue.
  text=text.replace(/[（(]([^()（）]{1,180})[）)]/gu,(whole,inner)=>INSTRUCTION.test(inner)||/\b(?:XX|hh:mm)\b/iu.test(inner)?'':whole);
  // Common author shorthand for sample dates/times and rule blocks.
  text=text.replace(/\s+\d{2,4}\/XX\/XX.*$/giu,'');
  text=text.replace(/(?:\d{2,4}\/XX\/XX\s*[（(][^)）]*[）)]|\d{2,4}\/XX\/XX|\bhh:mm\b)/giu,'');
  return text.replace(/\s{2,}/gu,' ').trim();
}
function fieldsInLine(line) {
  // '｜' is a column separator only if its right side starts another named field.
  const pieces=String(line).split(/\s*[｜|]\s*(?=[^｜|：:\n]{1,36}[：:])/u);
  return pieces.map(part=>{
    const match=part.match(LABEL);
    if(!match)return null;
    const name=match[2].trim();
    if(!name || INSTRUCTION.test(name) || UNSAFE.test(name))return null;
    const bareName=name.replace(/^[^\p{Script=Han}\p{Letter}]+/gu,'').trim();
    return {name,time:TIME_LABEL.test(bareName),date:DATE_LABEL.test(bareName),prefix:match[1],separator:match[3],sample:match[4]};
  }).filter(Boolean);
}
function parseFields(template) {
  const fields=[],seen=new Set();
  for(const line of String(template||'').replace(/\r/g,'').split('\n')) {
    for(const f of fieldsInLine(line)) {
      if(seen.has(f.name))continue;
      seen.add(f.name);fields.push({name:f.name,time:f.time,date:f.date});
    }
  }
  return fields;
}
function safeLine(raw) {
  const v=cleanInstructionNotes(raw).trim();
  if(!v || PLACEHOLDER.test(v) || UNSAFE.test(v) || /[{}]/u.test(v))return '';
  if(INSTRUCTION.test(v) && /[()（）]/u.test(v))return '';
  if(/(?:日期從|三人個別|當下一句|20字內|24小時制|不可瞬移|以十分鐘|視情況推進)/u.test(v))return '';
  if(/^(?:依照|請|需|不可|不得|例如|範例|要求|規則|備註|說明)[：:：\s]/u.test(v))return '';
  return v.slice(0,400);
}
function readValues(generated, allowed) {
  const values=new Map();let active='';
  for(const line of String(generated||'').replace(/\r/g,'').split('\n')) {
    const fs=fieldsInLine(line);
    const top=fs.filter(f=>allowed.has(f.name));
    if(top.length) {
      for(const f of top) {
        active=f.name;
        const v=safeLine(f.sample);
        if(v && !values.has(f.name))values.set(f.name,v);
      }
      continue;
    }
    // A continuation may be an NPC-specific line within 信任度 / 內心話.
    if(!active || !/(?:信任|內心|心聲|心裡話|想法|角色狀態|人物狀態|💭|💚)/u.test(active))continue;
    const trimmed=line.trim();
    if(!trimmed || /^[（(]/u.test(trimmed) && INSTRUCTION.test(trimmed))continue;
    const nested=trimmed.match(/^\s*([^：:\n]{1,24})[：:]\s*(.+)$/u);
    if(!nested || INSTRUCTION.test(nested[1]))continue;
    const value=safeLine(nested[2]);
    if(!value)continue;
    const appended=`${nested[1].trim()}：${value}`;
    const old=values.get(active)||'';
    values.set(active, (old && !PLACEHOLDER.test(old)?old+'\n':'')+appended);
  }
  return values;
}
function fixedSuffix(sample) {
  let raw=String(sample||'').trim();
  if(!raw || UNSAFE.test(raw) || INSTRUCTION.test(raw))return '';
  raw=raw.replace(/^(?:\d{1,4}[\/-])?\d{1,2}[\/-]\d{1,2}\s*/u,'')
    .replace(/^(?:\d{1,2}:\d{2}(?::\d{2})?|(?:子|丑|寅|卯|辰|巳|午|未|申|酉|戌|亥)時(?:[初正]|\d+刻)?|未確認)\s*/u,'');
  raw=raw.replace(/^(?:未知|待確認|不確定|無|待更新|描述|範例|地點|目標)(?=\s|[（(]|$)\s*/u,'');
  if(!EMOJI.test(raw) && !KAOMOJI.test(raw))return '';
  // Don't preserve explanatory parentheticals / placeholders as decoration.
  raw=cleanInstructionNotes(raw);
  if(/(?:XX|hh:mm)/iu.test(raw))return '';
  return raw ? ' '+raw.slice(0,80).trim() : '';
}
function isDecoration(line) {
  const t=String(line).trim();
  if(!t || t.length>150 || UNSAFE.test(t) || INSTRUCTION.test(t) || /[{}]/u.test(t))return false;
  if(/^(?:[─━═=\-—_＊*·•.\s]{3,}|[【\[「『][^\n:：]{1,70}[】\]」』])$/u.test(t))return true;
  if((EMOJI.test(t)||KAOMOJI.test(t)) && !/[:：]/u.test(t))return true;
  return /^〔固定文字〕[^\n]{1,100}$/u.test(t);
}
function lockCreatorStatus(template,generated,options={}) {
  const fields=parseFields(template);
  if(!fields.length)return '';
  const allowed=new Set(fields.map(f=>f.name));
  const values=readValues(generated,allowed);
  const timeText=typeof options.timeText==='string'?options.timeText:'';
  const dateText=typeof options.dateText==='string'?options.dateText:'';
  const seen=new Set(),out=[];
  for(const line of String(template||'').replace(/\r/g,'').split('\n')) {
    const fs=fieldsInLine(line),result=[];
    for(const f of fs) {
      if(!allowed.has(f.name)||seen.has(f.name))continue;
      seen.add(f.name);
      const value=f.time&&timeText?timeText:f.date&&dateText?dateText:(values.get(f.name)||'未確認');
      result.push(`${f.prefix}${f.name}${f.separator}${value}${fixedSuffix(f.sample)}`);
    }
    if(result.length)out.push(result.join('｜'));
    else if(isDecoration(line))out.push(line.replace(/^〔固定文字〕/u,''));
  }
  return out.join('\n').trim().slice(0,6000);
}
module.exports={parseFields,lockCreatorStatus,describeCreatorTemplate};
