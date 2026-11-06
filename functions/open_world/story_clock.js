'use strict';
// Fictional story clock: never uses wall-clock time to advance in-game scenes.
const PAD = n => String(n).padStart(2, '0');
function dateOk(y,m,d){ const dt=new Date(Date.UTC(y,m-1,d)); return dt.getUTCFullYear()===y&&dt.getUTCMonth()===m-1&&dt.getUTCDate()===d; }
function normalize(clock){
 if(!clock || typeof clock!=='object')return null;
 const year=Number(clock.year),month=Number(clock.month),day=Number(clock.day),hour=Number(clock.hour),minute=Number(clock.minute);
 if(![year,month,day,hour,minute].every(Number.isInteger)||!dateOk(year,month,day)||hour<0||hour>23||minute<0||minute>59)return null;
 return {year,month,day,hour,minute,yearKnown:clock.yearKnown===true, dateKnown:clock.dateKnown!==false};
}
function label(clock){const c=normalize(clock);if(!c)return '尚未確認';const date=c.dateKnown?`${c.yearKnown?c.year+'/':''}${PAD(c.month)}/${PAD(c.day)} `:'';return `${date}${PAD(c.hour)}:${PAD(c.minute)}`;}
function addMinutes(clock,mins){const c=normalize(clock);if(!c)return null;const t=Date.UTC(c.year,c.month-1,c.day,c.hour,c.minute)+Math.max(0,Math.trunc(mins))*60000;const d=new Date(t);return {...c,year:d.getUTCFullYear(),month:d.getUTCMonth()+1,day:d.getUTCDate(),hour:d.getUTCHours(),minute:d.getUTCMinutes()};}
function resolveClock(previous, player, advanceMinutes=3, maxNaturalMinutes=5){
 const base=normalize(previous);const text=String(player||'').trim();
 // A report or hypothetical about past events does not reset the present.
 const hypothetical=/(?:如果|假設|假如|回憶|回想|想起|夢裡|夢見|聽說)/u.test(text.slice(0,36));
 if(!hypothetical){
  const date=text.match(/(?:時間\s*[:：]?\s*|現在(?:是|時間)|今天(?:是)?\s*|日期\s*[:：]?\s*|^\s*)\s*(?:(\d{4})[\/.-])?(\d{1,2})[\/.-](\d{1,2})(?:\s*(?:日|號))?\s*(?:(上午|早上|下午|晚上|凌晨|中午|傍晚)\s*)?(\d{1,2})(?:[:：點時](\d{1,2}))?/u);
  if(date){let h=Number(date[5]);const mer=date[4]||'';if(['下午','晚上','傍晚'].includes(mer)&&h<12)h+=12;if(['凌晨','上午','早上'].includes(mer)&&h===12)h=0;let y=date[1]?Number(date[1]):base?.year||2000;const m=Number(date[2]),day=Number(date[3]),minute=Number(date[6]||0);const explicit=normalize({year:y,month:m,day,hour:h,minute,yearKnown:Boolean(date[1])||Boolean(base?.yearKnown),dateKnown:true});if(explicit)return {clock:explicit,reason:'player_absolute'};}
  const time=text.match(/(?:現在(?:的)?時間\s*(?:是|為)?\s*|時間\s*[:：]\s*|(?:改成|跳到|來到)\s*)(?:(早上|上午|下午|晚上|凌晨|中午|傍晚)\s*)?(\d{1,2})(?:[:：點時](\d{1,2}))?/u);
  if(time){let h=Number(time[2]);const mer=time[1]||'';if(['下午','晚上','傍晚'].includes(mer)&&h<12)h+=12;if(['凌晨','早上','上午'].includes(mer)&&h===12)h=0;if(h<24&&Number(time[3]||0)<60){const seed=base||{year:2000,month:1,day:1,yearKnown:false,dateKnown:false};return {clock:{...seed,hour:h,minute:Number(time[3]||0)},reason:'player_time_override'};}}
  if(base){const nextDay=/(?:隔天|第二天|翌日|次日)(?:的)?(?:早上|上午|清晨|一早|中午|下午|晚上|凌晨)?/u.test(text);
   if(nextDay){const next=addMinutes(base,24*60);let hour=next.hour,minute=next.minute;
     if(/早上|上午|清晨|一早/u.test(text)){hour=7;minute=10;}
     else if(/中午/u.test(text)){hour=12;minute=0;}
     else if(/下午/u.test(text)){hour=15;minute=0;}
     else if(/晚上/u.test(text)){hour=20;minute=0;}
     else {hour=base.hour;minute=base.minute;}
     return {clock:{...next,hour,minute},reason:'player_next_day'};
   }
   const elapsed=text.match(/(?:過了|經過|時間過了|時間推進)(\d{1,3})\s*(分鐘|分|小時|個小時|天|日)/u);
   if(elapsed){const n=Number(elapsed[1]);const unit=elapsed[2];const minutes=n*(unit==='分鐘'||unit==='分'?1:(unit==='天'||unit==='日'?1440:60));return {clock:addMinutes(base,minutes),reason:'player_elapsed'};}
  }
 }
 if(!base)return {clock:null,reason:'unknown'};
 const requested=Number(advanceMinutes);
 const safe=Number.isFinite(requested)?Math.min(Math.max(1,Math.min(5,Math.trunc(maxNaturalMinutes))),Math.max(1,Math.trunc(requested))):3;
 return {clock:addMinutes(base,safe),reason:'normal_turn'};
}
// Restore only an explicitly displayed clock from a creator status field.
// The internal 2000-01-01 below is arithmetic-only when the creator supplied
// a clock time without a date: dateKnown=false prevents displaying that date.
function parseStatusClock(status) {
 const lines=String(status||'').replace(/\r\n?/g,'\n').split('\n');
 for(const line of lines) {
  const m=line.match(/^\s*(?:(?:[\p{Extended_Pictographic}\u2600-\u27BF]\uFE0F?\s*)?(?:時間|時刻|故事時間|目前時間|現在時間|日期時間|📅|📆|🗓️?|⏰|🕒)\s*[:：])\s*(.+)$/u);
  if(!m)continue;
  const value=m[1].trim();
  if(/第[零〇一二兩三四五六七八九十百千\d]+[日天]/u.test(value))continue;
  const match=value.match(/^(?:(?:(\d{4})[\/.-])?(\d{1,2})[\/.-](\d{1,2})\s+)?([01]?\d|2[0-3])[:：]([0-5]\d)(?!\d)/u);
  if(!match)continue;
  const dated=Boolean(match[2]);
  const year=match[1]?Number(match[1]):2000;
  const clock=normalize({year,month:dated?Number(match[2]):1,day:dated?Number(match[3]):1,
    hour:Number(match[4]),minute:Number(match[5]),yearKnown:Boolean(match[1]),dateKnown:dated});
  if(clock)return clock;
 }
 return null;
}

