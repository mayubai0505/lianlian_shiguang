'use strict';
// Recognize a creator's primary thought section without assuming a colon or
// single-line layout. This is *not* a general instruction parser.
const START = /^\s*(?:(?:💭\s*)?(?:人物心聲|角色心聲|(?:當前|目前)?(?:人物)?想法|心聲)(?=\s|[｜|：:]|$)|💭(?=\s*[｜|：:]|$))/u;
const PLACEHOLDER = /(?:\{[^}\n]+\}|\uff5b[^\uff5d\n]+\uff5d|\u3008[^\u3009\n]+\u3009|\$\{[^}\n]+\})/u;
const UNAVAILABLE = /^(?:未確認|尚未確認|未顯示|未知|不明|待確認|無|沒有|N\/?A|[-—－])$/iu;
const NEW_SECTION = /^\s*(?:[\p{Extended_Pictographic}\u2600-\u27BF]|【|\[[^\]]+\]|[^\s]{1,22}\s*[：:])/u;
const TEMPLATE_RULE = /(?:每輪|每回|當前|本輪).{0,42}(?:重新|更新|不得.{0,12}沿用|不可.{0,12}沿用)/u;

function parseHeading(line) {
  const match=String(line||'').match(START);
  if (!match) return null;
  const rest=line.slice(match[0].length).trim();
  if (!rest) return {name:'',inline:''};
  const named=rest.match(/^[｜|]\s*(.*?)\s*$/u);
  if(named)return {name:named[1],inline:''};
  const colon=rest.match(/^[：:]\s*(.*)$/u);
  if(colon)return {name:'',inline:colon[1]};
  return null;
}
function authoredThoughtSpec(template) {
  const lines=String(template||'').replace(/\r\n?/g,'\n').split('\n');
  for (const line of lines) {
    const t=line.trim();
    if (/^(?:範例|例如|示例|備註|\/\/)/u.test(t))continue;
    const p=parseHeading(line);
    if(!p)continue;
    // Explicitly conditional thoughts remain conditional (not required in every turn).
    const conditional=lines.some(v=>/(?:人物心聲|角色心聲|心聲).{0,65}(?:僅在|只有|才顯示|才輸出|隱藏)|(?:僅在|只有).{0,60}(?:人物心聲|角色心聲|心聲)/u.test(v));
    const fresh=lines.some(v=>TEMPLATE_RULE.test(v) && /(?:心聲|想法)/u.test(v)) ||
      lines.some(v=>/(?:不得|不可).{0,30}(?:沿用上一輪心聲|重複沿用)/u.test(v));
    const absent=lines.some(v=>/(?:沒有其他人物|沒有人物|無人在場).{0,50}(?:暫無)/u.test(v));
    return {required:!conditional,heading:line.trim(),named:/[｜|]/u.test(line),fresh,absent};
  }
  return null;
}
function invalid(value) {
  const text=String(value||'').trim();
  return !text || UNAVAILABLE.test(text) || PLACEHOLDER.test(text) ||
    /^\s*(?:（上一輪心聲不提供|\(上一輪心聲不提供)/u.test(text);
}
function readThought(status) {
  const lines=String(status||'').replace(/\r\n?/g,'\n').split('\n');
  for(let i=0;i<lines.length;i++) {
    const p=parseHeading(lines[i]);
    if(!p)continue;
    const detail=[];
    for(let j=i+1;j<lines.length;j++) {
      if(!lines[j].trim())break;
      if(NEW_SECTION.test(lines[j]) || parseHeading(lines[j]))break;
      detail.push(lines[j]);
    }
    const content=(p.inline || detail.join('\n')).trim();
    const name=p.name.trim();
    if(!content && name==='暫無')return {exists:true,valid:true,start:i,end:i+1+detail.length,name,content:'',absent:true};
    if(content==='暫無' && (!name || name==='暫無'))return {exists:true,valid:true,start:i,end:i+1+detail.length,name,content,absent:true};
    if(invalid(content) || (name && invalid(name))) return {exists:true,valid:false,start:i,end:i+1+detail.length,name,content};
    if(!content || name==='暫無')return {exists:true,valid:false,start:i,end:i+1+detail.length,name,content};
    return {exists:true,valid:true,start:i,end:i+1+detail.length,name,content};
  }
  return {exists:false,valid:false};
}
function writeThought(status,spec,{name,thought,absent=false}) {
  const value=String(status||'').trim();
  const lines=value.split('\n');
  const old=readThought(value);
  let section;
  const quote=String(thought||'').replace(/^[\s「『“"']+|[\s」』”"']+$/gu,'').trim();
  if(absent) {
    section=spec.named ? [spec.heading.replace(/[｜|]\s*.*$/u,'｜暫無')] : [spec.heading.replace(/[：:]\s*.*$/u,'：暫無')];
  } else if(spec.named) {
    section=[spec.heading.replace(/[｜|]\s*.*$/u,`｜${name}`),`「${quote}」`];
  } else {
    section=[spec.heading.replace(/[：:]\s*.*$/u,`：${quote}`)];
  }
  if(old.exists)lines.splice(old.start,old.end-old.start,...section);
  else lines.push('',...section);
  return lines.join('\n').replace(/\n{3,}/gu,'\n\n').trim();
}
module.exports={authoredThoughtSpec,readThought,writeThought,parseHeading};
