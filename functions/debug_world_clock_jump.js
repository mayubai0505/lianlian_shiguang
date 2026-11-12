'use strict';
// Read-only narrow investigation for a fictional-day transition. Never prints full chat.
const {initializeApp,getApps,applicationDefault}=require('firebase-admin/app');
const {getFirestore,Timestamp}=require('firebase-admin/firestore');
const PROJECT='lianlianshiguang',APP_ID='lianlianshiguang';
if(!getApps().length)initializeApp({credential:applicationDefault(),projectId:PROJECT});
const db=getFirestore();
const sid=process.argv[2];
const show=process.argv.includes('--show-player-text');
if(!sid||!/^[\w-]{1,150}$/.test(sid)){
 console.error('用法：node .\\debug_world_clock_jump.js <sessionId> [--show-player-text]');process.exit(1);
}
const start=Timestamp.fromDate(new Date('2026-11-10T08:15:00.000Z'));
const end=Timestamp.fromDate(new Date('2026-11-10T09:05:00.000Z'));
const cue=/(隔天|第二天|翌日|次日|第\s*[二2兩]\s*[日天]|過了\s*\d+\s*[天日]|經過\s*\d+\s*[天日]|時間(?:跳到|推進|改成)|故事時間)/gu;
function tm(t){return t?.toDate?.().toISOString()||'(無 timestamp)';}
function statusRows(m){return (Array.isArray(m.segments)?m.segments:[]).filter(s=>s?.isStatusBar===true).flatMap(s=>String(s.text||'').split(/\r?\n/).filter(x=>/^\s*(?:📅|📆|🗓️?|⏰|日期|時間|故事時間)\s*[:：]/u.test(x)).map(x=>x.trim().slice(0,100))).slice(0,4);}
(async()=>{
 const room=db.collection('artifacts').doc(APP_ID).collection('world_chat_sessions').doc(sid);
 const doc=await room.get();if(!doc.exists)throw Error('房間不存在');
 console.log('目標世界：',doc.data().worldName||'(未命名)');
 console.log('查詢範圍：2026-11-10 08:15–09:05 UTC（台灣 16:15–17:05）');
 const snap=await room.collection('messages').where('timestamp','>=',start).where('timestamp','<=',end).orderBy('timestamp','asc').limit(80).get();
 if(snap.empty){console.log('查無這段時間的訊息；確認訊息是否存於此房間或時間範圍');return;}
 for(const d of snap.docs){const m=d.data();if(!['user','ai'].includes(m.sender))continue;
  console.log('\n'+tm(m.timestamp)+' '+(m.sender==='user'?'玩家':'AI'));
  if(m.sender==='user'){
   const raw=String(m.text||'');const matches=[...raw.matchAll(cue)].map(x=>x[0]);
   console.log('  時間跳躍關鍵詞：',matches.length?[...new Set(matches)].join('、'):'無');
   if(show) console.log('  玩家原文（僅在手動指定時顯示）：',raw.slice(0,1000));
  }else{
   const rows=statusRows(m);console.log('  狀態日期：',rows.length?rows.join(' / '):'(無可辨識日期欄)');
  }
 }
 console.log('\n判讀：若第二日前的玩家訊息沒有跳日指令，請再檢查同一時間的 Cloud Logging「world story clock diagnostic」及當時使用的程式版號；此工具無法回溯 Firestore 被覆寫前的時鐘。');
})().catch(e=>{console.error('查詢失敗：',e.message);process.exitCode=1});