// Internal clock remains Gregorian-like arithmetic; display labels follow fictional world conventions.
// Ancient lunar calendars / reign years are NOT inferred from these internal month/day values.
const BRANCHES = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];
// Creator time instructions are data. Recognise only a small, verifiable grammar;
// never execute arbitrary prose from a status template as a program or command.
function creatorTimePolicy(world={}) {
 const template=String(world.customOutputFormat||'').slice(0,6000);
 const source=[String(world.timeSystem||''),String(world.timeFormat||''),String(world.calendarSystem||''),template].join('\n');
 const rows=source.split(/\r?\n/).filter(row=>/(?:時間|時辰|紀時|計時|曆法|每回合|每輪|劇情推進)/u.test(row)).slice(0,25).map(row=>row.slice(0,200));
 const spec=rows.join('\n');
 let style=null;
 if(/(?:十二時辰|古代時辰|子丑寅卯|時辰制|以時辰(?:表示|顯示|記錄|推進)|使用時辰)/u.test(spec))style='ancient';
 else if(/(?:24\s*小時制|二十四小時制|24h|現代時間|數位時間)/iu.test(spec))style='modern';
 // Unambiguous per-reply durations only. Describing a '時辰制' does NOT imply a two-hour jump.
 let fixedMinutes=null;
 const duration=spec.match(/(?:每(?:一)?(?:回合|輪|次(?:對話|回覆)?)|每次(?:對話|回覆))\s*(?:自然)?(?:推進|經過|增加|流逝|過去|為|約)?\s*(\d{1,3})\s*(分鐘|分|小時|個小時|刻鐘|刻)(?![\p{Script=Han}\d])/u);
 if(duration){const n=Number(duration[1]);const multiplier=/(小時)/u.test(duration[2])?60:/(刻)/u.test(duration[2])?15:1;const mins=n*multiplier;if(mins>=1&&mins<=120)fixedMinutes=mins;}
 else if(/每(?:一)?(?:回合|輪|次對話|次回覆)\s*(?:推進|經過|增加|流逝|過去)\s*(?:一個)?時辰/u.test(spec))fixedMinutes=120;
 else if(/每(?:一)?(?:回合|輪|次對話|次回覆)\s*(?:推進|經過|增加|流逝|過去)\s*一刻鐘/u.test(spec))fixedMinutes=15;
 return {style,fixedMinutes,hasTimeInstructions:rows.length>0};
}
function advanceForWorld(world={},requested=3){
 const fixed=creatorTimePolicy(world).fixedMinutes;
 // Product rule: every ordinary successful turn advances 1..5 minutes, even if
 // a creator template asks for a larger automatic jump. Explicit player jumps
 // are handled separately by resolveClock/resolveFictionalClock.
 if(fixed!==null)return Math.max(1,Math.min(5,fixed));
 const value=Number(requested);
 return Number.isFinite(value)?Math.max(1,Math.min(5,Math.trunc(value))):3;
}
function detectTimeStyle(world={}) {
 const creator=creatorTimePolicy(world).style;
 if(creator)return creator;
 const explicit=String(world.timeSystem || world.timeFormat || world.calendarSystem || '').trim().toLowerCase();
 if (/^(modern|24h|digital|western)$/.test(explicit) || /(?:西元|24小時制|二十四小時制)/u.test(explicit)) return 'modern';
 if (/^(ancient|shichen|traditional|chinese_ancient)$/.test(explicit) || /(?:十二時辰|古代時辰|傳統時辰)/u.test(explicit)) return 'ancient';
 // Only use explicit era and calendar descriptors, never NPC dialogue or player history.
 const era=String(world.era||'').slice(0,180);
 const setting=String(world.worldSetting||'').slice(0,1200);
 const raw=(era+'\n'+setting).toLowerCase();
 if (/(?:明朝|明代|清朝|清代|唐朝|唐代|宋朝|宋代|漢朝|漢代|元朝|元代|隋朝|隋代|秦朝|秦代|晉朝|晉代|三國|戰國|春秋|古代中國|古風|古裝|武俠|仙俠|修仙|古代王朝|架空古代)/u.test(raw)) return 'ancient';
 return 'modern';
}
function branchOfHour(hour) {return BRANCHES[Math.floor(((hour+1)%24)/2)];}
function displayTime(clock, world={}) {
 const c=normalize(clock);if(!c)return '尚未確認';
 if(detectTimeStyle(world)!=='ancient')return label(c);
 // Do not pretend that a numeric Gregorian month/day is a historical lunar date.
 // Show the known day in neutral numeric form if known; otherwise only the branch hour.
 const prefix=c.dateKnown ? `${c.yearKnown?c.year+'/':''}${PAD(c.month)}/${PAD(c.day)} ` : '';
 return `${prefix}${branchOfHour(c.hour)}時`;
}
function timePresentationDirective(world={}) {
 const policy=creatorTimePolicy(world);
 const pacing='每次成功的新回合由後端強制推進一至五分鐘（至少一分鐘）。創作者指定的普通回合步長也以一至五分鐘為限；玩家明確指定跨日或跳時時依玩家為準，重新生成不額外推進。';
 if(detectTimeStyle(world)==='ancient') return pacing+' '+ '【世界紀時】此世界採古代時辰表達。NPC 自然使用子丑寅卯辰巳午未申酉戌亥時，避免現代數位鐘說法。後端以 24 小時精度保存事件先後；同一時辰內的短暫經過無須變更顯示。未指定陰曆/年號時，禁止把內部公曆月日當成農曆或虛構明朝年號。若創作者明訂不同曆法，以其世界觀為先，但勿自造日期換算。';
 return pacing+' '+'【世界紀時】此世界使用現代時間表達（24 小時制）；以故事內時間為準，不使用現實手機時間。若世界設定明示其他紀時方式，人物台詞依世界設定自然表達。';
}
// For modern creator status bars, replace only the value of a time/calendar row.
// status_template's lockCreatorStatus currently ignores timeText, so the
// authoritative server time must be applied after locking the creator layout.
// A one-line calendar may contain other fields separated by ｜: preserve them.
function enforceModernStatusTime(status, timeText) {
  const stamp=String(timeText||'').trim();
  if(!/(?:[01]\d|2[0-3]):[0-5]\d$/u.test(stamp)) return String(status||'');
  let found=false;
  const lines=String(status||'').replace(/\r\n?/gu,'\n').split('\n').map(line=>{
    if(found)return line;
    const m=line.match(/^(\s*(?:📅|📆|🗓️?|⏰|🕒|時間|時刻|故事時間|現在時間|目前時間|日期時間)\s*[:：]\s*)([^｜|]*)([\s\S]*)$/u);
    if(!m)return line;
    found=true;
    // Keep the creator's icon, label and every post-calendar field (e.g. location).
    return `${m[1]}${stamp}${m[3]}`;
  });
  if(!found) lines.unshift(`⏰：${stamp}`);
  return lines.join('\n');
}

