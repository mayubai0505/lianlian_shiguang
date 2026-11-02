'use strict';
// Share the existing creator support read logic across Taiwan and US callable endpoints.
function createCreatorSupportReaders({creatorSupportUid,REWARD_CAMPAIGN_ADMIN_UIDS,creatorSupportCreator,creatorSupportRoot,FieldPath,HttpsError,creatorSupportPublic}) {
  async function listCreatorSupportCasesHandler(request) {
 const uid=creatorSupportUid(request); const isAdmin=REWARD_CAMPAIGN_ADMIN_UIDS.has(uid)&&request.data?.asCreator!==true;
 if(!isAdmin) await creatorSupportCreator(request);
 const limit=20;const start=String(request.data?.cursor||'');if(start&&!/^[A-Za-z0-9]{1,100}$/.test(start))throw new HttpsError('invalid-argument','游標不正確');
 let q=isAdmin?creatorSupportRoot().orderBy(FieldPath.documentId()):creatorSupportRoot().where('creatorId','==',uid).orderBy(FieldPath.documentId());
 if(start)q=q.startAfter(start);
 const docs=(await q.limit(limit+1).get()).docs;const page=docs.slice(0,limit);
 return {items:page.map(d=>{const x=creatorSupportPublic(d.data(),d.id);if(!isAdmin)delete x.internalNote;return x;}),nextCursor:docs.length>limit?page[page.length-1].id:null};
  }
  async function getCreatorSupportCaseHandler(request) {
 const uid=creatorSupportUid(request),id=String(request.data?.caseId||'').trim();if(!/^[A-Za-z0-9]{1,100}$/.test(id))throw new HttpsError('invalid-argument','案件ID無效');
 const ref=creatorSupportRoot().doc(id),snap=await ref.get();if(!snap.exists)throw new HttpsError('not-found','案件不存在');const d=snap.data()||{};const isAdmin=REWARD_CAMPAIGN_ADMIN_UIDS.has(uid)&&request.data?.asCreator!==true;
 if(!isAdmin && d.creatorId!==uid)throw new HttpsError('permission-denied','無權查看此案件');
 if(!isAdmin)await creatorSupportCreator(request);
 const messages=await ref.collection('messages').orderBy('createdAt').limit(300).get();
 await ref.update({[isAdmin?'adminUnreadCount':'creatorUnreadCount']:0});
 const info=creatorSupportPublic(d,id);if(!isAdmin)delete info.internalNote;
 const images=await ref.collection('images').orderBy('createdAt').limit(60).get();return {case:info,images:images.docs.filter(x=>{const mid=String(x.data().messageId||'');const msg=messages.docs.find(m=>m.id===mid);return !mid||(msg&&!msg.data().recalledAt&&!(msg.data().hiddenFor||[]).includes(uid));}).map(x=>({id:x.id,messageId:x.data().messageId||'',contentType:x.data().contentType||''})),messages:messages.docs.filter(m=>!(m.data().hiddenFor||[]).includes(uid)).map(m=>({id:m.id,senderId:m.data().senderId||'',senderRole:m.data().senderRole||'',body:m.data().recalledAt?'':(m.data().body||''),recalled:!!m.data().recalledAt,edited:!!m.data().editedAt,createdAt:m.data().createdAt?.toMillis?.()||0}))};
  }
  return {listCreatorSupportCasesHandler,getCreatorSupportCaseHandler};
}
module.exports={createCreatorSupportReaders};
