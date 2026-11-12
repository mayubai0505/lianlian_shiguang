'use strict';
// Read-only diagnostic. No database writes, no AI calls.
const { initializeApp, getApps, applicationDefault } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const PROJECT = 'lianlianshiguang';
const APP_ID = 'lianlianshiguang';
if (!getApps().length) initializeApp({credential: applicationDefault(), projectId: PROJECT});
const db = getFirestore();
function when(v) {
  if (!v) return '-';
  if (typeof v.toDate === 'function') return v.toDate().toISOString();
  return String(v);
}
function briefClock(v) {
  if (!v || typeof v !== 'object') return '-';
  return JSON.stringify(v, (k,val) => k === 'sourceMessageAt' ? undefined : val);
}
function redactStatus(text) {
  // Show ONLY calendar/time status rows, not whole player text or NPC secrets.
  return String(text || '').split(/\r?\n/)
    .filter(x => /^(?:\s*(?:📅|📆|🗓️?|⏰|🕒|🕰️?|⌚|日期|時間|時刻|故事時間|當前時間|故事日期)\s*[:：])/u.test(x))
    .map(x => x.trim().slice(0,100)).slice(0,4);
}
async function main() {
  const sid = process.argv[2];
  const base = db.collection('artifacts').doc(APP_ID).collection('world_chat_sessions');
  if (!sid) {
    const snap = await base.orderBy('lastActivity','desc').limit(40).get();
    console.log('最近 40 個有 lastActivity 的開放世界房間（只顯示診斷欄位）：');
    if (snap.empty) console.log('查無結果。請確認專案與資料路徑，或房間是否有 lastActivity。');
    snap.docs.forEach((doc,i) => {
      const d=doc.data();
      console.log(`\n${i+1}. sessionId=${doc.id}\n  worldName=${String(d.worldName||'(未儲存世界名)').slice(0,70)}  lastActivity=${when(d.lastActivity)}\n  storyClock=${briefClock(d.storyClock)}  fictionalStoryClock=${briefClock(d.fictionalStoryClock)}\n  storyTimeAnchor=${String(d.storyTimeAnchor||'-').slice(0,80)}`);
    });
    console.log('\n找到房間後，執行：node .\\debug_world_clock.js <sessionId>');
    return;
  }
  if (!/^[A-Za-z0-9_-]{1,150}$/.test(sid)) throw new Error('sessionId 格式不正確');
  const ref=base.doc(sid), snap=await ref.get();
  if (!snap.exists) { console.error('找不到這個 sessionId'); process.exitCode=1; return; }
  const d=snap.data();
  console.log('房間狀態（唯讀）：',{
    sessionId:sid,worldName:d.worldName||null,lastActivity:when(d.lastActivity),
    storyClock:d.storyClock||null,fictionalStoryClock:d.fictionalStoryClock||null,
    storyClockUpdatedAt:when(d.storyClockUpdatedAt),storyTimeAnchor:d.storyTimeAnchor||null,
    storyTimeAnchorUpdatedAt:when(d.storyTimeAnchorUpdatedAt),
  });
  const messages=await ref.collection('messages').orderBy('timestamp','desc').limit(12).get();
  console.log('\n最近 12 筆訊息（僅 AI 狀態欄日期／時間，不含正文）：');
  for (const doc of messages.docs.reverse()) {
    const m=doc.data();
    if (m.sender !== 'ai') continue;
    const status=(Array.isArray(m.segments)?m.segments:[])
      .filter(s=>s?.isStatusBar===true).flatMap(s=>redactStatus(s.text));
    console.log({at:when(m.timestamp),statusTimeRows:status.length?status:['(無日期時間欄位)']});
  }
}
main().catch(e=>{console.error('診斷失敗：',e?.message||e);process.exitCode=1;});
