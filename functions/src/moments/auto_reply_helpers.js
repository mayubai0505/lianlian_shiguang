'use strict';
// V88: pure helpers moved from core.js without changing their implementations.

function momentTimestampToMillis(value) {
    if (!value) return 0;
    if (typeof value.toMillis === "function") return value.toMillis();
    if (value instanceof Date) return value.getTime();
    const parsed = new Date(value).getTime();
    return Number.isFinite(parsed) ? parsed : 0;
}

function sanitizeMomentReplyId(value) {
    return String(value || "")
        .replace(/[^a-zA-Z0-9_-]/g, "_")
        .slice(0, 180);
}

function extractJsonObjectText(text) {
    if (!text) return "";

    let cleaned = text.trim();

    // 去掉 ```json ``` 包裝
    cleaned = cleaned
        .replace(/^```json\s*/i, "")
        .replace(/^```\s*/i, "")
        .replace(/```$/i, "")
        .trim();

    const start = cleaned.indexOf("{");
    const end = cleaned.lastIndexOf("}");

    if (start >= 0 && end > start) {
        return cleaned.substring(start, end + 1);
    }

    return cleaned;
}

function hasPromptLeak(text) {
    if (!text) return true;

    const markers = [
        "任務指令",
        "這次的目標是",
        "這次的發文情境主題",
        "情境主題是",
        "最高防重複警告",
        "你上一次的發文內容",
        "請確保這次的貼文",
        "完全不同",
        "禁止使用 AI",
        "AI 機器人腔調",
        "來，發文吧",
        "現在請發一篇貼文",
        "30~80 字",
        "30-80 字",
        "Threads 風格",
        "內心獨白或生活動態"
    ];

    return markers.some((marker) => text.includes(marker));
}

module.exports = {momentTimestampToMillis, sanitizeMomentReplyId, extractJsonObjectText, hasPromptLeak};
