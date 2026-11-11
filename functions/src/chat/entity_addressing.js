"use strict";
// V4: Only explicitly given type/sex/pronoun information; never infer from a name or appearance.
function safe(value, limit=180) { return String(value ?? "").replace(/[\r\n]+/g," ").trim().slice(0,limit); }
function normalizedGender(value) {
  const v=safe(value,40).toLowerCase();
  if (["male","m","男","男性","男生"].includes(v)) return "male";
  if (["female","f","女","女性","女生"].includes(v)) return "female";
  return "unknown";
}
function pronounPairFromExplicit(value) {
  const v=safe(value,50).replace(/\s/g,"");
  // Never assume arbitrary words are pronouns; respect a declared, recognizable pair.
  const possibilities = [
    {match:/^(?:你[／/、,，]他|他|he(?:\/him)?|he\/him|男性稱謂)$/i, second:"你", third:"他"},
    {match:/^(?:妳[／/、,，]她|她|she(?:\/her)?|女性稱謂)$/i, second:"妳", third:"她"},
    {match:/^(?:牠|動物代詞)$/, second:"你", third:"牠"},
    {match:/^(?:祂|神祇代詞)$/, second:"你", third:"祂"},
    {match:/^(?:它|物件代詞)$/, second:"你", third:"它"},
  ];
  return possibilities.find(x=>x.match.test(v)) || null;
}
function buildEntityAddressDirective({mainCharacter={}, mainCharacterName="", npcCharacters=[]}={}) {
  const entities=[{...mainCharacter,name:mainCharacterName || mainCharacter.name || "主角色"},...((Array.isArray(npcCharacters)?npcCharacters:[]).slice(0,30))];
  const rows=[];
  for (const npc of entities) {
    const name=safe(npc?.name,70);
    if (!name) continue;
    const species=safe(npc?.species || npc?.race || "",50);
    const identity=safe(npc?.identity || npc?.role || "",50);
    const gender=normalizedGender(npc?.gender);
    const explicit=safe(npc?.pronouns || npc?.pronoun || npc?.preferredPronoun || npc?.preferredPronouns || npc?.addressing || "",50);
    const pair=pronounPairFromExplicit(explicit);
    let rule="";
    if (pair) rule=`創作者代詞：${pair.second}／${pair.third}`;
    else if (gender==="male") rule="若以人稱敘述：對他說「你」，提及用「他」";
    else if (gender==="female") rule="若以人稱敘述：對她說「妳」，提及用「她」";
    else rule="代詞未明：優先使用名稱；不得依姓名猜性別";
    rows.push(`- ${name}${species?`｜物種：${species}`:""}${identity?`｜身分：${identity}`:""}｜${rule}`);
  }
  return `【角色、NPC 指涉對照｜每個對象獨立判斷】
${rows.join("\n") || "- 無結構化角色稱謂資料：依創作者設定與已確立事實判斷，無法確定就直接稱名。"}
- 依創作者指定代詞、物種、人格化程度及既定身分決定適用的人稱；不能把所有非人 NPC 都當人，也不能把擬人角色一律寫成「牠」。
- 一般動物敘述用「牠」、一般物品用「它」、神祇可依設定用「祂」；擬人動物、獸人、機器人及其他種族依創作者指定及故事人稱設定。第二人稱「你／妳」要看實際受話者，沒有足夠依據時直接稱名字。
- 對白與群組訊息每次換說話對象，重新判定稱謂。玩家的代詞不可套用在 NPC，也不能把 NPC 的代詞套用在玩家。
- 例：男性角色對男性父親說「爸，你別鬧」，轉向女性母親說「媽，妳看他」，對寵物的旁白使用「牠」。
- 不要修改已確立設定；禁止把正文的「你／妳／他／她」全部自動替換。生成前自行檢查代詞，不輸出規則說明。`;
}
module.exports={buildEntityAddressDirective};
