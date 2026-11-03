'use strict';
// V85: preserve the two independent Taiwan-day range implementations for
// flower and IAP revenue dashboards; only inject the existing Timestamp class.
function createAdminDailyRanges({Timestamp}) {
  function getFlowerStatsTaipeiDayRange(
      date = new Date()
  ) {
      const formatter =
          new Intl.DateTimeFormat(
              "en-CA",
              {
                  timeZone: "Asia/Taipei",
                  year: "numeric",
                  month: "2-digit",
                  day: "2-digit",
              }
          );

      const parts =
          formatter.formatToParts(date);

      const values = {};

      for (const part of parts) {
          if (
              part.type === "year" ||
              part.type === "month" ||
              part.type === "day"
          ) {
              values[part.type] =
                  Number(part.value);
          }
      }

      // 台北 UTC+8
      // 台北 00:00 = UTC 前一天 16:00
      const startUtc =
          new Date(
              Date.UTC(
                  values.year,
                  values.month - 1,
                  values.day,
                  -8,
                  0,
                  0,
                  0
              )
          );

      const endUtc =
          new Date(
              startUtc.getTime() +
              24 * 60 * 60 * 1000
          );

      return {
          start:
              Timestamp.fromDate(startUtc),

          end:
              Timestamp.fromDate(endUtc),
      };
  }

  function getRevenueTaipeiDayRange(
      date = new Date()
  ) {
      const formatter =
          new Intl.DateTimeFormat(
              "en-US",
              {
                  timeZone: "Asia/Taipei",
                  year: "numeric",
                  month: "2-digit",
                  day: "2-digit",
              }
          );

      const parts =
          formatter.formatToParts(date);

      const values = {};

      for (const part of parts) {
          if (
              part.type === "year" ||
              part.type === "month" ||
              part.type === "day"
          ) {
              values[part.type] =
                  Number(part.value);
          }
      }

      // 台灣時間 00:00
      // 換算成 UTC = 前一天 16:00
      const startUtc =
          new Date(
              Date.UTC(
                  values.year,
                  values.month - 1,
                  values.day,
                  -8,
                  0,
                  0,
                  0
              )
          );

      const endUtc =
          new Date(
              startUtc.getTime() +
              24 * 60 * 60 * 1000
          );

      return {
          start:
              Timestamp.fromDate(startUtc),

          end:
              Timestamp.fromDate(endUtc),
      };
  }

  return {getFlowerStatsTaipeiDayRange,getRevenueTaipeiDayRange};
}
module.exports={createAdminDailyRanges};
