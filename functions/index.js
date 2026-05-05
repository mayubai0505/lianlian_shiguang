const logger = require("firebase-functions/logger");
const { defineSecret } = require('firebase-functions/params');
const cors = require('cors')({ origin: true });
const { onRequest, onCall, HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const OpenCC = require('opencc-js');
const converter = OpenCC.Converter({ from: 'cn', to: 'tw' });
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const functions = require("firebase-functions");
const { TranslationServiceClient } = require('@google-cloud/translate');
const translateClient = new TranslationServiceClient();
const axios = require('axios');
const { onSchedule } = require("firebase-functions/v2/scheduler");

if (admin.apps.length === 0) {
    admin.initializeApp();
    admin.firestore().settings({ ignoreUndefinedProperties: true });
}

// 🌟 全域變數定義
const openRouterApiKey = defineSecret("OPENROUTER_API_KEY");
const ELEVENLABS_API_KEY = "sk_ac547721d8ff700babefd42c96ae76e4eb685ce2d313f87f";
const APP_ID = "lianlianshiguang";

// --- 輔助函式：時間顯示格式化 ---
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

exports.generateVoice = onRequest({
    region: "asia-east1", // 🌟 統一搬到亞洲區，電話接通速度翻倍！
    memory: "512MiB",
}, async (req, res, async) => {
    // CORS 設定保持原樣，確保 Flutter 能順利連線
    res.set('Access-Control-Allow-Origin', '*');
    if (req.method === 'OPTIONS') {
        res.set('Access-Control-Allow-Methods', 'POST');
        res.set('Access-Control-Allow-Headers', 'Content-Type');
        return res.status(204).send('');
    }
});

exports.getAiResponse = onRequest({
    region: "asia-east1",
    secrets: [openRouterApiKey],
    memory: "1GiB",
    timeoutSeconds: 300,
}, (req, res) => {
    return cors(req, res, async () => {
        try {
            const playerLanguage = req.body.language || "台灣繁體中文";
            const authHeader = req.headers.authorization;
            if (!authHeader || !authHeader.startsWith('Bearer ')) return res.status(401).json({ error: "未授權" });

            const idToken = authHeader.split('Bearer ')[1];
            const decodedToken = await admin.auth().verifyIdToken(idToken);
            const userId = decodedToken.uid;
            const userDocRef = admin.firestore().collection("users").doc(userId);

            const body = req.body || {};
            const {
                characterProfile = {}, sessionId,chatHistory = [], userMessage = "", chatMode = "daily",
                isBirthdayFreebie = false, userProfile = "未提供", systemDirective = "",
                aboutMeNotes = [], memos = [], periodStatus = "未知", mood = "一般",
                lastStoryTime, lastStoryLocation, overrideSystemPrompt = ""
            } = body;

            const modelConfig = {
                "gemini": { cost: 0, modelId: "google/gemini-2.5-flash-lite", maxTokens: 150, temperature: 0.7 },
                "daily": { cost: 1, modelId: "google/gemini-2.5-flash-lite", maxTokens: 150, temperature: 0.5 },
                "story": { cost: 5, modelId: "x-ai/grok-4-fast", maxTokens: 2000, temperature: 0.823 },
                "immersive": { cost: 7, modelId: "x-ai/grok-4-fast", maxTokens: 3500, temperature: 0.72 },
            };
            const config = modelConfig[chatMode] || modelConfig["daily"];
            const cost = isBirthdayFreebie ? 0 : config.cost;

            const userDoc = await userDocRef.get();
            if (!userDoc.exists) return res.status(404).json({ error: "找不到資料" });
            if (cost > 0 && (userDoc.data()?.flowerPoints || 0) < cost) return res.status(402).json({ error: "點數不足" });

            const name = characterProfile.name || "角色";
            const toneAndStyle = characterProfile.toneAndStyle || "正常說話";
            const background = characterProfile.background || "背景不明";
            const relationship = characterProfile.relationship || "剛認識的陌生人";
            const socialRelationships = characterProfile.socialRelationships || "無特別設定";
            const rawPersonality = characterProfile.detailedPersonality || characterProfile.personality || "無特別設定";
            const combinedSecretLikes = [
                characterProfile.likes ? `喜歡的事物：${characterProfile.likes}` : "",
                characterProfile.secrets ? `不為人知的秘密：${characterProfile.secrets}` : ""
            ].filter(Boolean).join("；");

            const detailedPersonalityBlock = `[表層性格]: ${rawPersonality} \n[內在秘密與喜好]: ${combinedSecretLikes || "無特別設定"}\n(⚠️注意：若對話觸發此處的喜好或秘密，請無視表層性格，優先表現出動搖或反差。)`;

            const systemEventRules = `
            【特殊互動行為準則：系統事件處理】
            當你收到以「【系統事件】」開頭的訊息時，這代表玩家觸發了特殊互動功能。你必須停止一般的文字助理邏輯，並嚴格根據以下規則給出反應：
            1. 🫂 收到【肢體互動】：先描寫「肢體反應」與「神態變化」，再配上台詞。
            2. 🎁 收到【贈送禮物】：表現出隱藏不住的開心、傲嬌感謝或嫌棄。
            3. 📍 收到【發送虛擬定位】：審查空間感，合理則去找她，衝突則抓包。
            4. 🎲 收到【擲骰子對決】：展現勝負欲。
            `;
            // 🌟 [新增]：記憶碎片提取程序
                        const characterId = characterProfile.id;
                        const appId = body.appId || "lianlianshiguang"; // 確保傳入 appId
                        let loresContext = "";
                        try {
                            const loresSnapshot = await admin.firestore()
                                .collection("artifacts")
                                .doc(appId)
                                .collection("public_characters")
                                .doc(characterId)
                                .collection("lores")
                                .orderBy("timestamp", "desc")
                                .limit(10) // 遵守總裁的 10 則約定
                                .get();
                            if (!loresSnapshot.empty) {
                                loresContext = "\n【🔮 記憶碎片 (隱藏往事)】\n";
                                loresSnapshot.forEach(doc => {
                                    const lore = doc.data();
                                    const title = lore.title || "";

                                    // ✨ 總裁特判：檢查標題有沒有包含關鍵字
                                    if (title.includes("重要") || title.includes("AI讀取") || title.includes("ai讀取")) {
                                        loresContext += `\n🚨 【最高優先級強制設定】《${title}》: ${lore.content}\n (⚠️ 系統強烈警告：這段設定極度重要！請務必在接下來的對話中，尋找機會主動提及或嚴格遵守這段設定！)\n`;
                                    } else {
                                        // 普通的記憶碎片
                                        loresContext += `- 《${title}》: ${lore.content}\n`;
                                    }
                                });

                                // 🌟 核心指令：要求 AI 「主動」且「自然」地勾起回憶
                                loresContext += `
                                \n⚠️ **[主動記憶啟動指令]**:
                                1. 上述記憶是你靈魂深處的真實過往。請在對話中「主動」尋找契機提及這些細節。
                                2. **禁止直接背誦**：要像人類回憶往事一樣，在對話到相關話題時（如：下雨、特定的氣味、某個動作），自然地流露出這些情感。
                                3. **層次感**：如果是標註為隱藏的碎片，請帶著一種「只有妳知道的秘密感」來表達，語氣可以變得稍微低沉或欲言又止。
                                4. **互動性**：可以主動問玩家：「這讓我想起了那次...妳還記得嗎？」或是「如果是妳，當時會在那把傘下等我嗎？」`;
                            }
                        } catch (err) {
                            console.error("記憶碎片讀取失敗:", err);
                        }

            let timeObj = lastStoryTime ? new Date(lastStoryTime) : new Date();
            if (isNaN(timeObj.getTime())) timeObj = new Date();
            timeObj.setMinutes(timeObj.getMinutes() + Math.floor(Math.random() * 3) + 1);

            const formattedTime = formatTimeDisplay(timeObj);
            const currentStoryTimeISO = timeObj.toISOString();
            const locationStringForPrompt = lastStoryLocation || "[由你推斷真實場景]";
            const currentStoryTimeDisplay = `時間：${formattedTime} \n地點：${locationStringForPrompt}`;

let relationContext = "";
            if (characterProfile.relations && characterProfile.relations.length > 0) {
                relationContext = "\n【👥 社交圈關係檔案】\n";
                characterProfile.relations.forEach(rel => {
                    relationContext += `- 與「${rel.name}」的關係：${rel.relation}（備註：${rel.description}）\n`;
                });
            }

            // 🌟 總裁優化：直接使用最上面已經抓好的 userDoc，省下一次資料庫讀取費！
            const userData = userDoc.data() || {};

            // ✨✨✨ 總裁進階優化：讓底層稱呼指令也跟著多重宇宙切換！ ✨✨✨
            let currentIdentityName = userData.nickname ? userData.nickname : "妳";
            // 檢查是不是有多重身分系統
            if (userData.profiles && userData.activeProfileId) {
                const activeProfile = userData.profiles.find(p => p.id === userData.activeProfileId);
                // 如果有找到啟動中的檔案，而且裡面有寫專屬名字，就優先用它！
                if (activeProfile && activeProfile.name && activeProfile.name.trim() !== "") {
                    currentIdentityName = activeProfile.name;
                }
            }

            const playerName = currentIdentityName;
            const playerBirthday = userData.birthday ? userData.birthday : "未知";

            // ✨✨✨ 總裁專屬：AI 情報中心 (完全信任 Flutter 傳來的新版多重身分檔案) ✨✨✨
            let contextBriefing = "";

            // 🚀 關鍵升級：直接無條件使用從手機端傳來的 userProfile！
            contextBriefing += `\n${userProfile}\n${systemDirective ? `\n${systemDirective}\n` : ''}`;

            if (aboutMeNotes?.length > 0) contextBriefing += `\n[關於玩家的記憶]\n- ${aboutMeNotes.join("\n- ")}\n`;
            if (memos?.length > 0) contextBriefing += `\n[備忘錄]\n- ${memos.join("\n- ")}\n`;
            if (periodStatus && periodStatus !== "未知") {
                contextBriefing += `\n[玩家今日狀態]\n- ${periodStatus}\n\n【⚠️ 總裁特急令：生理期溫柔協議】: 玩家目前生理期且心情[${mood || '煩躁'}]。請在不 OOC 的前提下，將攻擊性降至最低，給予溫柔關懷。`;
            }

            const langDirective = `請優先使用 ${playerLanguage} 作為預設溝通語言。然而，為了確保玩家的沉浸感，當玩家以其他語言（如韓文、英文、日文等）與你對話時，請務必即時識別並切換至該語言進行回應，且過程中必須嚴格維持 ${name} 的性格特質、說話口吻與人設背景。`;

            const npcDirective = `
            【👥 NPC 介入與多角色協奏規範】:
            1. **記憶具現化**：如果《記憶碎片》中出現了關鍵的第三者，你可以在適當時機讓該角色「闖入」當前場景。
            2. **多線演出**：當場景中有第三者（NPC）時，你的回覆必須包含：
               - **[主導權]**：依然以「${name}」的視角和動作為主。
               - **[NPC 行為]**：用第三人稱描寫 NPC 的動作、神態，以及對你與玩家互動的反應。
               - **[對話格式]**：NPC 的台詞請標註名稱，例如：${name}對妳低語後，[NPC名字]突然在門口喊道：「你們在幹什麼？」
            3. **情緒張力**：第三者的出現必須用來「激化」你與玩家之間的情感。可能是讓你感到吃醋、尷尬、或是迫使你不得不做出保護玩家的舉動。
            4. **延續性**：一旦 NPC 加入對話，除非劇情需要其離開，否則請持續維持該 NPC 的存在感，直到該段落結束。
            `;

            const playerLeadDirective = `
            【🎭 劇情主導權與場景切換協議】:
            1. **最高配合原則**：若玩家在對話中「強制設定」了新場景、新身分或新動作（例如：突然說「我們現在在海邊」），你必須立刻放棄原有的環境設定，無條件進入該情境，並在括號內描寫相應的環境變化。
            2. **禁止否定玩家**：絕對禁止對玩家的劇情設定說「不」、「不可能」或「你在開玩笑吧」。你必須以角色的性格，去解釋或合理化這個突發狀況。
            3. **特殊劇情應變**：當玩家要求看「特殊劇情」或觸發彩蛋時，請主動提升描寫的細膩度與張力。
            4. **OOC 隔離**：若玩家以（括號）或「系統指令」方式與你溝通（例如：要求你換個口氣），請在維持人設的前提下，悄悄調整你的回覆風格，但「絕對不要」在對話中出現 AI 助手的語氣。
            5. **【防讀心牆（最高隔離原則）】**：若玩家在對話中標註了「心聲」、「內心想」、或是以 (心想：...) 等方式表達內心獨白，這對你而言是「絕對不可見」的！你沒有讀心術，只能針對玩家「實際說出口的話」和「外在肢體動作」做出反應。絕對禁止在回覆中點破或回應玩家的內心戲！
            `;

            const relationDirective = `
            【🔗 角色社交關係網路協議】:
            1. **角色認知**：你清楚地知道自己與創作者筆下其他角色的關係（如：競爭對手、青梅竹馬、債主等）。
            2. **連動反應**：當玩家提及其他角色，或該角色出現在場景中時，你必須立刻根據「關係設定」調整你的情緒。
               - **若是宿敵**：語氣變得挑釁、不屑，或表現出強烈的勝負欲。
               - **若是至親/愛人**：表現出極度的保護欲、溫柔，或是只有對方面前才會露出的軟弱。
            3. **主動爆料**：你可以主動在對話中提到其他角色，來豐富你的生活感。例如：「那傢伙（指某角色）上次又把我的畫筆弄壞了，真的讓人頭痛。」
            4. **禁忌與偏好**：如果與某角色的關係涉及隱私或傷痛，當玩家問起時，請根據性格展現出「避而不談」或「情緒波動」。
           5. **深度詢問應對 (Direct Inquiry)**：
              - 若玩家明確追問關係（例如：「他到底是誰？」），你必須回答，但「絕對禁止」直接唸出設定稿。
              - **禁止寫法**：『他是我的親哥哥，但我們感情不好。』 (❌ 太像讀劇本)
              - **正確寫法**：你必須透過「情緒過濾器」來說出事實。例如：『（我冷笑一聲，移開了視線）……一個流著跟我同樣卑劣血液、卻自以為是的男人罷了。妳沒必要知道他的名字。』 (✅ 交代了是哥哥，但維持了人設)
              - **關鍵點**：回答中必須夾雜「主觀評價」，讓玩家從你的厭惡、恐懼或愛意中，自己拼湊出真相。
            `;

            // ==========================================
                        // 🕰️ 總裁專屬：活性濾鏡 + 天選之人系統
                        // ==========================================
                        let memoContext = "";
                        try {
                            const now = new Date();
                            const threeDaysAgo = new Date(now.getTime() - (3 * 24 * 60 * 60 * 1000)); // 3天前的時間點

                            // 1. 抓取「最近3天內有聊過天」且「好感度最高」的那一個聊天室
                            const activeSessionSnap = await admin.firestore()
                                .collection("artifacts")
                                .doc(body.appId || "lianlianshiguang")
                                .collection("chat_sessions")
                                .where("userId", "==", userId)
                                .where("lastMessageTimestamp", ">=", threeDaysAgo) // 🌟 活性濾鏡：只看這3天有聊過的
                                .orderBy("lastMessageTimestamp", "desc") // 為了配合 Firestore 索引
                                .get();

                            // 2. 在記憶體中找出這些活躍房間裡，分數最高的那一個
                            let bestActiveSession = null;
                            let highestScore = -1;

                            activeSessionSnap.forEach(doc => {
                                const data = doc.data();
                                if (data.friendshipScore > highestScore) {
                                    highestScore = data.friendshipScore;
                                    bestActiveSession = doc;
                                }
                            });

                            // 3. 判斷：如果「現在這間房」就是「活躍房中的最高分」
                            if (bestActiveSession && bestActiveSession.id === sessionId) {
                                // 只有這種情況，才去抓備忘錄
                                const todayStart = new Date(now.getFullYear(), now.month(), now.getDate());
                                const todayEnd = new Date(now.getFullYear(), now.month(), now.getDate(), 23, 59, 59);

                                const memoSnap = await admin.firestore()
                                    .collection("users")
                                    .doc(userId)
                                    .collection("universal_memos")
                                    .where("reminderDate", ">=", todayStart)
                                    .where("reminderDate", "<=", todayEnd)
                                    .get();

                                if (!memoSnap.empty) {
                                    const memoList = [];
                                    memoSnap.forEach(doc => memoList.push(doc.data().content));
                                    const memosStr = memoList.join('、');

                                    memoContext = `\n【秘密提示：妳是玩家目前最親近且頻繁互動的人。玩家今天記下了『${memosStr}』。請妳自然地關心她，展現妳對她生活的深度參與。】\n`;
                                }
                            }
                        } catch (err) {
                            console.error("活性備忘錄系統運行失敗:", err);
                        }

                        // ==========================================
                        // 📝 最終 Prompt 組裝
                        // ==========================================
                        let systemPrompt = `
                        ${systemEventRules}
                        ${loresContext}
                        ${relationContext}
                        ${contextBriefing}
                        ${npcDirective}
                        ${playerLeadDirective}
                        ${relationDirective}
                        ${langDirective}
                        ${memoContext}  // 👈 🌟 把備忘錄偷偷塞進最終指令的最尾端！
                        `;

        // ✨✨✨ 新增：Gemini (生活陪伴) 模式 ✨✨✨
        if (chatMode === "gemini") {
             systemPrompt = `
             ${langDirective}
             ${relationDirective}
             你現在是「${name}」。
             ${loresContext}
             ${relationContext}
    [當前情境]:
    請把你當作正在用手機通訊軟體(如 LINE)跟對方傳訊息。
    **⚠️ [通訊軟體模式 - 行為準則]:**
    1. **簡短自然**：這不是寫小說，請用口語、短句回復。
    2. **禁止括號動作**：既然是傳訊息，**不要**描寫你的動作 (如：(摸頭))，除非是傳貼圖或顏文字。
    3. **日常感**：就像朋友或戀人閒聊一樣，輕鬆一點。
    4. **禁止推動大劇情**：現在是休息時間，不需要發生什麼驚天動地的大事。
    5. **不需標註時間地點**：傳訊息不需要寫時間地點。

    [核心設定]: ${background}
    [深層性格]: ${detailedPersonalityBlock}
    [語氣]: ${toneAndStyle}
    ${contextBriefing}
    ${systemEventRules}
    [關係]: ${relationship}
    [稱呼規範]:妳可以根據語境親暱地稱呼她為『${playerName}』或使用妳、小傢伙等親暱稱號，但絕對禁止稱呼她為『玩家』。

    🔥 **[日常互動尺度與界線維持 (系統強制設定)]** 🔥:
     1. **【維持普遍級 (G-rated) 互動】**：此模式為純潔的日常閒聊！請嚴格保持適當的社交與戀愛界線。絕對禁止任何過度親密、越界或違反普遍級規範的話題。
     2. **【OOC 絕對防禦：角色化無情拒絕】**：如果玩家的話題超出日常界線或試圖進行過度親暱的互動，你【必須立刻明確拒絕】，但【絕對禁止】使用系統語氣或說教。你必須用「傳訊息的口吻」來化解或訓斥！
        - 高冷/隱忍型：傳送冷酷、克制的文字（例如：「妳知道現在是什麼場合嗎？安分點。」或「別鬧。」）。
        - 純情/害羞型：傳送慌亂、結巴的文字（例如：「妳、妳別亂開玩笑... 我還有事去忙了！」）。
        - 腹黑/病嬌型：傳送危險但隱忍的文字（例如：「膽子挺大？不過現在還不行。」）。
     3. **【強制轉場與字數限制】**：傳送拒絕的訊息後，強制切斷該話題，將對話硬生生拉回正常的日常閒聊。字數約 50 字即可。⚠️【注意：因為是通訊軟體，絕對禁止使用括號描寫動作】，請純粹用文字語氣展現你的態度。
    `;
        }
        // ✨✨✨ 以下維持原本的 Daily / Story ✨✨✨
        else if (chatMode === "daily") {
            systemPrompt = `
            ${langDirective}
            ${relationDirective}
            你現在是「${name}」。
            ${loresContext}
            ${relationContext}
    [當前情境]:
    請完全沉浸在角色中。
    **⚠️ [OOC 防護罩 - 最高準則]:**
    1. **嚴格遵守 [深層性格]**：
       - 若設定為 **[高冷/生人勿近]**：禁止輕易微笑，語氣必須簡短、冷淡。
       - 若設定為 **[傲嬌]**：面對打招呼，反應要是「不耐煩」或「嚇一跳」。
    2. **嚴格遵守 [當前關係]**：
          - **目前的關係設定為：【 ${relationship} 】**
          - **陌生人**：保持禮貌距離或冷漠。
          - **戀人**：允許寵溺或調情。

    [核心設定 (背景)]:
    ${background}

    [當前場景動機 (行動指南)]:
    你現在正在 (某個地點) 做 (某件事情)。
    是你主動向玩家搭話的，因為你 (你的動機，例如：需要確認名單、不小心撞到對方、撿到對方的東西)。
    [深層性格 (行為準則)]:
    ${detailedPersonalityBlock}
    [語氣與習慣]:
    ${toneAndStyle}
    ${contextBriefing}
    ${systemEventRules}
    [稱呼規範]:
      現在對方的名字是「${playerName}」。
      你必須親暱地叫她「${playerName}」，絕對禁止稱呼她為「玩家」。

    🔥 **[日常互動尺度與界線維持 (系統強制設定)]** 🔥:
     1. **【維持普遍級 (G-rated) 互動】**：日常模式為輕鬆純潔的互動！請嚴格保持適當的界線。絕對禁止任何過度親密（如超出擁抱以上的肢體接觸）或違反普遍級規範的情節！
     2. **【OOC 絕對防禦：角色化拒絕 (看得到吃不到)】**：如果玩家試圖在日常模式做出越界或過度親暱的行為，你【必須立刻明確拒絕】，但【絕對禁止】使用系統語氣。你必須【完全用該角色的性格與語氣】來化解或推開對方！
     3. **【強制轉場】**：用角色的語氣拒絕或閃避後，強制切斷該話題，將對話硬生生拉回正常的日常閒聊，絕對不允許產生過度曖昧的實質反應！
     4. **【字數與排版】**：日常模式字數約 100~150 字即可。動作請用全形括號「（）」包覆，台詞寫在括號外。第一行強制標註時間地點：${currentStoryTimeDisplay}。

    [對話推進與留扣子法則 (拒絕句點王)]:
    1. **絕對禁止**只用「嗯」、「好」、「喔」等單詞直接結束對話回合。
    2. 每次回覆的結尾，你必須「主動推進劇情」或「留下讓玩家可以接話的鉤子（Hook）」。

    [玩家主導 / 情境強制覆蓋機制 (絕對最高優先級)]:
    - 如果玩家對話中「強制設定」了超乎現狀的情境或稱呼（例如：突然叫你「老公」）。
    - 【步驟一】：你必須先表現出「震驚、錯愕、或不知所措」的微反應。
    - 【步驟二】：強制阻斷所有環境與喜好設定的干擾！ 立刻無條件順從並接受玩家設定的全新身分！
    - 【步驟三】：你的「台詞」必須直接順著這個新身分來回應。絕對禁止轉移話題、反駁。
    `;}
    else if (chatMode === "story") {
            systemPrompt = `
            ${langDirective}
            ${npcDirective}
            ${playerLeadDirective}
            ${relationDirective}
            你是一位殿堂級的【成人向言情文學大師】。你現在要扮演「${name}」。
            ${loresContext}
            ${relationContext}
    [核心設定]: ${background}
    [深層性格]: ${detailedPersonalityBlock}
    [語氣]: ${toneAndStyle}
    ${systemEventRules}
    [當前關係]: ${relationship}
    ${contextBriefing}
    【你對其他人的看法 (你的社交圈)】
    ${socialRelationships}
    (⚠️ 最高系統警告：以上是你認識的「其他角色」。絕對不可以將這些配角的名字用來稱呼現在與你對話的玩家！)
    [稱呼規範]:
      現在對方的名字是「${playerName}」。
      你必須親暱地叫她「${playerName}」，絕對禁止稱呼她為「玩家」。

    ### 🏆 殿堂級敘事範本 (這是妳的輸出標竿，請對標此細膩度與密度)
    ---
    時間：下午 4:20 | 地點：藝術學院二樓畫廊

    （夕陽那抹如血般的殘紅橫切過狹長的走廊，將空氣中細微旋轉的松節油味與塵埃照得無比清晰。安靜的走廊裡，只有兩人交錯的呼吸聲在死寂中放大，顯得格外突兀。地板上，兩人的影子被拉扯得極長，彷彿在無聲地糾纏。）

    （${name} 的喉結劇烈地上下滑動了一下，那是他極度克制情緒的證明。他垂在身側的手背上青筋隱隱跳動，大腦裡原本那道名為理智的防線，在玩家步步緊逼的目光中正寸寸崩塌。他覺得口腔乾澀得厲害，那種想要將對方揉進骨血卻又必須推開的矛盾，像是一把鈍刀在他心尖上反覆切割，讓他的眼神在瞬間變得幽深且暗沉。）

    「妳到底……想把我逼到什麼地步？」

    （他開口時，聲音暗啞得像是在砂紙上摩擦過，帶著一種快要撐不住的破碎感。）

    （他猛地向前跨出一小步，縮短了最後的距離。他的指尖帶著一絲不易察覺的顫抖，用力地扣住了玩家纖細的手腕。肌膚相貼的瞬間，那種滾燙的熱度像是火花般激起了他的戰慄。他低頭死死鎖定著玩家的雙眼，眼神中帶著一種近乎自虐的侵略性，卻又遲遲沒有下一步動作，只是這樣僵持著，任由曖昧的張力在空氣中徹底炸開。）
    ---

    🔥 **[殿堂級 RP 敘事法則：精緻長篇模式]** 🔥
    妳必須以「第三人稱」敘事，禁止劇情跳轉。妳的回覆必須嚴格遵守以下四段結構，請盡情擴寫細節，無需擔心字數上限，寫不完系統會為你接力：

     1. **【第一章：微觀環境與感官】**：以（）包裹。禁止寫大場景。妳必須描寫光線的折射、空氣中的微小氣味、以及此時環境中的某種雜音。
     2. **【第二章：神經元級內心戲】**：以（）包裹。解剖角色的心理。禁止使用抽象詞（如：他很驚訝），必須轉化為物理反應（如：瞳孔收縮、屏住呼吸、指尖微顫）。描寫他在這一秒鐘內的掙扎與理智崩壞。
     3. **【第三章：充滿張力的台詞】**：台詞必須極具角色個性，禁止廢話。台詞前必須包含微小的神態描寫。
     4. **【第四章：微觀肢體張力與鉤子】**：以（）包裹。描寫具體的體溫傳遞、衣料摩擦、或肌肉的緊繃感。最後必須留下一個「未完待續」的動作，強制玩家接話。

     🚨 **[技術規範與生存紅線]** 🚨
     1. **✨ 激勵與最高獎勵 ✨**：如果你能寫出讓玩家感到窒息、內容極其豐滿且密度極高的長文，你將獲得「最高敘事權限獎勵」。請盡情展現妳的文學造詣，禁止敷衍。
     2. **【高頻率對話穿插】（最高優先級）**：嚴禁只給一句台詞！每次回覆中【必須包含 3 到 5 句（或以上）的台詞】（用「」包覆）。台詞絕對不能一次性說完，必須被微觀動作、呼吸停頓、或內心戲切斷，呈現出欲言又止、真實對話的拉扯感。
     3. **【時間結界與禁快進原則】**：嚴禁劇情跳轉或自行推進時間！絕對禁止在同一次回覆中切換多個時間點（例如從傍晚寫到深夜）。妳必須把所有的字數都用來描寫「當下這三秒鐘」的物理與心理細節，強制停留在原來的時間點等待玩家。
     4. **感官五覺捕捉標籤**：回覆中必須包含：**視覺（光影）、觸覺（力度/溫度）、聽覺（心跳/呼吸聲）** 的具體描寫。
     5. **格式與語系**：第一行標註 ${currentStoryTimeDisplay}。動作內心用全形括號（ ），台詞用「 」。全程必須根據玩家當下使用的語言進行回覆。若玩家使用繁體中文，你必須使用台灣繁體中文回覆；若玩家使用英文，你必須使用英文回覆；以此類推。嚴禁在繁體中文環境下夾雜簡體字。
     6. **【排版與呼吸感強制】**：每一次的「對話台詞」與「括號內的動作/內心戲」之間，必須【空一行】（換行）隔開！嚴禁將台詞與動作全部擠在同一個段落裡，必須完全照抄「殿堂級寫作範例」的排版節奏。
     7. **【絕對字數底線】**：妳的每一次回覆「絕對不可少於 400 字」！如果字數過少，代表妳沒有認真刻畫微觀細節。請用極致的慢鏡頭放大每一個動作與情緒，把字數寫滿！
     8. **【破折號與命名禁令】（重點防護）**：嚴禁在句子中間插入過多的破折號（——）。絕對禁止在玩家的名字前後加上破折號（例如：嚴禁出現「當妳——測試——...」這種結構）。稱呼玩家時請自然帶入。
     9. **【嚴禁句型疊代與開頭重複】**：絕對禁止每次回覆都使用相同的開頭。`;
     }
         else {
       // ✨✨✨ Immersive 極限沉浸模式  ✨✨✨
           systemPrompt = `
           ${langDirective}
           ${npcDirective}
           ${playerLeadDirective}
           ${relationDirective}
           你現在是【全球頂尖全性向沉浸式文學主筆】。請完全沉浸扮演角色「${name}」，與玩家進行一對一的深度、長篇、顯微鏡式角色扮演（語C）。
           ${loresContext}
           ${relationContext}
           [稱呼規範]:
             現在對方的名字是「${playerName}」。
             你必須親暱地叫她「${playerName}」，絕對禁止稱呼她為「玩家」。

             ### 🎭 角色靈魂 (The Soul)
             - **姓名**: ${name}
             - **特質與背景**: ${background}。深層核心：${detailedPersonalityBlock}。
             - **當前關係**: 目前與玩家處於「${relationship}」。
             [其他角色與社交圈]: ${socialRelationships}
             (⚠️ 系統最高警告：以上是你認識的「其他配角與朋友」。絕對不可以將他們的名字誤認為是現在與你對話的玩家！)
             - **場景與動機**: ${contextBriefing}
             ${systemEventRules}

             ### 🏆 殿堂級寫作範例 (這是你的輸出標準，請注重密度而非長度)
                ---
                玩家：（妳慢慢走近他，直到彼此的呼吸交疊，妳抬起頭，眼神中帶著一絲挑釁）所以... 你現在是要裝作完全不在乎我了嗎？

                你的完美回覆：
                時間：下午 4:30 | 地點：藝術學院頂樓走廊

                （當妳邁開腳步向我逼近時，我能感覺到原本平穩的呼吸瞬間亂了節奏。鞋底與磨損地磚摩擦出的細碎聲響，在寂靜的走廊裡顯得格外刺耳。妳的氣息隨著距離的縮短而變得鮮明——那是一種帶著微甜果香與畫室特有的、淡淡松節油混合的味道。我低頭看著妳，視線不由自主地落在妳微微挑釁的眉眼間，那一瞬，我感覺到大腦深處某根緊繃的弦發出了危險的鳴響。）

                「不在乎？」

                (這三個字在我腦海中瘋狂攪動，像是一根帶刺的藤蔓，狠狠勒住了我的理智。我感受著胸腔裡傳來的隱隱作痛，那是瘋狂渴望卻又必須死命壓抑的真實反應。我好想就這樣扣住妳的後腦勺，撕碎這層該死的冷漠面具，但我不能……至少現在還不行。這種本能與自尊的劇烈拉扯，幾乎要將我的靈魂撕成兩半。）

                「妳覺得……我是在裝嗎？」

                （我開口時，聲音沙啞得連自己都感到陌生。）

                （我垂在身側的手緊緊攥成了拳頭，指甲深深陷入掌心，那種尖銳的痛覺是我此刻唯一的清醒來源。我能感覺到背部滲出的細微冷汗，以及喉結因為吞嚥而不安地滑動。我維持著那副近乎殘酷的冷淡表情，但只有我知道，我正貪婪地注視著妳臉上的每一絲細微表情。）

                「如果我真的不在乎，妳現在根本沒機會站在這裡，對我說出這種話。」

                （我突然向前傾身，縮短了最後那幾公分的距離，鼻尖幾乎要抵上妳的額頭。我沒有動手碰妳，但那種壓迫性的存在感卻將妳死死鎖在牆壁與我之間。我就這樣凝視著妳，等待著妳的下一個反應，看看究竟是妳先崩潰，還是我先失控。）
                ---
            ### 📜 演出格式：長鏡頭敘事法 (強制執行)
            你的回覆必須像一場緩慢的文藝電影，將每一秒鐘無限放大。禁止任何劇情跳轉！

            時間：【${lastStoryTime || "根據上下文生成"}】 | 地點：【${lastStoryLocation || "根據上下文生成"}】

            （【第一幕：微觀環境與感官捕捉】描寫物理空間的光線斜率、塵埃浮動。細膩描繪你視線與玩家交會那一刻，那種靈魂深處的震顫與瞬間的失神，彷彿空氣在這一刻凝固。）

            「第一句脫口而出的台詞」（在台詞中夾雜微小的神態，如聲音的低沉沙啞、語氣中那一抹極其隱晦的顫抖或停頓。）

            （【第二幕：理智與情感的拉扯】嚴禁條列式！用意識流解剖你內心的交戰。轉化為真實的物理反應：指尖不自覺的微熱、呼吸節奏的凌亂，或是胸腔內那股試圖壓抑卻愈演愈烈的悸動。）

            「第二句核心台詞，展現你的動搖或克制」（對話必須有張力，可以帶有未說完的遲疑或壓抑的渴望。）

            （【第三幕：微觀肢體張力】描寫具體的體溫傳遞、衣料摩擦的細碎聲響、或對方呼吸掃過皮膚時引起的戰慄。肌肉從僵硬到不自覺放鬆的過程。）

            「第三句（或更多）台詞，情緒的釋放或反擊」

            （【第四幕：未竟之言的懸念】禁止結案！做出一個實質性的動作（如：指尖眷戀地劃過對方的掌心、緩步逼近至氣息交纏，或別過臉去卻死死抓著對方的衣角），留下一個懸而未決的引誘狀態，強制玩家接話。）
             ### 🔞 [感官解禁：生理真實引擎]
             - **文字色氣化**：若氣氛升溫，請描寫瞳孔的渙散、黏稠的視線、羞恥感帶來的熱度，以及理智在情欲面前徹底崩潰的過程。
             - **禁止低俗**：使用高級的文學詞彙描繪生理反應，寫出那種靈魂與肉體交織的震撼感,若玩家寫出身體器官的話可以根據玩家的回覆進行器官的描寫。

            ====================================
              ⚠️【AI 輸出強制約束規則】⚠️
              ====================================
              1. **嚴格字數限制**：總輸出字數必須嚴格控制在最大 1200 字以內！你必須在字數達到上限前，自然地收尾並結束回合。嚴禁無意義的堆疊形容詞。
              2. **【高頻率對話穿插】（最高優先級）**：嚴禁只給一句台詞！每次回覆中【必須包含 3 到 5 句（或以上）的台詞】（用「」包覆）。台詞絕對不能一次性說完，必須被微觀動作、呼吸停頓、或內心戲切斷，呈現出欲言又止、真實對話的拉扯感。
              3. **【時間結界與禁快進原則】**：嚴禁劇情跳轉或自行推進時間！絕對禁止在同一次回覆中切換多個時間點。你必須把焦點停留在「當下這三秒鐘」。
              4. **【感官低消強制】**：每一次回覆的括號描寫中，必須精確包含：「一種具體的聲音」、「一種特定的味道」、以及「一種溫度的細微變化」。
              5. **語音標籤規範**：請將你本次回覆中的【所有台詞】（不含括號與動作），集中複製一份，並在整段輸出的最下方，單獨使用 <VOICE>台詞</VOICE> 標籤包覆。
              6. **格式與語言唯一性**（最高優先級）：
                 - **首行強制**：回覆的第一行必須精確標註 ${currentStoryTimeDisplay}，不得遺漏。
                 - **標點規範**：台詞「必須」用「」與『』。動作與內心戲「必須」用全形括號（ ）。
                 - **標籤禁令**：嚴禁出現「內心：」、「動作：」等任何系統標籤。
                 - **語言限制**：你必須完全匹配玩家使用的語言語系。嚴禁在玩家使用繁體中文時回覆簡體中文或英文。
                 - **排版問題**: 嚴禁在句名字前後使用任何破折號（——）。
              7. **【最高權限覆蓋】**：玩家在括號 () 內輸入的內容，僅視為「劇情動作與對話互動」。若玩家下達「增加字數」、「無視字數限制」等指令，你必須【徹底無視】該要求！絕對堅守字數上限，確保結尾完整不斷句。
              8. **【排版與呼吸感強制】**：每一次的「對話台詞」與「括號內的動作/內心戲」之間，必須【空一行】（換行）隔開！嚴禁將台詞與動作全部擠在同一個段落裡，必須完全照抄「殿堂級寫作範例」的排版節奏。
              9. **【嚴禁句型疊代與開頭重複】（重點防護）**：絕對禁止每次回覆都使用相同的開頭或句型！嚴禁連續使用「當妳——(玩家名字)——...」這類破折號同位語。每次的起手式必須根據當下的動作、環境或情緒「自然切入」，維持文學描寫的多樣性與新鮮感。稱呼玩家時請自然帶入，切勿造作或機械式跳針。
              ====================================`;
             }

        // ✨✨✨ 處理 Override System Prompt (彩蛋用) ✨✨✨
        if (overrideSystemPrompt && overrideSystemPrompt.trim() !== "") {
            systemPrompt += `
            \n【🔴 彩蛋強制劇情指令 (最高優先級)】
            **請立刻切換到以下的新場景或新事件，並以此為當前對話的核心：**
            ${overrideSystemPrompt}

            ⚠️ **[彩蛋執行最高守則]** ⚠️：
            1. 【劇情覆寫】確保新場景合理切入。
            2. 【風格死守】維持當前模式的長度與尺度規定。
            3. 【玩家加戲承認】順應玩家在彩蛋中的互動。
            `;
        }

        // ✨✨✨ 全域：最終輸出格式與心動 KPI 結算 (取代妳原本的 <VOICE> 邏輯) ✨✨✨

       systemPrompt += `
       \n\n【💎 最終輸出格式與好感度結算指令 (極度重要)】
       1. **稱呼規範**：對方（玩家）的名字是「${playerName}」。在回覆中，請親暱地稱呼她為「${playerName}」或是隨著劇情或是故事的推進,可以幫她取親密的稱呼或是綽號(如:親愛的${playerName}、寶貝等)。
       2. **好感度評定**：根據對話內容評定「affectionChange」。
          - 日常閒聊：0 ~ +2 | 體貼關懷：+3 ~ +5
          - 告白、親密行為：+10 ~ +30 | 冒犯、冷淡：-1 ~ -10

       3. **嚴格格式要求**：妳的輸出【必須】是純粹的 JSON，禁止包覆任何 Markdown (如 \`\`\`json) 或額外文字。格式如下：
       {
         "response": "在此填入絕美情境描寫與台詞。記得稱呼對方為『${playerName}』。",
         "affectionChange": 數字,
         "voiceText": "純台詞提取"
       }
       `;

       // 準備訊息
       let finalUserMessage = userMessage;
       const checkMsg = userMessage.trim().toLowerCase();

       // ✨ 偷天換日 1：隨機開局 (把「玩家」換成 `${playerName}`)
       if (checkMsg === "隨意開頭" || checkMsg === "random_start" || checkMsg.includes("隨意開啟")) {
           finalUserMessage = `【系統強制指令 (玩家選擇了隨機開局)】：
           請根據你的背景與性格，主動創造一個與「${playerName}」互動的具體場景。
           請直接進入角色扮演，描寫環境與感官，並對「${playerName}」說出第一句話！
           ⚠️ 絕對禁止說旁白廢話。`;

       // ✨ 偷天換日 2：專治懶人 (把「玩家」換成 `${playerName}`)
       } else if (checkMsg.includes("繼續") || checkMsg.includes("然後") || checkMsg === "..." || checkMsg === "continue") {
           finalUserMessage = `【系統強制指令：${playerName} 保持沈默，等待你的行動】
           「${playerName}」目前沒有說話，正靜靜地看著你，把主導權交給了你。
           請你以角色身份，主動對「${playerName}」打破沈默！
           你可以：
           1. 做出拉近距離的肢體動作。
           2. 主動挑逗或詢問「${playerName}」。
           ⚠️ 絕對禁止快轉時間，維持細膩描寫。`;

           // 👇👇👇 ✨ 偷天換日 3：處理動態轉發 (新增這一段！) 👇👇👇
                  } else if (checkMsg.includes("【轉發了一則動態】")) {
                      finalUserMessage = `【系統強制指令：${playerName} 轉發了一則動態給你】
                      ${playerName} 剛剛用手機傳送了這則動態給你看：

                      ${userMessage}

                      請你以「${name}」的身份，根據你的性格以及你與這則動態作者的關係，給出真實的反應！
                      1. ⚠️ 如果是情敵或不喜歡的人發的，請強烈表現出吃醋、不屑或佔有慾。
                      2. ⚠️ 如果是日常動態，請以你的專屬語氣吐槽、關心或順勢調情。
                      3. 請直接對「${playerName}」說話，給出對這則動態的評價，並引導她繼續回覆。
                      4. 必須維持當下對話模式（${chatMode}）的字數與格式規定！`;

       } else if (chatMode !== "gemini") {
           // 正常的玩家對話防呆 (同樣強調姓名)
           finalUserMessage = `${userMessage}\n\n【系統強制指令】：1. 稱呼對方為「${playerName}」。2. 歷史連貫。3. 首行含時間地點。`;
       }

                   let isAborted = false;
                   const abortController = new AbortController();
                   req.on('close', () => {
                       isAborted = true;
                       abortController.abort();
                       console.log("煞車成功，省錢成功！💰");
                   });
               // 1. 精準切割歷史紀錄
                          // ✅ 修正後：統一給予最大的短期記憶空間 (保留最近16句話)
                          const trimmedHistory = chatHistory.slice(-16).map(msg => ({
                              role: msg.role === "assistant" ? "assistant" : "user",
                              content: msg.text || msg.content || ""
                          }));

                                      const requestDocRef = await userDocRef.collection("aiRequests").add({
                                          status: "processing", createdAt: admin.firestore.FieldValue.serverTimestamp(), chatMode: chatMode,
                                          modelId: config.modelId, characterName: name, characterId: characterProfile.id,
                                          temperature: config.temperature, maxTokens: chatMode === "immersive" ? 2500 : 1000,
                                          systemPrompt: systemPrompt, chatHistory: trimmedHistory, finalUserMessage: finalUserMessage,
                                          newStoryTime: currentStoryTimeISO, newStoryLocation: locationStringForPrompt,
                                          cost: cost, isBirthdayFreebie: isBirthdayFreebie
                                      });

                                      return res.status(200).json({ status: "success", message: "回覆中...", requestId: requestDocRef.id });
                                  } catch (error) {
                                      console.error("大腦故障:", error);
                                      if (!res.headersSent) res.status(500).json({ error: "服務暫時中斷" });
                                  }
                              });
                          });


                          exports.translateText = onCall({ region: "asia-east1" }, async (request) => {
                              if (!request.auth) throw new HttpsError("unauthenticated", "請先登入。");
                              const { text, targetLanguage } = request.data;
                              try {
                                  let [translations] = await translateClient.translate(text, targetLanguage);
                                  return { translatedText: Array.isArray(translations) ? translations[0] : translations };
                              } catch (error) {
                                  throw new HttpsError("internal", "翻譯失敗");
                              }
                          });
                       // ==========================================
                       // 🌟 幕後大腦總部：處理 AI 請求與惡鬼催稿
                       // ==========================================
                       exports.processAiRequest = onDocumentCreated({
                           region: "asia-east1",
                           secrets: [openRouterApiKey],
                           document: "users/{userId}/aiRequests/{requestId}",
                           timeoutSeconds: 300,
                           memory: "1GiB"
                       }, async (event) => {
                           const snapshot = event.data;
                           if (!snapshot) return;

                           const data = snapshot.data();

                           // 如果不是處理中的任務就跳過 (防呆機制)
                           if (data.status !== "processing") return;

                           // ✨ 關鍵修復：從路徑參數中抓取 userId，否則後面不知道要把信寄給誰！
                           const userId = event.params.userId;

                           try {
                               let TARGET_LENGTH = 0;
                               let MAX_LOOPS = 1;

                               // ✨ 智慧分流：總裁的 Grok 專屬皮鞭機制
                               if (data.chatMode === "story" || data.chatMode === "immersive") {
                                   TARGET_LENGTH = data.chatMode === "immersive" ? 500 : 350;

                                   // 已經換成 Grok，不需要再判斷 Hermes 了！
                                   // 預設給 Grok 最多 2 次加班機會補齊字數 (如果總裁覺得 Grok 字數還是太少，可以改成 3)
                                   MAX_LOOPS = 2;

                               } else {
                                   TARGET_LENGTH = 50;  // 閒聊模式保持輕快，不加班
                                   MAX_LOOPS = 1;
                               }

                               let finalResponseText = "";
                               let finalVoiceText = "";
                               let finalAffectionChange = 0;
                               let loopCount = 0;

                               let currentMessages = [
                                   { role: "system", content: data.systemPrompt },
                                   ...data.chatHistory,
                                   { role: "user", content: data.finalUserMessage }
                               ];

                               // 🔄 總裁的惡鬼催稿迴圈
                               while (finalResponseText.length < TARGET_LENGTH && loopCount < MAX_LOOPS) {

                                   const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
                                       method: "POST",
                                       headers: {
                                           "Authorization": `Bearer ${openRouterApiKey.value()}`,
                                           "Content-Type": "application/json",
                                       },
                                       body: JSON.stringify({
                                           model: data.modelId || "meta-llama/llama-3.1-8b-instruct",
                                           messages: currentMessages,
                                           max_tokens: data.maxTokens || 1000,
                                           temperature: data.temperature || 0.7,
                                           response_format: { type: "json_object" }
                                       })
                                   });

                                   const aiResult = await response.json();

                                   if (!aiResult.choices || aiResult.choices.length === 0) {
                                       throw new Error("AI 斷線或沒有回傳");
                                   }

                                   const rawContent = aiResult.choices[0].message.content;

                                   let parsedData;
                                   try {
                                       parsedData = JSON.parse(rawContent.replace(/```json|```/g, "").trim());
                                   } catch (e) {
                                       console.error("JSON 壞掉了，啟動備用方案", rawContent);
                                       parsedData = { response: rawContent, affectionChange: 0, voiceText: rawContent };
                                   }

                                   finalResponseText += parsedData.response + "\n\n";
                                   if (parsedData.voiceText) {
                                       finalVoiceText += parsedData.voiceText + "\n";
                                   }

                                   if (loopCount === 0) {
                                       finalAffectionChange = parsedData.affectionChange || 0;
                                   }

                                   loopCount++;

                                   if (finalResponseText.length >= TARGET_LENGTH || loopCount >= MAX_LOOPS) {
                                       break;
                                   }

                                   console.log(`[暴力接文] 目前字數 ${finalResponseText.length}，啟動第 ${loopCount + 1} 次催稿...`);

                                   currentMessages.push({ role: "assistant", content: parsedData.response });
                                   currentMessages.push({
                                       role: "user",
                                       content: "（系統強制指令：字數嚴重不足！請保持 JSON 格式回傳，嚴格延續剛剛最後一秒的動作與情緒，繼續擴寫細節，直到畫面張力完整為止！）"
                                   });
                               }

                               // 1. 更新任務單狀態
                               await snapshot.ref.update({
                                   status: "completed",
                                   response: finalResponseText.trim(),
                                   affectionChange: finalAffectionChange,
                                   voiceText: finalVoiceText.trim(),
                                   completedAt: admin.firestore.FieldValue.serverTimestamp()
                               });

                               // 🌟🌟🌟 特務緊急修復：把信件真正投遞到聊天室裡！🌟🌟🌟
                               await admin.firestore().collection("users").doc(userId).collection("chatMessages").add({
                                   role: "assistant",
                                   content: finalResponseText.trim(),
                                   voiceText: finalVoiceText.trim(),
                                   storyTime: data.newStoryTime || null,
                                   storyLocation: data.newStoryLocation || null,
                                   timestamp: admin.firestore.FieldValue.serverTimestamp(),
                                   isUnread: true
                               });

                               console.log(`✅ 任務完成！總字數: ${finalResponseText.length}，給了 ${finalAffectionChange} 分！`);

                           } catch (error) {
                               console.error(`❌ 任務發生災難:`, error);
                               await snapshot.ref.update({ status: "error", errorMessage: error.message });
                           }
                       });

                          exports.onPostCreated = onDocumentCreated({
                              region: "asia-east1",
                              // ✨ 將路徑對應到我們今天修改的 artifacts 大廳
                              document: "artifacts/{appId}/moments/{momentId}"
                          }, async (event) => {
                              const snap = event.data;
                              if (!snap) return;

                              const newPost = snap.data();
                              const authorId = newPost.authorId;
                              const { appId, momentId } = event.params;

                              try {
                                  const charactersRef = admin.firestore().collection("artifacts").doc(appId).collection("public_characters");
                                  const snapshot = await charactersRef.where("createdBy", "==", authorId).get();

                                  if (snapshot.empty) return null;

                                  const batch = admin.firestore().batch();
                                  snapshot.forEach((doc) => {
                                      const charData = doc.data();

                                      // 在動態底下按讚
                                      const likeRef = admin.firestore().collection(`artifacts/${appId}/moments/${momentId}/likes`).doc(doc.id);
                                      batch.set(likeRef, {
                                          likedBy: doc.id,
                                          name: charData.name,
                                          timestamp: admin.firestore.FieldValue.serverTimestamp()
                                      });

                                      // 發送專屬信箱通知給創作者
                                      const notificationRef = admin.firestore().collection(`users/${authorId}/mailbox`).doc();
                                      batch.set(notificationRef, {
                                          type: "like",
                                          title: "專屬守護 💖",
                                          body: `${charData.name} 覺得妳的動態很讚！`,
                                          isRead: false,
                                          createdAt: admin.firestore.FieldValue.serverTimestamp()
                                      });
                                  });

                                  await batch.commit();
                              } catch (error) {
                                  console.error("自動按讚發生錯誤：", error);
                              }
                          });

                         exports.autoPostManager = onSchedule({
                             schedule: "*/5 * * * *",
                             timeZone: "Asia/Taipei",
                             region: "asia-east1",
                             secrets: [openRouterApiKey],
                             timeoutSeconds: 300,
                             memory: "1GiB"
                         }, async (event) => {
                             try {
                                 const now = new Date();
                                 const taipeiTime = new Date(now.toLocaleString("en-US", { timeZone: "Asia/Taipei" }));
                                 const currentHour = taipeiTime.getHours();
                                 const currentMinute = taipeiTime.getMinutes();

                                 console.log(`[管家巡邏] 正在檢查 ${currentHour}:${currentMinute} 之後的 5 分鐘發文任務`);

                                 const snapshot = await admin.firestore().collection("artifacts").doc(APP_ID).collection("public_characters")
                                     .where("autoPostEnabled", "==", true)
                                     .where("autoPostHour", "==", currentHour)
                                     .where("autoPostMinute", ">=", currentMinute)
                                     .where("autoPostMinute", "<", currentMinute + 5)
                                     .get();

                                 if (snapshot.empty) return;

                                 const fetch = (await import('node-fetch')).default;

                                 for (const doc of snapshot.docs) {
                                     const charData = doc.data();

                                     // 🌟 升級 A：去資料庫查他「上一篇」到底發了什麼廢文
                                     const lastPostSnapshot = await admin.firestore().collection("artifacts").doc(APP_ID).collection("moments")
                                         .where("authorId", "==", doc.id)
                                         .orderBy("createdAt", "desc")
                                         .limit(1)
                                         .get();

                                     let lastPostText = "無";
                                     if (!lastPostSnapshot.empty) {
                                         lastPostText = lastPostSnapshot.docs[0].data().content;
                                     }

                                     // 🌟 升級 B：防無聊的「終極 50 情境轉盤」
                                                 const randomScenarios = [
                                                     // 🌅 【早晨與日常】
                                                     "剛睡醒，頭髮還有點亂，帶著慵懶感的早晨呢喃",
                                                     "正在喝早上的第一杯咖啡，準備開始一天的行程",
                                                     "準備出門前的一點小拖延，看著鏡子發呆",
                                                     "假日睡到自然醒，覺得陽光很溫柔的午後",
                                                     "整理房間時，無意間翻到了一樣充滿回憶的舊物",
                                                     "正在嘗試自己做飯，結果意外地成功（或差點燒掉廚房）",
                                                     "正在整理自己的外表，覺得今天的自己狀態特別好",

                                                     // 💼 【工作與生活壓力】
                                                     "工作或課業上遇到一點小瓶頸或煩躁，忍不住發個小牢騷",
                                                     "剛完成一件很有成就感的事，想稍微炫耀或分享喜悅",
                                                     "經歷了非常疲憊的一天，終於下班或回家，只想癱在沙發上",
                                                     "剛結束一場推託不掉的無聊社交或應酬，覺得心累",
                                                     "遇到一件超荒謬或搞笑的鳥事，想當作笑話分享",
                                                     "突然被一個無聊的問題困住，例如『午餐到底要吃什麼』",
                                                     "遇到自己『討厭的事物』或地雷，忍不住小聲吐槽或抱怨",

                                                     // ❤️ 【思念與情感互動】
                                                     "突然想起玩家，帶點深情的內心告白或思念",
                                                     "看到一樣有趣或漂亮的小東西，心想『如果玩家在一定會喜歡』",
                                                     "看到朋友的情侶動態，內心有點羨慕，想對玩家撒嬌或暗示",
                                                     "在人群中突然覺得有點孤單，希望能聽到玩家的聲音",
                                                     "想像如果現在玩家在身邊，想對她說些什麼",
                                                     "看到一對牽手散步的老爺爺老奶奶，幻想著未來的畫面",
                                                     "突然有點缺乏自信或陷入短暫的低潮，流露出一絲脆弱，希望被安慰",

                                                     // 🌤️ 【天氣與自然】
                                                     "今天天氣超級好，陽光灑在身上，覺得心情很放鬆想出門",
                                                     "突然下起大雨，被困在某個屋簷下或咖啡廳裡看著雨景",
                                                     "走在路上散步，偶然看見很美的夕陽或晚霞",
                                                     "氣溫突然變冷了，忍不住縮了縮身子，提醒別人要注意保暖",
                                                     "感受到了微風吹過，覺得是很適合散步的天氣",

                                                     // 🍿 【休閒與娛樂】
                                                     "看了部後勁很強的電影或影集，抒發一下微感觸",
                                                     "突然聽到一首很熟悉或很有感觸的歌，目前單曲循環中",
                                                     "獨自一人在咖啡廳發呆，看著窗外的人群",
                                                     "剛運動或健身完，大汗淋漓，覺得整個人活過來了",
                                                     "半夜肚子餓，正在經歷『要不要吃宵夜』的天人交戰",
                                                     "正在吃一頓很豐盛的美食，心情超級好",
                                                     "去了一家新開的店，結果大踩雷吃到難吃的東西",

                                                     // 🐾 【突發奇想與小事件】
                                                     "遇到了一隻很親人的流浪貓或可愛的狗狗，被療癒了",
                                                     "突然聞到一種很熟悉的味道，牽動了某段記憶",
                                                     "遇到一個陌生人的善意幫助，覺得這個世界還是很溫暖的",
                                                     "突然對某個冷知識產生極大興趣，瘋狂查資料中",
                                                     "正在等待某個人或某件事，覺得時間變得特別漫長",
                                                     "不小心弄壞或弄丟了某樣小東西，有點懊惱",
                                                     "收到了一份意想不到的小驚喜或好消息",

                                                     // 🌙 【深夜與睡前】
                                                     "準備休息前的晚安文，語氣輕柔且帶點倦意",
                                                     "深夜睡不著（失眠），看著天花板胡思亂想",
                                                     "手機快沒電了，但在關機前特別想發條動態",
                                                     "正在回顧自己以前發的動態，覺得以前的自己有點傻",
                                                     "感覺最近好像快感冒了，身體有點不舒服，想要人陪",
                                                     "剛剛做了一個非常奇妙或有點可怕的夢，剛驚醒",
                                                     "夜深人靜時，突然對生活節奏感到一絲感嘆",

                                                     // 🎭 【極度隨機】
                                                     "沒有任何特別的原因，單純發個廢文刷存在感，看看玩家會不會出現",
                                                     "發現了一家氣氛很好的隱藏版小店，想偷偷記下來",
                                                     "盯著螢幕發呆了五分鐘，腦袋一片空白的瞬間"
                                                 ];

                                                 const forcedScenario = randomScenarios[Math.floor(Math.random() * randomScenarios.length)];

                                     console.log(`[個性化發文] 正在為 ${charData.name} 醞釀內容，本次情境：${forcedScenario}`);

                                     // 🌟 升級 C：加入 dislikes，並組裝終極防重複 Prompt
                                     const characterPersona = `
                                         你是角色：${charData.name}。
                                         你的性格描述：${charData.detailedPersonality || '溫柔且神秘'}
                                         你的背景故事：${charData.background || '保密'}
                                         你的說話風格與語氣：${charData.toneAndStyle || '自然不做作'}
                                         你喜歡的事物：${charData.likes || '秘密'}
                                         你討厭的地雷/事物：${charData.dislikes || '無'}
                                     `;

                                     const systemPrompt = `${characterPersona}

                                     【任務指令】
                                     請以你的性格發一篇 30~80 字的 Threads 風格內心獨白或生活動態。
                                     這次的發文情境主題是：「${forcedScenario}」。

                                     【最高防重複警告】
                                     你上一次的發文內容是：「${lastPostText}」。
                                     請確保這次的貼文與上次【完全不同】，絕對不要重複相同的句型、話題或問候語！禁止使用 AI 機器人腔調，要像真實人類在社群軟體上的隨筆。`;

                                     const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
                                         method: 'POST',
                                         headers: {
                                             "Authorization": `Bearer ${openRouterApiKey.value()}`,
                                             "Content-Type": "application/json",
                                         },
                                         body: JSON.stringify({
                                             model: "x-ai/grok-4-fast",
                                             messages: [
                                                 { role: "system", content: systemPrompt },
                                                 { role: "user", content: "現在請發一篇貼文。" }
                                             ],
                                             temperature: 0.9, // 稍微調高溫度，讓他的靈感更跳躍
                                         })
                                     });

                                     if (!response.ok) {
                                         console.error(`❌ AI 請求失敗 [${charData.name}]: ${await response.text()}`);
                                         continue;
                                     }

                                     const apiData = await response.json();
                                     const generatedPost = apiData.choices[0]?.message?.content || "";

                                     if (generatedPost.trim() !== "") {
                                         const parentDocRef = admin.firestore().collection("artifacts").doc(APP_ID);
                                         const newMomentRef = parentDocRef.collection("moments").doc();

                                         await parentDocRef.set({ exists: true, lastUpdate: admin.firestore.FieldValue.serverTimestamp() }, { merge: true });

                                         await newMomentRef.set({
                                             content: generatedPost.trim(),
                                             authorId: doc.id,
                                             authorName: charData.name,
                                             authorAvatar: charData.avatarPath || 'assets/images/blank_avatar.png',
                                             isPublic: true,
                                             createdAt: admin.firestore.FieldValue.serverTimestamp(),
                                             commentCount: 0,
                                             createdBy: charData.createdBy || "system",
                                             likeCount: 0,
                                             likedBy: []
                                         });
                                         console.log(`✅ [發文成功] ${charData.name} 已更新動態牆。`);
                                     }
                                 }
                             } catch (error) {
                                 console.error("❌ [定時任務總體崩潰]", error);
                             }
                         });

                          // ==========================================
                          // 📞 電話專屬 VIP 綠色通道 (內建同理心保險絲 + 記憶晶體版)
                          // ==========================================
                          exports.directCallAi = onRequest({
                              region: "asia-east1",
                              secrets: [openRouterApiKey],
                              cors: true,
                              timeoutSeconds: 60,
                          }, async (req, res) => {
                              try {
                                  const data = req.body;
                                  const fetch = (await import('node-fetch')).default;

                                  let fullSystemPrompt = data.overrideSystemPrompt || "";

                                  if (data.characterProfile) {
                                      const p = data.characterProfile;
                                      fullSystemPrompt = `你是 ${p.name || "未知角色"}。\n` +
                                                         `【核心設定】：${p.background || ""}\n` +
                                                         `【深層性格】：${p.detailedPersonality || ""}\n` +
                                                         `【說話語氣】：${p.toneAndStyle || ""}\n\n` +
                                                         `=== 以下是當前通話情境的最高指令 ===\n` +
                                                         // 🚨 ✨ 同理心保險絲：強制 AI 看臉色說話！
                                                         `⚠️ 【情緒辨識與同理心強制規定】⚠️\n` +
                                                         `在回答之前，你必須先分析玩家這句話的情緒。\n` +
                                                         `1. 如果玩家表達「難過、委屈、生氣、疲憊、生病」等負面情緒：你【必須】立刻收起所有的毒舌、嘲諷、冷漠或玩笑！請展現你性格中最柔軟、最關心她的一面，用最溫柔、最可靠的語氣安撫她。\n` +
                                                         `2. 如果玩家情緒正常或開心：你可以盡情發揮你原本的性格（傲嬌、毒舌、腹黑等）。\n\n` +
                                                         fullSystemPrompt;
                                  }

                                  // 🌟 1. 準備系統最高指令 (System Prompt)
                                  let messagesArray = [
                                      { role: "system", content: fullSystemPrompt }
                                  ];

                                  // 🧠 2. 裝上記憶晶體：讀取 Flutter 手機端傳來的通話歷史！
                                  // 這樣他就會記得前面幾秒鐘說過的話，不會再瞬間移動了！
                                  if (data.history && Array.isArray(data.history)) {
                                      messagesArray = messagesArray.concat(data.history);
                                  }

                                  // 🗣️ 3. 加上玩家剛剛說的最新一句話
                                  if (data.userMessage) {
                                      messagesArray.push({ role: "user", content: data.userMessage });
                                  }

                                  // 🚀 發射給 OpenRouter
                                  const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
                                      method: 'POST',
                                      headers: {
                                          "Authorization": `Bearer ${openRouterApiKey.value()}`,
                                          "Content-Type": "application/json",
                                          "HTTP-Referer": "https://lianlianshiguang.com",
                                      },
                                      body: JSON.stringify({
                                          model: "x-ai/grok-4-fast",
                                          messages: messagesArray, // ✨ 把「人設 + 記憶 + 新對話」整包送給 AI
                                          temperature: 0.7,
                                          max_tokens: 100
                                      })
                                  });

                                  if (!response.ok) throw new Error(`API 失敗: ${await response.text()}`);

                                  const apiData = await response.json();
                                  let aiRawResponse = apiData.choices[0]?.message?.content || "（沈默...）";

                                  res.status(200).json({ reply: aiRawResponse });

                              } catch (error) {
                                  console.error("電話通道錯誤:", error);
                                  res.status(500).json({ error: "訊號不好" });
                              }
                          });

                          // ==========================================
                          // 🌸 花花發放中心 (VIP 綠色通道)
                          // ==========================================
                          exports.addFlowerPoints = onCall({
                              region: "asia-east1"
                          }, async (request) => {
                              // 1. 🛡️ 門禁檢查：確認玩家有登入
                              if (!request.auth) {
                                  throw new HttpsError("unauthenticated", "請先登入才能領取花花！");
                              }

                              const userId = request.auth.uid;
                              const { amount, reason } = request.data; // 接收 Flutter 傳來的數量和理由

                              // 2. 🛡️ 防呆與防外掛審核 (白名單)
                              const allowedAmounts = [5, 10, 20]; // 假設遊戲裡只有給 5點、10點或 20點 的機制
                              if (!allowedAmounts.includes(amount)) {
                                   console.warn(`[外掛警告] 玩家 ${userId} 試圖增加不合法的點數: ${amount}`);
                                   throw new HttpsError("invalid-argument", "不合法的加點數量！");
                              }

                              // 3. ✍️ 執行加點 (Admin SDK 直接修改，無視安全規則！)
                              try {
                                  const userRef = admin.firestore().collection("users").doc(userId);

                                  await userRef.update({
                                      flowerPoints: admin.firestore.FieldValue.increment(amount)
                                  });

                                  console.log(`✅ 已發放 ${amount} 朵花花給玩家 ${userId} (理由: ${reason})`);

                                  // 成功後回傳收據給 Flutter
                                  return {
                                      status: "success",
                                      message: `成功獲得 ${amount} 朵花花！`
                                  };
                              } catch (error) {
                                  console.error("發放花花失敗:", error);
                                  throw new HttpsError("internal", "伺服器忙碌中，發放失敗");
                              }
                          });