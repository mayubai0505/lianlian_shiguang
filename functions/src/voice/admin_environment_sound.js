'use strict';
const crypto = require('node:crypto');
const MAX_BYTES = 5 * 1024 * 1024;
function createEnvironmentSoundAdmin({db, APP_ID, FieldValue, HttpsError, requireAdmin, getBucket, elevenLabsApiKey, axios}) {
  const bank = db.collection('artifacts').doc(APP_ID).collection('environment_sound_bank');
  const fail = msg => { throw new HttpsError('invalid-argument', msg); };
  function soundId(v) { if(typeof v !== 'string' || !/^[a-z0-9_-]{1,80}$/.test(v)) fail('音效 ID 限小寫英文、數字、底線及連字號'); return v; }
  function fields(d) {
    const name = typeof d.name === 'string' ? d.name.trim() : '';
    if(!name || name.length > 80) fail('名稱須為 1–80 字');
    if(!['ambient','effect'].includes(d.type)) fail('無效音效類型');
    if(!['indoor','outdoor','weather','transport','action','other'].includes(d.category)) fail('無效分類');
    if(typeof d.volume !== 'number' || !Number.isFinite(d.volume) || d.volume < 0 || d.volume > 1) fail('音量須介於 0–1');
    if(typeof d.enabled !== 'boolean') fail('無效啟用狀態');
    if(!Array.isArray(d.tags) || d.tags.length > 20 || d.tags.some(t=>typeof t !== 'string' || t.length > 40)) fail('標籤最多 20 個，每個 40 字');
    return {name,type:d.type,category:d.category,volume:d.volume,enabled:d.enabled,loop:d.type==='ambient',tags:[...new Set(d.tags.map(t=>t.trim()).filter(Boolean))]};
  }
  function audio(d) {
    if(!['mp3','wav'].includes(d.extension) || typeof d.audioBase64 !== 'string' || d.audioBase64.length > Math.ceil(MAX_BYTES/3)*4 || !/^[A-Za-z0-9+/]+={0,2}$/.test(d.audioBase64) || d.audioBase64.length % 4) fail('僅支援 5 MiB 以內的 MP3 / WAV');
    const bytes=Buffer.from(d.audioBase64,'base64');
    if(bytes.length<12 || bytes.length>MAX_BYTES) fail('音檔大小不符');
    const wav=bytes.toString('ascii',0,4)==='RIFF' && bytes.toString('ascii',8,12)==='WAVE';
    const mp3=bytes.toString('ascii',0,3)==='ID3' || (bytes[0]===0xff && (bytes[1]&0xe0)===0xe0);
    if(d.extension==='wav'?!wav:!mp3) fail('音檔格式不符');
    return {bytes,contentType:d.extension==='wav'?'audio/wav':'audio/mpeg'};
  }
  function row(doc) { const v=doc.data(); return {soundId:doc.id,name:v.name,type:v.type,category:v.category,volume:v.volume,enabled:v.enabled,loop:v.loop,tags:v.tags,contentType:v.contentType,size:v.size}; }
  return async request => {
    const uid=await requireAdmin(request); const d=request.data||{};
    if(d.action==='list') return {sounds:(await bank.get()).docs.map(row).sort((a,b)=>a.soundId.localeCompare(b.soundId))};
    if(d.action==='generate') {
      const text=typeof d.text==='string'?d.text.trim():'';
      if(!text || text.length>450 || typeof d.duration!=='number' || !Number.isFinite(d.duration) || d.duration<0.5 || d.duration>30 || typeof d.loop!=='boolean') fail('音效描述限 450 字，長度 0.5–30 秒');
      let result;
      try {
        result=await axios({method:'post',url:'https://api.elevenlabs.io/v1/sound-generation',params:{output_format:'mp3_44100_128'},headers:{'xi-api-key':elevenLabsApiKey.value(),'Content-Type':'application/json'},data:{text,duration_seconds:d.duration,loop:d.loop,model_id:'eleven_text_to_sound_v3',prompt_influence:0.3},responseType:'arraybuffer',timeout:80000,maxContentLength:MAX_BYTES,maxRedirects:0});
      } catch(e) {
        const status=e.response?.status;
        let detail;try{detail=JSON.parse(Buffer.from(e.response?.data||[]).toString()).detail;}catch{}
        const code=typeof detail?.status==='string'?detail.status.replace(/[^a-zA-Z0-9_-]/g,'').slice(0,80):'';
        console.warn('ENV_SOUND_GENERATE_FAILED',{status:status||null,providerCode:code,transportCode:e.code});
        throw new HttpsError(status===429?'resource-exhausted':status===401||status===403?'permission-denied':!status?'unavailable':'failed-precondition',`ElevenLabs 音效生成失敗 (${status||'network'}${code?' / '+code:''})，請檢查音效權限、額度或稍後再試`);
      }
      const bytes=Buffer.from(result.data);
      const encoded=bytes.toString('base64');
      audio({extension:'mp3',audioBase64:encoded});
      return {audioBase64:encoded,contentType:'audio/mpeg'};
    }
    const id=soundId(d.soundId); const ref=bank.doc(id);
    if(d.action==='create') {
      const meta=fields(d); const {bytes,contentType}=audio(d);
      if((await ref.get()).exists) throw new HttpsError('already-exists','音效 ID 已存在');
      const path=`environment_sounds/${id}/${crypto.randomUUID()}.${d.extension}`;
      const file=getBucket().file(path);
      await file.save(bytes,{resumable:false,metadata:{contentType,cacheControl:'private, max-age=0'},preconditionOpts:{ifGenerationMatch:0}});
      // Unique object path prevents overwriting existing audio. On an ambiguous DB failure,
      // preserve the object rather than deleting a possibly committed sound.
      try { await ref.create({...meta,enabled:false,soundId:id,storagePath:path,contentType,size:bytes.length,createdBy:uid,createdAt:FieldValue.serverTimestamp(),updatedAt:FieldValue.serverTimestamp()}); }
      catch(e) { console.error('ENV_SOUND_REGISTER_FAILED',{soundId:id,path,code:e.code}); if(e.code===6||e.code==='already-exists') throw new HttpsError('already-exists','音效 ID 已存在'); throw new HttpsError('internal','音檔已上傳，但登錄結果未確認，請重新整理'); }
      return {success:true,soundId:id};
    }
    if(d.action==='update') {
      const meta=fields(d); await db.runTransaction(async tx=>{if(!(await tx.get(ref)).exists) throw new HttpsError('not-found','音效不存在'); tx.update(ref,{...meta,updatedAt:FieldValue.serverTimestamp()});}); return {success:true};
    }
    if(d.action==='preview') {
      const snap=await ref.get(); if(!snap.exists) throw new HttpsError('not-found','音效不存在');
      const v=snap.data(); const path=v.storagePath;
      if(typeof path!=='string'||!path.startsWith(`environment_sounds/${id}/`)) throw new HttpsError('failed-precondition','音檔路徑異常');
      const file=getBucket().file(path); const [meta]=await file.getMetadata();
      if(Number(meta.size)>MAX_BYTES || !['audio/mpeg','audio/wav'].includes(meta.contentType)) throw new HttpsError('failed-precondition','音檔格式或大小異常');
      const [bytes]=await file.download(); if(bytes.length>MAX_BYTES) throw new HttpsError('failed-precondition','音檔過大');
      return {audioBase64:bytes.toString('base64'),contentType:meta.contentType};
    }
    throw new HttpsError('invalid-argument','未知操作');
  };
}
module.exports={createEnvironmentSoundAdmin};
