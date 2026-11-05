'use strict';

// World-only memory jobs. No changes to the existing single-character RAG collections.
const {createMemoryExtractor} = require('../src/memory/extractor');
const {createMemoryScopeTools} = require('../src/memory/scope');

const EMBEDDING_MODEL = 'gemini-embedding-001';
const EMBEDDING_VERSION = 'gemini-embedding-001:768:v1';
const EMBEDDING_DIMS = 768;
const TOPICS = /(?:喜歡|最愛|討厭|不喜歡|不吃|不喝|每天|習慣|固定|我是|我的生日|我怕|我有養|我的職業|叫我|不要叫我|我們結婚|我們分手|我懷孕|我住在)/u;

function createWorldMemoryTools({db, APP_ID, crypto, FieldValue, logger, callAiWithRetry, normalizeAiResponseScript, geminiApiKey, HttpsError}) {
  const extractMemory = createMemoryExtractor({callAiWithRetry});
  const {canonicalizeMemoryFactKey, repairMemoryScope} = createMemoryScopeTools({db, APP_ID});

  async function embedding(text, taskType) {
    const value = String(text || '').trim().slice(0,1500);
    if (!value || !geminiApiKey.value()) return null;
    const abort = new AbortController();
    const timer = setTimeout(() => abort.abort(), 8500);
    try {
      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/${EMBEDDING_MODEL}:embedContent`, {
        method:'POST', signal:abort.signal,
        headers:{'Content-Type':'application/json', 'x-goog-api-key':geminiApiKey.value()},
        body:JSON.stringify({model:`models/${EMBEDDING_MODEL}`,content:{parts:[{text:value}]},taskType,outputDimensionality:EMBEDDING_DIMS}),
      });
      if (!response.ok) return null;
      const values = (await response.json())?.embedding?.values;
      if (!Array.isArray(values) || values.length !== EMBEDDING_DIMS || !values.every(Number.isFinite)) return null;
      const length = Math.hypot(...values);
      return length > 0 ? values.map(x => Number((x/length).toFixed(6))) : null;
    } catch (_) {return null;}
    finally {clearTimeout(timer);}
  }

  async function rememberPlayerMessage({room, uid, worldId, sessionId, rawMessage, mode, requestId, messageAt}) {
    // Ignore ordinary transient lines and system-like messages to control costs.
    const message = String(rawMessage || '').trim().slice(0,2500);
    if (!message || !TOPICS.test(message) || /^(?:【|\[玩家傳來)/u.test(message)) return {skipped:'no_stable_fact_signal'};
    const snapshot = await room.get();
    if (!snapshot.exists || snapshot.data()?.userId !== uid || snapshot.data()?.worldId !== worldId) return {skipped:'room_mismatch'};
    const playerWorldProfile = snapshot.data()?.playerWorldProfile || {};
    const account = !playerWorldProfile.nickname ? (await db.collection('users').doc(uid).get()).data() || {} : {};
    const playerName = String(playerWorldProfile.nickname || account.nickname || account.displayName || account.name || '玩家')
      .replace(/[\r\n\t\u0000-\u001f]/gu,' ').slice(0,40).trim() || '玩家';
    const extracted = await extractMemory({userMessage:message,playerName,chatMode:mode});
    const factKey = canonicalizeMemoryFactKey(extracted.factKey,{userMessage:message,category:extracted.category});
    const scope = repairMemoryScope({scope:extracted.scope,shouldRemember:extracted.shouldRemember,factKey,userMessage:message});
    const content = String(extracted.memory || '').trim().replace(/^玩家/u, playerName).slice(0,500);
    if (!extracted.shouldRemember || Number(extracted.confidence || 0) < 0.75 || !factKey || !content || scope === 'none')
      return {skipped:'low_confidence_or_no_fact'};
    // World memory remains world-room scoped, even for profile-type facts.
    // This avoids leaking role-play claims to the user's other characters/worlds.
    const ref = db.collection('users').doc(uid).collection('worlds').doc(worldId)
      .collection('sessions').doc(sessionId).collection('shared_memories')
      .doc(`auto_${crypto.createHash('sha256').update(factKey).digest('hex').slice(0,32)}`);
    // Build embedding before transaction, and never retry a deleted or manually edited fact.
    const vector = await embedding(content,'RETRIEVAL_DOCUMENT');
    const result = await db.runTransaction(async tx => {
      const old = await tx.get(ref);
      const data = old.data() || {};
      if (data.deletedByUser || data.lockedByUser) return 'user_override';
      // Eventarc delivery is at-least-once and may be out of order.
      const oldTime=data.sourceMessageAt?.toMillis?.() || 0;
      const newTime=messageAt?.toMillis?.() || 0;
      if (oldTime && newTime && oldTime > newTime) return 'stale_event';
      if (old.exists && data.active !== false && data.content === content) return 'unchanged';
      tx.set(ref, {
        title: 'AI 記住的事', subtitle: String(extracted.category || 'personal').slice(0,40),
        content, factKey, factValue:String(extracted.factValue || '').slice(0,240),
        source:'auto', scope, category:String(extracted.category || 'personal').slice(0,40),
        confidence:Number(extracted.confidence || 0), active:true,
        userId:uid, worldId, sessionId, sourceRequestId:requestId,
        ...(messageAt ? {sourceMessageAt:messageAt} : {}),
        ...(vector ? {embedding:vector,embeddingVersion:EMBEDDING_VERSION,embeddingContent:content} : {embedding:FieldValue.delete(),embeddingVersion:FieldValue.delete(),embeddingContent:FieldValue.delete()}),
        timestamp:old.exists ? (data.timestamp || FieldValue.serverTimestamp()) : FieldValue.serverTimestamp(),
        updatedAt:FieldValue.serverTimestamp(),
      }, {merge:true});
      return old.exists ? 'updated' : 'created';
    });
    return {result,scope,hasEmbedding:Boolean(vector)};
  }

  async function summarizeRoom({room,uid,worldId,sessionId,worldName,minimumNewMessages=12}) {
    const roomSnap = await room.get();
    if (!roomSnap.exists || roomSnap.data()?.userId !== uid || roomSnap.data()?.worldId !== worldId)
      return {skipped:true,reason:'room_mismatch'};
    const total = Number(roomSnap.data()?.messageCount || 0);
    const memoryRef = room.collection('world_memory').doc('story');
    const oldSnap = await memoryRef.get();
    const old = oldSnap.data() || {};
    const checkpoint = Number(old.messageCount || 0);
    const oldSummary = String(old.summary || '');
    const delta = total - checkpoint;
    if (delta > 90) return {skipped:true,reason:'backlog_over_90_requires_backfill',newMessageCount:delta};
    if (total < 4 || (oldSummary && delta < minimumNewMessages) || (!oldSummary && delta < 12))
      return {skipped:true,reason:'not_enough_messages',newMessageCount:Math.max(0,delta)};
    const leaseRef = room.collection('world_memory').doc('summary_lease');
    const acquired = await db.runTransaction(async tx => {
      const lease = await tx.get(leaseRef);
      if (Number(lease.data()?.until || 0) > Date.now()) return false;
      tx.set(leaseRef,{until:Date.now()+115000,userId:uid});
      return true;
    });
    if (!acquired) return {skipped:true,reason:'already_processing'};
    try {
      // Initial migration: old summaries have only messageCount. Read at most the NEW tail.
      // Never re-send the last 90 messages on every refresh.
      const amount = Math.min(90,Math.max(12,delta));
      const snap = await room.collection('messages').orderBy('timestamp','desc').limit(amount+4).get();
      const picked = snap.docs.filter(doc => ['user','ai'].includes(doc.data()?.sender) && doc.id !== 'opening')
        .slice(0,amount).reverse();
      const history = picked.map(d => {
        const m = d.data() || {};
        if (m.sender === 'user') return `玩家：${String(m.text || '').slice(0,1200)}`;
        return (Array.isArray(m.segments)?m.segments:[]).filter(s=>s.isStatusBar!==true)
          .map(s=>`${s.kind==='npc'?String(s.name || 'NPC'):'世界旁白'}：${String(s.text || '').slice(0,1000)}`).join('\n');
      }).filter(Boolean).join('\n').slice(-19000);
      if (!history.trim()) return {skipped:true,reason:'no_history'};
      const prompt = [
        '你是世界觀記憶檔案管理員。使用臺灣繁體中文，將既有摘要與本次「尚未整理的新對話」增量合併。',
        '200～500字；優先保存人物身份、長期關係、約定、關鍵事件、目前地點、已確定故事時間和未完成目標。',
        '以新對話中的確定事實修正過時資訊；不要將猜測、NPC 誤解或未經玩家確認的事情寫成玩家事實。',
        '每個 NPC 分開記錄；不要替玩家寫心理、行動或臺詞；不擅自推進日期。',
        '僅輸出合併後的摘要文字，勿輸出分析、標題或 JSON。',
      ].join('\n');
      const response = await callAiWithRetry({
        modelId:'google/gemini-3-flash-preview',fallbackModelId:'deepseek/deepseek-v3.2',
        retryPrimary:false,timeoutMs:95000,
        requestBody:{messages:[{role:'system',content:prompt},{role:'user',content:
          `世界：${String(worldName || '').slice(0,120)}\n既有長期摘要：\n${oldSummary.slice(0,4000)}\n本次新對話：\n${history}`}],
          temperature:0.25,max_tokens:1100},
      });
      let result = response?.choices?.[0]?.message?.content || '';
      if (Array.isArray(result)) result = result.map(x=>x.text || '').join('');
      const summary = normalizeAiResponseScript(String(result).trim(),'台灣繁體中文').slice(0,4800).trim();
      if (!summary) throw new Error('EMPTY_WORLD_SUMMARY');
      const entriesRef = room.collection('story_summary_entries');
      const progressed = await db.runTransaction(async tx => {
        const latest = await tx.get(memoryRef);
        if (Number(latest.data()?.messageCount || 0) !== checkpoint) return false;
        const entryRef = entriesRef.doc(`checkpoint_${total}`);
        const existing = await tx.get(entryRef);
        if (!existing.exists) tx.create(entryRef, {userId:uid,worldId,sessionId,content:summary,
          createdAt:FieldValue.serverTimestamp(),checkpoint:total});
        tx.set(memoryRef,{userId:uid,worldId,sessionId,summary,messageCount:total,
          updatedAt:FieldValue.serverTimestamp()}, {merge:true});
        return true;
      });
      return {skipped:!progressed,reason:progressed?'':'stale_checkpoint',messageCount:total};
    } finally {
      await leaseRef.delete().catch(()=>{});
    }
  }

  async function onWorldMessage(event) {
    const data = event.data?.data() || {};
    const {appId,sessionId,messageId} = event.params || {};
    if (appId !== APP_ID || data.sender !== 'user' || data.billingType !== 'chat') return;
    const room = db.collection('artifacts').doc(APP_ID).collection('world_chat_sessions').doc(sessionId);
    const snap = await room.get();
    if (!snap.exists) return;
    const uid = String(snap.data()?.userId || '');
    const worldId = String(snap.data()?.worldId || '');
    if (!uid || !worldId) return;
    try {
      const result = await rememberPlayerMessage({room,uid,worldId,sessionId,
        rawMessage:data.text,mode:data.chatMode,requestId:messageId,messageAt:data.timestamp});
      logger.info('world player fact extraction', {sessionId, status:result.result || result.skipped || 'unknown'});
    } catch (error) {
      logger.warn('world player fact extraction failed',{sessionId,code:String(error?.code || error?.name || 'unknown').slice(0,40)});
    }
    try {
      const summary = await summarizeRoom({room,uid,worldId,sessionId,worldName:String(snap.data()?.worldName || '')});
      logger.info('world incremental summary result',{sessionId, status:summary.reason || (summary.skipped?'skipped':'updated')});
    } catch (error) {
      logger.warn('world incremental summary failed',{sessionId,code:String(error?.code || error?.name || 'unknown').slice(0,40)});
    }
  }
  return {onWorldMessage,summarizeRoom};
}
module.exports={createWorldMemoryTools,EMBEDDING_VERSION};
