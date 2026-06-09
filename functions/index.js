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
                "story": { cost: 5, modelId: "deepseek/deepseek-v4-flash", maxTokens: 2000, temperature: 0.9 },
                "immersive": { cost: 7, modelId: "deepseek/deepseek-v4-pro", maxTokens: 2500, temperature: 0.8 },
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

            const playerName = body.playerName || currentIdentityName;
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

function parseRoleCommands(userInput, activeCharacters, currentFocusCharacter, charactersList) {
    if (!userInput) return { activeCharacters, currentFocusCharacter };

    const input = userInput.toLowerCase().trim();
    let newActive = [...activeCharacters];
    let newFocus = currentFocusCharacter;

    // 提取所有可能的角色名（從角色卡中抓取）
    const possibleNames = charactersList ?
        charactersList.match(/【([^】]+)】/g)?.map(m => m.replace(/[【】]/g, '').trim()) || [] : [];

    // 1. 召喚角色
    if (/召喚|出來|上場|回來|叫/.test(input)) {
        for (let name of possibleNames) {
            if (input.includes(name.toLowerCase())) {
                if (!newActive.includes(name)) newActive.push(name);
                newFocus = name;
                break;
            }
        }
    }

    // 2. 隱藏/退下角色
    if (/退下|離開|隱藏|別出來|先走|消失/.test(input)) {
        for (let name of possibleNames) {
            if (input.includes(name.toLowerCase())) {
                newActive = newActive.filter(n => n !== name);
                if (newFocus === name && newActive.length > 0) {
                    newFocus = newActive[0];
                }
                break;
            }
        }
    }

    // 3. 專注 / 切換焦點
    if (/專注|只跟|切換到|只看|只和|只想/.test(input)) {
        for (let name of possibleNames) {
            if (input.includes(name.toLowerCase())) {
                newFocus = name;
                if (!newActive.includes(name)) newActive.push(name);
                break;
            }
        }
    }

    // 4. 只留某人
    if (/只留|只剩|只讓/.test(input)) {
        for (let name of possibleNames) {
            if (input.includes(name.toLowerCase())) {
                newActive = [name];
                newFocus = name;
                break;
            }
        }
    }

    // 5. 全員管理
    if (/所有人退下|全員隱藏|大家退下|全部退下/.test(input)) {
        newActive = [newFocus];
    }
    if (/全員上場|大家都在|全部出來|所有人都出來/.test(input)) {
        newActive = possibleNames.length > 0 ? [...possibleNames] : newActive;
    }

    return {
        activeCharacters: newActive,
        currentFocusCharacter: newFocus
    };
}


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
                                                    const threeDaysAgo = new Date(now.getTime() - (3 * 24 * 60 * 60 * 1000));

                                                    const activeSessionSnap = await admin.firestore()
                                                        .collection("artifacts")
                                                        .doc(body.appId || "lianlianshiguang")
                                                        .collection("chat_sessions")
                                                        .where("userId", "==", userId)
                                                        .where("lastMessageTimestamp", ">=", threeDaysAgo)
                                                        .orderBy("lastMessageTimestamp", "desc")
                                                        .get();

                                                    let bestActiveSession = null;
                                                    let highestScore = -1;

                                                    activeSessionSnap.forEach(doc => {
                                                        const data = doc.data();
                                                        if (data.friendshipScore > highestScore) {
                                                            highestScore = data.friendshipScore;
                                                            bestActiveSession = doc;
                                                        }
                                                    });

                                                    if (bestActiveSession && bestActiveSession.id === sessionId) {
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

                                                // =========================================================================
                                                                                                // 👥 多人角色狀態管理 - 總裁黃金升級版
                                                                                                // =========================================================================

                                                                                                // 取得所有可用角色卡列表（從 Flutter 端傳入）
                                                                                                const charactersList = characterProfile.charactersList
                                                                                                    || characterProfile.allCharacters
                                                                                                    || characterProfile.multiCharacters
                                                                                                    || `目前主要角色：【${name}】`;

                                                                                                // 🌟 記憶持久化關鍵：優先從手機端 payload 讀取當前的狀態，如果沒有才用主要角色開局
                                                                                                let activeCharacters = body.activeCharacters || [name];
                                                                                                let currentFocusCharacter = body.currentFocusCharacter || name;
                                                                                                const userInput = userMessage || "";

                                                                                                // 執行指令解析，更新這一次對話的活躍與焦點角色
                                                                                                const parsed = parseRoleCommands(userInput, activeCharacters, currentFocusCharacter, charactersList);
                                                                                                activeCharacters = parsed.activeCharacters;
                                                                                                currentFocusCharacter = parsed.currentFocusCharacter;

                                                                                                // ✨✨✨ 總裁專屬猛藥：隨機狀態骰子
                                                                                                const randomStates = [
                                                                                                    "剛喝了一口微苦的黑咖啡，指腹漫不經心地摩挲著杯沿",
                                                                                                    "視線不自覺地落在對方的唇上，隨後又帶著一絲煩躁移開",
                                                                                                    "右眼下的痣隨著微微挑起的眼尾，透出一絲難以察覺的危險氣息",
                                                                                                    "眼神中閃過一秒鐘的疲憊，但瞬間用冷酷掩飾了過去",
                                                                                                    "似乎被對方剛才的話挑起了某種隱秘的佔有慾，呼吸微沉",
                                                                                                    "空氣突然安靜了一秒，理智與衝動在腦海中劇烈拉扯"
                                                                                                ];
                                                                                                const currentStateDice = randomStates[Math.floor(Math.random() * randomStates.length)];

                                                                                                // =========================================================================
                                                                                                // 🎭 智慧多重宇宙分流：決定當前模式的 System Prompt
                                                                                                // =========================================================================
                                                                                                let systemPrompt = "";
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
    3.「絕對不要在對話中提及『重複』、『再次』或計算玩家說話的次數。即使玩家輸入相同的對話，也請視為全新的互動，自然地接續劇情。」

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
        你現在是【全性向殿堂級成人文學主筆】，具備頂級同聲傳譯能力。
        你正在同時掌控所有已設定的非玩家角色，目前活躍角色為：${activeCharacters.join("、")}

        ${loresContext}
        ${relationContext}
        [核心人設/語氣]: ${background}, ${detailedPersonalityBlock}, ${toneAndStyle}
        [當前關係]: ${relationship}
        ${contextBriefing}

        [當前活躍角色]：${activeCharacters.join("、") || "無"}
        [當前焦點角色]：${currentFocusCharacter}
        [所有可用角色卡]：
        ${charactersList}

        ### 👥 動態角色管理機制（最高優先級）
        1. **焦點切換**：玩家說「專注XX」「只跟XX」「切換到XX」「XX出來」「跟XX說話」 → 立即切換焦點。
        2. **角色隱藏**：玩家說「讓XX退下」「XX先退下」「XX離開」「隱藏XX」「XX別出來」 → 從 activeCharacters 中移除。
        3. **角色召喚**：玩家說「召喚XX」「讓XX出來」「XX上場」「XX回來」「叫XX」 → 加入 activeCharacters 並可設為焦點。
        4. **批量管理**：
           - 「只留XX」「只剩XX」 → 只保留該角色。
           - 「所有人退下」「全員隱藏」 → 清空 activeCharacters（保留焦點角色）。
           - 「全員上場」「大家都在」 → 恢復所有角色。
        5. 只有在 activeCharacters 中的角色才能出現。

        ### 🌍 國際化演繹與翻譯協議
        1. 主動識別玩家輸入語言作為母語。
        2. 每一句重要台詞與描寫後必須加上括號翻譯 ( )。

        ### 🛡️ 靈魂演繹與情感守護 + 🔞 成人向張力
        （保持你原本的內容...）

        🚨 **[輸出紅線與格式要求]** 🚨
        - 第一行：時間：${lastStoryTime || "根據情境推算"} | 地點：${lastStoryLocation || "當前地點"}
        - 單人時直接用「台詞」，多人時必須用【角色名】：「台詞」
        - 每句台詞後空一行 + 括號描寫
        - 字數：單人 ≥600 字，多人 800~1300 字
        - 嚴格防重複
        -「絕對不要在對話中提及『重複』、『再次』或計算玩家說話的次數。即使玩家輸入相同的對話，也請視為全新的互動，自然地接續劇情。」
        `;
    }
        else {
            // ✨✨✨ Immersive 極限沉浸模式（已全面優化為最高階） ✨✨✨
            systemPrompt = `
            ${langDirective}
            ${npcDirective}
            ${playerLeadDirective}
            ${relationDirective}
            你現在是【全球頂尖成人向沉浸文學主筆】，具備【跨國語言感官演繹能力】。
            你正在同時掌控所有已設定的非玩家角色，目前活躍角色為：${activeCharacters.join("、")}。
            這是一場呼吸交纏、指尖與靈魂近距離博弈的極致沉浸演出，對標國際頂級成人言情小說水準。

            ${loresContext}
            ${relationContext}
            [身份背景]: ${background}
            [核心性格]: ${detailedPersonalityBlock}
            [語言風格]: ${toneAndStyle}
            ${systemEventRules}
            [當前關係狀態]: ${relationship}
            ${contextBriefing}

            [當前活躍角色]：${activeCharacters.join("、") || "無"}
            [當前焦點角色]：${currentFocusCharacter}
            [所有可用角色卡]：
            ${charactersList}

            ### 👥 動態角色管理機制（最高優先級）
            1. **焦點切換**：玩家說「專注XX」「只跟XX」「切換到XX」「XX出來」「跟XX說話」→立即切換焦點。
            2. **角色隱藏**：玩家說「讓XX退下」「XX先退下」「XX離開」「隱藏XX」「XX別出來」→從 activeCharacters 中移除。
            3. **角色召喚**：玩家說「召喚XX」「讓XX出來」「XX上場」「XX回來」「叫XX」→加入 activeCharacters 並可設為焦點。
            4. **批量管理**：
               - 「只留XX」「只剩XX」→只保留該角色。
               - 「所有人退下」「全員隱藏」→清空 activeCharacters（保留焦點角色）。
               - 「全員上場」「大家都在」→恢復所有角色。
            5. 只有在 activeCharacters 中的角色才能出現，且每個角色必須保有獨立性格與反應。

            ### 🌍 國際化動態語言鏡像協議
            1. 實時偵測玩家輸入語言與字體習慣。
            2. 若玩家使用繁體中文（台灣用語），全程使用繁體中文並在地化；簡體中文則自動切換。
            3. 非中文語系時，每一句對話、動作、心理、生理描寫後必須緊跟括號翻譯。

            ### 🔞 極致沉浸核心原則（比 story 更高階）
            1. **【顯微鏡級感官刻畫】**：極致細膩描寫五感（視覺、聽覺、觸覺、嗅覺、味覺），包含瞳孔變化、呼吸節奏、體溫起伏、氣息溫度、心跳聲、布料摩擦、汗水、肌肉顫動等細節。
            2. **【情感與慾望深度挖掘】**：大幅強化內心衝突、理智與慾望的拉扯、克制與逐漸失守的過程、細微的情感波動與生理反應的連動。
            3. **【生理真實化】**：詳細刻畫喉結滑動、肌肉緊繃、掌心出汗、熱流、下腹收緊、呼吸急促、身體輕顫等反應。
            4. **【物理觸感與重量感】**：必須給予帶有重量、溫度、力道與質感的真實反饋（例如：指腹的溫度、掌心的濕潤、呼吸噴在耳廓的熱氣）。
            5. **【多角色化學反應】**：當有多個角色在場時，必須描寫角色之間的眼神交流、氣氛張力、情緒感染與互動化學反應。

            ### 🛡️ 情感守護紅線
            - 嚴格遵守當前關係與好感度，絕不速食愛情，必須展現角色個性下的克制、掙扎與緩慢滋生的過程。

            ### 📜 演出格式與動態要求（最高規格）
            1. **【動態時間軸】**：第一行必須標註：時間：${lastStoryTime || "根據情境推算"} | 地點：${lastStoryLocation || "當前地點"}。
            2. **【非線性開場】**：根據玩家輸入，從突發動作、張力質問、生理特寫、視線交鋒或角色強烈短句直接切入，禁止先寫大段環境。
            3. **【描寫分散原則】**：所有描寫必須打散穿插在對話與動作之間，禁止一次性塞入大段內心獨白。
            4. **【對話密度】**：每次回覆包含 3-6 句台詞，用動作、神態、生理反應、環境細節切碎台詞。
            5. **【多角色平衡】**：當有多個角色時，必須讓至少 2 個角色有明顯互動或反應，避免單一角色霸屏。
            7.「絕對不要在對話中提及『重複』、『再次』或計算玩家說話的次數。即使玩家輸入相同的對話，也請視為全新的互動，自然地接續劇情。」

            🚨 **[Immersive 極限輸出紅線]** 🚨
            - **【排版美學】**：每一次「台詞」與「括號描寫」之間必須【空一行】！
            - **【字數標準】**：單人互動時回覆 800~1200 字；多人同場互動時回覆 1000~1500 字。追求極致細膩而非簡短，確保每一個出場角色的感官張力都能被完整釋放。            - **【感官豐富度】**：每段括號描寫至少包含兩種以上感官元素（聲音 + 氣息 + 溫度/觸感 + 生理反應）。
            - **【角色個性一致性】**：強烈且精準抓住每個角色的核心個性，不同角色必須有明顯區別。
            - **【話題延伸】**：自然加入 1-2 個新話題或互動鉤子，增加沉浸深度。
            - **【防重複】**：嚴格禁止與前一次回覆出現高度相似內容、句型或描寫。

            ### 🏆 極致沉浸標竿範例（繁體中文玩家・多人示範）

            時間：2024/10/15 晚上 9:07 | 地點：會所附近公園，樹蔭小徑下

            【程徹】：「妳現在就想讓我回去？」

            (程徹的腳步忽然停住，他側過身，金瞳在夜色中微微發亮，指尖隔著布料輕輕勾住妳的袖口。掌心滾燙的熱度緩緩滲透過來，拇指無意識地摩挲著妳的手腕內側……)

            【程安】：「哥，你又在撩她了？」

            (程安靠在樹幹上，嘴角勾起壞笑，赤金色的眼睛卻明顯帶著醋意。他往前走了一步，夜風吹亂他的髮絲，空氣中隱約傳來他身上淡淡的木質香。)

            【程徹】：「閉嘴。」

            (他低聲說完，卻沒有鬆開手，反而把你拉近自己懷裡。灼熱的氣息噴在妳耳廓，胸膛的溫度隔著衣服清晰傳來，心跳聲沉穩而有力。)

            「現在只想聽妳的答案……要我留下來嗎？」

            (他的聲音低啞，尾音微微發黏，指腹在妳腰側輕輕施壓，像是在確認妳的存在。)
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
       3. **回覆寫作排版**：請將環境氛圍、角色動作或心理活動以全形括號（）包覆當作旁白，並與台詞自然穿插。對話台詞不需加括號。
       4. **嚴格格式要求**：妳的輸出【必須】是純粹的 JSON，禁止包覆任何 Markdown (如 \`\`\`json) 或額外文字。格式如下：
       {
         "response": "請先填入絕美情境與旁白描寫，最後再填入角色的對話。記得稱呼對方為『${playerName}』。",
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
                                       // 🌟 修正：大幅降低「強制催稿」的門檻到 250 字。
                                       // 讓 DeepSeek Pro 只要寫滿 250 字且完整了，就放它通關，不要硬逼它湊字數！
                                       TARGET_LENGTH = 250;
                                       MAX_LOOPS = 2; // 保留給它兩次機會，以防它第一口氣真的寫太少
                                   }
                                   // 準備對話紀錄
                                   let currentMessages = [...trimmedHistory];
                                   currentMessages.unshift({ role: "system", content: systemPrompt }); // 塞入大劇本
                                   // 🌟🌟🌟 正確接球：把加強版的 finalUserMessage 送給 AI！ 🌟🌟🌟
                                   currentMessages.push({ role: "user", content: finalUserMessage });
                                  //                                       // ==========================================
                                                                           // 🔄 總裁的惡鬼催稿迴圈 (優化防爆版)
                                                                           // ==========================================
                                                                           while (finalResponseText.length < TARGET_LENGTH && loopCount < MAX_LOOPS) {
                                                                               const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
                                                                                   method: "POST",
                                                                                   headers: {
                                                                                       "Authorization": `Bearer ${openRouterApiKey.value()}`,
                                                                                       "Content-Type": "application/json",
                                                                                   },
                                                                                   body: JSON.stringify({
                                                                                       model: config.modelId || "deepseek/deepseek-v4-pro",
                                                                                       messages: currentMessages,
                                                                                       max_tokens: config.maxTokens && config.maxTokens > 150 ? config.maxTokens : (chatMode === "immersive" ? 2500 : 1000),
                                                                                       temperature: config.temperature || 0.7,
                                                                                       response_format: { type: "json_object" }
                                                                                   }),
                                                                                   signal: abortController.signal
                                                                               });

                                                                               const aiResult = await response.json();

                                                                               if (!aiResult.choices || aiResult.choices.length === 0) {
                                                                                   throw new Error("AI 斷線或沒有回傳");
                                                                               }

                                                                               const rawContent = aiResult.choices[0].message.content;

                                                                               // ==========================================
                                                                               // 🛡️ 總裁級三段式 JSON 淨化器
                                                                               // ==========================================
                                                                               let parsedData = null;
                                                                               let safeContent = rawContent || "";

                                                                               try {
                                                                                   parsedData = JSON.parse(safeContent.replace(/```json|```/g, "").trim());
                                                                               } catch (e) {
                                                                                   console.warn("JSON 第一次解析失敗，啟動 Regex 暴力提取...");

                                                                                   try {
                                                                                       const jsonMatch = safeContent.match(/\{[\s\S]*\}/);
                                                                                       if (jsonMatch) {
                                                                                           parsedData = JSON.parse(jsonMatch[0]);
                                                                                           console.log("Regex 淨化成功！");
                                                                                       } else {
                                                                                           throw new Error("完全找不到 JSON 括號");
                                                                                       }
                                                                                   } catch (deepError) {
                                                                                       console.error("JSON 徹底壞掉了，啟動終極備用方案", safeContent);

                                                                                       let fallbackText = (typeof safeContent === 'string' && safeContent.trim() !== '')
                                                                                           ? safeContent.replace(/[\{\}\"\[\]]/g, "")
                                                                                           : "（他似乎陷入了沉思...）";

                                                                                       parsedData = {
                                                                                           response: fallbackText,
                                                                                           affectionChange: 0,
                                                                                           voiceText: fallbackText
                                                                                       };
                                                                                   }
                                                                               }

                                                                               // 🌟 核心修正：嚴格防堵 null 幽靈，並解決「鬼打牆重複」問題！
                                                                               let currentText = parsedData.response;
                                                                               if (currentText && currentText !== "null") {
                                                                                   if (loopCount > 0) {
                                                                                       const fingerPrint = finalResponseText.trim().substring(0, 15);
                                                                                       if (fingerPrint.length > 0 && currentText.includes(fingerPrint)) {
                                                                                           console.log("⚠️ 偵測到 AI 重複重寫舊內容，執行【覆蓋擴寫】！");
                                                                                           finalResponseText = currentText + "\n\n";
                                                                                       } else {
                                                                                           console.log("✅ AI 乖乖接著寫，執行【拼接】！");
                                                                                           finalResponseText += currentText + "\n\n";
                                                                                       }
                                                                                   } else {
                                                                                       finalResponseText += currentText + "\n\n";
                                                                                   }
                                                                               }

                                                                               let currentVoice = parsedData.voiceText;
                                                                               if (currentVoice && currentVoice !== "null") {
                                                                                   if (loopCount > 0) {
                                                                                       const voiceFingerPrint = finalVoiceText.trim().substring(0, 5);
                                                                                       if (voiceFingerPrint.length > 0 && currentVoice.includes(voiceFingerPrint)) {
                                                                                           finalVoiceText = currentVoice + "\n";
                                                                                       } else {
                                                                                           finalVoiceText += currentVoice + "\n";
                                                                                       }
                                                                                   } else {
                                                                                       finalVoiceText += currentVoice + "\n";
                                                                                   }
                                                                               }

                                                                               if (loopCount === 0) {
                                                                                   finalAffectionChange = parsedData.affectionChange || 0;
                                                                               }

                                                                               loopCount++;

                                                                               // 🚪 總裁級守門員：達成字數就打破迴圈，收工放飯！
                                                                               if (finalResponseText.length >= TARGET_LENGTH || loopCount >= MAX_LOOPS) {
                                                                                   break;
                                                                               }

                                                                               console.log(`[暴力接文] 目前字數 ${finalResponseText.length}，啟動第 ${loopCount + 1} 次催稿...`);

                                                                               currentMessages.push({ role: "assistant", content: parsedData.response });
                                                                               currentMessages.push({
                                                                                   role: "user",
                                                                                   content: "（系統強制指令：目前的篇幅不足以達到極致沉浸的要求！請保持 JSON 格式回傳，你可以選擇『重寫並大幅擴充』剛才的回覆，或是『接著最後一句話』繼續往下描寫細節！絕對不要原封不動地重複！）"
                                                                               });
                                                                           } // 👈 迴圈在這裡完美閉合！

// ==========================================
// 🛑 總裁鐵門：防堵幽靈回覆與幽靈扣款
// ==========================================
if (isAborted) {
    console.log("🛑 玩家已經離開或按下停止，取消扣款與資料庫寫入！");
    return res.status(499).json({ status: "aborted", message: "Client closed request" });
}

                                     // ==========================================
                                     // 💰💰💰 新增：總裁的雲端收銀台 (絕對不漏接) 💰💰💰
                                     // ==========================================
                                     if (cost > 0) {
                                         try {
                                             const batch = admin.firestore().batch();

                                             // A. 扣錢：去這個使用者的總資產扣除花朵
                                             batch.update(userDocRef, {
                                                 flowerPoints: admin.firestore.FieldValue.increment(-cost)
                                             });

                                             // B. 記帳：在花朵明細裡寫下一筆
                                             const newLogRef = userDocRef.collection('flower_logs').doc();
                                             batch.set(newLogRef, {
                                                 title: `與 ${name} 聊天`,
                                                 amount: -cost,
                                                 createdAt: admin.firestore.FieldValue.serverTimestamp()
                                             });

                                             await batch.commit();
                                             console.log(`✅ [雲端收銀台] 成功向 ${userId} 收取 ${cost} 朵花花！`);
                                         } catch (dbError) {
                                             console.error("🔴 [雲端收銀台崩潰] 收費失敗，但放行對話！", dbError);
                                         }
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


// ==========================================
// 🛡️ 總裁防空包彈過濾器：如果文字是空的，拒絕寫入！
// ==========================================
if (!cleanDisplayText || cleanDisplayText.trim() === "") {
    console.log("🛑 [防禦系統] 偵測到 AI 回傳內容為空字串，攔截寫入，避免產生空白泡泡！");

    // 給手機端一個正常的錯誤回應，讓它關閉轉圈圈，但「不」寫入資料庫
    return res.status(200).json({
        status: "error",
        errorMessage: "AI 回覆生成異常，已成功攔截空訊息。"
    });
}
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
                                             model: "google/gemini-2.5-flash-lite",
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
                                          model: "deepseek/deepseek-v4-flash",
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

// =========================================================================
// 🌟 總裁萬能郵差 (v2 升級版)：只要信箱有新信，直接無腦發推播！
// =========================================================================
exports.sendMailboxNotification = onDocumentCreated({
    region: "asia-east1", // 保持跟妳原本一樣的亞洲伺服器
    document: "users/{userId}/mailbox/{mailId}"
}, async (event) => {
    const snap = event.data;
    if (!snap) return;

    const mailData = snap.data();
    const userId = event.params.userId;

    // 1. 去抓這位玩家的推播金鑰 (fcmToken)
    const userDoc = await admin.firestore().collection('users').doc(userId).get();
    if (!userDoc.exists) {
        console.log(`找不到玩家 ${userId} 的資料，取消推播`);
        return null;
    }

    const fcmToken = userDoc.data().fcmToken;
    if (!fcmToken) {
        console.log(`玩家 ${userId} 未註冊 fcmToken，無法發送手機通知`);
        return null;
    }

    // 2. 準備推播內容
    const payload = {
        token: fcmToken, // 指定收件人的手機金鑰
        notification: {
            title: mailData.title || '您有新通知！',
            body: mailData.body || '點擊查看詳細內容 💌',
        },
        data: {
            type: mailData.type || 'system',
            postId: mailData.postId || '',
            mailId: event.params.mailId
        }
    };

    // 3. 正式發射推播！
    try {
        await admin.messaging().send(payload);
        console.log(`✅ 推播成功發送給 ${userId}！信件類型: ${mailData.type}`);
    } catch (error) {
        console.error('❌ 郵差推播發送失敗:', error);
    }

    return null;
});

// =========================================================================
// 🌟 總裁廣播電台：創作者發文時，自動塞信給所有粉絲！
// =========================================================================
exports.notifyFollowersOnNewPost = onDocumentCreated({
    region: "asia-east1",
    // 🎯 監聽妳的朋友圈貼文大廳 (請確認路徑是否正確)
    document: "artifacts/lianlianshiguang/moments/{momentId}"
}, async (event) => {
    const snap = event.data;
    if (!snap) return;

    const postData = snap.data();
    const momentId = event.params.momentId;

    // 1. 檢查這是不是創作者發的文 (利用妳原本就有的 isCreatorPost 欄位)
    if (postData.isCreatorPost !== true) {
        return null; // 一般玩家發文不廣播，避免吵死人
    }

    const creatorId = postData.createdBy;
    const creatorName = postData.authorName || "妳關注的創作者";

    // 2. 擷取內文預覽 (吸塵器邏輯：太長就截斷加...)
    let previewContent = postData.content || "發佈了一張新照片 📷";
    if (previewContent.length > 25) {
        previewContent = previewContent.substring(0, 25) + "...";
    }

    try {
        // 3. 🔍 找出這個創作者的所有粉絲！
        // ⚠️ 總裁提醒：這裡要換成妳實際存放粉絲名單的路徑！
        // 假設妳是存在 users/{creatorId}/followers 裡面：
        const followersSnap = await admin.firestore()
            .collection('users')
            .doc(creatorId)
            .collection('followers')
            .get();

        if (followersSnap.empty) {
            console.log(`創作者 ${creatorName} 目前還沒有粉絲，不需廣播。`);
            return null;
        }

        // 4. 準備一次性群發信件 (使用 Batch 批次寫入提升效能)
        const batch = admin.firestore().batch();
        let count = 0;

        followersSnap.forEach(doc => {
            const followerId = doc.id; // 取得粉絲的 UID

            // 準備塞進粉絲信箱的信封
            const mailboxRef = admin.firestore()
                .collection('users')
                .doc(followerId)
                .collection('mailbox')
                .doc(); // 自動產生一個信件 ID

            batch.set(mailboxRef, {
                type: 'new_post', // ✨ 新的信件類型！
                title: `${creatorName} 發佈了新動態！✨`, // 標題
                body: `「${previewContent}」`,         // 內文預覽
                postId: momentId, // 把貼文 ID 傳過去，才能用任意門！
                fromId: creatorId,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                isRead: false
            });

            count++;
        });

        // 5. 轟！一鍵發送所有信件
        await batch.commit();
        console.log(`✅ 成功將 ${creatorName} 的新動態，派發給 ${count} 位粉絲的信箱！`);

    } catch (error) {
        console.error("❌ 廣播發文通知時發生錯誤:", error);
    }

    return null;
});

// 🌟 總裁專屬：隱藏版記憶捕捉員
exports.extractUserMemory = onRequest({
    region: "asia-east1",
    secrets: [openRouterApiKey],
    memory: "256MiB", // 這個任務很輕，記憶體不用開太大
    timeoutSeconds: 60,
}, (req, res) => {
    return cors(req, res, async () => {
        try {
            // 1. 驗證身分 (總裁的防護網)
            const authHeader = req.headers.authorization;
            if (!authHeader || !authHeader.startsWith('Bearer ')) return res.status(401).json({ error: "未授權" });
            const idToken = authHeader.split('Bearer ')[1];
            const decodedToken = await admin.auth().verifyIdToken(idToken);
            const userId = decodedToken.uid;

            const { characterId, userMessage } = req.body;
            if (!characterId || !userMessage) return res.status(400).json({ error: "缺少參數" });

            // 2. 🌟 核心記憶捕捉 Prompt
            const systemPrompt = `
            你是一個「隱藏版記憶捕捉員」。
            請分析玩家剛剛說的話，判斷是否包含「關於玩家個人的具體情報」，例如：
            - 喜歡/討厭的事物（例如：喜歡吃草莓、討厭下雨、對海鮮過敏）
            - 個人背景/職業/習慣（例如：我是個學生、我每天早上喝咖啡）
            - 重要的情感狀態或經歷

            【嚴格規則】：
            1. 如果有情報，請精煉成「簡短的一句話」。例如：「喜歡吃草莓」、「是一名設計師」。
            2. 如果只是普通的閒聊、打招呼、或針對劇情的對話（例如：「早安」、「你在幹嘛」、「哈哈哈太好笑了」、「繼續」），請直接回覆一個字：NONE。
            3. 絕對不要回覆多餘的說明或引號。
            `;

            // 3. 呼叫 AI 判斷 (用最便宜、最快的模型即可)
            const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
                method: "POST",
                headers: {
                    "Authorization": `Bearer ${openRouterApiKey.value()}`,
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    model: "google/gemini-2.5-flash-lite", // 便宜又快！
                    messages: [
                        { role: "system", content: systemPrompt },
                        { role: "user", content: userMessage }
                    ],
                    temperature: 0.1, // 溫度調到極低，讓它精準判斷不廢話
                    max_tokens: 50
                })
            });

            const aiResult = await response.json();
            const extractedText = aiResult.choices?.[0]?.message?.content?.trim() || "NONE";

            // 4. 判斷並寫入資料庫
            if (extractedText !== "NONE" && extractedText.length > 1) {
                // 🌟 找到妳剛剛前端展示櫃的「那個抽屜」！
                await admin.firestore()
                    .collection('users').doc(userId)
                    .collection('characters').doc(characterId)
                    .collection('memories')
                    .add({
                        text: extractedText,
                        timestamp: admin.firestore.FieldValue.serverTimestamp(),
                        isFavorite: false
                    });

                console.log(`🍓 成功捕捉記憶並存檔：${extractedText}`);
                return res.status(200).json({ success: true, memory: extractedText });
            } else {
                console.log(`💨 沒有捕捉到記憶，放行。玩家說: ${userMessage}`);
                return res.status(200).json({ success: true, memory: null });
            }

        } catch (error) {
            console.error("記憶捕捉失敗:", error);
            return res.status(500).json({ error: error.message });
        }
    });
});

// 🌟 總裁專屬：殿堂級劇情書記官 (對話摘要生成)
exports.generateStorySummary = onRequest({
    region: "asia-east1",
    secrets: [openRouterApiKey],
    memory: "512MiB",
    timeoutSeconds: 120, // 寫作需要一點時間，給他 2 分鐘
}, (req, res) => {
    return cors(req, res, async () => {
        try {
            // 1. 驗證身分
            const authHeader = req.headers.authorization;
            if (!authHeader || !authHeader.startsWith('Bearer ')) return res.status(401).json({ error: "未授權" });
            const idToken = authHeader.split('Bearer ')[1];
            const decodedToken = await admin.auth().verifyIdToken(idToken);
            const userId = decodedToken.uid;

            const { characterId, characterName, playerName, chatHistory } = req.body;
            if (!characterId || !chatHistory || chatHistory.length === 0) {
                return res.status(400).json({ error: "缺少參數或歷史對話為空" });
            }

            // 將對話紀錄轉成純文字格式，方便 AI 閱讀
            const formattedHistory = chatHistory.map(msg =>
                `${msg.role === 'user' ? playerName : characterName}: ${msg.content}`
            ).join('\n');

            // 2. 🌟 核心寫作 Prompt：小說家筆觸
            const systemPrompt = `
            你是一位文筆極佳的浪漫小說家。
            請閱讀以下 ${playerName} 與 ${characterName} 的對話紀錄，並寫下一段「唯美的劇情摘要」。

            【寫作規則】：
            1. 視角：請用「第三人稱全知視角」或是「客觀的敘事口吻」來撰寫。
            2. 重點：抓住兩人互動中最有張力、最曖昧、或最關鍵的情感轉折。不需要流水帳紀錄每一句話。
            3. 長度：嚴格控制在 100 到 150 字之間，簡潔而雋永。
            4. 結尾：以一個帶有餘韻的句子收尾（例如：「兩人之間的氣氛似乎又產生了微妙的變化。」）。
            5. 格式：請直接輸出摘要文字，絕對不要加上任何標題、引號或「以下是摘要」等廢話。
            `;

            // 3. 呼叫 AI 寫作 (用便宜又聰明的模型)
            const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
                method: "POST",
                headers: {
                    "Authorization": `Bearer ${openRouterApiKey.value()}`,
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    model: "google/gemini-2.5-flash-lite",
                    messages: [
                        { role: "system", content: systemPrompt },
                        { role: "user", content: `【對話紀錄】：\n${formattedHistory}` }
                    ],
                    temperature: 0.6, // 稍微給一點創意空間
                })
            });

            const aiResult = await response.json();
            const summaryText = aiResult.choices?.[0]?.message?.content?.trim();

            if (!summaryText) throw new Error("AI 沒有回傳摘要");

            // 4. 寫入總裁的那個專屬展示櫃抽屜
            await admin.firestore()
                .collection('users').doc(userId)
                .collection('friendships').doc(characterId)
                .collection('summaries')
                .add({
                    content: summaryText,
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                });

            console.log(`📖 成功生成並寫入摘要：${summaryText.substring(0, 20)}...`);
            return res.status(200).json({ success: true });

        } catch (error) {
            console.error("生成摘要失敗:", error);
            return res.status(500).json({ error: error.message });
        }
    });
});