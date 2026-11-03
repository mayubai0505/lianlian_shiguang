'use strict';
// Restricted administrative maintenance endpoints. Never expose message content without authentication.
const crypto = require('crypto');
const BROKEN = /(æ|å|ç|ï¼|ã|â|�)/;
const AUDIT = 'broken_message_maintenance_audit';
const MAX_SCAN = 300;
const MAX_DELETE = 100;
const PREVIEW_TTL_MS = 10 * 60 * 1000;
function createBrokenMessageHandlers({db, auth, adminUids, now = () => Date.now()}) {
  async function authorize(req, res) {
    if (req.method !== 'POST') {
      res.set('Allow', 'POST');
      res.status(405).json({error:'method-not-allowed'});
      return null;
    }
    const header = req.headers?.authorization || '';
    const match = /^Bearer ([^\s]+)$/i.exec(header);
    if (!match) {res.status(401).json({error:'authentication-required'}); return null;}
    try {
      const token = await auth.verifyIdToken(match[1], true);
      if (!token?.uid || !adminUids.has(token.uid)) {
        res.status(403).json({error:'admin-only'});
        return null;
      }
      return token.uid;
    } catch (err) {
      res.status(401).json({error:'invalid-authentication'});
      return null;
    }
  }
  function parseLimit(raw, fallback, max) {
    const n = raw === undefined ? fallback : Number(raw);
    return Number.isSafeInteger(n) && n >= 1 && n <= max ? n : null;
  }
  function matched(doc) {
    const d = doc.data();
    return [d.text, d.voiceText, d.content].some(x => typeof x === 'string' && BROKEN.test(x));
  }
  function previewInfo(doc) {
    const d = doc.data();
    return {path:doc.ref.path, sender:d.sender || '',textPreview:String(d.text || '').slice(0,200),
      voicePreview:String(d.voiceText || '').slice(0,100),contentPreview:String(d.content || '').slice(0,200)};
  }
  const scanBrokenMessages = async (req,res) => {
    const uid = await authorize(req,res);
    if (!uid) return;
    const limit = parseLimit(req.body?.limit, 300, MAX_SCAN);
    if (!limit) return res.status(400).json({error:'invalid-limit'});
    try {
      const snap = await db.collectionGroup('messages').limit(limit).get();
      const results=[];
      snap.forEach(doc => {if (matched(doc)) results.push(previewInfo(doc));});
      return res.status(200).json({scanned:snap.size,brokenCount:results.length,results});
    } catch (e) {
      console.error('掃描亂碼訊息失敗',e);
      return res.status(500).json({error:'scan-failed'});
    }
  };
  const deleteBrokenMessages = async (req,res) => {
    const uid = await authorize(req,res);
    if (!uid) return;
    const action = req.body?.action || 'preview';
    if (!['preview','delete'].includes(action)) return res.status(400).json({error:'invalid-action'});
    try {
      if (action === 'preview') {
        const limit=parseLimit(req.body?.limit,100,MAX_DELETE);
        if (!limit) return res.status(400).json({error:'invalid-limit'});
        const snap=await db.collectionGroup('messages').limit(limit).get();
        const candidates=[];
        snap.forEach(doc => {if(doc.data().sender==='ai' && matched(doc)) candidates.push(doc);});
        const paths=candidates.map(doc=>doc.ref.path);
        const previewId=crypto.randomUUID();
        await db.collection(AUDIT).doc(previewId).create({uid,createdAtMs:now(),expiresAtMs:now()+PREVIEW_TTL_MS,
          state:'preview',paths,scanned:snap.size,matched:paths.length});
        return res.status(200).json({action:'preview',previewId,expiresInSeconds:600,
          scanned:snap.size,matched:paths.length,deleted:0,results:candidates.map(previewInfo)});
      }
      const previewId=req.body?.previewId;
      if(typeof previewId !== 'string' || !/^[0-9a-f-]{36}$/.test(previewId) || req.body?.confirm !== 'DELETE_AI_BROKEN_MESSAGES') {
        return res.status(400).json({error:'confirmation-required'});
      }
      const auditRef=db.collection(AUDIT).doc(previewId);
      let paths;
      await db.runTransaction(async transaction => {
        const snapshot=await transaction.get(auditRef);
        const data=snapshot.exists ? snapshot.data() : null;
        if(!data || data.uid!==uid || data.state!=='preview' || data.expiresAtMs<now() ||
          !Array.isArray(data.paths) || data.paths.length>MAX_DELETE) {
          const err=new Error('invalid-or-expired-preview');err.httpCode=409;throw err;
        }
        paths=data.paths;
        transaction.update(auditRef,{state:'processing',startedAtMs:now()});
      });
      try {
        const batch=db.batch();
        let deleted=0,skipped=0;
        for(const path of paths) {
          if(typeof path!=='string' || !/^(?:[^/]+\/)+messages\/[^/]+$/.test(path)) {skipped++;continue;}
          const ref=db.doc(path);
          const snap=await ref.get();
          if(snap.exists && snap.data().sender==='ai' && matched(snap)) {batch.delete(ref);deleted++;}
          else skipped++;
        }
        if(deleted) await batch.commit();
        await auditRef.update({state:'completed',completedAtMs:now(),deleted,skipped});
        return res.status(200).json({action:'delete',deleted,skipped,previewId});
      } catch(e) {
        await auditRef.update({state:'failed',failedAtMs:now(),errorCode:'delete-failed'});
        throw e;
      }
    } catch(e) {
      console.error('亂碼訊息維護作業失敗',e);
      return res.status(e.httpCode || 500).json({error:e.httpCode?'invalid-or-expired-preview':'maintenance-failed'});
    }
  };
  return {scanBrokenMessages,deleteBrokenMessages};
}
module.exports={createBrokenMessageHandlers};
