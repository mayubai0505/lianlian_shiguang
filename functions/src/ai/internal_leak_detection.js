'use strict';
// Original roleplay internal analysis leak guard, unchanged.
function isRoleplayInternalLeak(value) {
    const text = String(value || "");
    return /["「]?userRequestSummary["」]?\s*[:：]/i.test(text) ||
        /["「]?reasoning_content["」]?\s*[:：]/i.test(text) ||
        /["「]?於封禁狀態["」]?\s*[:：]/.test(text) ||
        /["「]?用戶性別未設定["」]?\s*[,，}]/.test(text) ||
        (/(回顧系統提示|檢查之前的系統提示|上一輪的系統提示|現在開始正式寫作)/.test(text) &&
         /(我需要|我注意到|系統提示|AI系統|我決定)/.test(text));
}

module.exports = {isRoleplayInternalLeak};
