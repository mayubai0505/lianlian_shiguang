"use strict";

// A control request is deliberately narrow: ordinary dialogue containing
// 「繼續」 (e.g. 繼續喝茶) must retain the player's actual action.
function isContinueRequest(message, explicit = false) {
  return explicit === true || /^(?:繼續|繼續吧|繼續故事|繼續劇情|接著|接下去|然後呢|然後|continue)[！!。.…\s]*$/iu.test(String(message || '').trim());
}

function progressionInstruction({continuing = false, casual = false} = {}) {
  return [
    '【共用回合推進規則】',
    continuing
      ? '這是續寫控制指令，不是玩家台詞或動作。從最近一則已完成 AI 回覆的結尾之後接續，不重新回答上一輪玩家的訊息，不重演開場。'
      : '回應玩家本輪的新訊息；先前已完成的對話與事件是既成事實，不重新演出。玩家只有短句或小動作，也不代表只能重述上一輪。',
    casual
      ? '維持手機短訊息格式與原字數限制；接續尚未說完的話題，加入新的具體回應或資訊，不添加場景旁白。'
      : '依角色目前目標和因果關係，讓角色、NPC 或環境至少有一項具體的新進展，例如執行先前說要做的事、帶來新資訊，或讓已有事件產生後果。幅度可以小，不強制轉場、跳日、突發危機或加速關係。',
    '同一件事換詞重講、重複質問／邀請／威脅、只加強相同情緒與動作，都不算新進展。已掛斷的電話不能重新掛一次；應接續掛斷後角色可做的事。',
    '需要玩家選擇的關鍵決定仍留給玩家；可推進角色自己的行動，不擅自替玩家回答、移動、同意、產生心聲或情緒，也不把繼續視為親密同意。',
    '遵守當前模式、世界設定、已知資訊與安全限制。創作者狀態欄依原模板單獨更新，未改變的值可保留，不為避重複而亂改數值或新增欄位。',
    '輸出前自行比對最近幾輪：本輪具體新增了什麼？若只有改寫舊內容，先改成真正接續的回覆；不要輸出檢查過程。',
  ].join('\n');
}
module.exports = {isContinueRequest, progressionInstruction};
