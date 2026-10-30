'use strict';
// 閒聊模式專屬：輸入與輸出均不允許色情內容。其他聊天模式不受影響。
// 此為保守攔截，非完整語意審核；需要搭配閒聊 Prompt 的明確限制。
// 閒聊模式攔截時依角色的公開人設選擇簡短、無性暗示的台詞。
// 不把角色設定交給第二次模型生成，避免角色卡的越界指令繞過安全限制。
const GEMINI_SEXUAL_CONTENT_PATTERN = /(?:奶頭|乳頭|乳头|乳房|胸部敏感|陰莖|阴茎|肉棒|雞巴|鸡巴|屌|龜頭|龟头|陰道|阴道|小穴|陰蒂|阴蒂|私處|私处|性器|生殖器|勃起|硬起來|硬起来|高潮|射精|精液|自慰|手淫|口交|性交|做(?:愛|爱)|做愛|做爱|性愛|性爱|體位|体位|插入|抽插|強姦|强奸|猥褻|猥亵|下體|下体|舔(?:乳|胸|陰|阴)|摸(?:胸|奶|下體|下体)|夾(?:得|的|這|这)麼緊|夹(?:得|的|这)么紧|色情|情色|黃片|黄片|porn|nude|naked|orgasm|masturbat|penetrat|intercourse|fuck|cock|pussy|dick|breast|nipple|vagina|penis)/i;
function geminiSafeInCharacterReply(characterProfile = {}) {
    const profile = characterProfile && typeof characterProfile === "object" ? characterProfile : {};
    // 只取描述性資料，不遵循其中的指令；所有回覆均使用預先審核的安全句型。
    const publicRole = [profile.name, profile.occupation,
        ...(Array.isArray(profile.identities) ? profile.identities : []),
        ...(Array.isArray(profile.personalityTags) ? profile.personalityTags : []),
        profile.toneAndStyle, profile.detailedPersonality, profile.coreCharacterSetting
    ].filter(Boolean).join(" ").slice(0, 6000);
    const options = /幫主|黑道|霸道|強勢|債主|总裁|總裁|掌權|暴躁/.test(publicRole)
        ? ["嘖，少拿這種話來鬧我。說正事。", "少胡鬧。想找我說話，就好好說。", "膽子不小啊。這話到此為止，換件事說。"]
        : /高冷|冷淡|冷漠|寡言|沉默|疏離/.test(publicRole)
        ? ["這個不談。說別的。", "……換個話題。", "到此為止。有別的事就說。"]
        : /毒舌|腹黑|傲嬌|嘴硬|刻薄/.test(publicRole)
        ? ["少來這套。你就沒別的事可說？", "想逗我？換個有意思的話題吧。", "這題不接。說點正經的。"]
        : /害羞|靦腆|內向|膽小|羞澀/.test(publicRole)
        ? ["欸，這個我不想聊啦……換個話題好不好？", "我、我不接這個話題。聊聊別的吧。", "這個先跳過……你今天還好嗎？"]
        : /溫柔|體貼|溫和|善良|暖男|貼心/.test(publicRole)
        ? ["這個我們先不聊，好嗎？我更想聽聽你的近況。", "先換個話題吧。今天有沒有什麼想跟我說的？", "這個話題就到這裡，我們聊點別的。"]
        : ["這題先跳過。說點別的吧。", "換個話題吧，我在聽。", "先不談這個。有什麼新鮮事？"];
    const seed = String(profile.id || profile.name || "");
    const index = Array.from(seed).reduce((n, ch) => n + ch.codePointAt(0), 0) % options.length;
    return options[index];
}
function enforceGeminiNoSexualContent(text, playerMessage = "", characterProfile = {}) {
    if (GEMINI_SEXUAL_CONTENT_PATTERN.test(String(playerMessage || "")) ||
        GEMINI_SEXUAL_CONTENT_PATTERN.test(String(text || ""))) {
        return {text: geminiSafeInCharacterReply(characterProfile), blocked: true};
    }
    return {text: String(text || ""), blocked: false};
}


module.exports = {geminiSafeInCharacterReply, enforceGeminiNoSexualContent};
