'use strict';
// V79: extracted date/time helpers. Preserve pre-existing calendar and formatting rules.
function createDateTimeHelpers({HttpsError}) {
const formatTimeDisplay = (date) => {
    const YYYY = date.getFullYear();
    const MM = date.getMonth() + 1;
    const DD = String(date.getDate()).padStart(2, '0');
    const rawHour = date.getHours();
    const min = String(date.getMinutes()).padStart(2, '0');
    let period = (rawHour < 6) ? "凌晨" : (rawHour < 12) ? "早上" : (rawHour === 12) ? "中午" : (rawHour < 18) ? "下午" : "晚上";
    let displayHour = (rawHour > 12) ? rawHour - 12 : (rawHour === 0) ? 12 : rawHour;
    return `${YYYY}/${MM}/${DD} ${period}${displayHour}:${min}`;
};

function parseRewardCampaignDate(value, fieldName) {
  if (!value) {
    throw new HttpsError(
      "invalid-argument",
      `缺少${fieldName}`
    );
  }

  const date = new Date(value);

  if (Number.isNaN(date.getTime())) {
    throw new HttpsError(
      "invalid-argument",
      `${fieldName}格式不正確`
    );
  }

  return date;
}

function getTaipeiUtcStartOfDay(date = new Date()) {
    const formatter = new Intl.DateTimeFormat("en-US", {
        timeZone: "Asia/Taipei",
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
    });

    const values = {};
    for (const part of formatter.formatToParts(date)) {
        if (part.type === "year" || part.type === "month" || part.type === "day") {
            values[part.type] = Number(part.value);
        }
    }

    return new Date(Date.UTC(
        values.year,
        values.month - 1,
        values.day,
        -8,
        0,
        0,
        0
    ));
}

function getTaipeiMonthStart(date = new Date(), offsetMonths = 0) {
    const dayStart = getTaipeiUtcStartOfDay(date);
    const taipeiLocal = new Date(dayStart.getTime() + 8 * 60 * 60 * 1000);
    return new Date(Date.UTC(
        taipeiLocal.getUTCFullYear(),
        taipeiLocal.getUTCMonth() + offsetMonths,
        1,
        -8,
        0,
        0,
        0
    ));
}

return {formatTimeDisplay,parseRewardCampaignDate,getTaipeiUtcStartOfDay,getTaipeiMonthStart};
}
module.exports={createDateTimeHelpers};
