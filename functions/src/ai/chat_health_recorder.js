'use strict';
// Separate committed-chat telemetry; no player content or billing changes.
const {getAiHealthTaipeiDateKey} = require('./health_utils');
const modes = {regular:['casual','story','immersive','resonance'],world:['story','immersive','resonance','interaction']};
function createChatHealthRecorder({db,APP_ID,FieldValue}) {
  return function beginChatHealth(scope, mode, startedAt = Date.now()) {
    if (scope === 'regular' && ['daily','gemini'].includes(mode)) mode = 'casual';
    let finished = false;
    return async function finish(outcome) {
      if (finished || !modes[scope]?.includes(mode) || !['success','failure','cancelled'].includes(outcome)) return;
      finished = true;
      try {
        const inc = n => FieldValue.increment(n);
        const elapsed = Math.max(0, Date.now()-startedAt);
        const dateKey = getAiHealthTaipeiDateKey();
        await db.collection('artifacts').doc(APP_ID).collection('ai_chat_daily').doc(`${dateKey}_v2`).set({
          dateKey, schemaVersion:2, updatedAt:FieldValue.serverTimestamp(),
          [scope]:{[mode]:{successCount:inc(outcome==='success'?1:0), failureCount:inc(outcome==='failure'?1:0),
            cancelledCount:inc(outcome==='cancelled'?1:0), totalLatencyMs:inc(outcome==='cancelled'?0:elapsed)}}
        },{merge:true});
      } catch (e) { console.warn('AI_CHAT_HEALTH_WRITE_FAILED', {scope,mode,code:String(e?.code||'unknown')}); }
    };
  };
}
module.exports={createChatHealthRecorder};
