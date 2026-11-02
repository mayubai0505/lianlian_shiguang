'use strict';

// 從 core.js 原樣搬移；注入既有 db/HttpsError，避免新增 Firebase 初始化。
function createCreatorFanMailUtils({db, HttpsError}) {
const CREATOR_FAN_MAIL_LIMITS = Object.freeze({single:30, broadcast:5, title:100, body:5000});
function creatorFanMailDayKey() {
  return new Intl.DateTimeFormat('en-CA', {timeZone:'Asia/Taipei', year:'numeric', month:'2-digit', day:'2-digit'}).format(new Date());
}
function creatorFanMailVerified(d) {
  return d.creatorStatus === 'approved' && d.creatorVerified === true && d.creatorDashboardEnabled === true;
}
function creatorFanMailCharCount(s) {
  // JS Array.from counts Unicode code points (including emoji, but not grapheme clusters).
  return Array.from(new Intl.Segmenter('zh-Hant', {granularity:'grapheme'}).segment(s)).length;
}
function creatorFanMailValidate(title, body) {
  if (!title || creatorFanMailCharCount(title) > CREATOR_FAN_MAIL_LIMITS.title) {
    throw new HttpsError('invalid-argument', '標題須為 1～100 字');
  }
  if (!body || creatorFanMailCharCount(body) > CREATOR_FAN_MAIL_LIMITS.body) {
    throw new HttpsError('invalid-argument', '內文須為 1～5000 字');
  }
}
function creatorFanMailUsageRef(uid, day) {
  return db.collection('creator_fan_mail_usage').doc(`${uid}_${day}`);
}

return {CREATOR_FAN_MAIL_LIMITS, creatorFanMailDayKey, creatorFanMailVerified, creatorFanMailCharCount, creatorFanMailValidate, creatorFanMailUsageRef};
}
module.exports = {createCreatorFanMailUtils};
