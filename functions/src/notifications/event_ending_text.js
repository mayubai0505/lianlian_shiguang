'use strict';

function createEventEndingText({normalizeNotificationLocale}) {
function getEventEndingNotificationText(
    locale,
    {
        eventName = "期間限定活動",
        currencyName = "活動貨幣",
        stage = "3d",
    } = {}
) {
    const normalized =
        normalizeNotificationLocale(locale);

    const isOneDay =
        stage === "1d";

    const texts = {
        zh_Hant: {
            title: isOneDay
                ? "最後一天啦！"
                : "活動即將結束",
            body: isOneDay
                ? `「${eventName}」即將結束，別忘了使用剩下的${currencyName}。`
                : `「${eventName}」只剩 3 天，還有想兌換的限定獎勵嗎？`,
        },
        zh_Hans: {
            title: isOneDay
                ? "最后一天啦！"
                : "活动即将结束",
            body: isOneDay
                ? `“${eventName}”即将结束，别忘了使用剩下的${currencyName}。`
                : `“${eventName}”只剩 3 天，还有想兑换的限定奖励吗？`,
        },
        en: {
            title: isOneDay
                ? "Last day!"
                : "Event ending soon",
            body: isOneDay
                ? `"${eventName}" is ending soon. Don’t forget to use your remaining ${currencyName}.`
                : `"${eventName}" has only 3 days left. Don’t miss the limited rewards.`,
        },
        ja: {
            title: isOneDay
                ? "いよいよ最終日！"
                : "イベント終了間近",
            body: isOneDay
                ? `「${eventName}」はまもなく終了します。残りの${currencyName}をお忘れなく。`
                : `「${eventName}」はあと3日。限定報酬の交換をお忘れなく。`,
        },
        ko: {
            title: isOneDay
                ? "마지막 날이에요!"
                : "이벤트 종료 임박",
            body: isOneDay
                ? `「${eventName}」 이벤트가 곧 종료돼요. 남은 ${currencyName}을 잊지 말고 사용해 주세요.`
                : `「${eventName}」 이벤트가 3일 남았어요. 한정 보상을 놓치지 마세요.`,
        },
    };

    return texts[normalized] || texts.en;
}

return {getEventEndingNotificationText};
}
module.exports = {createEventEndingText};
