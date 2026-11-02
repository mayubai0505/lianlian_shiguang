'use strict';
// Creator support validation/serialization. Keep exact original behavior.
function createCreatorSupportUtils({ HttpsError }) {
const CREATOR_SUPPORT_MAX_IMAGE_BYTES = 2 * 1024 * 1024;
function creatorSupportImageData(raw) {
  if(typeof raw !== 'string' || raw.length < 40 || raw.length > 2900000 || !/^[A-Za-z0-9+/=]+$/.test(raw)) throw new HttpsError('invalid-argument','截圖資料無效');
  const bytes=Buffer.from(raw,'base64');
  const png=bytes.subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10]));
  const jpg=bytes[0]===255&&bytes[1]===216&&bytes[2]===255;
  if(!png&&!jpg||bytes.length>CREATOR_SUPPORT_MAX_IMAGE_BYTES) throw new HttpsError('invalid-argument','僅支援小於 2MB 的 JPG/PNG 截圖');
  return {bytes,contentType:png?'image/png':'image/jpeg'};
}
const CREATOR_SUPPORT_CATEGORIES = new Set(['角色管理問題','AI 角色互動異常','創作者後台問題','合作與權益問題','其他問題']);
const CREATOR_SUPPORT_STATUSES = new Set(['pending','in_progress','waiting_creator','resolved']);
function creatorSupportText(raw,max,label,required=true) {
 const s=typeof raw==='string'?raw.trim():'';
 if ((required&&!s) || s.length>max) throw new HttpsError('invalid-argument',`${label}格式不正確（最多 ${max} 字）`);
 return s;
}
function creatorSupportPublic(d,id) {
 return {id,creatorId:d.creatorId||'',creatorName:d.creatorName||'',category:d.category||'',characterId:d.characterId||'',title:d.title||'',description:d.description||'',status:d.status||'pending',createdAt:d.createdAt?.toMillis?.()||0,updatedAt:d.updatedAt?.toMillis?.()||0,lastReplyAt:d.lastReplyAt?.toMillis?.()||0,lastReplyBy:d.lastReplyBy||'',adminUnreadCount:Number(d.adminUnreadCount||0),creatorUnreadCount:Number(d.creatorUnreadCount||0),internalNote:d.internalNote||''};
}
return { CREATOR_SUPPORT_MAX_IMAGE_BYTES, creatorSupportImageData, CREATOR_SUPPORT_CATEGORIES, CREATOR_SUPPORT_STATUSES, creatorSupportText, creatorSupportPublic };
}
module.exports = { createCreatorSupportUtils };
