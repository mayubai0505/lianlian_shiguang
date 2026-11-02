'use strict';
const OpenCC = require('opencc-js');

// 僅在玩家選擇繁體中文時轉換 AI 的最終輸出；不碰玩家輸入或其他語系。
const convertAiTextToTaiwanTraditional = OpenCC.Converter({ from: 'cn', to: 'tw' });
function shouldConvertAiToTaiwanTraditional(language) {
    const raw = String(language || '').trim().replace(/-/g, '_').toLowerCase();
    return new Set([
        '台灣繁體中文', '台湾繁体中文', '繁體中文', '繁体中文',
        'traditional chinese', 'zh_hant', 'zh_tw', 'zh_hk', 'zh_mo'
    ]).has(raw);
}
function normalizeAiResponseScript(text, language) {
    const original = String(text ?? '');
    return shouldConvertAiToTaiwanTraditional(language)
        ? convertAiTextToTaiwanTraditional(original)
        : original;
}

// Windows-1252 反向表，用來處理 â€™、â€œ、â€ 等情況
const CP1252_REVERSE_MAP = {
    "€": 0x80,
    "‚": 0x82,
    "ƒ": 0x83,
    "„": 0x84,
    "…": 0x85,
    "†": 0x86,
    "‡": 0x87,
    "ˆ": 0x88,
    "‰": 0x89,
    "Š": 0x8A,
    "‹": 0x8B,
    "Œ": 0x8C,
    "Ž": 0x8E,
    "‘": 0x91,
    "’": 0x92,
    "“": 0x93,
    "”": 0x94,
    "•": 0x95,
    "–": 0x96,
    "—": 0x97,
    "˜": 0x98,
    "™": 0x99,
    "š": 0x9A,
    "›": 0x9B,
    "œ": 0x9C,
    "ž": 0x9E,
    "Ÿ": 0x9F,
};

function fixMojibake(text) {
    if (!text || typeof text !== "string") return text;

    const looksBroken =
        /[æåçèéäöüïãâ¤¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿]/.test(text) ||
        text.includes("ï¼") ||
        text.includes("ã") ||
        text.includes("â") ||
        text.includes("�");

    if (!looksBroken) return text;

    const candidates = [];

    candidates.push(text);

    try {
        candidates.push(decodeMojibakeOnce(text));
    } catch (e) {
        console.error("mojibake 一次修復失敗:", e);
    }

    try {
        const once = decodeMojibakeOnce(text);
        candidates.push(decodeMojibakeOnce(once));
    } catch (e) {
        // 不用中斷
    }

    let best = text;
    let bestScore = scoreChineseText(text);

    for (const candidate of candidates) {
        const score = scoreChineseText(candidate);
        if (score > bestScore) {
            best = candidate;
            bestScore = score;
        }
    }

    return best.replace(/�/g, "");
}

function decodeMojibakeOnce(str) {
    const bytes = [];

    for (const ch of str) {
        const code = ch.codePointAt(0);

        if (code <= 0xFF) {
            bytes.push(code);
            continue;
        }

        const cp1252 = CP1252_REVERSE_MAP[ch];
        if (cp1252 !== undefined) {
            bytes.push(cp1252);
            continue;
        }

        const buf = Buffer.from(ch, "utf8");
        for (const b of buf) bytes.push(b);
    }

    return Buffer.from(bytes).toString("utf8");
}

function scoreChineseText(str) {
    if (!str || typeof str !== "string") return -999999;

    const cjkCount = (str.match(/[\u4e00-\u9fff]/g) || []).length;
    const zhPunctCount = (str.match(/[，。！？：「」『』（）——、]/g) || []).length;

    const mojibakeCount =
        (str.match(/[æåçèéäöüïãâ¤¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿]/g) || []).length;

    const replacementCount = (str.match(/�/g) || []).length;
    const controlCount = (str.match(/[\u0000-\u001F\u007F-\u009F]/g) || []).length;

    return (
        cjkCount * 5 +
        zhPunctCount * 2 -
        mojibakeCount * 8 -
        replacementCount * 20 -
        controlCount * 20
    );
}

module.exports = { normalizeAiResponseScript, fixMojibake };
