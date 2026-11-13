'use strict';
// Compatibility with common roleplay card *identity placeholders* only.
// This is intentionally NOT a scripting/macro execution engine.
// Never evaluate expressions, nested macros, variable writes or random commands.
const NAME_TOKEN = /\{\{\s*(char|character|bot|user|username|persona_name)\s*\}\}|<\s*(CHAR|BOT|USER)\s*>|\{\s*(char|user)\s*\}/giu;
function resolveCreatorIdentityMacros(raw, {characterName, playerName} = {}) {
  const source = String(raw ?? '');
  const char = String(characterName || '').trim();
  const user = String(playerName || '').trim();
  return source.replace(NAME_TOKEN, (full, braced, angled, single) => {
    const key = String(braced || angled || single || '').toLowerCase();
    const value = ['char','character','bot'].includes(key) ? char : user;
    return value || full; // No guess and no substitution when identity is unavailable.
  });
}
module.exports = {resolveCreatorIdentityMacros};
