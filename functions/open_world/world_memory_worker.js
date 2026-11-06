'use strict';

// World-only memory jobs. No changes to the existing single-character RAG collections.
const {createMemoryScopeTools} = require('../src/memory/scope');

const EMBEDDING_MODEL = 'gemini-embedding-001';
const EMBEDDING_VERSION = 'gemini-embedding-001:768:v1';
const EMBEDDING_DIMS = 768;
const TOPICS = /(?:喜歡|最愛|討厭|不喜歡|不吃|不喝|每天|習慣|固定|我是|我的生日|我怕|我有養|我的職業|叫我|不要叫我|我們結婚|我們分手|我懷孕|我住在)/u;

function createWorldMemoryTools({db, APP_ID, crypto, FieldValue, logger, callAiWithRetry, normalizeAiResponseScript, geminiApiKey, HttpsError}) {
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

  // World-only extractor. Never modifies the general-character memory extractor.
  // A compact prompt and larger output budget avoid the prior 400-token JSON truncation.
  async function extractWorldMemory({userMessage,playerName}) {
    const prompt = [
      '你是《戀戀拾光》世界觀聊天室的玩家長期記憶提取器。只輸出一個合法 JSON object，不要 Markdown。',
      '只判斷玩家本人最新一句話。NPC 台詞、旁白、內心猜測不得當成玩家的個人事實。',
      '明確、可持續的玩家偏好、禁忌、習慣、稱呼、身份、人物關係或世界線重大事件，應該記住。',
      '例如「我一直很喜歡吃巧克力蛋糕」應該記住；「這塊巧克力很好吃」若僅指眼前食物則不記住。',
      '角色扮演情境中的事實只適用本世界聊天室；不要當成玩家在真實生活中的全域資訊。',
      '臨時動作、當下想法、推測、玩笑、單次感受及普通劇情台詞不記住。',
      '記憶要用提供的玩家名稱作主詞，不能擅自推斷。最多一項。',
      '世界觀記憶一律 scope=session；無記憶則 scope=none。',
      '若 shouldRemember=true，memory、factKey、factValue、confidence 必須齊全。',
      'factKey 用語意鍵：preference.food.<英文slug>、preference.drink.<英文slug>、preference.other.<英文slug>、habit.<英文slug>、trait.<英文slug>、identity.occupation、identity.birthday、identity.pet、interaction.preferred_address、relationship.status、important_event.<英文slug>、worldline.event.<英文slug>。',
      '同一主題正反偏好用相同 factKey；英文 slug 限小寫與底線。confidence 是 0～1 數值。',
      '固定 JSON 欄位：shouldRemember(boolean),memory(string),scope(string),category(string),factKey(string),factValue(string),confidence(number)。',
      '不應記住時全部回傳：{"shouldRemember":false,"memory":"","scope":"none","category":"none","factKey":"","factValue":"","confidence":0}',
    ].join('\n');
    const messages=[{role:'system',content:prompt},{role:'user',content:`玩家名稱：${playerName}\n最新訊息：${userMessage}`}];
    function parse(result) {
      let raw=result?.choices?.[0]?.message?.content || '';
      if (Array.isArray(raw)) raw=raw.map(x=>x.text||'').join('');
      const text=String(raw).replace(/```(?:json)?/gi,'').trim();
      const start=text.indexOf('{'), end=text.lastIndexOf('}');
      if(start<0 || end<=start) throw new Error('INVALID_WORLD_MEMORY_JSON');
      const obj=JSON.parse(text.slice(start,end+1));
      return {
        shouldRemember:obj.shouldRemember===true,
        memory:String(obj.memory||'').trim(),
        scope:String(obj.scope||'none').toLowerCase(),
        category:String(obj.category||'none'),
        factKey:String(obj.factKey||'').trim(),
        factValue:String(obj.factValue||'').trim(),
        confidence:Number(obj.confidence||0),
      };
    }
    const requestBody={messages,temperature:0,max_tokens:900,response_format:{type:'json_object'}};
    try {
      try {
        return parse(await callAiWithRetry({modelId:'google/gemini-2.5-flash-lite',
          fallbackModelId:'google/gemini-2.5-flash-lite',retryPrimary:false,timeoutMs:20000,requestBody}));
      } catch(primaryError) {
        logger.warn('world memory primary extractor failed',{reason:String(primaryError?.message||'error').slice(0,60)});
        return parse(await callAiWithRetry({modelId:'deepseek/deepseek-v4-flash',
          fallbackModelId:'deepseek/deepseek-v4-flash',retryPrimary:false,timeoutMs:20000,requestBody}));
      }
    } catch(error) {
      logger.warn('world memory extractor failed',{reason:String(error?.message||'error').slice(0,60)});
      return {shouldRemember:false,memory:'',scope:'none',category:'none',factKey:'',factValue:'',confidence:0};
    }
  }

  async function rememberPlayerMessage({room, uid, worldId, sessionId, rawMessage, mode, requestId, messageAt}) {
    // Cheap filter for empty, non-linguistic, or very brief chat only.
    // Do not use a preference-keyword whitelist: allergies, dates, identity and
    // stable habits can be stated without any of the words in TOPICS.
    // The extractor still decides whether a fact is stable (confidence >= .75).
    const message = String(rawMessage || '').trim().slice(0,2500);
    const withoutDecorations = message.replace(/[\p{P}\p{S}\p{Z}\p{C}]/gu, '');
    const meaningfulLength = [...withoutDecorations].length;
    const obviousSmallTalk = /^(?:早安|午安|晚安|你好|哈囉|嗨|謝謝|感謝|好|好的|嗯|喔|哦|哈哈+|呵呵+|掰掰|再見|ok|okay|yes|no|hi|hello|bye)[!！。~～\s]*$/iu.test(message);
    const looksLikeInjectedSystemText = /^(?:【|\[玩家傳來)/u.test(message);
    if (!message || !withoutDecorations || obviousSmallTalk || looksLikeInjectedSystemText ||
        (!TOPICS.test(message) && meaningfulLength < 7)) {
      logger.info('world memory extractor prefilter', {
        reason:!message || !withoutDecorations ? 'empty_or_nonlinguistic'
          : obviousSmallTalk ? 'brief_smalltalk'
          : looksLikeInjectedSystemText ? 'system_like'
          : 'too_brief_without_signal',
      });
      return {skipped:'no_stable_fact_signal'};
    }
    const snapshot = await room.get();
    if (!snapshot.exists || snapshot.data()?.userId !== uid || snapshot.data()?.worldId !== worldId) return {skipped:'room_mismatch'};
    const playerWorldProfile = snapshot.data()?.playerWorldProfile || {};
    const account = !playerWorldProfile.nickname ? (await db.collection('users').doc(uid).get()).data() || {} : {};
    const playerName = String(playerWorldProfile.nickname || account.nickname || account.displayName || account.name || '玩家')
      .replace(/[\r\n\t\u0000-\u001f]/gu,' ').slice(0,40).trim() || '玩家';
    const extracted = await extractWorldMemory({userMessage:message,playerName});
    const factKey = canonicalizeMemoryFactKey(extracted.factKey,{userMessage:message,category:extracted.category});
    const scope = repairMemoryScope({scope:extracted.scope,shouldRemember:extracted.shouldRemember,factKey,userMessage:message});
    const content = String(extracted.memory || '').trim().replace(/^玩家/u, playerName).slice(0,500);
    // Report only decision metadata, never the player's raw message or memory text.
    // Keep the existing threshold and storage behavior unchanged.
    const decision = {
      shouldRemember:extracted.shouldRemember === true,
      confidence:Number.isFinite(Number(extracted.confidence)) ? Number(extracted.confidence) : 0,
      hasFactKey:Boolean(factKey),
      hasContent:Boolean(content),
      scope,
      category:String(extracted.category || 'none').slice(0,40),
    };
    logger.info('world memory extractor decision', decision);
    if (!decision.shouldRemember) return {skipped:'extractor_rejected'};
    if (decision.confidence < 0.75) return {skipped:'confidence_below_075'};
    if (!decision.hasFactKey) return {skipped:'missing_fact_key'};
    if (!decision.hasContent) return {skipped:'empty_memory_content'};
    if (scope === 'none') return {skipped:'scope_none'};
    // World memory remains world-room scoped, even for profile-type facts.
    // This avoids leaking role-play claims to the user's other characters/worlds.
    const ref = db.collection('users').doc(uid).collection('worlds').doc(worldId)
      .collection('sessions').doc(sessionId).collection('memories')
      .doc(`auto_${crypto.createHash('sha256').update(factKey).digest('hex').slice(0,32)}`);
    // Build embedding before transaction, and never retry a deleted or manually edited fact.
    const vector = await embedding(content,'RETRIEVAL_DOCUMENT');
    const result = await db.runTransaction(async tx => {
      const old = await tx.get(ref);
      const data = old.data() || {};
      if (data.deletedByUser || data.lockedByUser || data.active === false) return 'user_override';
      // Eventarc delivery is at-least-once and may be out of order.
      const oldTime=data.sourceMessageAt?.toMillis?.() || 0;
      const newTime=messageAt?.toMillis?.() || 0;
      if (oldTime && newTime && oldTime > newTime) return 'stale_event';
      if (old.exists && data.active !== false && String(data.text || '') === content) return 'unchanged';
      tx.set(ref, {
        text:content, factKey, factValue:String(extracted.factValue || '').slice(0,240),
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

  // Only normalize AI-generated Markdown decoration in world story summaries.
  // Preserve narrative punctuation, ordinary star characters and full-width symbols.
  function plainWorldSummary(value) {
    return String(value || '').replace(/\r\n?/g, '\n').split('\n').map(line => {
      let s = line.replace(/^\s{0,3}#{1,6}\s+(?=\S)/u, '');
      s = s.replace(/^\s{0,3}(?:\*|-|\+)\s+(?=\S)/u, '・');
      s = s.replace(/\*\*([^\n*]+?)\*\*/gu, '$1');
      return s;
    }).join('\n');
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
      const summary = plainWorldSummary(normalizeAiResponseScript(String(result).trim(),'台灣繁體中文')).slice(0,4800).trim();
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

  // Production canary: disabled by default. Read per-message so the owner can stop
  // extraction without redeploying. No raw player content is logged.
  async function canRunWorldMemory(uid, room, messageId) {
    const configRef = db.collection('artifacts').doc(APP_ID)
      .collection('settings').doc('world_memory_rollout');
    const cfg = (await configRef.get()).data() || {};
    if (cfg.enabled !== true || !Array.isArray(cfg.allowedUserIds)
        || !cfg.allowedUserIds.includes(uid)) {
      logger.info('world memory diagnostic', {
        stage:'gate_skipped', enabled:cfg.enabled === true,
        listIsArray:Array.isArray(cfg.allowedUserIds),
        userAllowed:Array.isArray(cfg.allowedUserIds) && cfg.allowedUserIds.includes(uid),
      });
      return false;
    }
    const cap = Math.max(1, Math.min(30, Math.trunc(Number(cfg.maxDailyJobsPerRoom || 10))));
    const day = new Date().toISOString().slice(0,10).replace(/-/g,'');
    const counterRef = room.collection('world_memory_control').doc(`daily_${day}`);
    const claimRef = room.collection('world_memory_jobs').doc(messageId);
    return db.runTransaction(async tx => {
      const [claim,counter] = await Promise.all([tx.get(claimRef),tx.get(counterRef)]);
      if (claim.exists || Number(counter.data()?.count || 0)>=cap) {
        logger.info('world memory diagnostic', {
          stage:claim.exists ? 'already_claimed' : 'daily_cap_reached',
          currentCount:Number(counter.data()?.count || 0), cap,
        });
        return false;
      }
      tx.create(claimRef,{createdAt:FieldValue.serverTimestamp(),status:'claimed'});
      tx.set(counterRef,{count:FieldValue.increment(1),date:day},{merge:true});
      return true;
    });
  }

  async function onWorldMessage(event) {
    const data = event.data?.data() || {};
    const {appId,sessionId,messageId} = event.params || {};
    if (appId !== APP_ID) {
      logger.info('world memory diagnostic',{stage:'wrong_app_id',appIdMatches:false});
      return;
    }
    if (data.sender !== 'user' || data.billingType !== 'chat') return;
    logger.info('world memory diagnostic',{stage:'eligible_message_received',
      hasText:typeof data.text === 'string' && data.text.trim().length > 0});
    const room = db.collection('artifacts').doc(APP_ID).collection('world_chat_sessions').doc(sessionId);
    const snap = await room.get();
    if (!snap.exists) {
      logger.warn('world memory diagnostic',{stage:'room_missing'});
      return;
    }
    const uid = String(snap.data()?.userId || '');
    const worldId = String(snap.data()?.worldId || '');
    if (!uid || !worldId) {
      logger.warn('world memory diagnostic',{stage:'room_identifiers_missing',hasUid:!!uid,hasWorldId:!!worldId});
      return;
    }
    // Guard happens before any paid AI call. Failed config reads fail closed.
    try {
      if (!await canRunWorldMemory(uid,room,messageId)) return;
      logger.info('world memory diagnostic',{stage:'work_claimed'});
    } catch (error) {
      logger.warn('world memory canary gate failed',{code:String(error?.code || 'unknown').slice(0,40)});
      return;
    }
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
