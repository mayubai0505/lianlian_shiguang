"use strict";

// V5.7.18: Deterministic, conservative player-speech protection.
// Never treats author/creator text as executable instructions. Does not invoke AI.
const NO_SPEECH = /(?:不(?:要|准|可以|允許|能)|禁止|別|勿|嚴禁|不要再|不能再)[^\n。！？]{0,25}(?:代(?:寫|替寫|說)|幫(?:我|玩家|角色|用戶|使用者)?(?:寫|說)|編(?:寫|造)|自(?:行|己)(?:寫|說)|生成|寫出|補寫)[^\n。！？]{0,24}(?:玩家|我|使用者|用戶)?(?:的)?(?:回應|回答|回話|對話|台詞|發言|說話)|(?:不(?:要|准|可以|允許|能)|禁止|別|勿|嚴禁)[^\n。！？]{0,18}(?:玩家|我|使用者|用戶)(?:的)?[^\n。！？]{0,12}(?:台詞|回應|回答|對白|說話|發言)|請系統不要代寫玩家的回應/iu;
const NO_REPEAT = /(?:不要|別|禁止|勿|嚴禁)[^\n。！？]{0,18}(?:重(?:複|述|演|播)|再(?:寫|演|講))[^\n。！？]{0,18}(?:玩家|我|我的|我說|輸入|行動|動作|台詞)/iu;

function detectPlayerInstructions(input) {
  const text = String(input || '');
  return { noPlayerDialogue: NO_SPEECH.test(text), noPlayerReplay: NO_REPEAT.test(text) };
}

function escapeRegex(s) { return String(s).replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); }

// Remove only clearly player-attributed speech. Do not guess the speaker of
// unlabelled quotes, or strip NPC dialogue or user-authored status bars.
function enforcePlayerInstructions(output, input, playerName) {
  const flags=detectPlayerInstructions(input);
  let text=String(output || '');
  if (!flags.noPlayerDialogue) return {text, flags, corrected:0, uncertainQuotes:0};
  let corrected=0;
  const playerLabel=String(playerName || '').trim();
  const labelPattern=playerLabel ? `(?:${escapeRegex(playerLabel)}|玩家|妳|你|用戶|使用者)` : '(?:玩家|妳|你|用戶|使用者)';
  // 1. Explicit script labels: 玩家名：「...」 or 玩家名：... (only quoted speech).
  const labelRe=new RegExp(`(^|\\n)([ \\t]*${labelPattern}[ \\t]*[:：][ \\t]*)(「[^」\\n]{1,240}」)`, 'gu');
  text=text.replace(labelRe, (_m, before) => {corrected++; return before;});
  // 2. Explicit player speech actions in parenthesized narration, followed by a quote.
  //    Keep the non-speech prose, remove only the utterance. A guard against
  //    '妳聽見他說...' prevents removal of the character's dialogue.
  const lines=text.split('\n');
  for(let i=0;i<lines.length;i++) {
    const line=lines[i];
    const m=line.match(/^(\s*)(「[^」\n]{1,240}」)(\s*)$/u);
    if(!m) continue;
    const previous = lines[i - 1] || '';
    const context = previous.trim();
    // Only statements which end by attributing speech to the player.
    const attribution=/(?:妳|你|玩家|使用者|用戶)(?:[^（）「」。！？\n]{0,28})(?:說(?:道|著)?|問(?:道)?|回答|回(?:應|道|嘴)?|嘟囔|喊(?:道)?|開口)(?:[^（）「」。！？\n]{0,8})[）)]?\s*$/u;
    const otherSpeaker=/(?:他|她|角色|NPC)(?:[^（）「」。！？\n]{0,12})(?:說|問|回答|喊)(?:[^（）「」。！？\n]{0,8})[）)]?\s*$/iu;
    if(attribution.test(context) && !otherSpeaker.test(context)) {
      lines[i]=''; corrected++;
    }
  }
  text=lines.join('\n').replace(/\n{3,}/g,'\n\n').trim();
  // Count quotes for quality diagnostics only; no private dialogue logging.
  const uncertainQuotes=(text.match(/「[^」\n]+」/gu)||[]).length;
  return {text, flags, corrected, uncertainQuotes};
}
module.exports={detectPlayerInstructions,enforcePlayerInstructions};
