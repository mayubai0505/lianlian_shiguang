"use strict";

// Free-form creator status is display text, not an authoritative currency ledger.
// Do not interpret mentions of past / hypothetical transactions as new spending.
const financialLabel = /(?:金錢|金钱|銀兩|银两|私庫|私库|錢包|钱包|荷包|錢袋|钱袋|餘額|余额|存款|現金|现金|金幣|金币|銅錢|铜钱|元寶|元宝|財產|财产|資金|资金|貨幣|货币|結餘|结余|資產|资产|銀票|银票|帳戶|账户|帳號餘款|賬戶|賬號餘款|信用點|信用点|靈石|灵石|貝幣|贝币)/u;
// Custom currency names such as 星火幣 are not limited to a fixed vocabulary.
const isFinancial = label => {
  const key = keyOf(label);
  if (/(?:價格|价格|售價|售价|單價|单价|匯率|汇率|獎勵|奖励|費用|费用|消費紀錄|消費記錄|花費紀錄|交易紀錄|交易记录|任務|任务)/u.test(key)) return false;
  return financialLabel.test(key) || /(?:幣|币|錢|钱|銀|银|鈔|钞)$/u.test(key);
};
const keyOf = label => String(label).normalize('NFKC').replace(/[\p{Extended_Pictographic}\p{Emoji_Presentation}\uFE0F\u200D\s：:]/gu,'').replace(/^[-*•]+/u,'');
const labelLine = /^(\s*(?:[\p{Extended_Pictographic}\u2600-\u27BF\uFE0F\u200D]\s*){0,3}[^\n：:]{1,48}?[：:]\s*)(.*)$/u;
// Require an *immediate*, player-initiated action. Past tense, recalls and
// observations deliberately do not qualify. The same-room previous value wins.
function hasExplicitCurrentTransaction(message, action) {
  if (action !== 'send') return false;
  const text = String(message || '').trim().slice(0,800);
  if (!text) return false;
  if (/(?:如果|假設|假如|要是|曾經|之前|上次|昨天|前天|以前|回憶|記得|提到|說起|已經買|買過|买过|先前|曾買|曾买|還沒買|还没买|沒買|没买|不要買|不買|别买|不付錢|沒付|没付)/u.test(text)) return false;
  return /(?:^|[。！!\n])\s*(?:我|玩家|本人)\s*(?:現在|這次|立刻|當場|馬上|立即|此刻)\s*(?:要\s*)?(?:買下|購買|购买|買|买|支付|付錢|付款|付出|交付|賣掉|卖掉|出售|領取|领取|收下獎金|收取報酬|獲得報酬|获得报酬|兌換|兑换|存入|提領|提款|取出)/u.test(text);
}
function protectWorldFinancialStatus({current,previous,playerMessage,action}) {
  const next = String(current || '');
  const prior = String(previous || '');
  if (!next || !prior || hasExplicitCurrentTransaction(playerMessage,action)) return {status:next,restoredRows:0};
  const previousRows = new Map();
  for (const line of prior.split(/\r?\n/u)) {
    const match = line.match(labelLine);
    if (match && isFinancial(match[1])) {
      const key=keyOf(match[1]);
      if (!previousRows.has(key)) previousRows.set(key,match[2]);
    }
  }
  if (!previousRows.size) return {status:next,restoredRows:0};
  let restoredRows=0;
  const lines=next.split(/\r?\n/u).map(line=>{
    const match=line.match(labelLine);
    if (!match || !isFinancial(match[1]))return line;
    const key=keyOf(match[1]);
    const old=previousRows.get(key);
    if (old === undefined || old===match[2])return line;
    restoredRows++;
    return match[1]+old;
  });
  return {status:lines.join('\n'),restoredRows};
}
module.exports={protectWorldFinancialStatus,hasExplicitCurrentTransaction};
