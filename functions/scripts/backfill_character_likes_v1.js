'use strict';
// Run from the project root. Dry run by default; --apply only creates/repairs
// the owner-only index, never changes likes, totals, or creator mailboxes.
const {initializeApp, applicationDefault} = require('firebase-admin/app');
const {getFirestore, FieldValue} = require('firebase-admin/firestore');
const {syncCharacterLikeIndex} = require('../src/characters/work_engagement');
const APP_ID = 'lianlianshiguang';
const args = process.argv.slice(2);
const projectArg = args.indexOf('--project');
if (projectArg < 0 || args[projectArg + 1] !== APP_ID ||
  args.some((v,i) => i !== projectArg + 1 && !['--project','--dry-run','--apply'].includes(v)) ||
  (args.includes('--apply') && args.includes('--dry-run'))) {
  console.error('Usage: node functions/scripts/backfill_character_likes_v1.js --project lianlianshiguang [--dry-run|--apply]');
  process.exit(1);
}
const apply = args.includes('--apply');
initializeApp({credential:applicationDefault(), projectId:APP_ID});
const db = getFirestore();
(async () => {
  const refs = await db.collection('artifacts').doc(APP_ID).collection('public_characters').listDocuments();
  const stats = {characters:refs.length, likerDocs:0, created:0, removed:0, unchanged:0};
  console.log(`Project: ${APP_ID} | ${apply ? 'APPLY' : 'DRY RUN (no writes)'}`);
  for (const ref of refs) {
    const likers = await ref.collection('likers').select().get();
    stats.likerDocs += likers.size;
    if (!apply) continue;
    for (let i=0; i<likers.docs.length; i+=12) {
      const results = await Promise.all(likers.docs.slice(i,i+12).map(doc =>
        syncCharacterLikeIndex({db, APP_ID, FieldValue, characterId:ref.id, uid:doc.id})));
      for (const result of results) stats[result]++;
    }
  }
  console.log(JSON.stringify(stats, null, 2));
})().catch(error => { console.error(error); process.exitCode=1; });