function enforceStatusTime(status,clock,world={}){const c=normalize(clock);if(!c)return String(status||'');const time=displayTime(c,world);return String(status||'').replace(/(^|\n)(\s*(?:時間|日期時間|故事時間|當前時間|目前時間)\s*[:：]\s*)[^\n]*/gu,(_,lead,prefix)=>lead+prefix+time);}

// Fictional day number (e.g. "第三日，07:20") is deliberately separate
// from the Gregorian-based storyClock, so fictional calendars are not converted.
const HAN_DIGITS = {'零':0,'〇':0,'一':1,'二':2,'兩':2,'三':3,'四':4,'五':5,'六':6,'七':7,'八':8,'九':9};
function parseDayNumber(value) {
 const raw=String(value||'').trim();
 if (/^\d{1,4}$/u.test(raw)) return Number(raw);
 if (!/^[零〇一二兩三四五六七八九十百千]+$/u.test(raw)) return null;
 let total=0, digit=0;
 for (const c of raw) {
  if (Object.prototype.hasOwnProperty.call(HAN_DIGITS,c)) digit=HAN_DIGITS[c];
  else { const unit=c==='十'?10:c==='百'?100:1000; total+=(digit||1)*unit; digit=0; }
 }
 return total+digit;
}
function chineseDay(n) {
 if(n<=10)return ['','一','二','三','四','五','六','七','八','九','十'][n];
 if(n<20)return '十'+(n===10?'':['','一','二','三','四','五','六','七','八','九'][n%10]);
 if(n<100)return ['','一','二','三','四','五','六','七','八','九'][Math.floor(n/10)]+'十'+(n%10?['','一','二','三','四','五','六','七','八','九'][n%10]:'');
 return String(n);
}
function normalizeFictionalClock(value) {
 if(!value || typeof value!=='object')return null;
 const day=Number(value.day),hour=Number(value.hour),minute=Number(value.minute);
 if(!Number.isInteger(day)||day<1||day>9999||!Number.isInteger(hour)||hour<0||hour>23||!Number.isInteger(minute)||minute<0||minute>59)return null;
 return {day,hour,minute};
}
function parseFictionalTime(value) {
 const text=String(value||'');
 // Parse a status value, not free-form prose. The label is validated by status_template.
 const m=text.match(/第\s*([零〇一二兩三四五六七八九十百千\d]{1,8})\s*[日天]\s*[,，、\s]*([01]?\d|2[0-3])\s*[:：]\s*([0-5]\d)/u);
 if(!m)return null;
 return normalizeFictionalClock({day:parseDayNumber(m[1]),hour:Number(m[2]),minute:Number(m[3])});
}
// Bootstrap a fictional daypart only when an explicit creator-status calendar
// row supplies both the fictional day and a named time-of-day. These defaults
// are game conventions, not inferred historical/real-world timestamps.
const FICTIONAL_DAYPART_START = Object.freeze({
  '凌晨':[3,0], '清晨':[6,0], '早上':[9,0], '上午':[9,0],
  '中午':[12,0], '下午':[15,0], '傍晚':[18,0], '晚上':[20,0], '半夜':[0,0],
});
function parseFictionalDaypart(value) {
  const source=String(value||'').trim();
  const match=source.match(/第\s*([零〇一二兩三四五六七八九十百千\d]{1,8})\s*[日天]\s*[,，、\s]*(凌晨|清晨|早上|上午|中午|下午|傍晚|晚上|半夜)(?=$|[。．!！\s｜|])/u);
  if(!match)return null;
  const hm=FICTIONAL_DAYPART_START[match[2]];
  return normalizeFictionalClock({day:parseDayNumber(match[1]),hour:hm[0],minute:hm[1]});
}
// Limit fictional bootstrap to explicit 📅 calendar rows, never narration or
// random occurrences of 'morning' in dialogue or an author's instructions.
function parseFictionalStatusAnchor(status) {
  for(const line of String(status||'').replace(/\r\n?/gu,'\n').split('\n')) {
    const match=line.match(/^\s*(?:📅|📆|🗓️?)\s*[:：]\s*([^\n]*)$/u);
    if(!match)continue;
    const value=match[1].split(/[｜|]/u)[0].trim();
    const exact=parseFictionalTime(value);
    if(exact)return {clock:exact,source:'explicit_time'};
    const part=parseFictionalDaypart(value);
    if(part)return {clock:part,source:'daypart_default'};
  }
  return null;
}
function addFictionalMinutes(clock,minutes) {
 const base=normalizeFictionalClock(clock);if(!base)return null;
 const next=(base.day-1)*1440+base.hour*60+base.minute+Math.max(0,Math.trunc(minutes));
 return {day:Math.floor(next/1440)+1,hour:Math.floor((next%1440)/60),minute:next%60};
}
function displayFictionalClock(clock) {
 const c=normalizeFictionalClock(clock);if(!c)return '';
 return `第${chineseDay(c.day)}日，${PAD(c.hour)}:${PAD(c.minute)}`;
}
function resolveFictionalClock(previous,player,minutes=3) {
 const base=normalizeFictionalClock(previous);if(!base)return null;
 const input=String(player||'');
 if(/(?:隔天|第二天|翌日|次日)/u.test(input)) {
  const next=addFictionalMinutes(base,1440);
  if(/早上|上午|清晨|一早/u.test(input))return {...next,hour:7,minute:10};
  if(/中午/u.test(input))return {...next,hour:12,minute:0};
  if(/下午/u.test(input))return {...next,hour:15,minute:0};
  if(/晚上/u.test(input))return {...next,hour:20,minute:0};
  return next;
 }
 const elapsed=input.match(/(?:過了|經過|時間過了|時間推進)\s*(\d{1,3})\s*(分鐘|分|小時|個小時|天|日)/u);
 if(elapsed) {
  const n=Number(elapsed[1]),unit=elapsed[2];
  return addFictionalMinutes(base,n*(unit==='分鐘'||unit==='分'?1:unit==='天'||unit==='日'?1440:60));
 }
 // Only an explicit instruction may override the present time.
 const explicit=parseFictionalTime(input.match(/(?:現在|目前|故事時間|時間設定|時間改成|時間跳到)[^。\n]{0,60}/u)?.[0]||'');
 if(explicit)return explicit;
 const local=input.match(/(?:現在(?:的)?時間(?:是|為)?|時間(?:改成|跳到|來到|設定為))\s*([01]?\d|2[0-3])\s*[:：]\s*([0-5]\d)/u);
 if(local)return {...base,hour:Number(local[1]),minute:Number(local[2])};
 return addFictionalMinutes(base,Math.max(1,Math.min(5,Number.isFinite(Number(minutes))?Math.trunc(Number(minutes)):3)));
}

module.exports={normalize,label,addMinutes,resolveClock,parseStatusClock,enforceStatusTime,detectTimeStyle,branchOfHour,displayTime,timePresentationDirective,creatorTimePolicy,advanceForWorld,normalizeFictionalClock,parseFictionalTime,parseFictionalDaypart,parseFictionalStatusAnchor,displayFictionalClock,resolveFictionalClock,enforceModernStatusTime};
