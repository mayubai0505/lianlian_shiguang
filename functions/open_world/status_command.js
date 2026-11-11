'use strict';
// A world creator's STATUS COMMAND is an on-demand player UI query, not NPC dialogue.
// Only use facts already authorized in this player's current world session.
const DEFINITIONS = Object.freeze([
  {id:'characters', heading:'人物查詢', words:['人物查詢','角色資料','查看人物']},
  {id:'relations', heading:'關係查詢', words:['關係查詢','人物關係','好感度']},
  {id:'thoughts', heading:'角色內心', words:['內心查詢','真實想法','心理狀態']},
  {id:'families', heading:'家族查詢', words:['家族查詢','勢力查詢','五大家族']},
  {id:'intel', heading:'情報查詢', words:['情報查詢','秘密查詢','隱藏情報']},
  {id:'story', heading:'劇情查詢', words:['劇情查詢','任務查詢','事件紀錄']},
  {id:'all', heading:'完整狀態', words:['完整狀態','全部狀態']},
]);
function findCreatorStatusCommand(source, input) {
  const template=String(source||'');
  // Never invent STATUS COMMAND capability for worlds without creator setup.
  if (!/(?:STATUS\s*COMMAND|查詢指令|【(?:人物查詢|關係查詢|角色內心|家族查詢|情報查詢|劇情查詢|完整狀態)】)/iu.test(template) ||
      !/(?:關鍵字|STATUS\s*COMMAND)/iu.test(template)) return null;
  const text=String(input||'').trim();
  if (!text || text.length>100 || /[\r\n]/u.test(text)) return null;
  for(const def of DEFINITIONS){
    // If the creator did not declare this exact query family, don't enable it.
    if (!template.includes(`【${def.heading}】`) && !def.words.some(w=>template.includes(w))) continue;
    for(const word of def.words){
      if(!template.includes(word)) continue;
      // Only standalone commands or command + optional named subject are queries.
      if(text===word) return {id:def.id,heading:def.heading,target:''};
      if(text.startsWith(word)) {
        const suffix=text.slice(word.length);
        if(!/^[\s:：、，,（(\-—]+/u.test(suffix) || /[？?!！]/u.test(suffix)) continue;
        const target=suffix.replace(/^[\s:：、，,（(\-—]+|[）)\s。！？!?]+$/gu,'').trim();
        if(target.length<=40 && !/[。！？!?]/u.test(target)) return {id:def.id,heading:def.heading,target};
      }
    }
  }
  return null;
}
const clipped=(text,max=140)=>String(text||'').replace(/[\r\n\t]+/gu,' ').trim().slice(0,max);
function makeStatusCommandDisplay(command, {characters=[],relationships=[],visibleNpcIds=[],knownEvents='',storySummary='',storyTime=''}={}) {
  if(!command)return '';
  const list=Array.isArray(characters)?characters:[];
  const relations=Array.isArray(relationships)?relationships:[];
  const present=new Set(Array.isArray(visibleNpcIds)?visibleNpcIds:[]);
  const target=String(command.target||'').trim();
  const selected=target
    ? list.filter(n=>String(n.name||'')===target || String(n.id||'')===target)
    : list.filter(n=>present.has(String(n.id||'')));
  const relevant=selected.slice(0,8);
  const personLines=()=> relevant.length ? relevant.map(n=>{
    const bits=[`姓名：${clipped(n.name,60)}`];
    if(n.role)bits.push(`身分：${clipped(n.role,100)}`);
    if(n.appearance)bits.push(`外貌：${clipped(n.appearance,180)}`);
    const r=relations.find(x=>x.id===n.id);
    if(r?.hasMetPlayer)bits.push('目前狀態：已與玩家相遇');
    return bits.join('｜');
  }) : ['目前沒有符合條件的已出場人物資料。'];
  const relLines=()=>relevant.length ? relevant.map(n=>{
    const r=relations.find(x=>x.id===n.id);
    if(!r || !r.hasMetPlayer)return `${clipped(n.name,60)}：尚未建立可查詢的互動關係。`;
    return `${clipped(n.name,60)}：好感度 ${Number.isFinite(r.score)?Math.trunc(r.score):0}；關係 ${clipped(r.currentRelationship||'未記錄',100)}；信任度、敵意：未獨立記錄。`;
  }) : ['請指定角色，或先與角色在劇情中相遇。'];
  const thoughtLines=()=>relevant.length ? relevant.map(n=>{
    const r=relations.find(x=>x.id===n.id);
    // Never extrapolate an unspoken secret intention from the complete NPC dossier.
    return `${clipped(n.name,60)}：${r?.hasMetPlayer && r.currentThought ? clipped(r.currentThought,180) : '目前沒有可查詢的已記錄想法。'}`;
  }) : ['請指定角色，或先與角色在劇情中相遇。'];
  const storyLines=()=>{
    const lines=[];
    if(storyTime)lines.push(`目前故事時間：${clipped(storyTime,70)}`);
    if(storySummary)lines.push(`已知劇情摘要：${clipped(storySummary,500)}`);
    if(knownEvents)lines.push(`近期已記錄事件：${clipped(knownEvents,500)}`);
    return lines.length?lines:['目前沒有可查詢的劇情紀錄。'];
  };
  const familyLines=()=>['尚無經確認且可公開的家族／勢力資料；不會直接展示創作者未公開設定。'];
  const intelLines=()=>['僅顯示已透過劇情取得的情報；目前沒有可安全確認的可公開情報項目。'];
  const handlers={characters:personLines,relations:relLines,thoughts:thoughtLines,
    families:familyLines,intel:intelLines,story:storyLines};
  if(command.id==='all')return [
    ...DEFINITIONS.filter(d=>d.id!=='all').map(d=>`【${d.heading}】\n${handlers[d.id]().join('\n')}`)
  ].join('\n\n').slice(0,6000);
  return `【${command.heading}】\n${(handlers[command.id]?.()||['沒有可查詢資料。']).join('\n')}`.slice(0,2200);
}
module.exports={findCreatorStatusCommand,makeStatusCommandDisplay};
