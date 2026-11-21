'use strict';
// Delimiters are required: never rewrite ordinary narration containing 玩家/user.
const token = /\{\{\s*(?:user|uers|player|user_name|username|player_name|玩家名字|玩家姓名|玩家名稱|玩家昵称|玩家暱稱|玩家)\s*\}\}|\(\s*(?:玩家名字|玩家姓名|玩家名稱|玩家昵称|玩家暱稱)\s*\)|（\s*(?:玩家名字|玩家姓名|玩家名稱|玩家昵称|玩家暱稱)\s*）/giu;
function replacePlayerName(text, name) {
  const value=String(name || '').trim();
  return value ? String(text ?? '').replace(token, () => value) : String(text ?? '');
}
function hasPlayerNamePlaceholder(text) {token.lastIndex=0;const found=token.test(String(text||''));token.lastIndex=0;return found;}
function openingPlayerName(profile={}, account={}) {
  return String(profile.nickname || account.nickname || account.displayName || account.name || '').trim().replace(/[\r\n]+/gu,' ').slice(0,80);
}
module.exports={replacePlayerName,hasPlayerNamePlaceholder,openingPlayerName};
