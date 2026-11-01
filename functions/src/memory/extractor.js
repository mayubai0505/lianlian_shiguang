'use strict';
function createMemoryExtractor({callAiWithRetry}) {
async function extractPlayerMemory({
  userMessage,
  playerName,
  chatMode = "",
  abortController,
}) {
  const cleanMessage = String(userMessage || "").trim();

  if (!cleanMessage) {
    return {
      shouldRemember: false,
      memory: "",
      category: "none",
      confidence: 0,
    };
  }

  // 系統續寫指令、圖片失敗提示等內容不做記憶分析
  if (
    cleanMessage.startsWith("【續寫指令】") ||
    cleanMessage.startsWith("【系統事件】") ||
    cleanMessage.startsWith("[玩家傳來")
  ) {
    return {
      shouldRemember: false,
      memory: "",
      category: "none",
      confidence: 0,
    };
  }

  const memorySystemPrompt = `
你是「玩家長期記憶提取器」。
${["immersive", "resonance"].includes(chatMode) ? "【沉浸／共鳴模式補充】玩家明確敘述已發生的婚姻、關係變更、重要約定、時間進展、修為境界、重要 NPC、重大事件或長期情感關係中的重要承諾，屬於目前聊天室世界線可保存的劇情事實，優先使用 session 範圍與 relationship.status、relationship.event.*、important_event.* 或 worldline.event.*。僅保存玩家明確表示已發生或已確定的事件；不得把願望、假設、AI 未經確認的台詞當成事實，切勿寫入跨角色 profile。" : ""}

你的工作不是聊天，也不能回應玩家。
你只需要判斷玩家最新一句話中，是否包含值得未來持續記住的個人資訊。

【應該記住】
1. 穩定偏好：
   - 喜歡或討厭的食物、事物、活動、類型。
   - 例如：我喜歡草莓蛋糕、我討厭香菜。

2. 個人基本資訊：
   - 職業、生日、居住地、家庭關係、寵物、長期興趣。
   - 例如：我是護理師、我的生日是 8 月 12 日。

3. 穩定習慣或明確特質：
   - 例如：我怕打雷、我不喝咖啡、我習慣晚睡。

4. 對玩家具有長期意義的重要事件：
   - 例如：下週要面試、最近剛失戀、正在準備重要考試。
   - 只有明顯會影響後續關心與陪伴時才記住。

【不應該記住】
1. 純粹當下狀態：
   - 今天很熱、我現在好睏、剛剛吃了飯。

2. 普通劇情台詞或角色扮演內容（沉浸模式中，玩家明確確認的重大世界線事件例外）。

3. 不確定、假設、玩笑、反問句。

4. AI 自己推測出來的資訊。

5. 玩家沒有明確說出的資訊。

【重要規則】
- 只能提取玩家明確表達的事實。
- 不得補充、推測或改寫成更誇張的內容。
- 記憶中的玩家稱呼，必須使用系統提供的玩家名稱。
- 例如玩家名稱是「妮妮」，就寫「妮妮喜歡吃草莓蛋糕」。
- 絕對不要使用「玩家喜歡……」這種系統式稱呼。
- 一次最多提取一項最重要的記憶。
- 若沒有值得長期保存的資訊，shouldRemember 必須是 false。
- 若 shouldRemember=true，必須同時提供 factKey 與 factValue。
- factKey 是「這條事實屬於哪一個固定欄位」的機器鍵，不可把玩家姓名、角色姓名、日期或具體值塞進 key。
- 同一件事即使說法改變，也必須盡量使用相同 factKey，讓系統能辨識更新與衝突。
- factKey 必須使用下列固定 taxonomy；不要自行創造新的第一、第二層分類。
- 固定鍵：
  - identity.name
  - identity.gender
  - identity.occupation
  - identity.birthday
  - identity.residence
  - identity.family
  - identity.pet
  - interaction.preferred_address
  - interaction.preferred_treatment
  - relationship.status
  - worldline.pregnancy_status
  - worldline.identity
- 可帶「穩定主題 slug」的鍵（第三層只能放被描述的事物，不可放喜歡/討厭/現在/每天等狀態）：
  - preference.food.<subject>
  - preference.drink.<subject>
  - preference.hobby.<subject>
  - preference.activity.<subject>
  - preference.media.<subject>
  - preference.other.<subject>
  - habit.<subject>
  - trait.<subject>
  - important_event.<subject>
  - relationship.event.<subject>
  - worldline.preference.<subject>
  - worldline.event.<subject>
- subject 一律使用簡短、穩定的小寫英文 snake_case。相同事物前後改變時必須沿用同一 subject。
- 特別例子：
  - 「我不喝咖啡」→ preference.drink.coffee
  - 「我現在每天喝咖啡」若是在更新長期習慣，仍用 preference.drink.coffee，不要改成 habit.coffee。
  - 「我討厭草莓蛋糕」與「我現在最喜歡草莓蛋糕」→ 都用 preference.food.strawberry_cake。
  - 「我是學生」與「我畢業後成為咖啡師」→ 都用 identity.occupation。
  - 「叫我小滿」與「以後叫我阿滿」→ 都用 interaction.preferred_address。
  - 若是一般、跨聊天室成立的稱呼（例如「大家都叫我阿滿」「叫我小滿就好」）→ scope=profile。
  - 若是目前角色／目前聊天室專屬稱呼（例如「我喜歡你叫我寶寶」「你叫我老婆」「不要叫我寶寶，叫名字」）→ scope=session。
  - 「我們結婚了」與「我們決定離婚」→ 都用 relationship.status；事件本身若另有長期意義才用 relationship.event.<subject>。
  - scope 只表示「這個事實在哪裡成立」，不要把 scope 重複編進 factKey。
  - 「在這個世界裡我很愛甜食」→ scope=session，但 factKey 仍是 preference.food.sweets，不要輸出 worldline.preference.sweets。
  - 只要已有 identity / preference / habit / interaction / relationship 等語意鍵可用，就優先使用語意鍵；worldline.* 僅保留給沒有其他 canonical semantic key 可表達的世界線事實。
  - 「我懷孕了」→ worldline.pregnancy_status。
- 禁止輸出 personal.job、habit.alcohol、relationship.preferred_name、story.relationship_status、story.pregnancy_status 等舊式自由鍵。
- factValue 是這條事實目前的簡潔值，例如「咖啡師」「不喝」「喜歡」「阿滿」「已婚」「離婚」「懷孕」。
- 只回傳合法 JSON，不要加入 Markdown 或說明。

【記憶範圍判斷】
- profile：只在明確是玩家穩定、自身、跨角色都成立的事實時使用。
  例：我是咖啡師、我對花生過敏、我固定不喝酒。
- character：只對目前這個角色有意義、而且應跨該角色不同聊天室共享的長期記憶。
  例：我最喜歡你做的草莓蛋糕、我一直很信任你。
- session：只在目前聊天室／世界線成立的劇情事實與稱呼。
  例：我們昨天結婚了、在這個世界裡我不吃甜食、我現在懷孕了、我喜歡你在這裡叫我寶寶。
- none：一次性、模糊、玩笑、當下狀態，或不值得長期保存。

判斷原則：
- 「我今天想吃草莓蛋糕」只是當下需求，不是穩定偏好，scope 應為 none。
- 「我現在最喜歡草莓蛋糕」中的「現在」是在更新長期偏好，不是短暫狀態；scope 應為 profile。
- 「最喜歡／最愛／討厭／不喜歡／不吃／不喝／每天／固定／習慣」等明確穩定語意，若沒有角色或世界線限定，優先視為 profile。
- 只有「今天／剛剛／突然／今晚／這次／現在想……」這類純當下需求才應判為 none。
- 若無法確定是全域穩定事實，寧可選 character 或 session，不要誤放 profile。
- 一次最多提取一項最重要的記憶。

輸出要求：
- 只輸出一個合法 JSON object。
- 禁止任何前言、解釋、Markdown、程式碼框或「Here is...」之類文字。
- 即使 shouldRemember=false，也必須輸出完整 JSON 結構。

輸出格式：
{
  "shouldRemember": true 或 false,
  "memory": "${playerName || "對方"}喜歡吃草莓蛋糕。",
  "scope": "profile | character | session | none",
  "category": "preference | personal | habit | relationship | story_state | important_event | none",
  "factKey": "preference.food.strawberry_cake",
  "factValue": "喜歡",
  "confidence": 0 到 1
}
`;

  const requestBody = {
    messages: [
      {
        role: "system",
        content: memorySystemPrompt,
      },
      {
        role: "user",
        content: `需要記憶的人名：${playerName || "對方"}\n最新訊息：${cleanMessage}`,
      },
    ],
    max_tokens: 400,
    temperature: 0,
    response_format: {
      type: "json_object",
    },
  };

  try {
    const result = await callAiWithRetry({
      // 使用便宜、快速的模型即可
      modelId: "google/gemini-2.5-flash-lite",
      fallbackModelId: "deepseek/deepseek-v4-flash",
      abortController,
      timeoutMs: 20_000,
      requestBody,
    });

    const parseMemoryJson = (value) => {
      const cleaned = String(value || "")
        .replace(/```json/gi, "")
        .replace(/```/g, "")
        .trim();

      if (!cleaned) {
        throw new Error("EMPTY_MEMORY_EXTRACTOR_OUTPUT");
      }

      const start = cleaned.indexOf("{");
      const end = cleaned.lastIndexOf("}");
      if (start < 0 || end <= start) {
        throw new Error(
          `INVALID_MEMORY_EXTRACTOR_JSON: ${cleaned.slice(0, 160)}`
        );
      }

      return JSON.parse(cleaned.slice(start, end + 1));
    };

    let parsed;

    try {
      parsed = parseMemoryJson(
        result?.choices?.[0]?.message?.content || ""
      );
    } catch (firstParseError) {
      console.warn(
        "⚠️ Gemini 記憶提取輸出不是合法 JSON，改用 DeepSeek 重試一次：",
        {
          finishReason: result?.choices?.[0]?.finish_reason || "",
          preview: String(
            result?.choices?.[0]?.message?.content || ""
          ).slice(0, 180),
          error: firstParseError?.message || String(firstParseError),
        }
      );

      const retryResult = await callAiWithRetry({
        modelId: "deepseek/deepseek-v4-flash",
        fallbackModelId: "deepseek/deepseek-v4-flash",
        abortController,
        timeoutMs: 20_000,
        requestBody: {
          ...requestBody,
          max_tokens: 400,
          messages: [
            {
              role: "system",
              content:
                memorySystemPrompt +
                "\n\n【最高格式要求】只輸出一個合法 JSON object；禁止前言、說明、Markdown 或程式碼框。",
            },
            {
              role: "user",
              content: `需要記憶的人名：${playerName || "對方"}\n最新訊息：${cleanMessage}`,
            },
          ],
        },
      });

      parsed = parseMemoryJson(
        retryResult?.choices?.[0]?.message?.content || ""
      );
    }

    return {
      shouldRemember: parsed.shouldRemember === true,
      memory: String(parsed.memory || "").trim(),
      scope: String(parsed.scope || "none").trim().toLowerCase(),
      category: String(parsed.category || "none").trim(),
      factKey: String(parsed.factKey || "").trim(),
      factValue: String(parsed.factValue || "").trim(),
      confidence: Number(parsed.confidence || 0),
    };
  } catch (error) {
    console.error("⚠️ 玩家記憶提取失敗：", error);

    // 記憶失敗不能影響正常聊天
    return {
      shouldRemember: false,
      memory: "",
      category: "none",
      confidence: 0,
    };
  }
}



return extractPlayerMemory;
}
module.exports = {createMemoryExtractor};
