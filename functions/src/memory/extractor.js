'use strict';
function createMemoryExtractor({callAiWithRetry}) {
async function extractPlayerMemory({
  userMessage,
  playerName,
  playerLanguage = "",
  recentHistory = [],
  assistantMessage = "",
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

  const contextText = (Array.isArray(recentHistory) ? recentHistory : []).slice(-6)
    .map(msg => `${msg.role === 'assistant' ? '角色' : '玩家'}：${String(msg.content || msg.text || '').slice(0, 1800)}`).join('\n');
  const evidenceInput = `需要記憶的人名：${playerName || "對方"}\n【前文，僅供指涉理解，不可直接當成新記憶證據】\n${contextText}\n【玩家本輪訊息，唯一允許的記憶來源】\n${cleanMessage}`;
  const memorySystemPrompt = `
你是「玩家長期記憶提取器」。
【玩家可見記憶的語言】
- 本輪指定語言：${String(playerLanguage || "未指定：沿用玩家本輪原文的主要語言").slice(0,80)}。
- memory 是直接顯示給玩家的完整句子，必須使用上述語言；未指定時沿用玩家本輪原文的主要語言。繁體中文不得改成英文或簡體中文；其他語系也不得強制翻成中文。
- 玩家、角色與寵物的原始名稱原樣保留，例如棉花糖不可翻譯成 Cotton Candy。
- factKey 仍用英文 taxonomy；factKey 的英文規則不適用於 memory。factValue 可用簡潔原語言值，不得據此把 memory 改寫為英文。
【核心限制：只記錄玩家本人確認的資訊】
- 所有記憶項目只能引用【玩家本輪訊息】的原文；不從角色回覆、角色的內心、角色的行程或角色單方面的台詞建立記憶。
- 「與我相關」每一條 memory 都必須以需要記憶的人名作為敘述主體；例如「默語白早上 7:50 上駕訓班」，不可變成「角色提醒默語白上課」，也不可寫「玩家早上 7:50...」。
- 明確的未來安排、上課/駕訓班時間、約定的時間和地點屬於應保存的事件，即使不是永久偏好；如「我早上 7:50 上駕訓班」，保存為 important_event.driving_class，scope=session，含準確時刻。既有儲存器會將 important_event.* 固定為 session，跨聊天室固定課程另需設計獨立鍵與分類；不得憑空補日期、星期、地點。
- 只保存玩家明確說過、確認過或更正過的內容；角色單方面提議不等於玩家接受。
【自然敘述、特質與職業必須分清】
- 玩家在括號動作或普通聊天中明確透露的自身資訊也可擷取，不需要說「請記住」。例如「回房找東西，狗狗坐在門口」可保存目前世界線的養狗事實；不得推測品種、名字或數量。
- 玩家做菜時笑稱「我可是大廚！要是還不能讓你滿意，我就要自卑了」：可保存「對自己的廚藝有信心」這項特質，使用 trait.cooking_confidence；不得保存成「職業是廚師」，也不得推斷專業資格。
- 玩笑、暱稱、誇飾、自我打氣可以表現特質，但不能自動升格為職業或已發生的事件。
- identity.occupation 只保存玩家明確表達的實際職業／任職事實。對照前文職業背景；角色叫玩家「大廚／醫生／老師」或玩家開玩笑自稱，均不足以變更職業。若無法確定，不產生職業記憶，其他有依據的特質仍可保留。

${["immersive", "resonance"].includes(chatMode) ? "【沉浸／共鳴模式補充】玩家明確敘述已發生的婚姻、關係變更、重要約定、時間進展、修為境界、重要 NPC、重大事件或長期情感關係中的重要承諾，屬於目前聊天室世界線可保存的劇情事實，優先使用 session 範圍與 relationship.status、relationship.event.*、important_event.* 或 worldline.event.*。僅保存玩家明確表示已發生或已確定的事件；不得把願望、假設、AI 未經確認的台詞當成事實，切勿寫入跨角色 profile。" : ""}

你的工作不是聊天，也不能回應玩家。
你需要提取本輪新出現或被明確更新的重要事實。前文只供理解「好」「那個約定」等指涉，不重複提取無關舊事。

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
   - 玩家明確提供的未來時間安排、課程與重要約定即使只是單次事件，也應優先記住，直到玩家更正、取消或確認完成。

【不應該記住】
1. 純粹當下狀態：
   - 今天很熱、我現在好睏、剛剛吃了飯。

2. 無長期意義的普通劇情。各模式中已明確成立的重要事件、約定、物品去向、關係變化可存session。

3. 不確定、假設、玩笑、反問句。

4. AI 自己推測出來的資訊。

5. 玩家沒有明確說出的資訊。

【重要規則】
- 玩家自身事實必須由玩家明確表達，不得從角色回覆臆測玩家的偏好、身體狀態、身分、動作或同意。
- 不保存角色自行宣稱的承諾、想法、行動或演繹。只有玩家在本輪確認的雙方約定，才可作為玩家相關事件保存。
- 每項必須附evidence（引用玩家本輪原文的連續片段，一般至少2字；玩家只回「好／嗯／對／是／行」且前文指涉明確時可用該單字）；sourceRole 一律是 user。
- 禁止輸出 sourceRole=assistant；角色回覆和角色所說的話不屬於玩家記憶。
- 假設、疑問、演繹內的猜測或未完成的玩家動作不能保存為完成事實。取消、更正必須更新同一主題鍵並寫清新狀態。
- 不得補充、推測或改寫成更誇張的內容。
- 記憶中的玩家稱呼，必須使用系統提供的人設名稱，禁止猜測別名、暱稱或沿用前文的其他名稱。
- 例如系統提供的人設名稱是「小滿」，就寫「小滿喜歡吃草莓蛋糕」；不可自行創造其他名字。
- 絕對不要使用「玩家喜歡……」這種系統式稱呼。
- 一次最多提取4項不同的重要事實，不要為湊數提取。
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
- 一次最多提取4項不同的重要事實，不要為湊數提取。

輸出要求：
- 只輸出一個合法 JSON object。
- 禁止任何前言、解釋、Markdown、程式碼框或「Here is...」之類文字。
- 即使 shouldRemember=false，也必須輸出完整 JSON 結構。

輸出格式：
{"memories":[{"shouldRemember":true,"memory":"簡潔事實，標明主體及狀態", "scope":"profile | character | session", "category":"preference | personal | habit | relationship | story_state | important_event", "factKey":"固定taxonomy鍵", "factValue":"目前值或事件狀態", "confidence":0.95,"sourceRole":"user","evidence":"本輪原文片段"}]}
無記憶時輸出 {"memories":[]}。
`;

  const requestBody = {
    messages: [
      {
        role: "system",
        content: memorySystemPrompt,
      },
      {
        role: "user",
        content: evidenceInput,
      },
    ],
    max_tokens: 1500,
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
          max_tokens: 1500,
          messages: [
            {
              role: "system",
              content:
                memorySystemPrompt +
                "\n\n【最高格式要求】只輸出一個合法 JSON object；禁止前言、說明、Markdown 或程式碼框。",
            },
            {
              role: "user",
              content: evidenceInput,
            },
          ],
        },
      });

      parsed = parseMemoryJson(
        retryResult?.choices?.[0]?.message?.content || ""
      );
    }

    // Reject English-only display sentences for Chinese requests, even when
    // the player name itself is Chinese. Retry extraction, never translate
    // the original evidence or turn unsupported claims into facts.
    const requestedChinese = /中文|繁體|繁体|簡體|简体|chinese|^zh(?:[-_]|$)/i.test(playerLanguage) ||
      (!playerLanguage && /[\u3400-\u9fff]/.test(cleanMessage));
    const wrongDisplayLanguage = value => requestedChinese &&
      (Array.isArray(value.memories) ? value.memories : [value]).some(item => {
        if (item.shouldRemember !== true) return false;
        const text = String(item.memory || '').split(String(playerName || '\u0000')).join('').trim();
        return /[a-zA-Z]{3,}/.test(text) && !/[\u3400-\u9fff]/.test(text);
      });
    if (wrongDisplayLanguage(parsed)) {
      console.warn('MEMORY_DISPLAY_LANGUAGE_RETRY', {language: playerLanguage || 'source'});
      const retry = await callAiWithRetry({
        modelId: 'google/gemini-2.5-flash-lite',
        fallbackModelId: 'deepseek/deepseek-v4-flash',
        abortController, timeoutMs: 20_000,
        requestBody: {...requestBody, messages: [
          {role:'system',content:memorySystemPrompt + '\n【語言修正】上一輪把 memory 寫成英文。重新從原文提取，memory 必須使用指定的中文；名字及 evidence 保留原文。只回合法 JSON。'},
          {role:'user',content:evidenceInput},
        ]},
      });
      parsed = parseMemoryJson(retry?.choices?.[0]?.message?.content || '');
      if (wrongDisplayLanguage(parsed)) throw new Error('MEMORY_DISPLAY_LANGUAGE_MISMATCH');
    }
    const candidates = Array.isArray(parsed.memories) ? parsed.memories.slice(0, 4) : [parsed];
    const memories = candidates.map(item => ({
      shouldRemember: item.shouldRemember === true,
      memory: String(item.memory || '').trim(), scope: String(item.scope || 'none').trim().toLowerCase(),
      category: String(item.category || 'none').trim(), factKey: String(item.factKey || '').trim(),
      factValue: String(item.factValue || '').trim(), confidence: Number(item.confidence || 0),
      sourceRole: String(item.sourceRole || 'user') === 'user' ? 'user' : 'assistant',
      evidence: String(item.evidence || '').trim(),
    })).filter(item => {
      const source = cleanMessage;
      const shortConfirmation = item.sourceRole === 'user' && /^(好|嗯|對|是|行)$/.test(item.evidence) && contextText.length > 0;
      const culinaryNickname = item.factKey === 'identity.occupation' &&
        /大[廚厨]/.test(item.evidence) &&
        !/(職業|职业|任職|任职|受僱|受雇|餐廳|餐厅|飯店|饭店|酒店|工作是|工作就是|當廚師|当厨师|當主廚|当主厨)/.test(item.evidence);
      return item.sourceRole === 'user' && !culinaryNickname && item.shouldRemember && (item.evidence.length >= 2 || shortConfirmation) && source.includes(item.evidence);
    });
    return {shouldRemember: memories.length > 0, memories};

  } catch (error) {
    console.error("⚠️ 玩家記憶提取失敗：", error);

    throw error;

  }
}



return extractPlayerMemory;
}
module.exports = {createMemoryExtractor};
