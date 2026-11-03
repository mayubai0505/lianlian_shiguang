'use strict';
// V76: Existing chat/mailbox push handlers and legacy badge reset, moved without business-logic edits.
function createChatMessageNotificationHandler({db, sendToUserDevices}) {
  return async (event) => {
    const snap = event.data;
    if (!snap) return;

    const messageData = snap.data();
    const sessionId = event.params.sessionId;

    // 確定是 AI 說的話才發通知
    if (messageData.sender !== "ai" && messageData.role !== "assistant") {
        return null;
    }

    try {
        // 1. 去 session 拿 userId
        const sessionDoc = await db
            .collection('artifacts').doc('lianlianshiguang')
            .collection('chat_sessions').doc(sessionId).get();

        if (!sessionDoc.exists) return null;
        const sessionData = sessionDoc.data();
        const userId = sessionData.userId;
// 計算玩家目前 AI 未讀訊息數量
const unreadSnapshot = await db
    .collection("artifacts")
    .doc("lianlianshiguang")
    .collection("chat_sessions")
    .where("userId", "==", userId)
    .get();

let unreadCount = 0;

for (const doc of unreadSnapshot.docs) {
    const messagesSnapshot = await doc.ref
        .collection("messages")
        .where("role", "==", "assistant")
        .where("isUnread", "==", true)
        .get();

    unreadCount += messagesSnapshot.size;
}
        let previewText = "你收到了一則新訊息 ✨";
        // 🌟 優先從 cleanDisplayText (text 欄位) 拿資料，如果沒有才去解析 content
        const rawContent = messageData.text || messageData.content || "";

        try {
            // 🎯 使用正則表達式「吸塵器」，不管內容多亂，只吸 response 裡的對白
            const regex = /"response"\s*:\s*"((?:[^"\\]|\\.)*)"/g;
            const matches = [...rawContent.matchAll(regex)];

            if (matches.length > 0) {
                // 把所有片段接在一起，並處理換行
                previewText = matches.map(m => m[1]).join(" ")
                    .replace(/\\n/g, " ")
                    .replace(/\\"/g, '"');
            } else {
                // 如果完全不含 JSON 格式，就直接用原始文字
                previewText = rawContent;
            }
        } catch (e) {
            previewText = "（發送了一則訊息）";
        }

        // 限制通知長度
        if (previewText.length > 40) previewText = previewText.substring(0, 40) + "...";

        // ==========================================
        // 🔎 【修正 2：對準路徑抓角色姓名與頭像】
        // ==========================================
        const charId = messageData.characterId || sessionData.characterId;

        // 🌟 初始化安全的空箱子：預設名稱與空圖片
        let charName = '你的愛人';
        let charAvatar = null;

        try {
            // ❌ 原本錯誤路徑：.collection('characters')
            // ✅ 【關鍵修正】：對準真正的角色檔案大樓
            const charDoc = await db
                .collection('artifacts').doc('lianlianshiguang')
                .collection('public_characters').doc(String(charId)).get();

            if (charDoc.exists) {
                const charData = charDoc.data();
                // 🌟 【修正】：將抓到的真正名字和頭像路徑裝進箱子
                charName = charData.name || charName;
                charAvatar = charData.avatarPath;
            }
        } catch (error) {
            console.error("查無此人資料:", error);
        }

        // ==========================================
        // 🚀 【修正 3：將正確的名字與圖片塞入 Payload】
        // ==========================================
        const safeNotificationImageUrl =
            typeof charAvatar === "string" &&
            /^https?:\/\//i.test(charAvatar.trim())
                ? charAvatar.trim()
                : "";

        const payload = {
            notification: {
                title: charName,
                body: previewText,
                ...(safeNotificationImageUrl
                    ? { imageUrl: safeNotificationImageUrl }
                    : {}),
            },
            data: {
                type: 'chat',
                characterId: String(charId || ""),
                sessionId: String(sessionId || ""),
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
            android: {
                priority: "high",
                notification: {
                    channelId: "high_importance_channel",
                    sound: "default",
                    defaultVibrateTimings: true,
                    defaultLightSettings: true
                }
            },
            apns: {
                payload: {
                    aps: {
                        sound: "default",
                    }
                }
            }
        };

        console.log(`叮咚！準備發送推播給用戶: ${userId}，來自角色的通知: ${charName}`);
        return await sendToUserDevices(userId, payload);
    } catch (error) {
        console.error("推播接線生發生錯誤:", error);
    }
};
}

function createMailboxNotificationHandler({sendToUserDevices}) {
  return async (event) => {
    const snap = event.data;
    if (!snap) return null;

    const mailData = snap.data();
    const userId = event.params.userId;
    const mailId = event.params.mailId;

    const payload = {
        notification: {
            title: mailData.title || "您有新通知！",
            body: mailData.body || "點擊查看詳細內容 💌",
        },
        data: {
            type: String(mailData.type || "system"),
            postId: String(mailData.postId || ""),
            mailId: String(mailId || ""),
            click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        android: {
            priority: "high",
            notification: {
                channelId: "high_importance_channel",
                sound: "default",
                defaultVibrateTimings: true,
            },
        },
        apns: {
            payload: {
                aps: {
                    sound: "default",
                    badge: 0, // 只清除桌面舊徽章，不依信箱未讀數新增 Badge。
                },
            },
        },
    };

    try {
        await sendToUserDevices(userId, payload);
        console.log(`✅ 信箱推播已送出給 ${userId}，類型: ${mailData.type}`);
    } catch (error) {
        console.error("❌ 郵差推播發送失敗:", error);
    }

    return null;
};
}

function createSyncNotificationBadgeHandler({sendToUserDevices, HttpsError}) {
  return async (request) => {
        const userId = request.auth?.uid;
        if (!userId) {
            throw new HttpsError("unauthenticated", "請先登入");
        }

        // 若舊版客戶端還在呼叫這個函式，以靜默推播將歷史 iOS Badge 歸零。
        await sendToUserDevices(userId, {
            data: { type: "badge_sync", unreadCount: "0" },
            android: { priority: "normal" },
            apns: {
                headers: {
                    "apns-priority": "5",
                    "apns-push-type": "background",
                },
                payload: { aps: { "content-available": 1, badge: 0 } },
            },
        });
        return { success: true, unreadCount: 0 };
    };
}

module.exports = {createChatMessageNotificationHandler,createMailboxNotificationHandler,createSyncNotificationBadgeHandler};
