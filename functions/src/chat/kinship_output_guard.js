"use strict";
// V5.7.5: conservative group-chat kinship repair based on explicit creator relationships.
// Never global-replace kinship words in narrative or regular dialogue.
const {extractAnchoredRole} = require('./relationship_guard');
const escapeRe = s => String(s).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
function protectGroupKinship(text, {mainCharacterName='',npcCharacters=[],customOutputFormat=''}={}) {
  const original=String(text??'');
  const main=String(mainCharacterName??'').trim();
  if (!main || !Array.isArray(npcCharacters) || !customOutputFormat) return {text:original,changes:0};
  const older=new Set();
  const younger=new Set();
  for (const npc of npcCharacters) {
    const name=String(npc?.name||'').trim();
    const role=extractAnchoredRole(npc?.relationship,main);
    if (!name || !role) continue;
    if (['哥哥','姐姐'].includes(role.relationship)) older.add(name);
    if (['弟弟','妹妹'].includes(role.relationship)) younger.add(name);
  }
  if (!older.size && !younger.size) return {text:original,changes:0};
  // Group label must have been defined by the creator, not inferred from prose.
  const creatorGroupLabels=new Set();
  for (const raw of String(customOutputFormat).split(/\r?\n/)) {
    const m=raw.match(/^\s*([^\r\n：:]{1,48})[：:]/u);
    if (m && /(?:📱|群組|聊天室|群聊|家庭群|聊天群)/u.test(m[1])) creatorGroupLabels.add(m[1].trim());
  }
  if (!creatorGroupLabels.size) return {text:original,changes:0};
  const allFields=new Set();
  for(const raw of String(customOutputFormat).split(/\r?\n/)) {
    const m=raw.match(/^\s*([^\r\n：:]{1,48})[：:]/u);
    if(m && /^[\p{Extended_Pictographic}\p{Emoji_Presentation}]/u.test(m[1].trim())) allFields.add(m[1].trim());
  }
  let inGroup=false,changes=0;
  const lines=original.split(/\r?\n/);
  const amended=lines.map(line=>{
    const field=line.match(/^\s*([^\r\n：:]{1,48})[：:]\s*(.*)$/u);
    if (field && creatorGroupLabels.has(field[1].trim())) {inGroup=true;return line;}
    if (field && allFields.has(field[1].trim())) {inGroup=false;return line;}
    if (!inGroup || !field) return line;
    const speaker=field[1].trim();
    const message=field[2];
    if (!older.has(speaker) && !younger.has(speaker)) return line;
    // When an elder NPC describes the main character's action, '哥說/哥要去'
    // incorrectly labels the younger main character as an older brother.
    // Only repair third-person, sentence-initial quotations, not '哥' in any dialogue.
    // A first-person elder saying '哥我...' remains untouched.
    const isOlder=older.has(speaker);
    const wrongLead=isOlder ? /^(哥|哥哥|大哥)(說|表示|提到|告訴|要去|去了|今天|明天|剛剛|昨天)(?=.)/u : /^(弟|弟弟|小弟)(說|表示|提到|告訴|要去|去了|今天|明天|剛剛|昨天)(?=.)/u;
    const m=message.match(wrongLead);
    if (!m) return line;
    const replaced=message.replace(wrongLead, main+'$2');
    if (replaced===message) return line;
    changes++;
    return line.slice(0,line.indexOf(message))+replaced;
  });
  return {text:amended.join('\n'),changes};
}
module.exports={protectGroupKinship};
