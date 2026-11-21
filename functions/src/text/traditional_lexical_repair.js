'use strict';
// Conservative whole phrases only. Do not replace 麵 globally or round-trip
// all traditional text through simplified Chinese (which loses distinctions).
const surfaceWords=['負面','表面','場面','局面','畫面','頁面','界面','版面','封面','書面','字面','層面','面容','面孔','面貌','面頰','面試','面談','面積','面具','面紗'];
const repairs=new Map(surfaceWords.map(word=>[word.replaceAll('面','麵'),word]));
const pattern=new RegExp('(?:' + [...repairs.keys()].sort((a,b)=>b.length-a.length).join('|') + ')(?!包|條|粉|團|糊|皮|餅|線|食|館|攤)','gu');
function repairTraditionalLexemes(text) {return String(text??'').replace(pattern,word=>repairs.get(word));}
module.exports={repairTraditionalLexemes};
