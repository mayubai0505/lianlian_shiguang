'use strict';
const {replacePlayerName,hasPlayerNamePlaceholder}=require('../text/player_name_placeholders');
const owns=(o,k)=>Object.prototype.hasOwnProperty.call(o,k);
const LATEST_SETTINGS_DIRECTIVE='【創作者最新設定】本輪角色與世界設定來自目前儲存版本。若舊對話、摘要或檢索記憶對固定設定、人物資料、輸出欄位的描述與本輪設定衝突，以本輪設定為準。已移除或清空的設定不可從歷史恢復。保留已發生事件、玩家選擇及動態關係；不要重播開場、重置進度或把更新說明寫入故事。玩家本人最新身分設定仍優先於創作者預設主角。';
function projectLiveProfile(saved,client,id){
 const profile={...saved,id};
 // Relationship is room progress, not a replacement for creator settings.
 profile.relationship=client.relationship || saved.initialRelationship || '';
 if(owns(saved,'coreCharacterSetting')){
  profile.detailedPersonality='';profile.personality='';
 }
 if(owns(saved,'worldLore')){profile.worldSetting='';profile.background='';}
 profile.socialRelationships=owns(saved,'relationships')?JSON.stringify(saved.relationships??{}):String(saved.socialRelationships??'');
 return profile;
}
async function loadLiveProfile({db,appId,userId,id,client={},isTestMode=false,sessionId,playerProfileId}){
 // Unsaved creator preview intentionally uses the submitted draft.
 if(isTestMode===true)return {profile:client,source:'draft_preview'};
 if(!id || typeof id!=='string' || id.includes('/'))throw Object.assign(Error('角色 ID 不正確'),{code:'invalid-argument'});
 const base=db.collection('artifacts').doc(appId);
 let snap=await base.collection('public_characters').doc(id).get();
 let source='public_characters';
 if(!snap.exists){
  snap=await base.collection('users').doc(userId).collection('private_characters').doc(id).get();
  source='private_characters';
 }
 if(!snap.exists)throw Object.assign(Error('角色已不存在，請重新開啟角色頁'),{code:'not-found'});
 const saved=snap.data()||{};
 if(source==='public_characters' && saved.isPublic===false && saved.createdBy!==userId)
  throw Object.assign(Error('此角色目前不對外公開'),{code:'permission-denied'});
 let profile=projectLiveProfile(saved,client,id);
 if(hasPlayerNamePlaceholder(JSON.stringify(profile))){
  const account=(await db.collection('users').doc(userId).get()).data()||{};
  const selectedId=account.roomProfiles?.[sessionId] ?? playerProfileId ?? 'default';
  const selected=Array.isArray(account.profiles)?account.profiles.find(p=>p?.id===selectedId):null;
  const playerName=String(selected?.name || account.nickname || account.displayName || '').trim();
  // Only narrative fields: never rewrite IDs, URLs or timestamps.
  const fields=['coreCharacterSetting','detailedPersonality','toneAndStyle','socialInteraction',
   'worldLore','worldSetting','background','customOutputFormat','likes','dislikes','secrets',
   'appearance','dialogueExamples','initialStory','storyModeFirstLine','firstLine','socialRelationships'];
  for(const field of fields)if(typeof profile[field]==='string')profile[field]=replacePlayerName(profile[field],playerName);
 }
 return {profile,source,revision:String(saved.lastEditTime?.toMillis?.()??'unknown')};
}
function preferredWorldLore(data={}){
 if(owns(data,'worldLore'))return String(data.worldLore??'').trim();
 if(owns(data,'worldSetting'))return String(data.worldSetting??'').trim();
 return String(data.background??'').trim();
}
module.exports={loadLiveProfile,projectLiveProfile,preferredWorldLore,LATEST_SETTINGS_DIRECTIVE};
