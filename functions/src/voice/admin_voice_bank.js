'use strict';
// Administrator-only control plane. Never deletes or changes existing voice IDs.
function createVoiceBankAdmin({db, APP_ID, FieldValue, HttpsError, requireAdmin, elevenLabsApiKey, axios}) {
  const bank = db.collection('artifacts').doc(APP_ID).collection('voice_bank');
  const str = (v,n=160) => typeof v === 'string' ? v.trim().slice(0,n) : '';
  const id = v => { if(typeof v !== 'string' || !/^[A-Za-z0-9_-]{1,128}$/.test(v)) throw new HttpsError('invalid-argument','無效 ID'); return v; };
  const num = (v, fallback) => typeof v === 'number' && Number.isFinite(v) ? v : fallback;
  const url = v => { try {const u=new URL(v); return u.protocol==='https:' ? u.href : ''; } catch {return '';} };
  async function api(method,path,params,data, responseType) {
    const startedAt = Date.now();
    const stage = path === 'shared-voices' ? (params?.owner_id ? 'import_metadata' : 'search') : path.startsWith('voices/add/') ? 'import_add' : path.startsWith('voices/') ? 'voice_lookup' : 'other';
    try { return (await axios({method,url:'https://api.elevenlabs.io/v1/'+path,params,data,responseType,timeout:stage === 'search' ? 45000 : 20000,headers:{'xi-api-key':elevenLabsApiKey.value()},maxContentLength:5*1024*1024,maxRedirects:0})).data; }
    catch(e) { const status=e.response?.status;
      const endpoint = path === 'shared-voices' ? 'shared-voices' : path.startsWith('voices/add/') ? 'voices/add/:owner/:voice' : path.startsWith('voices/') ? 'voices/:voice' : path.startsWith('text-to-speech/') ? 'text-to-speech/:voice' : 'other';
      const detail = e.response?.data?.detail;
      const safe = value => {
        if (typeof value !== 'string') return '';
        const key = elevenLabsApiKey.value();
        return (key ? value.split(key).join('[REDACTED]') : value).replace(/\b(?:sk_[A-Za-z0-9_-]+|Bearer\s+[^\s,;]+)\b/gi, '[REDACTED]').replace(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/gi, '[EMAIL]').slice(0, 500);
      };
      console.warn('VOICE_ADMIN_PROVIDER', status || 'network', JSON.stringify({method, endpoint, stage, elapsedMs:Date.now()-startedAt, errorCode:typeof e.code==='string' && /^[A-Z0-9_]{1,64}$/.test(e.code)?e.code:'', errorName:typeof e.name==='string' && /^[A-Za-z0-9_]{1,64}$/.test(e.name)?e.name:'', hasResponse:!!e.response, transportReason:!e.response?( /maxContentLength/i.test(e.message||'')?'response_size_limit': /timeout/i.test(e.message||'')?'timeout': /redirect/i.test(e.message||'')?'redirect': /certificate/i.test(e.message||'')?'certificate': 'other') : undefined, pageSize:params?.page_size, page:params?.page, providerStatus:safe(detail?.status), providerMessage:safe(typeof detail === 'string' ? detail : detail?.message), validation:Array.isArray(detail) ? detail.slice(0,5).map(x=>({type:safe(x?.type),message:safe(x?.msg),location:Array.isArray(x?.loc)?x.loc.map(y=>typeof y==='string'?safe(y):typeof y==='number'?y:null):[]})) : undefined})); if (stage === 'search' && !e.response && (e.code === 'ECONNABORTED' || e.code === 'ETIMEDOUT')) throw new HttpsError('deadline-exceeded','ElevenLabs 聲音搜尋逾時，請稍後重試'); throw new HttpsError(status===429?'resource-exhausted':(status===404 || (stage==='voice_lookup' && method==='get' && status===400 && detail?.status==='voice_not_found'))?'not-found':'failed-precondition',`ElevenLabs 請求失敗 (${status||'network'})，請確認 API Key 權限及方案`); }
  }
  function shared(v,lang) {const p=(Array.isArray(v.verified_languages)?v.verified_languages:[]).find(x=>x.language===lang);return {voiceId:str(v.voice_id),ownerId:str(v.public_owner_id),name:str(v.name),gender:str(v.gender).toLowerCase(),age:str(v.age),language:str(p?.language||v.language),accent:str(p?.accent||v.accent),locale:str(p?.locale),description:str(v.description,500),libraryPreviewUrl:url(p?.preview_url||v.preview_url),rate:num(v.rate,null),noticePeriod:num(v.notice_period,null),moderated:v.live_moderation_enabled===true};}
  function row(d){const v=d.data();return {documentId:d.id,voiceId:str(v.voiceId),name:str(v.name),gender:str(v.gender),age:str(v.age),language:str(v.language),accent:str(v.accent),locale:str(v.locale),tags:Array.isArray(v.tags)?v.tags.filter(x=>typeof x==='string').slice(0,30):[],enabled:v.enabled===true,defaultSettings:v.defaultSettings||{},previewUrl:url(v.previewUrl),libraryPreviewUrl:url(v.libraryPreviewUrl),rate:num(v.rate,null),noticePeriod:num(v.noticePeriod,null)};}
  function settings(d){const s=num(d.stability,0.6), t=num(d.style,0.15); if(s<0.1||s>0.9||t<0||t>1)throw new HttpsError('invalid-argument','參數超出範圍');return {stability:s,style:t};}
  async function search(d){const language=str(d.language,12), gender=str(d.gender,12);const page=Math.max(0,Math.min(100,Math.trunc(num(d.page,0)))); const params={page,page_size:30,include_custom_rates:false,include_live_moderated:false,min_notice_period_days:30};if(language)params.language=language;if(gender)params.gender=gender;if(str(d.locale,16))params.locale=str(d.locale,16);if(str(d.search))params.search=str(d.search);const r=await api('get','shared-voices',params);return {voices:(r.voices||[]).map(v=>shared(v,language)),hasMore:r.has_more===true,page};}
  return async request=>{
    requireAdmin(request); const d=request.data||{};
    switch(d.action){
      case 'search':return search(d);
      case 'list':{const q=await bank.get();return {voices:q.docs.map(row).sort((a,b)=>a.name.localeCompare(b.name,'zh-Hant'))};}
      case 'import':{
        const voiceId=id(d.voiceId), ownerId=id(d.ownerId);
        if(!(await bank.where('voiceId','==',voiceId).limit(1).get()).empty)throw new HttpsError('already-exists','此音色已在聲音庫');
        // Resolve authoritative metadata from provider, not client values. Search owner pages.
        let match;for(let page=0;page<10&&!match;page++){const r=await api('get','shared-voices',{owner_id:ownerId,page,page_size:100,include_custom_rates:false,include_live_moderated:false,min_notice_period_days:30});match=(r.voices||[]).find(v=>v.voice_id===voiceId&&v.public_owner_id===ownerId);if(!r.has_more)break;}
        if(!match)throw new HttpsError('failed-precondition','找不到符合標準費率、30 日通知期的共享音色');
        const v=shared(match,str(d.language,12));if(v.moderated || (v.rate!==null&&v.rate!==1))throw new HttpsError('failed-precondition','不接受額外費率或即時審核音色');
        let actualId=voiceId;let existingVoice=null;try{existingVoice=await api('get','voices/'+voiceId);}catch(e){if(e.code!=='not-found')throw e;}if(!existingVoice || (existingVoice.is_bookmarked===false && existingVoice.is_owner!==true)){const added=await api('post',`voices/add/${ownerId}/${voiceId}`,undefined,{new_name:v.name||voiceId,bookmarked:true});actualId=id(added.voice_id);await api('get','voices/'+actualId);}
        const ref=bank.doc('library_'+voiceId);await db.runTransaction(async tx=>{const existing=await tx.get(ref);const dup=await tx.get(bank.where('voiceId','==',actualId).limit(1));if(existing.exists||!dup.empty)throw new HttpsError('already-exists','此音色已匯入');tx.create(ref,{voiceId:actualId,sourceVoiceId:voiceId,ownerId,name:v.name||voiceId,gender:v.gender,age:v.age,category:v.gender,language:v.language,accent:v.accent,locale:v.locale,description:v.description,libraryPreviewUrl:v.libraryPreviewUrl,rate:v.rate,noticePeriod:v.noticePeriod,tags:[],traits:{},searchWeight:100,displayOrder:1000,enabled:false,previewUrl:'',defaultSettings:{stability:0.6,style:0.15},source:'elevenlabs_library',createdAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp()});});return {success:true,voiceId:actualId};
      }
      case 'update':{const ref=bank.doc(id(d.documentId));const name=str(d.name);if(!name||typeof d.enabled!=='boolean')throw new HttpsError('invalid-argument','請填寫名稱及推薦狀態');const tags=Array.isArray(d.tags)?[...new Set(d.tags.map(x=>str(x,40)).filter(Boolean))].slice(0,30):[];await db.runTransaction(async tx=>{const snap=await tx.get(ref);if(!snap.exists)throw new HttpsError('not-found','音色不存在');tx.update(ref,{name,tags,language:str(d.language,20),accent:str(d.accent,80),enabled:d.enabled,defaultSettings:{...(snap.data().defaultSettings||{}),...settings(d)},updatedAt:FieldValue.serverTimestamp()});});return {success:true};}
      case 'preview':{const snap=await bank.doc(id(d.documentId)).get();if(!snap.exists)throw new HttpsError('not-found','音色不存在');const v=snap.data();const s=settings(d);const audio=await api('post','text-to-speech/'+id(v.voiceId),undefined,{text:'今天過得怎麼樣？不用急，慢慢跟我說，我會一直在這裡陪你。',model_id:'eleven_turbo_v2_5',voice_settings:{...s,similarity_boost:0.75,use_speaker_boost:true}},'arraybuffer');return {audioBase64:Buffer.from(audio).toString('base64')};}
      default:throw new HttpsError('invalid-argument','未知操作');
    }
  };
}
module.exports={createVoiceBankAdmin};
