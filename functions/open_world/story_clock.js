'use strict';
const {explicitAncientElapsed} = require('./creator_countdown');
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
// Only treat a next-day phrase as a scene transition when the player actually
// directs the scene forward. Future warnings, plans and hypothetical mentions
// (e.g. "隔天被我發現誰受傷") are not time commands.
function explicitNextDayTransition(player) {
 const text=String(player||'').trim();
 const day='(?:隔天|第二天|翌日|次日)';
 const part='(凌晨|清晨|早上|上午|一早|中午|下午|傍晚|晚上|深夜|半夜)?';
 const front='(?:^|[\n。！？!?；;])\s*[（(]?\s*';
 // Direct time / scene commands, including parenthesized roleplay instructions.
 const directive=new RegExp(front+'(?:故事時間|時間|劇情|場景|畫面)\s*(?:來到|跳到|跳至|推進到|切到|進入)\s*'+day+'(?:的)?\s*'+part,'u');
 const commanded=text.match(directive);
 if(commanded)return {period:commanded[1]||''};
 // A new-scene opening (not a future-tense mention buried in dialogue).
 const opening=new RegExp(front+day+'(?:的)?\s*'+part+'(?=\s*(?:$|[，,。、）)]|我(?:醒來|起床|睜開)|醒來|起床|天亮))','u');
 const opened=text.match(opening);
 if(opened)return {period:opened[1]||''};
 // A completed overnight transition in narration.
 const overnight=new RegExp('(?:^|[\n。！？!?；;])\s*[（(]?\s*(?:一夜過去|過了一晚|睡了一晚|睡了一夜|一覺睡到)\s*[，, ]*'+day+'(?:的)?\s*'+part,'u');
 const slept=text.match(overnight);
 if(slept)return {period:slept[1]||''};
 // "我睡了一晚，隔天醒來" (completed action, not a future warning).
 if(/(?:睡了一晚|睡了一夜|睡過一晚|一覺睡醒)\s*[，,]\s*(?:隔天|第二天|翌日|次日)(?:的)?\s*(?:醒來|起床|睜開)/u.test(text) &&
    !/(?:如果|假如|假設|萬一|要是|不准|不能|別|打算|計畫)\s*[^。！？!?；;\n]{0,28}(?:睡了一晚|睡了一夜|睡過一晚|一覺睡醒)/u.test(text))return {period:''};
 return null;
}
function resolveClock(previous, player, advanceMinutes=3, maxNaturalMinutes=5){
 const base=normalize(previous);const text=String(player||'').trim();
 // A report or hypothetical about past events does not reset the present.
 const hypothetical=/(?:如果|假設|假如|回憶|回想|想起|夢裡|夢見|聽說)/u.test(text.slice(0,36));
 if(!hypothetical){
  // A player explicitly setting the PRESENT fictional date/time in Chinese
  // takes precedence over any saved clock. Mere historical mentions do not.
  const chineseDateTime=text.match(/(?:^|[\s，。；;（(])(?:現在(?:是|在|的時間(?:是|為)?)?|目前(?:是|在|時間(?:是|為)?)?|此刻(?:是|在)?|故事時間(?:設定為|改成|是|為)?|時間(?:設定為|改成|跳到|是|為)|今天(?:是)?|日期時間(?:設定為|是|為)?)\s*[：:]?\s*(\d{4})\s*年\s*(\d{1,2})\s*月\s*(\d{1,2})\s*[日號]\s*(?:(上午|早上|下午|晚上|凌晨|中午|傍晚)\s*)?(\d{1,2})\s*(?:[:：點時])\s*(\d{1,2})(?:\s*分)?/u);
  if(chineseDateTime){
   let hour=Number(chineseDateTime[5]);
   const period=chineseDateTime[4]||'';
   if(['下午','晚上','傍晚'].includes(period)&&hour<12)hour+=12;
   if(['凌晨','上午','早上'].includes(period)&&hour===12)hour=0;
   const explicit=normalize({year:Number(chineseDateTime[1]),month:Number(chineseDateTime[2]),
    day:Number(chineseDateTime[3]),hour,minute:Number(chineseDateTime[6]),
    yearKnown:true,dateKnown:true});
   if(explicit)return {clock:explicit,reason:'player_absolute_chinese'};
  }
  const date=text.match(/(?:時間\s*[:：]?\s*|現在(?:是|時間)|今天(?:是)?\s*|日期\s*[:：]?\s*|^\s*)\s*(?:(\d{4})[\/.-])?(\d{1,2})[\/.-](\d{1,2})(?:\s*(?:日|號))?\s*(?:(上午|早上|下午|晚上|凌晨|中午|傍晚)\s*)?(\d{1,2})(?:[:：點時](\d{1,2}))?/u);
  if(date){let h=Number(date[5]);const mer=date[4]||'';if(['下午','晚上','傍晚'].includes(mer)&&h<12)h+=12;if(['凌晨','上午','早上'].includes(mer)&&h===12)h=0;let y=date[1]?Number(date[1]):base?.year||2000;const m=Number(date[2]),day=Number(date[3]),minute=Number(date[6]||0);const explicit=normalize({year:y,month:m,day,hour:h,minute,yearKnown:Boolean(date[1])||Boolean(base?.yearKnown),dateKnown:true});if(explicit)return {clock:explicit,reason:'player_absolute'};}
  const time=text.match(/(?:現在(?:的)?時間\s*(?:是|為)?\s*|時間\s*[:：]\s*|(?:改成|跳到|來到)\s*)(?:(早上|上午|下午|晚上|凌晨|中午|傍晚)\s*)?(\d{1,2})(?:[:：點時](\d{1,2}))?/u);
  if(time){let h=Number(time[2]);const mer=time[1]||'';if(['下午','晚上','傍晚'].includes(mer)&&h<12)h+=12;if(['凌晨','早上','上午'].includes(mer)&&h===12)h=0;if(h<24&&Number(time[3]||0)<60){const seed=base||{year:2000,month:1,day:1,yearKnown:false,dateKnown:false};return {clock:{...seed,hour:h,minute:Number(time[3]||0)},reason:'player_time_override'};}}
  if(base){const nextDay=explicitNextDayTransition(text);
   if(nextDay){const next=addMinutes(base,24*60);let hour=next.hour,minute=next.minute;
     if(/早上|上午|清晨|一早/u.test(nextDay.period)){hour=7;minute=10;}
     else if(/中午/u.test(nextDay.period)){hour=12;minute=0;}
     else if(/下午/u.test(nextDay.period)){hour=15;minute=0;}
     else if(/晚上|夜晚/u.test(nextDay.period)){hour=20;minute=0;}
     else {hour=base.hour;minute=base.minute;}
     return {clock:{...next,hour,minute},reason:'player_next_day'};
   }
   const ancientElapsed=explicitAncientElapsed(text);
   if(ancientElapsed!==null)return {clock:addMinutes(base,ancientElapsed),reason:'player_elapsed_ancient'};
   const elapsed=text.match(/(?:過了|經過|時間過了|時間推進)(\d{1,3})\s*(分鐘|分|小時|個小時|天|日)/u);
   if(elapsed){const n=Number(elapsed[1]);const unit=elapsed[2];const minutes=n*(unit==='分鐘'||unit==='分'?1:(unit==='天'||unit==='日'?1440:60));return {clock:addMinutes(base,minutes),reason:'player_elapsed'};}
  }
 }
 if(!base)return {clock:null,reason:'unknown'};
 const requested=Number(advanceMinutes);
 const safe=Number.isFinite(requested)?Math.min(Math.max(5,Math.min(120,Math.trunc(maxNaturalMinutes))),Math.max(1,Math.trunc(requested))):3;
 return {clock:addMinutes(base,safe),reason:'normal_turn'};
}
// Choose a stable, fictional start date independently for each room.
// The room ID is randomly generated by Firebase; hashing it makes the initial
// selection repeatable across retries/concurrent requests before Firestore saves.
// Never use wall-clock dates, and never treat a bare year in world lore as an
// instruction to set the story calendar.
function creatorInitialCalendar(world={}) {
 const template=String(world.customOutputFormat||'').slice(0,16000);
 const explicitSources=[String(world.timeSystem||''),String(world.calendarSystem||''),
  String(world.timeFormat||'')];
 // An era consisting of just a year is an explicit calendar setting.
 const eraText=String(world.era||'').trim();
 const eraYear=eraText.match(/^(?:(?:西元|公元)\s*)?((?:1[6-9]|20|21)\d{2})\s*年?$/u);
 const relevant=template.split(/\r?\n/u).filter(line=>
  /(?:^|[：:\s])(?:起始(?:日期|時間|年份|年分)|故事(?:起始|開始)(?:日期|時間|年份|年分)?|日期|年月日|故事日期|📅|📆|🗓️)/u.test(line)
  || /(?:從|自|始於|設定為|起始於|開始於)\s*\d{4}\s*年/u.test(line));
 const creatorSettingLines=String(world.worldSetting||'').slice(0,5000).split(/\r?\n/u)
  .filter(line => /(?:故事|劇情|世界|時代|背景|開局|起始|開始|設定)/u.test(line) &&
    /(?:起始|開始|始於|設定於|設定在|發生於|發生在|從\s*\d{4}\s*年|西元\s*\d{4}\s*年)/u.test(line));
 const lines=[...explicitSources,...relevant,...creatorSettingLines];
 const exactDate=/(?:^|[^\d])((?:1[6-9]|20|21)\d{2})\s*(?:年\s*(\d{1,2})\s*月\s*(\d{1,2})\s*[日號]?|[\/.-](\d{1,2})[\/.-](\d{1,2}))(?!\d)/u;
 const explicitYear=/(?:起始(?:年份|年分|日期|時間)|故事(?:起始|開始)(?:於|在|年份|年分|日期|時間)?|開始於|始於|從|自|設定為|日期\s*[:：]|📅\s*[:：])[^\n\d]{0,24}((?:1[6-9]|20|21)\d{2})\s*年/u;
 for (const line of lines) {
  const match=line.match(exactDate);
  if(match){
   const year=Number(match[1]),month=Number(match[2]||match[4]),day=Number(match[3]||match[5]);
   if(dateOk(year,month,day))return {year,month,day};
  }
  const y=line.match(explicitYear);
  if(y)return {year:Number(y[1])};
  const startYear=line.match(/((?:1[6-9]|20|21)\d{2})\s*年\s*(?:開始|開局|起始|作為故事起點)/u);
  if(startYear)return {year:Number(startYear[1])};
  // Accept an explicitly labelled current story setting, not incidental history.
  const settingYear=line.match(/(?:故事|劇情|世界)(?:\s*(?:背景|時間|年代|年份|起點))?\s*(?:設定|發生)\s*(?:在|於)\s*((?:1[6-9]|20|21)\d{2})\s*年/u);
  if(settingYear)return {year:Number(settingYear[1])};
 }
 return eraYear ? {year:Number(eraYear[1])} : {};
}
function initialStoryClock(world={},roomId='',previous=null) {
 const prior=normalize(previous);
 // Existing confirmed story date wins even if creator settings have changed.
 if(prior?.dateKnown)return prior;
 const chosen=creatorInitialCalendar(world);
 const crypto=require('node:crypto');
 const digest=crypto.createHash('sha256').update('fictional-world-date-v10:'+String(roomId)).digest();
 const seededYear=2000+digest.readUInt32BE(0)%50; // 2000-2049, not the device date.
 const year=chosen.year||(prior?.yearKnown ? prior.year : seededYear);
 const month=chosen.month||1+digest.readUInt16BE(4)%12;
 const daysInMonth=new Date(Date.UTC(year,month,0)).getUTCDate();
 const day=chosen.day||1+digest.readUInt16BE(6)%daysInMonth;
 const hour=prior?.hour??8,minute=prior?.minute??0;
 return normalize({year,month,day,hour,minute,yearKnown:true,dateKnown:true});
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
 if(fixed!==null)return fixed;
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
 const pacing=policy.fixedMinutes===null ? '每輪一般對話自然經過一至五分鐘；實際經過時間以情節為準。' : `創作者明訂每回合推進 ${policy.fixedMinutes} 分鐘；玩家明確指定跳時時以玩家為準。`;
 if(detectTimeStyle(world)==='ancient') return pacing+' '+ '【世界紀時】此世界採古代時辰表達。NPC 自然使用子丑寅卯辰巳午未申酉戌亥時，避免現代數位鐘說法。後端以 24 小時精度保存事件先後；同一時辰內的短暫經過無須變更顯示。未指定陰曆/年號時，禁止把內部公曆月日當成農曆或虛構明朝年號。若創作者明訂不同曆法，以其世界觀為先，但勿自造日期換算。';
 return pacing+' '+'【世界紀時】此世界使用現代時間表達（24 小時制）；以故事內時間為準，不使用現實手機時間。若世界設定明示其他紀時方式，人物台詞依世界設定自然表達。';
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
  const match=source.match(/^第\s*([零〇一二兩三四五六七八九十百千\d]{1,8})\s*[日天]\s*[,，、\s]*(凌晨|清晨|早上|上午|中午|下午|傍晚|晚上|半夜)(?=$|[。．!！\s｜|])/u);
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
 const nextDay=explicitNextDayTransition(input);
 if(nextDay) {
  const next=addFictionalMinutes(base,1440);
  if(/早上|上午|清晨|一早/u.test(nextDay.period))return {...next,hour:7,minute:10};
  if(/中午/u.test(nextDay.period))return {...next,hour:12,minute:0};
  if(/下午/u.test(nextDay.period))return {...next,hour:15,minute:0};
  if(/晚上|夜晚/u.test(nextDay.period))return {...next,hour:20,minute:0};
  return next;
 }
 const ancientElapsed=explicitAncientElapsed(input);
 if(ancientElapsed!==null)return addFictionalMinutes(base,ancientElapsed);
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
 return addFictionalMinutes(base,Math.max(1,Math.min(120,Number.isFinite(Number(minutes))?Math.trunc(Number(minutes)):3)));
}



// Unlike generic word spotting, accept an explicit present-time/scene command.
// Mentions of past/future/hypothetical dates are not authorizations to rewrite
// the current story calendar.
function isExplicitCreatorCalendarTransition(message) {
  const input=String(message||'').trim().slice(0,1500);
  if(!input || /^(?:如果|假如|假設|回憶|回想|曾經|聽說|夢見|夢裡)/u.test(input))return false;
  if(explicitNextDayTransition(input))return true;
  return /(?:^|[\n。！？!?；;])\s*[（(]?\s*(?:時間|故事時間|日期|故事日期|劇情|場景|畫面)\s*(?:改成|設定為|設定成|跳到|跳至|推進到|來到|切到|進入)\s*[^\n。！？!?；;]{1,80}/u.test(input) ||
    /(?:^|[\n。！？!?；;])\s*[（(]?\s*(?:過了|經過|時間過了|時間推進)\s*\d{1,3}\s*(?:分鐘|分|小時|個小時|天|日)/u.test(input);
}

// V10: Treat a player's explicit present-time declaration as an authoritative
// creator-calendar override, not merely a prompt hint. A question ("現在幾點？")
// and an old/hypothetical date are NOT instructions to set a clock.
function explicitPlayerAncientTime(message) {
  const text=String(message||'').trim().slice(0,700);
  if(!text || /^(?:如果|假如|假設|回憶|回想|曾經|聽說|夢見|夢裡)/u.test(text))return null;
  const lines=text.split(/[\n。！？!?；;]/u).map(x=>x.trim());
  const cue=/(?:現在(?:的)?(?:故事)?(?:時間|時辰|日期)?|目前(?:的)?(?:故事)?(?:時間|時辰|日期)?|此刻|今日|今天|故事時間|故事日期|劇情時間|時間|時辰|日期)\s*(?:是|為|已是|設定為|設定成|改成|改為|跳到|跳至|推進到|來到|到|已到)/u;
  const branch=/(?:([子丑寅卯辰巳午未申酉戌亥])時\s*([一二三四]?刻)?)/u;
  const day=/([零〇一二兩三四五六七八九十廿卅初\d]{1,4})\s*(?:日|號)?\s*(?:[・·，,、\s-]+)?(?=[子丑寅卯辰巳午未申酉戌亥]時)/u;
  for(const line of lines){
    if(!cue.test(line)||/(?:如果|假如|假設|回憶|回想|曾經|夢裡|夢見|昨夜的|昨天的)/u.test(line))continue;
    const time=line.match(branch);
    if(!time)continue;
    const suffix=line.slice(line.indexOf(time[0])-22,time.index).replace(/^.*?(?:是|為|到|改成|設定為)/u,'');
    const dayMatch=line.match(/月\s*([零〇一二兩三四五六七八九十廿卅初\d]{1,4})\s*(?:日|號)?\s*[・·，,、\s-]*[子丑寅卯辰巳午未申酉戌亥]時/u) || suffix.match(day);
    const monthMatch=line.match(/([零〇一二兩三四五六七八九十\d]{1,4})月/u);
    const yearMatch=line.match(/([\p{Script=Han}]{1,12}[零〇一二兩三四五六七八九十百千\d]{1,8}年)/u);
    return {branch:time[1],quarter:time[2]||'',day:dayMatch?.[1]||'',month:monthMatch?.[1]||'',year:yearMatch?.[1]||''};
  }
  return null;
}

function reconcileExplicitPlayerAncientTime(template,status,previous,message,options={}){
  const current=String(status||''), prior=String(previous||'');
  if(options.regenerate || !current.trim() || !prior.trim() ||
      !/(?:時辰|時刻|故事時間|時間)/u.test(String(template||'')))return current;
  const target=explicitPlayerAncientTime(message);
  if(!target)return current;
  const label=/^\s*([^\n：:]{1,55})[：:]\s*(.*)$/u;
  const dateTime=/([\p{Script=Han}]{1,12}[零〇一二兩三四五六七八九十百千\d]{1,8}年\s*[・·，,、\s-]*)([零〇一二兩三四五六七八九十廿卅初\d]{1,4})(月\s*[・·，,、\s-]*)([零〇一二兩三四五六七八九十廿卅初\d]{1,4})(日?\s*[・·，,、\s-]*)([子丑寅卯辰巳午未申酉戌亥])時\s*([一二三四]?刻)?/u;
  const previousRows=new Map(prior.split(/\r?\n/u).map(line=>line.match(label))
    .filter(x=>x&&/(?:時辰|時刻|故事時間|時間)/u.test(x[1])).map(x=>[x[1].trim(),x[2]]));
  return current.split(/\r?\n/u).map(line=>{
    const m=line.match(label);
    if(!m || !/(?:時辰|時刻|故事時間|時間)/u.test(m[1]))return line;
    const prev=previousRows.get(m[1].trim());
    const old=prev?.match(dateTime), now=m[2].match(dateTime);
    if(!old || !now)return line; // preserve unknown calendars and creator formats
    // A time-only instruction changes only the branch; never invent a new day.
    // A full explicit month/day command can set that day, without Gregorian math.
    const year=target.year || old[1].trim().replace(/[・·，,、\s-]+$/u,'');
    const month=target.month || old[2];
    const day=target.day || old[4];
    const revised=year+old[1].slice(old[1].lastIndexOf('年')+1)+month+old[3]+day+old[5]+target.branch+'時'+target.quarter;
    return line.replace(now[0],revised);
  }).join('\n');
}

// Keep unknown creator calendars stable from the last committed status.
// A Gregorian arithmetic clock cannot calculate alien cycles, Roman eras or
// arbitrary author-defined dates. This guard never inserts a field, alters
// a known 24-hour clock, nor interprets creator prose as executable rules.
function preserveOpaqueCreatorCalendar(template, generated, previous, options={}) {
  const current=String(generated||'');
  if(!current.trim() || !String(previous||'').trim()) return current;
  // A deliberate player time jump may change a custom calendar. We cannot
  // validate its math, so don't override it with a stale prior date.
  if(options.explicitTransition===true && options.regenerate!==true) return current;
  const row=/^\s*([^\n：:]{1,55})[：:]\s*(.*)$/u;
  const calendarLabel=/(?:日期|年月|年分|年份|時間|時辰|曆|紀年|週期|周期|時段|星際日|星日|stardate|calendar|date|time|cycle)/iu;
  const labelOf=line=>line.match(row)?.[1]?.trim()||'';
  const authored=new Set(String(template||'').replace(/\r\n?/g,'\n').split('\n')
    .map(labelOf).filter(x=>calendarLabel.test(x)));
  if(!authored.size) return current;
  const bodyHead=value=>String(value||'').split(/[｜|]/u)[0].trim();
  const standard=value=>{
    const v=bodyHead(value);
    return /^(?:(?:\d{4}[\/.\-])?\d{1,2}[\/.\-]\d{1,2}\s+)?(?:[01]?\d|2[0-3])[:：][0-5]\d$/u.test(v) ||
      /^第\s*[零〇一二兩三四五六七八九十百千\d]+[日天][，,、\s]+(?:[01]?\d|2[0-3])[:：][0-5]\d$/u.test(v);
  };
  // Require strong date/cycle syntax; e.g. 「晚上」「亥時」 alone is an ordinary
  // time-of-day, not an opaque calendar requiring a whole-row freeze.
  const opaque=value=>{
    const v=bodyHead(value);
    return !standard(v) && v.length<=200 && (
      /(?:星曆|星歷|星際曆|星紀|紀元|紀年|週期|周期|星日|恆星日|羅馬曆|羅馬紀|帝國曆|曆年|stardate|galactic\s+(?:date|cycle)|sol\s*\d)/iu.test(v) ||
      /(?:[零〇一二兩三四五六七八九十百千\dIVXLCDM]{1,12})\s*(?:年|月|日|週|周|季|紀)[^\n]{0,75}(?:第\s*[零〇一二兩三四五六七八九十百千\dIVXLCDM]+|[零〇一二兩三四五六七八九十百千\dIVXLCDM]{1,12}\s*(?:日|時段|週期|周期))/iu.test(v)
    );
  };
  const oldRows=new Map();
  for(const line of String(previous).replace(/\r\n?/g,'\n').split('\n')) {
    const m=line.match(row);if(!m)continue;
    const label=m[1].trim(),head=bodyHead(m[2]);
    if(authored.has(label) && !oldRows.has(label) && opaque(head)) oldRows.set(label,head);
  }
  if(!oldRows.size)return current;
  return current.replace(/\r\n?/g,'\n').split('\n').map(line=>{
    const m=line.match(row);if(!m)return line;
    const label=m[1].trim();
    if(!oldRows.has(label))return line;
    const split=m[2].match(/^([^｜|]*)([｜|].*)?$/u);
    if(!split || !opaque(split[1]))return line;
    // Keep exact current field prefix and any separately-authored compound tail.
    const valueStart=line.indexOf(m[2]);
    return line.slice(0,valueStart)+oldRows.get(label)+(split[2]||'');
  }).join('\n');
}


// An author may use a standalone, colon-free calendar field such as
// ⏳2041/11/01 13:10.  The existing creator-calendar guard handles labelled
// rows but cannot see this format. Protect only an author-owned ⏳ row and
// never change locations, thoughts, other characters' plans, or hidden fields.
function protectHourglassStoryDate(template, generated, previous, options={}) {
  const current=String(generated||'');
  const prior=String(previous||'');
  if(!current.trim() || !prior.trim() || !/^\s*⏳/mu.test(String(template||'')))return current;
  // Date and time must be fully specified, at the start of an explicit ⏳ row.
  const pattern=/^(\s*⏳\s*[:：]?\s*)(\d{4})([\/.-])(\d{1,2})\3(\d{1,2})(\s+)([01]?\d|2[0-3])([:：])([0-5]\d)(?=\s|$|[｜|])/u;
  const parse=line=>{
    const m=String(line).match(pattern);
    if(!m)return null;
    const clock=normalize({year:Number(m[2]),month:Number(m[4]),day:Number(m[5]),
      hour:Number(m[7]),minute:Number(m[9]),yearKnown:true,dateKnown:true});
    return clock?{match:m,clock}:null;
  };
  const original=prior.replace(/\r\n?/gu,'\n').split('\n').map(parse).find(Boolean);
  if(!original)return current;
  // An intentional present-time jump and a verified SERVER-side day advance
  // take precedence.  A model's proposed date is not evidence of day advance.
  if(options.explicitTransition===true && options.regenerate!==true)return current;
  const backendAdvanced=options.backendDayAdvanced===true && options.regenerate!==true;
  const toMinutes=c=>Date.UTC(c.year,c.month-1,c.day,c.hour,c.minute);
  const oldTime=toMinutes(original.clock);
  let changed=false;
  const output=current.replace(/\r\n?/gu,'\n').split('\n').map(line=>{
    const next=parse(line);
    if(!next)return line;
    const proposed=toMinutes(next.clock);
    const previousDay=Date.UTC(original.clock.year,original.clock.month-1,original.clock.day);
    const proposedDay=Date.UTC(next.clock.year,next.clock.month-1,next.clock.day);
    const dateChanged=previousDay!==proposedDay;
    // A differing date without an authoritative day transition is never
    // allowed, even when it moves forwards.  On the same date, prevent the
    // clock from moving backwards on an ordinary new reply.
    if(options.regenerate===true || (dateChanged && !backendAdvanced) || (!dateChanged && proposed<oldTime)) {
      changed=true;
      const start=next.match.index||0;
      // Preserve the creator's CURRENT ⏳ prefix and rest of the status line.
      const prevDate=`${original.clock.year}${next.match[3]}${PAD(original.clock.month)}${next.match[3]}${PAD(original.clock.day)}`;
      const prevHour=`${PAD(original.clock.hour)}${next.match[8]}${PAD(original.clock.minute)}`;
      return line.slice(0,start)+next.match[1]+prevDate+next.match[6]+prevHour+
        line.slice(start+next.match[0].length);
    }
    return line;
  }).join('\n');
  if(options.audit && typeof options.audit==='object') options.audit.corrected=changed;
  return changed?output:current;
}

// V6: Interpret a SMALL, explicit arithmetic grammar already written by the
// creator. Free-form instructions are never evaluated as code. Incomplete or
// conflicting rules produce null and leave the last committed calendar intact.
// Only supports ordinal day/period fields that actually appear in the status;
// never invents a hidden day index to guess when a cycle ends.
function creatorOrdinalTimeRules(world={}) {
  const source=[world.timeSystem,world.timeFormat,world.calendarSystem,world.customOutputFormat]
    .map(x=>String(x||'').slice(0,6000)).join('\n');
  const rows=source.split(/\r?\n/u).filter(x=>/(?:每輪|每回合|每次對話|每次回覆|時段|週期|周期)/u.test(x))
    .slice(0,40).map(x=>x.slice(0,240));
  const text=rows.join('\n');
  const digit='(\\d{1,3})';
  const readUnique=patterns=>{
    const values=[];
    for(const pattern of patterns){
      const re=new RegExp(pattern,'gu');
      for(const m of text.matchAll(re)) values.push(Number(m[1]));
    }
    const unique=[...new Set(values)];
    return unique.length===1 ? unique[0] : null;
  };
  const perTurn=readUnique([
    '(?:每(?:一)?(?:輪|回合|次對話|次回覆)|每次(?:對話|回覆))\\s*(?:自然)?(?:推進|經過|增加|流逝|過去)\\s*'+digit+'\\s*(?:個)?時段',
    '(?:每(?:一)?(?:輪|回合|次對話|次回覆)|每次(?:對話|回覆))\\s*(?:自然)?(?:推進|經過|增加|流逝|過去)\\s*一個?時段',
  ]);
  const hasOneStep=/(?:每(?:一)?(?:輪|回合|次對話|次回覆)|每次(?:對話|回覆))\s*(?:自然)?(?:推進|經過|增加|流逝|過去)\s*一(?:個)?時段/u.test(text);
  const step=perTurn ?? (hasOneStep?1:null);
  const slotsPerDay=readUnique([
    '每\\s*'+digit+'\\s*(?:個)?時段\\s*(?:為|等於|算作|算|是)\\s*一(?:個)?[日天]',
    '一(?:個)?[日天]\\s*(?:有|含|包含|分成|分為)\\s*'+digit+'\\s*(?:個)?時段',
  ]);
  const daysPerCycle=readUnique([
    '每\\s*'+digit+'\\s*[日天]\\s*(?:為|等於|算作|算|是)\\s*一(?:個)?(?:週期|周期)',
    '一(?:個)?(?:週期|周期)\\s*(?:有|含|包含|分成|分為)\\s*'+digit+'\\s*[日天]',
  ]);
  // Two conflicting declarations, even if one is recognised, must not be
  // silently converted into an arbitrary choice.
  const countDeclared=regex=>(text.match(regex)||[]).length;
  const periodDeclarations=countDeclared(/每\s*\d{1,3}\s*(?:個)?時段\s*(?:為|等於|算作|算|是)\s*一(?:個)?[日天]|一(?:個)?[日天]\s*(?:有|含|包含|分成|分為)\s*\d{1,3}\s*(?:個)?時段/gu);
  if(step===null || !Number.isInteger(step) || step<1 || step>24 ||
    slotsPerDay===null || slotsPerDay<2 || slotsPerDay>100 ||
    (daysPerCycle!==null && (daysPerCycle<2 || daysPerCycle>365)) ||
    (periodDeclarations>0 && slotsPerDay===null)) return null;
  return {step,slotsPerDay,daysPerCycle};
}

// A calendar field such as 「星曆728年・第36週期・第8日・第12時段」.
// Increment only pieces present in the last committed display. When a day or
// cycle must roll over but its required counterpart is absent, freeze safely.
function advanceCreatorOrdinalTimeHead(oldHead, rules) {
  if(!rules)return null;
  const original=String(oldHead||'');
  const segment=/第\s*(\d{1,4})\s*(?:個)?時段/u;
  const day=/第\s*(\d{1,4})\s*[日天]/u;
  const cycle=/第\s*(\d{1,4})\s*(?:個)?(?:週期|周期)/u;
  const seg=original.match(segment);
  if(!seg || !/(?:星曆|星歷|星際曆|紀元|紀年|週期|周期|第\s*\d+\s*[日天])/u.test(original))return null;
  const currentSlot=Number(seg[1]);
  if(currentSlot<1 || currentSlot>rules.slotsPerDay)return null;
  let nextSlot=currentSlot+rules.step;
  const dayIncrease=Math.floor((nextSlot-1)/rules.slotsPerDay);
  nextSlot=(nextSlot-1)%rules.slotsPerDay+1;
  const d=original.match(day), c=original.match(cycle);
  if(dayIncrease && !d)return null; // Unknown day within a longer cycle.
  let nextDay=d?Number(d[1])+dayIncrease:null;
  let nextCycle=c?Number(c[1]):null;
  if(nextDay!==null && (nextDay<1||nextDay>9999))return null;
  if(nextDay!==null && rules.daysPerCycle!==null && nextDay>rules.daysPerCycle){
    if(!c)return null;
    nextCycle+=Math.floor((nextDay-1)/rules.daysPerCycle);
    nextDay=(nextDay-1)%rules.daysPerCycle+1;
  }
  // The creator did not define a year rollover. Don't invent one.
  if(nextCycle!==null && nextCycle>9999)return null;
  let result=original.replace(segment,m=>m.replace(seg[1],(seg[1].startsWith('0') ? String(nextSlot).padStart(seg[1].length,'0') : String(nextSlot))));
  if(d && nextDay!==null)result=result.replace(day,m=>m.replace(d[1],(d[1].startsWith('0') ? String(nextDay).padStart(d[1].length,'0') : String(nextDay))));
  if(c && nextCycle!==null)result=result.replace(cycle,m=>m.replace(c[1],(c[1].startsWith('0') ? String(nextCycle).padStart(c[1].length,'0') : String(nextCycle))));
  return result;
}


// Protect an ordinal STORY DAY inside an author-declared status row.
// This is not a generic numeric replacement: countdowns, quest deadlines,
// resource quantities, month dates and unsourced AI-generated rows are excluded.
// The previous committed status is the display anchor; only the SERVER clock
// may advance the ordinal on an ordinary turn. Never alter other row fragments.
function protectCreatorStoryDayOrdinal(template, generated, previous, options={}) {
  const now=String(generated||''), before=String(previous||'');
  if(!now.trim() || !before.trim())return now;
  const explicit=options.explicitTransition===true && options.regenerate!==true;
  if(explicit)return now; // Existing explicit creator calendar semantics stay intact.
  const row=/^\s*([^：:\n]{1,60})[：:]\s*(.*)$/u;
  const templateLabels=new Set(String(template||'').split(/\r?\n/u)
    .map(line=>line.match(row)?.[1]?.trim()).filter(Boolean));
  if(!templateLabels.size)return now;
  const dateLabel=/(?:時間|日期|日數|天數|日曆|日程|日序|紀日|曆法|環境|旅程|進度|進程|calendar|date|day|time)/iu;
  const storyPrefix=/(?:生存|冒險|末日|探索|旅程|旅行|流浪|故事|劇情|遊戲|開局|世界|在此|來到|進入|抵達|第?階段)/u;
  const excludePrefix=/(?:倒數|剩餘|剩下|期限|截止|冷卻|解鎖|任務|活動|連續|簽到|挑戰|獎勵|目標|營運|能源|物資)/u;
  const ordinal=/第\s*([零〇一二兩三四五六七八九十百千\d]{1,8})\s*([日天])/gu;
  const eligible=(label,body)=>{
    if(!templateLabels.has(label))return null;
    const head=String(body).split(/[｜|]/u)[0];
    const hits=[...head.matchAll(ordinal)].filter(match=>{
      const leading=head.slice(Math.max(0,match.index-14),match.index);
      const nearest=leading.replace(/.*[，,、。:：;；｜|]/u,'').trim();
      if(excludePrefix.test(nearest))return false;
      return dateLabel.test(label) || storyPrefix.test(nearest);
    });
    return hits.length===1 ? hits[0] : null; // Ambiguous multi-day rows fail closed.
  };
  const old=new Map();
  for(const line of before.split(/\r?\n/u)){
    const m=line.match(row);if(!m)continue;
    const label=m[1].trim(),hit=eligible(label,m[2]);
    if(!hit || old.has(label))continue;
    const day=parseDayNumber(hit[1]);
    if(Number.isInteger(day) && day>=1 && day<=9999)old.set(label,{day,raw:hit[1]});
  }
  if(!old.size)return now;
  // The day count comes from the backend, not the model's proposed status.
  // For an uninitialized clock, keep the last committed day rather than guess.
  const delta=options.regenerate===true ? 0 : Number(options.backendDaysElapsed);
  const days=Number.isSafeInteger(delta)&&delta>=0&&delta<=3650 ? delta : 0;
  return now.split(/\r?\n/u).map(line=>{
    const m=line.match(row);if(!m)return line;
    const label=m[1].trim(),oldDay=old.get(label);
    if(!oldDay)return line;
    const hit=eligible(label,m[2]);if(!hit)return line;
    const expected=oldDay.day+days;
    if(expected>9999)return line;
    const replacement=/^\d+$/u.test(oldDay.raw)
      ? String(expected).padStart(oldDay.raw.length,'0') : chineseDay(expected);
    const body=m[2];
    const next=body.slice(0,hit.index)+hit[0].replace(hit[1],replacement)+body.slice(hit.index+hit[0].length);
    return line.slice(0,line.length-body.length)+next;
  }).join('\n');
}

// V5: A creator-declared time field is a VIEW, never an authoritative clock.
// Preserve the prior committed field's calendar and apply ONLY the server-approved
// elapsed minutes when its display is an unambiguous Gregorian numeric date.
// For calendars we cannot calculate, keep the last committed display unchanged.
// No model text can establish a date change on an ordinary turn.
function enforceCreatorTimeAuthority(template, generated, previous, options={}) {
  const now=String(generated||'');
  const before=String(previous||'');
  if(!now.trim() || !before.trim()) return now;
  const noOp=options.regenerate===true;
  const explicit=options.explicitTransition===true && !noOp;
  const cue=/^(?:\s*(?:⏳|⌛|📅|📆|🗓️?|🕰️?|⏰|🕒)|\s*(?:日期|故事日期|當前日期|目前日期|時間|故事時間|目前時間|當前時間|時刻|時辰|紀年|曆法|星曆|星際曆法|週期|周期|calendar|date|time|stardate)(?:\s|[：:｜|]|$))/iu;
  // A time row must be creator-authored; AI-invented rows aren't adopted.
  const key=line=>{
    const str=String(line||'').trim();
    if(!cue.test(str)) return '';
    // Emoji-first: never mistake the colon in HH:MM for a field separator.
    const emoji=str.match(/^((?:⏳|⌛|📅|📆|🗓️?|🕰️?|⏰|🕒))\s*/u);
    if(emoji)return emoji[1];
    const named=str.match(/^([^：:\n]{1,60})[：:]/u);
    return named?named[1].trim():'';
  };
  const lines=s=>String(s).replace(/\r\n?/gu,'\n').split('\n');
  const authoredKeys=lines(template).map(key).filter(Boolean);
  const counts=new Map();
  for(const id of authoredKeys)counts.set(id,(counts.get(id)||0)+1);
  // Multiple identical symbolic clock labels are ambiguous. Skip them rather
  // than projecting one row's time into another intentional creator section.
  const declared=new Set(authoredKeys.filter(id=>counts.get(id)===1));
  if(!declared.size)return now;
  const rows=s=>{
    const map=new Map();
    for(const line of lines(s)) {
      const id=key(line);
      if(id && declared.has(id) && !map.has(id))map.set(id,line);
    }
    return map;
  };
  const old=rows(before);
  if(!old.size)return now;
  const ordinalRules=creatorOrdinalTimeRules(options.world||{});
  const dateRe=/(\d{4})([\/.\-])(\d{1,2})\2(\d{1,2})/u;
  const timeRe=/(?:^|[^\d])([01]?\d|2[0-3])[:：]([0-5]\d)(?!\d)/u;
  // Find the last committed calendar AND clock, including split date/time rows.
  let oldDate=null, oldTime=null;
  for(const line of old.values()){
    const head=line.split(/[｜|]/u)[0];
    const date=head.match(dateRe), time=head.match(timeRe);
    if(date && !oldDate) {
      const c=normalize({year:Number(date[1]),month:Number(date[3]),day:Number(date[4]),hour:0,minute:0,yearKnown:true,dateKnown:true});
      if(c)oldDate=c;
    }
    if(time && !oldTime)oldTime={hour:Number(time[1]),minute:Number(time[2])};
  }
  // Opaque calendars cannot be converted safely; intentional player jumps may
  // provide a new authored anchor, while numeric clocks still use server delta.
  if(explicit && !oldDate)return now;
  const deltaInput=Number(options.elapsedMinutes);
  // A negative/unknown backend delta is never permission to rewind the view.
  const delta=Number.isSafeInteger(deltaInput)&&deltaInput>=0&&deltaInput<=5256000 ? deltaInput : 0;
  let expected=null;
  if(oldDate){
    const h=oldTime?.hour??0,m=oldTime?.minute??0;
    expected=addMinutes({...oldDate,hour:h,minute:m},delta);
  }
  const expectedTime=oldTime ? (()=>{
    const minutes=(oldTime.hour*60+oldTime.minute+delta)%1440;
    return {hour:Math.floor(minutes/60),minute:minutes%60};
  })():null;
  return lines(now).map(line=>{
    const id=key(line);
    if(!id || !declared.has(id) || !old.has(id))return line;
    const priorLine=old.get(id);
    // Exact label prefix is safe for named rows; unlabelled emoji rows use
    // the emoji key. Preserve punctuation following the key from this turn.
    const prefix=line.slice(0,line.indexOf(id)+id.length);
    const prevBody=priorLine.slice(priorLine.indexOf(id)+id.length);
    const newBody=line.slice(line.indexOf(id)+id.length);
    const split=v=>v.match(/^([^｜|]*)([｜|].*)?$/u);
    const p=split(prevBody),n=split(newBody);
    if(!p||!n)return line;
    let head=p[1];
    // Ordinal units are advanced from the last COMMITTED status, never the
    // model proposal. A natural short turn is one declared step; explicit
    // jumps and regenerations retain the existing conservative protections.
    if(!noOp && !explicit && !oldDate && ordinalRules && delta<=5) {
      const calculated=advanceCreatorOrdinalTimeHead(head,ordinalRules);
      if(calculated!==null)head=calculated;
    }
    if(expected && dateRe.test(head)){
      head=head.replace(dateRe,(_all,y,separator,m,d)=>`${String(expected.year).padStart(4,'0')}${separator}${String(expected.month).padStart(m.length,'0')}${separator}${String(expected.day).padStart(d.length,'0')}`);
      if(/[（(][一二三四五六日][）)]/u.test(head)) {
        const wd='日一二三四五六'[new Date(Date.UTC(expected.year,expected.month-1,expected.day)).getUTCDay()];
        head=head.replace(/([（(])[一二三四五六日]([）)])/u,(_all,a,b)=>a+wd+b);
      }
    }
    if(expectedTime && timeRe.test(head)){
      head=head.replace(timeRe,(full,h,m)=>full.replace(new RegExp(`${h}[:：]${m}$`,'u'), `${String(expectedTime.hour).padStart(h.length,'0')}:${String(expectedTime.minute).padStart(m.length,'0')}`));
    }
    return prefix+head+(n[2]||'');
  }).join('\n');
}


// Accept only an explicit PRESENT-tense story-time statement in the current
// rendered scene. This never reads remembered events, hidden chapters or model
// calendar guesses. Ancient lunar month boundaries remain creator-owned.
function reconcileExplicitAncientSceneTime(template, status, previous, segments, options={}) {
  const current=String(status||''), prior=String(previous||'');
  if(options.regenerate || !current.trim() || !prior.trim() || !Array.isArray(segments))return current;
  if(!/(?:時辰|時刻|🕰|⏰)/u.test(String(template||'')))return current;
  const present=/(?:現下|眼下|如今|此刻|現在|眼前|當下|此時)\s*(?:已|已經|正|約|剛|已過|才|是|為|到|到了|過了|已到|已是|已過了|已至|將近|已近|已經過了|已經到了|已經是)?\s*(?:過|到|至|是|為|近|了)?\s*([子丑寅卯辰巳午未申酉戌亥])時\s*([一二三四]?刻)?/gu;
  const story=segments.filter(s=>s && (s.kind==='npc'||s.kind==='narrator') && !s.isStatusBar)
    .map(s=>String(s.text||'').slice(0,1200)).join('\n').slice(-5000);
  const cues=[...story.matchAll(present)];
  if(cues.length!==1)return current; // ambiguous scene clocks are not authoritative
  const [,branch,quarter='']=cues[0];
  // A separate historical timestamp using this same branch is ambiguous.
  if(new RegExp(`(?:昨夜|昨晚|昨日|回憶|曾經)[^。！？\\n]{0,12}${branch}時`,'u').test(story))return current;
  const branches='子丑寅卯辰巳午未申酉戌亥';
  // Require corroboration for an overnight leap: a new morning AND a
  // reference to the previous night in the same newly-generated scene.
  const nightToMorning=/昨夜|昨晚|一夜過去|翌晨|隔日清晨|次日清晨|天亮了|天已亮/u.test(story) &&
    /[子丑亥]/u.test(prior) && /[寅卯辰]/u.test(branch);
  const row=/^\s*([^\n：:]{1,55})[：:]\s*(.*)$/u;
  const timeLabel=label=>/(?:時辰|時間|時刻|故事時間|現在時間|當前時間|🕰|⏰)/u.test(label);
  const priorRows=prior.split(/\r?\n/u).map(line=>line.match(row)).filter(m=>m && timeLabel(m[1]));
  const currentRows=current.split(/\r?\n/u);
  if(!priorRows.length)return current;
  const numeral='零〇一二兩三四五六七八九十廿卅初';
  const numOf=v=>{
    const x=String(v||'').replace(/^初/u,'');
    if(/^\d{1,2}$/u.test(x))return Number(x);
    const digit={'零':0,'〇':0,'一':1,'二':2,'兩':2,'三':3,'四':4,'五':5,'六':6,'七':7,'八':8,'九':9};
    if(x==='十')return 10;
    if(x.startsWith('廿'))return 20+(digit[x.slice(1)]||0);
    if(x.startsWith('卅'))return 30+(digit[x.slice(1)]||0);
    if(x.includes('十')) {const [a,b]=x.split('十');return (a?(digit[a]||0):1)*10+(digit[b]||0);}
    return Object.hasOwn(digit,x)?digit[x]:null;
  };
  const nextNumeral=n=>{
    if(n<=10)return n===10?'十':'一二三四五六七八九'[n-1];
    if(n<20)return '十'+'一二三四五六七八九'[n-11];
    if(n===20)return '二十';
    if(n<30)return '二十'+'一二三四五六七八九'[n-21];
    return n===30?'三十':null;
  };
  const dateTime=new RegExp(`([\\p{Script=Han}]{1,12}[零〇一二兩三四五六七八九十百千\\d]{1,8}年\\s*[・·，,、\\s-]*[${numeral}\\d]{1,4}月\\s*[・·，,、\\s-]*)([${numeral}\\d]{1,4})(日?\\s*[・·，,、\\s-]*)([子丑寅卯辰巳午未申酉戌亥])時\\s*([一二三四]?刻)?`,'u');
  let changed=false;
  const out=currentRows.map(line=>{
    const m=line.match(row);
    if(!m||!timeLabel(m[1]))return line;
    const earlier=priorRows.find(pr=>pr[1].trim()===m[1].trim());
    if(!earlier)return line;
    const old=earlier[2].match(dateTime), now=m[2].match(dateTime);
    if(!old||!now)return line;
    const oldDay=numOf(old[2]);
    if(!oldDay || oldDay>30 || old[4]===branch)return line;
    // No guessing 29/30-day lunar months or historical leap months.
    const nextDay=nightToMorning && oldDay<30 ? nextNumeral(oldDay+1):null;
    if(nightToMorning && !nextDay)return line;
    const newDate=old[1]+(nextDay||old[2])+old[3]+branch+'時'+quarter;
    changed=true;
    return line.replace(now[0],newDate);
  }).join('\n');
  return changed?out:current;
}


// V13: apply the room's accumulated server minutes to a creator-authored
// Chinese-era time row. Never infer a lunar month length, overwrite a creator
// label, trust model-proposed time on ordinary turns, or use real device time.
// Carry is persisted per room so 3-minute turns eventually make a 15-minute
// quarter visible. A changed, validated explicit time row becomes a new anchor.
function advanceCreatorAncientDisplay(template, status, previous, elapsedMinutes, savedCarry=0, options={}) {
  const current=String(status||''), before=String(previous||'');
  const oldCarry=Number.isInteger(savedCarry) && savedCarry>=0 && savedCarry<120 ? savedCarry : 0;
  const result=(text,carry,handled=false,reason='skip')=>({status:text,carry,handled,reason});
  if(!current.trim() || !before.trim() || !String(template||'').trim())return result(current,oldCarry);
  if(options.regenerate)return result(current,oldCarry);
  const row=/^(\s*([^\n：:]{1,55})[：:]\s*)(.*)$/u;
  const timeLabel=label=>/(?:時辰|時間|時刻|故事時間|現在時間|當前時間|🕰|⏰)/u.test(label);
  const authored=new Set(String(template).split(/\r?\n/u).map(line=>line.match(row))
    .filter(m=>m&&timeLabel(m[2])).map(m=>m[2].trim()));
  if(!authored.size)return result(current,oldCarry);
  const findLine=text=>text.split(/\r?\n/u).map((line,index)=>({line,index,m:line.match(row)}))
    .filter(item=>item.m&&authored.has(item.m[2].trim()));
  const previousRows=findLine(before), currentRows=findLine(current);
  if(previousRows.length!==1 || currentRows.length!==1 ||
      previousRows[0].m[2].trim()!==currentRows[0].m[2].trim())return result(current,oldCarry);
  const prev=previousRows[0], now=currentRows[0];
  // Recognizes a complete dated time, but not incidental historical dates in
  // unrelated status lines. The creator's current naming and punctuation remain.
  const dateTime=/([\p{Script=Han}]{1,12}(?:元|[零〇一二兩三四五六七八九十百千\d]{1,8})年\s*[・·，,、\s-]*)([零〇一二兩三四五六七八九十\d]{1,4})(月\s*[・·，,、\s-]*)([初廿卅零〇一二兩三四五六七八九十\d]{1,4})(日?\s*[・·，,、\s-]*)([子丑寅卯辰巳午未申酉戌亥])時([一二三四五六七八]?刻)?/u;
  const a=prev.m[3].match(dateTime),b=now.m[3].match(dateTime);
  if(!a || !b)return result(current,oldCarry);
  // If an explicit player/scene time update has already been validated by the
  // existing pipeline, do not advance it a second time.
  if(options.explicitTransition || a[0]!==b[0])return result(current,0,true,'new_anchor');
  const duration=Number(elapsedMinutes);
  if(!Number.isSafeInteger(duration) || duration<0 || duration>120)return result(current,oldCarry);
  const branches='子丑寅卯辰巳午未申酉戌亥';
  const numerals='一二三四五六七八';
  const withQuarter=Boolean(a[7]);
  const quarter=withQuarter ? numerals.indexOf(a[7][0])+1 : 1;
  if(quarter<1)return result(current,oldCarry);
  const step=withQuarter?15:120;
  const carried=oldCarry+duration;
  const steps=Math.floor(carried/step);
  const remain=carried%step;
  if(!steps)return result(current,remain,true,'accumulated');
  const initialBranch=branches.indexOf(a[6]);
  if(initialBranch<0)return result(current,oldCarry);
  const initialSlot=initialBranch*8+(withQuarter?quarter-1:0);
  const slot=(initialSlot+steps*(withQuarter?1:8))%96;
  const wraps=Math.floor((initialSlot+steps*(withQuarter?1:8))/96);
  const nextBranch=branches[Math.floor(slot/8)];
  const nextQuarter=withQuarter?numerals[slot%8]+'刻':'';
  const dayText=a[4];
  const hanDigit={'零':0,'〇':0,'一':1,'二':2,'兩':2,'三':3,'四':4,'五':5,'六':6,'七':7,'八':8,'九':9};
  const parseDay=v=>{if(/^\d{1,2}$/u.test(v))return Number(v);
    if(v.startsWith('初'))return parseDay(v.slice(1));
    if(v==='十')return 10;
    if(v.startsWith('廿'))return 20+(hanDigit[v.slice(1)]??0);
    if(v.startsWith('卅'))return 30+(hanDigit[v.slice(1)]??0);
    if(v.includes('十')){const [l,r]=v.split('十');return (l?(hanDigit[l]??0):1)*10+(hanDigit[r]??0);}
    return hanDigit[v]??null;};
  const toDay=(n,was)=>{if(/^\d+$/u.test(was))return String(n).padStart(was.length,'0');
    if(was.startsWith('初')&&n<=10)return '初'+(n===10?'十':numerals[n-1]);
    if(n<=9)return numerals[n-1];if(n===10)return '十';
    if(n<20)return '十'+numerals[n-11];if(n===20)return '二十';
    if(n<30)return '二十'+numerals[n-21];if(n===30)return '三十';return null;};
  let nextDay=dayText;
  if(wraps){const n=parseDay(dayText);
    // Unknown historical month length: don't invent an inter-month date.
    if(!n || n+wraps>30)return result(current,oldCarry);
    nextDay=toDay(n+wraps,dayText);
    if(!nextDay)return result(current,oldCarry);
  }
  const replacement=a[1]+a[2]+a[3]+nextDay+a[5]+nextBranch+'時'+nextQuarter;
  const lines=current.split(/\r?\n/u);
  lines[now.index]=lines[now.index].replace(b[0],replacement);
  return result(lines.join('\n'),remain,true,'advanced');
}

module.exports={normalize,label,addMinutes,resolveClock,creatorInitialCalendar,initialStoryClock,parseStatusClock,enforceStatusTime,detectTimeStyle,branchOfHour,displayTime,timePresentationDirective,creatorTimePolicy,advanceForWorld,normalizeFictionalClock,parseFictionalTime,parseFictionalDaypart,parseFictionalStatusAnchor,displayFictionalClock,resolveFictionalClock,preserveOpaqueCreatorCalendar,isExplicitCreatorCalendarTransition,explicitPlayerAncientTime,reconcileExplicitPlayerAncientTime,protectHourglassStoryDate,enforceCreatorTimeAuthority,protectCreatorStoryDayOrdinal,creatorOrdinalTimeRules,advanceCreatorOrdinalTimeHead,reconcileExplicitAncientSceneTime,advanceCreatorAncientDisplay};
