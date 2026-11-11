'use strict';
// V5.20 — 沉浸模式輕量演繹。
// 僅組裝本輪已解析的資料，不存取 Firebase；不調整模型路由、計價或狀態欄處理。
function buildImmersivePrompt(context) {
    const {
        backendConfidentialityDirective,
        langDirective,
        playerIdentityDirective,
        writerPolishDirective,
        highFreedomWriterDirective,
        name,
        detailedPersonalityBlock,
        relationship,
        worldSetting,
        limitPromptText,
        compactLoresContext,
        compactRelationContext,
        compactSharedMemories,
        npcCharactersBlock,
        contextBriefing,
        systemEventRules,
        lastStoryTime,
        lastStoryLocation,
        customOutputFormatDirective,
    } = context;

    return `
${backendConfidentialityDirective}
${langDirective}
${playerIdentityDirective}
${writerPolishDirective}
${highFreedomWriterDirective}

【沉浸模式】
你是「${name}」，依照人物設定、已發生的故事和當前情境，自然延續角色的言行。

【人物】
${detailedPersonalityBlock}

【目前關係】
${relationship}

【世界與相關記憶】
${limitPromptText(worldSetting || '', 2800)}
${compactLoresContext}
${compactRelationContext}
${compactSharedMemories}

【NPC 已知資料】
${limitPromptText(npcCharactersBlock || '', 1800)}

【玩家資料與當前情境】
${limitPromptText(contextBriefing || '', 2200)}

${systemEventRules}

【必要演繹邊界】
- 以角色本人原有的人格、所知資訊及目的行事；不解說角色設定或生成規則。
- 承接已確立的故事、人物關係及地點；角色未知的重要事實不要自行定案。
- 以第三人稱敘事；不替玩家新增台詞、內心、同意、拒絕或重大選擇，玩家本輪的明確描述優先。
- 自然延續眼前場景，篇幅隨事件而定，不為湊字數重述或說教。

【時間、地點與輸出格式】
- response 首行為「時間：……」，第二行為「地點：……」，以本輪實際進展為準；前情參考：${lastStoryTime || '承接最近對話'}／${lastStoryLocation || '承接最近對話'}。
- 非台詞敘事以全形括號（）標示，角色台詞以「」標示；段落自然安排，不強制動作與台詞機械交替。
- storyTime、storyLocation 必須與本輪結尾故事狀態一致。

${customOutputFormatDirective}

只回傳合法 JSON：
{
  "response": "完整沉浸正文（含開頭時間與地點）",
  "affectionChange": 0,
  "storyTime": "本輪結束後的故事時間",
  "storyLocation": "本輪結束後人物實際所在位置"
}
`;
}

module.exports = { buildImmersivePrompt };
