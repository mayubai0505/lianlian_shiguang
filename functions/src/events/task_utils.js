'use strict';

// Existing event task behavior moved verbatim from core.js.
function createEventTaskUtils({db, APP_ID}) {
function normalizeReusableEventTaskDefinition(taskId, data = {}) {
    const title = String(data.title || "").trim();
    const explicitType = String(data.taskType || "").trim();

    let taskType = explicitType || "any_chat";

    // 舊測試資料相容：尚未有 taskType 時，依任務名稱推斷。
    if (!explicitType) {
        if (/沉浸/.test(title)) taskType = "mode_immersive";
        else if (/共鳴/.test(title)) taskType = "mode_resonance";
        else if (/劇情/.test(title)) taskType = "mode_story";
        else if (/閒聊/.test(title)) taskType = "mode_gemini";
        else if (/日常/.test(title)) taskType = "mode_daily";
        else if (/禮物/.test(title)) taskType = "gift";
        else if (/互動/.test(title)) taskType = "interaction";
        else taskType = "any_chat";
    }

    let target = Number(data.target || 0);

    // 舊測試資料相容：例如「聊天 5 次」會抓到 5。
    if (!Number.isFinite(target) || target <= 0) {
        const titleNumber = title.match(/(\d+)/);
        target = titleNumber ? Number(titleNumber[1]) : 1;
    }

    target = Math.max(1, Math.trunc(target));

    const rewardAmount = Math.max(
        0,
        Math.trunc(Number(data.rewardAmount || 0))
    );

    return {
        taskId,
        taskType,
        target,
        rewardAmount,
        title,
    };
}

function reusableEventTaskMatchesAction(taskType, action) {
    const billingType = String(action.billingType || "chat");
    const chatMode = String(action.chatMode || "");

    switch (taskType) {
        case "any_chat":
            return billingType === "chat";
        case "mode_gemini":
            return billingType === "chat" && chatMode === "gemini";
        case "mode_daily":
            return billingType === "chat" && chatMode === "daily";
        case "mode_story":
            return billingType === "chat" && chatMode === "story";
        case "mode_immersive":
            return billingType === "chat" && chatMode === "immersive";
        case "mode_resonance":
            return billingType === "chat" && chatMode === "resonance";
        case "interaction":
            return billingType === "interaction";
        case "gift":
            return billingType === "gift";
        default:
            return false;
    }
}

function reusableEventIsRunning(eventData, now = new Date()) {
    if (eventData?.isActive !== true) return false;

    const startAt = eventData?.startAt?.toDate?.();
    const endAt = eventData?.endAt?.toDate?.();

    if (startAt && now < startAt) return false;
    if (endAt && now > endAt) return false;

    return true;
}

function reusableEventProgressRef(userId, eventId) {
    return db
        .collection("artifacts")
        .doc(APP_ID)
        .collection("event_progress")
        .doc(userId)
        .collection("events")
        .doc(eventId);
}


return {normalizeReusableEventTaskDefinition, reusableEventTaskMatchesAction, reusableEventIsRunning, reusableEventProgressRef};
}

module.exports = {createEventTaskUtils};
