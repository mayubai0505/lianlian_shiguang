'use strict';

// 從 core.js 原樣抽離：管理後台的時間轉換與台北日期計算。
function adminDateFromDynamic(value) {
  if (!value) return null;

  if (typeof value.toDate === "function") {
    return value.toDate();
  }

  if (value instanceof Date) {
    return value;
  }

  if (typeof value === "string") {
    const parsed = new Date(value);

    if (!Number.isNaN(parsed.getTime())) {
      return parsed;
    }
  }

  return null;
}

// 台灣固定 UTC+8，避免 Cloud Functions 在 UTC 下把「今天」算錯。
const TAIPEI_OFFSET_MS = 8 * 60 * 60 * 1000;
const ONE_DAY_MS = 24 * 60 * 60 * 1000;

function getTaipeiDayStart(date = new Date()) {
  const shifted = new Date(
    date.getTime() + TAIPEI_OFFSET_MS
  );

  const taipeiMidnightAsUtc = Date.UTC(
    shifted.getUTCFullYear(),
    shifted.getUTCMonth(),
    shifted.getUTCDate()
  );

  return new Date(
    taipeiMidnightAsUtc - TAIPEI_OFFSET_MS
  );
}

function getTaipeiDayIndex(date, startDate) {
  const shiftedDate = new Date(
    date.getTime() + TAIPEI_OFFSET_MS
  );

  const shiftedStart = new Date(
    startDate.getTime() + TAIPEI_OFFSET_MS
  );

  const dateDay = Date.UTC(
    shiftedDate.getUTCFullYear(),
    shiftedDate.getUTCMonth(),
    shiftedDate.getUTCDate()
  );

  const startDay = Date.UTC(
    shiftedStart.getUTCFullYear(),
    shiftedStart.getUTCMonth(),
    shiftedStart.getUTCDate()
  );

  return Math.floor(
    (dateDay - startDay) / ONE_DAY_MS
  );
}


module.exports = {adminDateFromDynamic, getTaipeiDayStart, getTaipeiDayIndex, ONE_DAY_MS};
