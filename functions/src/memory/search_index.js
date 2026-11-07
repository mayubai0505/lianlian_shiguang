'use strict';
// Bounded lexical index, scoped to the collection supplied by the caller.
const STOP = new Set(['我是','我的','你的','妳的','我們','你們','這個','那個','什麼','怎麼','可以','不是','就是','已經','現在','一下','記得','知道','自己','有沒有','the','and','you','that','this']);
const GROUPS = [
 ['約定','承諾','答應','說好','promise','appointment'],
 ['結婚','已婚','夫妻','婚禮','married','marriage'],
 ['生日','birthday'], ['鑰匙','钥匙','key'],
 ['醫院','医院','就醫','看醫生','hospital'],
 ['咖啡','coffee'], ['打雷','雷聲','雷雨','怕雷','thunder'],
 ['喜歡','喜欢','最愛','偏好','favorite'],
 ['取消','作廢','不去了','cancel'],
];
function buildSearchTerms(value, limit = 256) {
 const text = String(value || '').normalize('NFKC').toLowerCase();
 const terms = new Set();
 for (const token of text.match(/[a-z0-9_]{2,40}/g) || []) if (!STOP.has(token)) terms.add(token);
 for (const run of text.match(/[\u3400-\u9fff]{2,}/g) || []) {
  for (let i=0;i<run.length-1;i++) {const word=run.slice(i,i+2);if(!STOP.has(word))terms.add(word);}
 }
 for (const group of GROUPS) if (group.some(word=>text.includes(word))) for(const word of group) terms.add(word);
 return [...terms].slice(0,limit);
}
function indexPayload(data) {
 const text = `${data.text || data.content || ''} ${data.factKey || ''} ${data.factValue || ''}`;
 return {retrievalTerms: data.active === false ? [] : buildSearchTerms(text), searchIndexVersion:1,
  searchTextHash:require('crypto').createHash('sha256').update(`${data.active !== false}:${text}`).digest('hex')};
}
async function loadIndexedCandidates({db, memoriesRef, query, recentLimit=40, backfillLimit=25}) {
 const terms=buildSearchTerms(query,30);
 const recent=await memoriesRef.orderBy('timestamp','desc').limit(recentLimit).get();
 // A small page is indexed per call, including old records outside the recent window.
 // The cursor is deterministic document-ID order, independent of fact timestamps.
 const stateRef=memoriesRef.parent.collection('memory_search_state').doc('v1');
 try {
  const stateSnap=await stateRef.get();const state=stateSnap.data() || {};
  const rescan = state.complete && Date.now() - Number(state.lastScanAt || 0) >= 6 * 60 * 60 * 1000;
  const batch=db.batch();const toIndex=new Map(recent.docs.map(doc=>[doc.id,doc]));
  if (!state.complete || rescan) {
   let pageQuery=memoriesRef.orderBy('__name__').limit(backfillLimit);
   if(state.cursor && !rescan)pageQuery=pageQuery.startAfter(state.cursor);
   const page=await pageQuery.get();
   for(const doc of page.docs)toIndex.set(doc.id,doc);
   batch.set(stateRef,{cursor:page.docs.length?page.docs[page.docs.length-1].id:'',complete:page.docs.length<backfillLimit,lastScanAt:Date.now()},{merge:true});
  }
  let writes=0;
  for(const doc of toIndex.values()){
   const data=doc.data()||{};const payload=indexPayload(data);
   if(data.searchTextHash !== payload.searchTextHash || data.searchIndexVersion!==1){batch.set(doc.ref,payload,{merge:true});writes++;}
  }
  if(writes || !state.complete || rescan)await batch.commit();
 } catch(error) {console.warn('Memory index backfill deferred:',error?.code||error?.message);}

 let matching=[];
 if(terms.length)try{matching=(await memoriesRef.where('retrievalTerms','array-contains-any',terms).limit(120).get()).docs;}catch(error){console.warn('Memory indexed lookup deferred:',error?.code||error?.message);}
 const byId=new Map();for(const doc of [...recent.docs,...matching])byId.set(doc.id,doc);
 return {docs:[...byId.values()],forEach(fn){this.docs.forEach(fn);}};
}
module.exports={buildSearchTerms,loadIndexedCandidates,indexPayload};

async function filterValidMemoryEvidence({db, items}) {
 const refs = new Map();
 for(const item of items) {
  if(item.sourceMessageId && item.sourceSessionId && item.sourceAppId) {
   const ref=db.collection('artifacts').doc(item.sourceAppId).collection('chat_sessions').doc(item.sourceSessionId).collection('messages').doc(item.sourceMessageId);
   refs.set(ref.path,ref);
  }
 }
 if(!refs.size)return items;
 const snapshots=await db.getAll(...refs.values());
 const live=new Map(snapshots.map(doc=>[doc.ref.path,doc]));
 return items.filter(item=>{
  if(!item.sourceMessageId || !item.sourceSessionId || !item.sourceAppId)return true;
  const path=`artifacts/${item.sourceAppId}/chat_sessions/${item.sourceSessionId}/messages/${item.sourceMessageId}`;
  const source=live.get(path);
  if(!source?.exists)return false;
  if(item.sourceHash){const hash=require('crypto').createHash('sha256').update(String(source.data()?.text||'')).digest('hex');if(hash!==item.sourceHash)return false;}
  return true;
 });
}
module.exports.filterValidMemoryEvidence=filterValidMemoryEvidence;
