"use strict";
// Directional kinship guidance from explicitly anchored creator data only.
// Does not edit generated dialogue, guess a relation from surnames, or treat
// ambiguous social-network labels as directed facts.
const compact = (x, n=180) => String(x ?? "").replace(/[\r\n\t]+/g," ").replace(/\s+/g," ").trim().slice(0,n);
const genderOf = x => {
 const v=compact(x,30).toLowerCase();
 if (["male","m","男","男性","男生"].includes(v)) return "male";
 if (["female","f","女","女性","女生"].includes(v)) return "female";
 return "unknown";
};
const anchors = [
 {match:/^(?:親)?哥哥$|^兄長$|^大哥$/, relationship:"哥哥", inverse:{male:"弟弟",female:"妹妹",unknown:"年幼的手足"}},
 {match:/^(?:親)?弟弟$|^胞弟$/, relationship:"弟弟", inverse:{male:"哥哥",female:"姐姐",unknown:"年長的手足"}},
 {match:/^(?:親)?姐姐$|^姊姊$|^姊$|^胞姊$/, relationship:"姐姐", inverse:{male:"弟弟",female:"妹妹",unknown:"年幼的手足"}},
 {match:/^(?:親)?妹妹$|^胞妹$/, relationship:"妹妹", inverse:{male:"哥哥",female:"姐姐",unknown:"年長的手足"}},
 {match:/^父親$|^爸爸$|^父$/, relationship:"父親", inverse:{male:"兒子",female:"女兒",unknown:"子女"}},
 {match:/^母親$|^媽媽$|^母$/, relationship:"母親", inverse:{male:"兒子",female:"女兒",unknown:"子女"}},
 {match:/^兒子$/, relationship:"兒子", inverse:{male:"父親",female:"母親",unknown:"家長"}},
 {match:/^女兒$/, relationship:"女兒", inverse:{male:"父親",female:"母親",unknown:"家長"}},
];
function extractAnchoredRole(value, mainName) {
 const v=compact(value,250).replace(/[。！!，,；;].*$/u,"").trim();
 // The NPC field is named 「與主角色的關係」, not a free-form relation direction.
 // For long prose, only accept an explicit NPC-is-main's phrase.
 const main=compact(mainName,70);
 const safeName = main.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
 let role=v;
 if (main) {
   const re=new RegExp(`^(?:${safeName}|主角色|主角|男主角|女主角)的(?:親)?(哥哥|弟弟|姐姐|姊姊|妹妹|爸爸|媽媽|父親|母親)(?:[（(].*[）)])?$`,"u");
   const m=v.match(re);
   if (m) role=m[1];
   // Also accept a fully stated creator fact: 「NPC 是主角的哥哥」.
   if (!m) {
     const full = v.match(new RegExp(`^.{1,70}是(?:「)?${safeName}(?:」)?的(哥哥|弟弟|姐姐|姊姊|妹妹|爸爸|媽媽|父親|母親)$`, "u"));
     if (full) role=full[1];
   }
 }
 // Reject vague strings like 「把他當哥哥」or「哥哥的朋友」.
 const match=anchors.find(item=>item.match.test(role));
 return match || null;
}
function buildRelationshipGuard({mainCharacter={}, mainCharacterName="", npcCharacters=[], relations=[], socialRelationships=""}={}) {
 const main=compact(mainCharacterName || mainCharacter.name,70);
 if (!main) return "";
 const mainGender=genderOf(mainCharacter.gender);
 const rows=[];
 for (const npc of (Array.isArray(npcCharacters)?npcCharacters:[]).slice(0,30)) {
   const name=compact(npc?.name,70);
   if (!name || name===main) continue;
   const role=extractAnchoredRole(npc?.relationship,main);
   if (!role) continue;
   const inverse=role.inverse[mainGender];
   rows.push(`- ${name}是「${main}」的${role.relationship}；「${main}」是${name}的${inverse}。由${name}稱呼${main}時，不可把長幼輩分叫反。`);
 }
 // Deliberately avoid directional interpretation of characterProfile.relations entries:
 // 「與X的關係：哥哥」 does not identify whether X or the main character is older.
 const socialRaw=compact(socialRelationships,650);
 const socialLines=(Array.isArray(relations)?relations:[]).slice(0,10).map(r=>{
   const name=compact(r?.name,55), rel=compact(r?.relation,85);
   return name && rel ? `- 與「${name}」的原始關係描述：「${rel}」（方向未明時不得自行認定誰年長）。` : "";
 }).filter(Boolean);
 if (!rows.length && !socialRaw && !socialLines.length) return "";
 return `【創作者關係方向核對｜不得改寫既有身分】
- 「NPC 與主角色的關係」表示該 NPC 相對於「${main}」的身分；不能反過來理解成主角色相對於 NPC。
${rows.join("\n")}
${socialRaw ? `- 創作者其他社交關係原文：${socialRaw}` : ""}
${socialLines.join("\n")}
- 對話、轉述及群組訊息中，要先識別發話者與受話者，再依已明確確認的關係使用哥、姐、爸、媽等稱謂；暱稱及玩笑稱呼需有明確劇情依據。
- 若資料有衝突或方向不清，稱名字，不要自行建立、倒置或升級親屬關係；最近對話中的模型錯稱不能推翻創作者設定。
- 本規則只供演繹核對，不要輸出關係表或設定說明。`;
}
module.exports={buildRelationshipGuard,extractAnchoredRole};
