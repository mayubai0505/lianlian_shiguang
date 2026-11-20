'use strict';
// Countdown values are durations, not wall-clock timestamps. Keep full minutes
// between turns; never feed a rounded display value back into arithmetic.
const duration = /^(\d+(?:\.\d+)?|[零一二兩三四五六七八九十]+|半)\s*(個?時辰|個?小時|分鐘|分)(?![\d])/u;
function numberOf(text) {
  if (/^\d+(?:\.\d+)?$/.test(text)) return Number(text);
  if (text === '半') return 0.5;
  const d={零:0,一:1,二:2,兩:2,三:3,四:4,五:5,六:6,七:7,八:8,九:9};
  if (text.includes('十')) {const [a,b]=text.split('十');return (a ? d[a] : 1)*10+(b ? d[b] : 0);}
  return d[text];
}
function readDuration(text) {
  const match=String(text||'').trim().match(duration);
  if (!match) return null;
  const n=numberOf(match[1]), factor=match[2].includes('時辰')?120:match[2].includes('小時')?60:1;
  if (!Number.isFinite(n)||n<0||n*factor>525600) return null;
  return {minutes:n*factor,unit:match[2],factor,matched:match[0]};
}
const keyOf=label=>label.replace(/^[\s\-*•\p{Extended_Pictographic}\p{Emoji_Presentation}\uFE0F]+/u,'').trim();
function rowOf(line) {
  const m=String(line).match(/^(\s*[^：:\n]{1,60}[：:][ \t]*)(.*)$/u);
  return m ? {prefix:m[1],value:m[2],key:keyOf(m[1].replace(/[：:][ \t]*$/u,''))} : null;
}
function updateCreatorCountdown({template,status,previous='',saved={},elapsedMinutes=0,regenerate=false}) {
  const definitions=new Map(String(template||'').split(/\r?\n/u).map(rowOf).filter(r=>r &&
    /^(?:距離|距|剩餘|剩下|倒數)/u.test(r.key) && /時辰|小時|分鐘/u.test(r.value))
    .map(r=>[r.key,r]));
  const prior=new Map(String(previous||'').split(/\r?\n/u).map(rowOf).filter(Boolean).map(r=>[r.key,r]));
  const entries=[];let changed=false;
  const elapsed=Number.isFinite(elapsedMinutes)?Math.max(0,elapsedMinutes):0;
  const text=String(status||'').split(/\r?\n/u).map(line=>{
    const row=rowOf(line),def=row&&definitions.get(row.key);
    if(!def)return line; // No inserting hidden/absent conditional fields.
    const old=readDuration(prior.get(row.key)?.value),current=readDuration(row.value);
    const instruction=def.value.split(/例如|範例|示例/u)[0];
    const start=instruction.match(/(?:從|初始(?:值)?\s*[：:=]?|起始(?:值)?\s*[：:=]?)\s*([^（）()]+)/u);
    const initial=start?readDuration(start[1]):null;
    const state=Object.hasOwn(saved||{},row.key)?saved[row.key]:null;
    const stored=state && Number.isFinite(state.remainingMinutes) && state.remainingMinutes>=0 && state.remainingMinutes<=525600;
    const format=current||old||initial;
    if(!format)return line;
    // Old rooms migrate from their most recent saved display, not the opening.
    const base=stored?state.remainingMinutes:old?old.minutes:initial?initial.minutes:current?.minutes;
    if(!Number.isFinite(base))return line;
    const remaining=regenerate?base:Math.max(0,base-(stored||old||initial?elapsed:0));
    entries.push([row.key,{remainingMinutes:remaining}]);changed=true;
    // Keep positive countdowns positive even inside the last display increment.
    const amount=remaining/format.factor;
    const shown=format.factor===1?String(Math.ceil(amount)):
      (amount===0?'0':String(Math.max(0.1,Math.round(amount*10)/10)));
    const value=current?row.value.replace(duration,shown+' '+format.unit):shown+' '+format.unit;
    return row.prefix+value;
  }).join('\n');
  return {status:text,state:Object.fromEntries(entries),handled:changed};
}
// Only a completed duration at a sentence boundary is a clock instruction.
// Future plans, questions, negation and quotations must not advance the clock.
function explicitAncientElapsed(text) {
  const m=String(text||'').match(/(?:^|[\n。！；;])\s*[（(]?\s*(?:時間推進|時間過了|過了|經過|等待了|等了)\s*(半|\d+(?:\.\d+)?|[一二兩三四五六七八九十]+)\s*個?時辰(?:又|零)?(?:\s*(半))?\s*(?=[）)。！，,；;\n]|$)/u);
  if(!m)return null;
  const n=numberOf(m[1])+(m[2]?0.5:0);
  return Number.isFinite(n)&&n>0&&n<=720?n*120:null;
}
module.exports={updateCreatorCountdown,explicitAncientElapsed};
