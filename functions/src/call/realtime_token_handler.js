'use strict';

// Internal test only: keep the ElevenLabs key server-side, bind token issuance
// to an owned chat room, and bound both issuance frequency and session length.
function createCallRealtimeTokenHandler({db, APP_ID, HttpsError, elevenLabsApiKey,
  requireTester, fetchImpl = globalThis.fetch, now = Date.now}) {
  return async function createCallRealtimeToken(request) {
    const uid = requireTester(request);
    const sid = String(request.data?.sessionId || '').trim();
    const cid = String(request.data?.characterId || '').trim();
    if (!sid || !cid || sid.length > 256 || cid.length > 256 || sid.includes('/') || cid.includes('/')) {
      throw new HttpsError('invalid-argument', 'Invalid call room');
    }
    const root = db.collection('artifacts').doc(APP_ID);
    const room = await root.collection('chat_sessions').doc(sid).get();
    const data = room.data() || {};
    if (!room.exists || data.userId !== uid || data.characterId !== cid) {
      throw new HttpsError('permission-denied', 'Call room access denied');
    }
    const ts = now();
    const day = new Date(ts + 8 * 3600 * 1000).toISOString().slice(0, 10);
    const limitRef = root.collection('call_realtime_test_limits').doc(uid);
    // Reserve an attempt before calling the paid upstream, including failures.
    await db.runTransaction(async tx => {
      const snap = await tx.get(limitRef);
      const previous = snap.data() || {};
      const count = previous.day === day ? (Number(previous.count) || 0) : 0;
      if (count >= 30 || ts - (Number(previous.lastIssuedAt) || 0) < 2500) {
        throw new HttpsError('resource-exhausted', 'Realtime test limit reached');
      }
      tx.set(limitRef, {day, count: count + 1, lastIssuedAt: ts});
    });
    try {
      const result = await fetchImpl('https://api.elevenlabs.io/v1/single-use-token/realtime_scribe?max_session_duration_seconds=90', {
        method: 'POST', headers: {'xi-api-key': elevenLabsApiKey.value(), accept: 'application/json'},
        signal: AbortSignal.timeout(10000),
      });
      if (!result.ok) {
        console.warn('CALL_REALTIME_TOKEN_FAILED', {status: result.status});
        throw new HttpsError('unavailable', 'Realtime speech service unavailable');
      }
      const payload = await result.json();
      if (typeof payload.token !== 'string' || !payload.token) {
        throw new HttpsError('unavailable', 'Realtime token missing');
      }
      console.info('CALL_REALTIME_TOKEN_ISSUED', {sessionLimitSeconds: 90});
      return {token: payload.token};
    } catch (error) {
      if (error instanceof HttpsError) throw error;
      console.warn('CALL_REALTIME_TOKEN_FAILED', {name: error?.name || 'Error'});
      throw new HttpsError('unavailable', 'Realtime speech service unavailable');
    }
  };
}
module.exports = {createCallRealtimeTokenHandler};
