'use strict';
// Offline maintenance only. Run from functions/ with Application Default Credentials.
const fs = require('node:fs');
const crypto = require('node:crypto');
const {initializeApp, applicationDefault} = require('firebase-admin/app');
const {getFirestore, FieldPath, FieldValue} = require('firebase-admin/firestore');
const {indexPayload} = require('../src/memory/search_index');
const PROJECT = 'lianlianshiguang';
const BAD = '妮妮';
const digest = x => crypto.createHash('sha256').update(JSON.stringify(x)).digest('hex');
const str = x => String(x ?? '').trim();
const looks = x => /^妮妮(?=引用|相信|喜歡|討厭|不|認為|知道|需要|想|打算|會|要|在|是|有|曾|已|早|晚|今|明|昨|每|的|對|希望|覺得|表示|說|提到|，|：|\s)/u.test(x);
function locate(path) {
  const p=path.split('/');
  if(p[0]==='users' && p[2]==='profile_memories' && p[4]==='memories' && p.length===6) return {uid:p[1],profile:p[3],scope:'profile'};
  if(p[0]==='users' && p[2]==='profile_memories' && p[4]==='characters' && p[6]==='memories' && p.length===8) return {uid:p[1],profile:p[3],character:p[5],scope:'character'};
  if(p[0]==='users' && p[2]==='characters' && p[4]==='memories' && p.length===6) return {uid:p[1],profile:'default',character:p[3],scope:'character'};
  if(p[0]==='artifacts' && p[1]===PROJECT && p[2]==='chat_sessions' && p[4]==='memories' && p.length===6) return {session:p[3],scope:'session'};
  return null;
}
function snapshotKey(d) {return digest([d.text,d.factKey,d.factValue,d.active,d.deletedByUser,d.playerProfileId,d.characterId,d.sourceSessionId,d.sessionId,d.sourceMessage,d.evidence,d.sourceRole,d.source,d.updatedAt,d.retrievalTerms,d.searchTextHash,d.searchIndexVersion]);}
async function main(){
 const args=process.argv.slice(2); const apply=args[0]==='--apply';
 if(!(args[0]==='--scan' && args.length===2 || apply && args.length===4 && args[2]==='--confirm' && args[3]===PROJECT)) throw Error('Usage: --scan REPORT.json OR --apply REPORT.json --confirm lianlianshiguang');
 const reportPath=args[1];
 if(apply && !fs.existsSync(reportPath)) throw Error('Report missing');
 if(!apply && fs.existsSync(reportPath)) throw Error('Report already exists; choose a new name');
 initializeApp({credential:applicationDefault(),projectId:PROJECT}); const db=getFirestore();
 async function inspect(snap,read){
  const d=snap.data(); const loc=locate(snap.ref.path); const text=str(d?.text);
  if(!loc || !d || !looks(text)) return null;
  const base={path:snap.ref.path,oldText:text,approved:false,signature:snapshotKey(d)};
  const skip=reason=>({...base,status:'review_only',reason});
  if(d.active!==true || d.deletedByUser===true || d.lockedByUser===true || d.source!=='auto' || d.sourceRole!=='user') return skip('inactive, manual, locked, or unverified source');
  const source=str(d.sourceMessage), evidence=str(d.evidence);
  if(!source || !evidence || !source.includes(evidence) || source.includes(BAD) || evidence.includes(BAD)) return skip('source missing, inconsistent, or mentions name');
  if(!str(d.factKey) || !str(d.factValue) || str(d.factValue).includes(BAD) || text.slice(BAD.length).includes(BAD)) return skip('ambiguous name or fact fields');
  const sid=str(d.sourceSessionId || d.sessionId);
  if(!sid || (loc.session && loc.session!==sid) || (d.sourceSessionId && d.sessionId && d.sourceSessionId!==d.sessionId)) return skip('session mismatch');
  const room=(await read(db.doc(`artifacts/${PROJECT}/chat_sessions/${sid}`))).data();
  if(!room || !str(room.userId) || (loc.uid && loc.uid!==room.userId)) return skip('room owner mismatch');
  if(!str(d.characterId) || room.characterId!==d.characterId || (loc.character && loc.character!==d.characterId)) return skip('character mismatch');
  const pid=str(d.playerProfileId);
  if(!pid || pid!==str(room.playerProfileId) || (loc.profile && loc.profile!==pid)) return skip('profile mismatch');
  if(loc.scope!==str(d.scope) && !(pid==='default' && loc.scope==='character')) return skip('scope mismatch');
  const owner=(await read(db.doc(`users/${room.userId}`))).data();
  if(!owner) return skip('owner missing');
  const matches=Array.isArray(owner.profiles)?owner.profiles.filter(p=>str(p?.id)===pid):[];
  const name=pid==='default'?str(owner.nickname):matches.length===1?str(matches[0].name):'';
  if(!name || /[\r\n]/.test(name) || name.startsWith(BAD)) return skip('name missing, ambiguous, or possibly legitimate');
  const newText=name+text.slice(BAD.length);
  if(newText.length>900) return skip('text exceeds storage limit');
  return {...base,status:'candidate',newText,profileId:pid,sourceSessionId:sid,reason:'verify historical name and source before approval'};
 }
 if(!apply){
  const report={project:PROJECT,version:1,createdAt:new Date().toISOString(),scanned:0,entries:[]}; let last;
  while(true){let q=db.collectionGroup('memories').orderBy(FieldPath.documentId()).limit(300); if(last)q=q.startAfter(last); const batch=await q.get(); if(batch.empty)break;
   for(const s of batch.docs){report.scanned++; if(locate(s.ref.path)&&looks(str(s.data().text))){const c=await inspect(s,r=>r.get()); if(c)report.entries.push(c);}}
   last=batch.docs.at(-1); console.log('Scanned:',report.scanned,'Matches:',report.entries.length); if(batch.size<300)break;
  }
  fs.writeFileSync(reportPath,JSON.stringify(report,null,2),{flag:'wx',mode:0o600}); console.log('READ ONLY. No database writes. Candidates:',report.entries.filter(x=>x.status==='candidate').length,'Report:',reportPath); return;
 }
 const report=JSON.parse(fs.readFileSync(reportPath,'utf8')); if(report.project!==PROJECT||report.version!==1||!Array.isArray(report.entries))throw Error('Invalid report');
 const selected=report.entries.filter(e=>e.approved===true && e.status==='candidate');
 if(!selected.length){console.log('No approved candidates. No writes.');return;}
 if(new Set(selected.map(e=>e.path)).size!==selected.length)throw Error('Duplicate paths');
 const backup=reportPath+'.backup-'+Date.now()+'.jsonl'; const fd=fs.openSync(backup,'wx',0o600);
 let changed=0,skipped=0;
 try{for(const entry of selected){
  if(!locate(entry.path)){skipped++;continue;}
  const ref=db.doc(entry.path);
  // Backup durable before each attempted transaction (including retries).
  const before=await ref.get(); if(!before.exists||snapshotKey(before.data())!==entry.signature){skipped++;console.log('SKIP changed:',entry.path);continue;}
  fs.writeSync(fd,JSON.stringify({path:entry.path,original:before.data(),proposal:entry.newText})+'\n');fs.fsyncSync(fd);
  const ok=await db.runTransaction(async tx=>{
   const current=await tx.get(ref);if(!current.exists)return false;
   const c=await inspect(current,r=>tx.get(r));
   if(!c||c.status!=='candidate'||c.signature!==entry.signature||c.newText!==entry.newText)return false;
   const d=current.data(); const index=indexPayload({text:c.newText,factKey:d.factKey,factValue:d.factValue,active:true});
   if(!index||!Array.isArray(index.retrievalTerms)||!index.searchTextHash||index.retrievalTerms.includes(BAD))throw Error('Index validation failed');
   tx.update(ref,{...index,text:c.newText,updatedAt:FieldValue.serverTimestamp()});return true;
  }); if(ok){changed++;console.log('UPDATED:',entry.path);}else{skipped++;console.log('SKIP revalidation:',entry.path);}
 }}finally{fs.closeSync(fd);console.log({changed,skipped,backup});}
}
main().catch(e=>{console.error(e);process.exitCode=1;});
