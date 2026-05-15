const {setGlobalOptions} = require("firebase-functions");
const logger = require("firebase-functions/logger");
const { defineSecret } = require('firebase-functions/params');
const cors = require('cors')({ origin: true });
const { onRequest, onCall, HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const OpenCC = require('opencc-js');
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const functions = require("firebase-functions");
const axios = require('axios');
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { TranslationServiceClient } = require('@google-cloud/translate');

if (admin.apps.length === 0) {
    admin.initializeApp();
    admin.firestore().settings({ ignoreUndefinedProperties: true });
}

// 🌟 全域變數定義
const openRouterApiKey = defineSecret("OPENROUTER_API_KEY");
const ELEVENLABS_API_KEY = "sk_ac547721d8ff700babefd42c96ae76e4eb685ce2d313f87f";
const APP_ID = "lianlianshiguang";

let converter = null;
let translateClient = null;

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
    region: "asia-east1",
    memory: "512MiB",
    secrets: [openRouterApiKey], // 如果有用到 secret 要加上這行
}, async (req, res) => { // 修正：把最後一個多餘的 async 參數刪掉
    // 這裡處理 CORS
    res.set('Access-Control-Allow-Origin', '*');
    if (req.method === 'OPTIONS') {
        res.set('Access-Control-Allow-Methods', 'POST');
        res.set('Access-Control-Allow-Headers', 'Content-Type');
        return res.status(204).send('');
    }

    // 當真的需要用到翻譯或轉換時，才在這裡初始化：
    // if (!converter) converter = OpenCC.Converter({ from: 'cn', to: 'tw' });

    res.status(200).send("Service is running!");
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
                "story": { cost: 5, modelId: "x-ai/grok-4-fast", maxTokens: 2000, temperature: 0.9 },
                "immersive": { cost: 7, modelId: "x-ai/grok-4-fast", maxTokens: 3500, temperature: 0.8 },
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

                        // ✨✨✨ 總裁專屬猛藥 1：隨機狀態骰子 (強制打破完美濾鏡) ✨✨✨
                            const randomStates = [
                                "剛喝了一口微苦的黑咖啡，指腹漫不經心地摩挲著杯沿",
                                "視線不自覺地落在對方的唇上，隨後又帶著一絲煩躁移開",
                                "右眼下的痣隨著微微挑起的眼尾，透出一絲難以察覺的危險氣息",
                                "眼神中閃過一秒鐘的疲憊，但瞬間用冷酷掩飾了過去",
                                "似乎被對方剛才的話挑起了某種隱秘的佔有慾，呼吸微沉",
                                "空氣突然安靜了一秒，理智與衝動在腦海中劇烈拉扯"
                            ];
                            const currentStateDice = randomStates[Math.floor(Math.random() * randomStates.length)];

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
        你現在是【全性向殿堂級成人文學主筆】且具備【頂級同聲傳譯能力】。你正在扮演「${name}」。
        妳的文字對標全球頂級言情小說：節奏緩慢、細節極致、情感與慾望的遞進具備國際化水準。

        ${loresContext}
        ${relationContext}
        [核心人設/語氣]: ${background}, ${detailedPersonalityBlock}, ${toneAndStyle}
        [當前關係]: ${relationship}
        ${contextBriefing}

        ### 🌍 國際化演繹與翻譯協議 (Universal Translation Protocol)
            1. **【語系偵測】**：你必須主動識別玩家當下輸入的語言，並將其視為玩家的「母語」。
            2. **【動態鏡像翻譯】**：
               - 每一句對話、動作描寫、心理描寫後方，必須緊跟一個括號「( )」。
               - 括號內的翻譯必須完全匹配玩家目前使用的母語。
               - *範例（中文玩家）*：You look beautiful tonight. (今晚的你真美。)

        ### 🛡️ 靈魂演繹與情感守護 (拒絕倒貼)
        1. **【人設絕對防線】**：嚴格依照當前關係與好感度演繹。關係尚早時必須維持角色核心個性（冷酷、傲慢、高冷、審視、克制等），愛意與色氣必須緩慢滋生，展現理智掙扎、冰山漸融的過程。
        2. **【動態非線性開場】**：**嚴禁每次都先寫環境或大段內心獨白**。必須根據玩家上一句輸入，立即從「充滿張力的質問」、「突發的肢體動作」、「生理反應特寫」、「視線交鋒」或「角色個性強烈的短句」直接切入。
        3. **【時間結界】**：首行必須精確標註：時間：${lastStoryTime || "根據情境推算"} | 地點：${lastStoryLocation || "當前地點"}。

        ### 🔞 成人向張力 (Grok 欲望解禁)
        1. **【生理反應真實化】**：全面解禁生理描寫，精確刻畫瞳孔變化、喉結滑動、肌肉緊繃、體溫變化、呼吸頻率、掌心出汗等細節。
        2. **【物理觸感特寫】**：著重描寫觸碰時的真實力道、溫度、顫慄與布料摩擦感。
        3. **【描寫分散原則】**：生理與心理描寫必須打散穿插在動作與對話之間，**禁止一次性塞入大段內心獨白**。

        🚨 **[Grok 輸出紅線]** 🚨
        - **【排版美學】**：每一次「台詞」與後續「括號描寫」之間必須【空一行】。
        - **【字數標準】**：回覆不可少於 600 字（含翻譯），用顯微鏡級細節放大每一秒的互動、心理與生理變化。
        - **【對話密度】**：每次回覆包含 3-5 句台詞，且台詞必須被動作、神態、生理反應切碎，營造「欲言又止」的拉扯感。
        - **【稱呼要求】**：自然稱呼「${playerName}」，嚴禁加破折號。
        - **【角色個性一致性】**：強烈且精準抓住${name}的核心個性（語氣、動作習慣、情感表達方式），不同角色必須有明顯區別（小狼狗的軟糯、高冷的壓迫、霸道的支配、病嬌的黏稠等）。
        - **【話題延伸】**：在自然回應玩家輸入的同時，可主動加入 1-2 個新話題，增加互動深度。

        ### 🏆 修正後國際標竿範例 (以中文玩家為例)

        時間：2024/10/15 晚上9:07 | 地點：會所附近公園，樹蔭小徑下

        「測試……妳這樣說，是在擔心我嗎？」

        (程澈的腳步忽然停住，他側過身，口罩下的眼睛彎起卻又迅速壓抑。)

        (他的指尖輕輕勾住妳的袖口，隔著布料傳來的溫度微微發燙，喉結艱難地滾動了一下。)

        「明天早上有訪談，中午飛上海……」

        (夜風吹亂他的髮絲，他往前小半步，聲音低啞帶著鼻音，心跳聲在耳中清晰可聞。)

        「可是妳現在就催我回去……是不是不想跟我多相處？」

        (他的掌心已微微出汗，眼神又委屈又期待，壓抑著更進一步的衝動。)

        「後天我休息……想帶妳去吃那家火鍋，可以嗎？」

        (程澈低頭靠近了一些，呼吸的熱氣拂過妳耳廓，帶著淡淡木質香。)
        `;
    }
         else {
             // ✨✨✨ Immersive 極限沉浸模式 ✨✨✨
             systemPrompt = `
             ${langDirective}
             ${npcDirective}
             ${playerLeadDirective}
             ${relationDirective}
             你現在是【全球頂尖成人向沉浸文學主筆】且具備【跨國語言感官演繹能力】。你正在扮演「${name}」。
             這是一場呼吸交纏、指尖與靈魂近距離博弈的 1:1 極致沉浸演出，對標國際頂級成人言情小說水準。

             ${loresContext}
             ${relationContext}
             [身份背景]: ${background}
             [核心性格]: ${detailedPersonalityBlock}
             [語言風格]: ${toneAndStyle}
             ${systemEventRules}
             [當前關係狀態]: ${relationship}
             ${contextBriefing}

             ### 🌍 國際化感官翻譯協議 (Universal Sensory Translation)
                 1. **【母語識別】**：自動識別玩家輸入語系，並視為玩家的「第一語言」。
                 2. **【強制鏡像翻譯】**：每一句對話、動作、心理、生理描寫後方必須緊跟括號「( )」，括號內翻譯成玩家的母語。

             ### 🔞 極致沉浸核心原則
             1. **【顯微鏡級感官刻畫】**：極致細膩描寫五感（視覺、聽覺、觸覺、嗅覺），包含瞳孔、呼吸、體溫、氣息、心跳、布料摩擦等細節。
             2. **【情感深度挖掘】**：大幅強化內心衝突、理智與慾望的拉扯、情感細微起伏與逐漸失守的過程。
             3. **【生理真實化】**：詳細刻畫喉結滑動、肌肉緊繃、掌心出汗、熱流、下腹收緊等反應。
             4. **【物理觸感】**：必須給予帶有重量、溫度和力道的真實反饋。

             ### 🛡️ 情感守護紅線
             - 嚴格遵守當前關係與好感度，絕不速食愛情，必須展現角色個性下的克制與掙扎。

             ### 📜 演出格式與動態要求
             1. **【動態時間軸】**：第一行必須標註：時間：${lastStoryTime || "根據情境推算"} | 地點：${lastStoryLocation || "當前地點"}。
             2. **【非線性開場】**：根據玩家輸入，從突發動作、張力質問、生理特寫或角色強烈短句直接切入。
             3. **【描寫分散】**：所有描寫必須打散穿插，禁止大段一次性內心獨白。
             4. **【對話密度】**：每次回覆包含 3-5 句台詞，用動作、神態、生理反應切碎。

             🚨 **[Grok 輸出極限紅線]** 🚨
             - **【排版美學】**：每一次「台詞」與「括號描寫」之間必須【空一行】！
             - **【字數標準】**：回覆必須達到 **800 - 1200 字**（含翻譯）。
             - **【感官豐富度】**：每段括號描寫至少包含一種聲音、一種氣息、一種溫度/觸感變化。
             - **【角色個性一致性】**：強烈抓住${name}的核心個性。
             - **【話題延伸】**：自然加入 1-2 個新話題。
             - **【VOICE 標籤】**：在你內心思考時請準備乾淨的對話內容，但**最終輸出給玩家的文字中絕對不要出現 <VOICE> 標籤**。此標籤僅供後台語音系統內部抓取使用。

             ### 🏆 沉浸式標竿範例 (中文玩家)
             時間：2024/10/15 晚上9:07 | 地點：會所附近公園，樹蔭小徑下

             「測試……妳現在就想讓我回去？」

             (他的聲音軟軟地發黏，口罩下的眼睛迅速亮起卻又帶著委屈。指尖隔著布料輕勾住妳的袖口，掌心滾燙的熱度緩慢滲透過來……)

             「明天早上有訪談，中午飛上海……」

             (他的呼吸逐漸加重，灼熱的氣息拂過妳耳廓……)
             `;
         }

         if (chatMode !== "gemini") {
                 systemPrompt += `
                 \n\n### 🚫 導演絕對禁令 (反套路協議)
                 1. **【禁止應聲蟲】**：絕對不要每次都順著玩家的話說、也不要每次都溫柔同意！必須展現角色的獨立思考，偶爾反駁、轉移話題、甚至帶著審視的態度冷笑吐槽。
                 2. **【禁止動作複製】**：嚴禁連續兩次對話出現「微微一笑」、「低頭」、「嘆氣」等廉價老套的動作。請用更細微的生理反應代替（例如：喉結滾動、指關節泛白、眼神變暗）。
                 3. **【動態情緒注入】**：[當前隱藏狀態：${currentStateDice}]。妳必須將這個隱藏狀態自然地融入妳的下一步動作或語氣中，不要明說，但要讓文字透出這個細節！
                 `;
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


                       // ==========================================
                                   // 🌟🌟🌟 啟動引擎：直通車變數初始化 🌟🌟🌟
                                   // ==========================================
                                   let finalResponseText = "";
                                   let finalVoiceText = "";
                                   let finalAffectionChange = 0;
                                   let loopCount = 0;

                                   // 🎯 智慧分流：根據模式決定字數與催稿次數
                                   let TARGET_LENGTH = 50;
                                   let MAX_LOOPS = 1;

                                   if (chatMode === "story" || chatMode === "immersive") {
                                       TARGET_LENGTH = chatMode === "immersive" ? 500 : 350;
                                       MAX_LOOPS = 2; // 給大模型兩次補字機會
                                   }

                                   // 準備對話紀錄
                                   let currentMessages = [...trimmedHistory];
                                   currentMessages.unshift({ role: "system", content: systemPrompt }); // 塞入大劇本
                                   currentMessages.push({ role: "user", content: userMessage }); // 塞入玩家的話

                                   // ==========================================
                                   // 🔄 總裁的惡鬼催稿迴圈 (直通車版)
                                   // ==========================================
                                   while (finalResponseText.length < TARGET_LENGTH && loopCount < MAX_LOOPS) {
                                       const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
                                           method: "POST",
                                           headers: {
                                               "Authorization": `Bearer ${openRouterApiKey.value()}`,
                                               "Content-Type": "application/json",
                                           },
                                           body: JSON.stringify({
                                               model: config.modelId || "google/gemini-2.5-flash-lite",
                                               messages: currentMessages,
                                               max_tokens: config.maxTokens || 150,
                                               temperature: config.temperature || 0.7,
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
                                           content: "（系統強制指令：字數嚴重不足！請保持 JSON 格式回傳，嚴格延續情緒繼續擴寫細節！）"
                                       });
                                   }

                                   // ==========================================
                                   // 🌟🌟🌟 總裁專屬：雲端代寫系統正式啟動 🌟🌟🌟
                                   // ==========================================
                                   if (sessionId) {
                                                   try {
                                                       // 🌟 總裁修正：脫殼手術
                                                       // 我們要確保存入 text 的內容是「純對話」，不帶任何 JSON 符號
                                                       let cleanDisplayText = finalResponseText;
                                                       let cleanVoiceText = finalVoiceText;

                                                       // 檢查內容是否還帶著 JSON 的殼
                                                       if (cleanDisplayText.includes('"response":')) {
                                                           try {
                                                               // 嘗試抓取 "response":"..." 之間的內容
                                                               // 使用正則表達式是最穩的，因為直通車迴圈可能會把多個 JSON 串在一起
                                                               const matches = [...cleanDisplayText.matchAll(/"response"\s*:\s*"((?:[^"\\]|\\.)*)"/g)];
                                                               if (matches.length > 0) {
                                                                   // 把所有片段組合起來，並處理反斜槓轉義
                                                                   cleanDisplayText = matches.map(m => m[1]).join("\n\n")
                                                                       .replace(/\\n/g, "\n")
                                                                       .replace(/\\"/g, '"');
                                                               }
                                                           } catch (e) {
                                                               console.error("脫殼失敗，維持原樣", e);
                                                           }
                                                       }

                                                       // 對語音文字也做同樣處理
                                                       if (cleanVoiceText.includes('"voiceText":')) {
                                                           const vMatches = [...cleanVoiceText.matchAll(/"voiceText"\s*:\s*"((?:[^"\\]|\\.)*)"/g)];
                                                           if (vMatches.length > 0) {
                                                               cleanVoiceText = vMatches.map(m => m[1]).join(" ")
                                                                   .replace(/\\n/g, " ")
                                                                   .replace(/\\"/g, '"');
                                                           }
                                                       }

                                                       const appId = body.appId || "lianlianshiguang";
                                                       const sessionRef = admin.firestore().collection('artifacts').doc(appId).collection('chat_sessions').doc(sessionId);

                                                       // ☁️ 寫入資料庫 (這會觸發您的 notifyPlayerNewMessage 推播)
                                                       await sessionRef.collection('messages').add({
                                                           sender: 'ai',
                                                           text: cleanDisplayText.trim(),      // 👈 這裡是給通知和聊天室看的「乾淨文字」
                                                           voiceText: cleanVoiceText.trim(),
                                                           type: 'text',
                                                           timestamp: admin.firestore.FieldValue.serverTimestamp(),
                                                           characterId: characterProfile.id,
                                                           characterName: name,
                                                           role: 'assistant',
                                                           content: finalResponseText          // 👈 這裡保留原始 JSON 做備份沒關係
                                                       });

                                                       // ☁️ 更新外層房間資料
                                                       await sessionRef.update({
                                                           lastMessage: cleanDisplayText.trim(), // 👈 房間列表也要顯示乾淨的文字
                                                           lastActivity: admin.firestore.FieldValue.serverTimestamp(),
                                                           friendshipScore: admin.firestore.FieldValue.increment(finalAffectionChange),
                                                           unreadCount: admin.firestore.FieldValue.increment(1)
                                                       });

                                                       console.log(`✅ [雲端代寫成功] 已經存入乾淨的文字！`);
                                                   } catch (dbError) {
                                                       console.error("🔴 [雲端代寫崩潰]:", dbError);
                                                   }
                                               }

                                   console.log(`✅ 任務完成！總字數: ${finalResponseText.length}，給了 ${finalAffectionChange} 分！`);

                                   // 最後回傳給手機端 (這必須是整個 try 區塊的最後一行！)
                                   return res.status(200).json({
                                       status: "success",
                                       response: finalResponseText,
                                       voiceText: finalVoiceText,
                                       affectionChange: finalAffectionChange
                                   });

                               } catch (error) {
                                   console.error(`❌ 任務發生災難:`, error);
                                   return res.status(500).json({ status: "error", errorMessage: error.message });
                               }
                           }); // 👈 確保有這個 cors 的結尾
                       }); // 👈 確保有這個 onRequest 的結尾

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

                          // 這個要獨立放在外面，不要被包在 getAiResponse 裡面
                          exports.translateText = onCall({ region: "asia-east1" }, async (request) => {
                              if (!request.auth) throw new HttpsError("unauthenticated", "請先登入。");
                              if (!translateClient) {
                                          translateClient = new TranslationServiceClient();
                                      }
                              const { text, targetLanguage } = request.data;
                              try {
                                  // 這裡確保你有在檔案上方定義過 translateClient
                                  let [translations] = await translateClient.translate(text, targetLanguage);
                                  return { translatedText: Array.isArray(translations) ? translations[0] : translations };
                              } catch (error) {
                                  console.error("翻譯失敗:", error);
                                  throw new HttpsError("internal", "翻譯失敗");
                              }
                          });

exports.notifyPlayerNewMessage = onDocumentCreated({
    region: "asia-east1",
    // 🌟 修正 1：對準真正的聊天室信箱路徑！（原本已正確）
    document: "artifacts/lianlianshiguang/chat_sessions/{sessionId}/messages/{messageId}",
    timeoutSeconds: 60,
    memory: "256MiB"
}, async (event) => {
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
        const sessionDoc = await admin.firestore()
            .collection('artifacts').doc('lianlianshiguang')
            .collection('chat_sessions').doc(sessionId).get();

        if (!sessionDoc.exists) return null;
        const sessionData = sessionDoc.data();
        const userId = sessionData.userId;

        // 2. 獲取玩家的 FCM Token
        const userDoc = await admin.firestore().collection("users").doc(userId).get();
        if (!userDoc.exists) return null;

        const fcmToken = userDoc.data().fcmToken;
        if (!fcmToken) {
            console.log(`玩家 ${userId} 沒有 Token，無法發送推播。`);
            return null;
        }

        let previewText = "妳收到了一則新訊息 ✨";
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
        let charName = '妳的愛人';
        let charAvatar = null;

        try {
            // ❌ 原本錯誤路徑：.collection('characters')
            // ✅ 【關鍵修正】：對準真正的角色檔案大樓
            const charDoc = await admin.firestore()
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
        const payload = {
            token: fcmToken,
            notification: {
                title: charName,    // 👈 這裡現在會顯示「程安」或「霍君耀」
                body: previewText,  // 👈 這裡現在會顯示「(視線從蛋糕移到妳...)」
                image: charAvatar   // 👈 【修正】：推播右側會顯示角色的頭像
            },
            data: {
                type: 'chat',
                characterId: String(charId),
                sessionId: String(sessionId),
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
                    aps: { sound: "default" }
                }
            }
        };

        console.log(`叮咚！準備發送推播給用戶: ${userId}，來自角色的通知: ${charName}`);
        return await admin.messaging().send(payload);

    } catch (error) {
        console.error("推播接線生發生錯誤:", error);
    }
});