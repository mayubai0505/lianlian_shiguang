'use strict';
// A newly persisted world AI reply -> the same FCM presentation as ordinary character replies.
// Do not inspect creator-defined status bars, prompt metadata or player messages.
function worldReplyPreview(segments) {
  if (!Array.isArray(segments)) return '';
  for (const segment of segments) {
    if (!segment || typeof segment !== 'object' || segment.isStatusBar === true || segment.kind === 'status') continue;
    let text = String(segment.text || '').replace(/\r\n?/g, '\n').trim();
    // Remove only leading presentation markers; never incorporate other segments as status text.
    text = text.replace(/^(?:\s*#{1,6}\s*|\s*[-*]\s+)+/u, '').replace(/^[「『“"']+/u, '').trim();
    if (!text) continue;
    // The first sentence or first paragraph, whichever comes first.
    const first = text.split(/\n|(?<=[。！？!?])/u).map(x => x.trim()).find(Boolean) || '';
    const clean = first.replace(/[」』”"']+$/u, '').replace(/\s+/gu, ' ').trim();
    if (!clean) continue;
    const chars = Array.from(clean);
    return chars.length > 20 ? chars.slice(0,20).join('') + '...' : clean;
  }
  return '';
}

function createWorldReplyNotificationHandler({db, APP_ID, sendToUserDevices, logger, worldPushAllowedUids}) {
  return async (event) => {
    const snap = event.data;
    if (!snap?.exists) return null;
    const {appId,sessionId,messageId} = event.params || {};
    if (appId !== APP_ID || typeof messageId !== 'string' || !/^ai_[A-Za-z0-9_-]+$/.test(messageId)) return null;
    const message = snap.data() || {};
    if (message.sender !== 'ai') return null;
    const body = worldReplyPreview(message.segments);
    if (!body) return null;
    try {
      const roomDoc = await db.collection('artifacts').doc(APP_ID)
        .collection('world_chat_sessions').doc(sessionId).get();
      if (!roomDoc.exists) return null;
      const room = roomDoc.data() || {};
      const uid = String(room.userId || '').trim();
      const worldId = String(room.worldId || '').trim();
      if (!uid || !worldId) return null;
      // V2 staged rollout: no push to regular players, regardless of client version.
      // Fail closed when the allowlist was not supplied; never fall back to all users.
      if (!(worldPushAllowedUids instanceof Set) || !worldPushAllowedUids.has(uid)) return null;
      const worldName = String(room.worldName || '').trim() || '開放世界';
      const title = `《${worldName.replace(/^《|》$/gu, '')}》`;
      return await sendToUserDevices(uid, {
        notification: {title, body},
        data: {type:'world_chat', worldId, sessionId:String(sessionId),
          click_action:'FLUTTER_NOTIFICATION_CLICK'},
        android: {priority:'high',notification:{channelId:'high_importance_channel',
          sound:'default',defaultVibrateTimings:true,defaultLightSettings:true}},
        apns: {payload:{aps:{sound:'default'}}},
      });
    } catch (error) {
      logger.warn('world reply notification failed', {
        sessionId:String(sessionId || ''),messageId,
        code:String(error?.code || ''),error:String(error?.message || error),
      });
      return null;
    }
  };
}
module.exports = {createWorldReplyNotificationHandler,worldReplyPreview};
