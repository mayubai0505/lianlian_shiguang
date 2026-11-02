'use strict';

// ============================================================
// Voice Matching V2：共用設定
// ============================================================

const VOICE_MATCH_MIN_SCORE = 55;

const VOICE_TRAIT_WEIGHTS = {
  depth: 5,
  warmth: 5,
  energy: 4,
  softness: 4,
  maturity: 5,
  brightness: 3,
  confidence: 4,
  romance: 4,
  elegance: 4,
  mystery: 4,
  cuteness: 3,
};

// 避免 Firestore 中的數值超出 0～1。
function clampVoiceTrait(value, fallback = 0.5) {
  const numberValue = Number(value);

  if (!Number.isFinite(numberValue)) {
    return fallback;
  }

  return Math.max(0, Math.min(1, numberValue));
}

// 統一年齡格式。
// 前端目前可能傳 young，Voice Bank 則可能使用 young_adult。
function normalizeVoiceAge(age) {
  const value = String(age || "")
    .trim()
    .toLowerCase();

  const ageAliases = {
    teen: "young",
    teenager: "young",
    highschool: "young",
    high_school: "young",
    student: "young",

    young: "young",
    youth: "young",

    youngadult: "young_adult",
    "young-adult": "young_adult",
    young_adult: "young_adult",
    college: "young_adult",
    university: "young_adult",

    adult: "adult",
    mature_adult: "adult",

    mature: "mature",
    middle_age: "mature",
    middleaged: "mature",
    older: "mature",
  };

  return ageAliases[value] || value;
}

// 判斷兩個年齡分類的接近程度。
// 回傳值：
// 1 = 完全相符
// 0.65 = 相鄰年齡
// 0 = 差距較大
function getVoiceAgeSimilarity(
  requestedAge,
  candidateAge
) {
  const requested =
    normalizeVoiceAge(requestedAge);

  const candidate =
    normalizeVoiceAge(candidateAge);

  if (!requested || !candidate) {
    return 0;
  }

  if (requested === candidate) {
    return 1;
  }

  const ageOrder = [
    "young",
    "young_adult",
    "adult",
    "mature",
  ];

  const requestedIndex =
    ageOrder.indexOf(requested);

  const candidateIndex =
    ageOrder.indexOf(candidate);

  if (
    requestedIndex === -1 ||
    candidateIndex === -1
  ) {
    return 0;
  }

  const distance = Math.abs(
    requestedIndex - candidateIndex
  );

  if (distance === 1) {
    return 0.65;
  }

  return 0;
}

// 將標籤統一成可比較的格式。
function normalizeVoiceTag(tag) {
  return String(tag || "")
    .trim()
    .toLowerCase()
    .replace(/\s+/g, "");
}

// ============================================================
// Voice Bank：玩家描述正規化 V2
// ============================================================

function normalizeVoiceRequest({
  description,
  gender,
  age,
}) {
  const text = String(description || "")
    .trim()
    .toLowerCase();

  const matchedTags = new Set();

  // 沒有明確描述的項目維持中間值，
  // 避免未提及的特質過度影響配對。
  const traits = {
    depth: 0.5,
    warmth: 0.5,
    energy: 0.5,
    softness: 0.5,
    maturity: 0.5,
    brightness: 0.5,
    confidence: 0.5,
    romance: 0.5,
    elegance: 0.5,
    mystery: 0.5,
    cuteness: 0.5,
  };

  // 每組可以同時：
  // 1. 命中多個 Voice Bank 標籤
  // 2. 調整人物聲音特質
  const keywordProfiles = [
    {
      keywords: [
        "低沉",
        "深沉",
        "低音",
        "厚重",
        "渾厚",
        "沉厚",
      ],
      tags: [
        "低沉",
        "深沉",
        "磁性",
      ],
      traits: {
        depth: 0.92,
        brightness: 0.22,
        maturity: 0.78,
      },
    },
    {
      keywords: [
        "高音",
        "清亮",
        "明亮",
        "清脆",
      ],
      tags: [
        "高音",
        "明亮",
        "清晰",
      ],
      traits: {
        depth: 0.20,
        brightness: 0.92,
      },
    },
    {
      keywords: [
        "成熟",
        "穩重",
        "沉穩",
        "大人感",
        "有閱歷",
        "老練",
      ],
      tags: [
        "成熟",
        "穩重",
        "沉穩",
        "可靠",
      ],
      traits: {
        maturity: 0.92,
        confidence: 0.78,
        energy: 0.40,
      },
    },
    {
      keywords: [
        "霸總",
        "霸道總裁",
        "總裁",
        "ceo",
        "上位者",
        "強勢",
        "掌控",
      ],
      tags: [
        "霸總",
        "霸道總裁",
        "總裁",
        "CEO",
        "強勢",
        "安全感",
      ],
      traits: {
        depth: 0.88,
        maturity: 0.90,
        confidence: 0.98,
        softness: 0.28,
        romance: 0.80,
        elegance: 0.78,
      },
    },
    {
      keywords: [
        "溫柔",
        "溫暖",
        "體貼",
        "柔和",
        "暖男",
        "暖心",
      ],
      tags: [
        "溫柔",
        "溫暖",
        "體貼",
        "暖男",
        "安心",
      ],
      traits: {
        warmth: 0.96,
        softness: 0.86,
        romance: 0.78,
      },
    },
    {
      keywords: [
        "療癒",
        "治癒",
        "安撫",
        "陪伴",
        "包容",
        "安心",
      ],
      tags: [
        "療癒",
        "安撫",
        "陪伴",
        "包容",
        "安心",
      ],
      traits: {
        warmth: 0.98,
        softness: 0.94,
        energy: 0.28,
      },
    },
    {
      keywords: [
        "心理師",
        "諮商師",
        "傾聽",
        "心理醫生",
        "諮詢師",
      ],
      tags: [
        "心理師",
        "諮商師",
        "傾聽",
        "耐心",
        "專業",
      ],
      traits: {
        warmth: 0.92,
        softness: 0.88,
        maturity: 0.86,
        energy: 0.26,
        confidence: 0.64,
      },
    },
    {
      keywords: [
        "高冷",
        "冷淡",
        "冷酷",
        "清冷",
        "疏離",
        "冷漠",
      ],
      tags: [
        "高冷",
        "冷淡",
        "冷靜",
        "疏離",
        "禁慾",
      ],
      traits: {
        warmth: 0.28,
        energy: 0.28,
        softness: 0.32,
        confidence: 0.82,
        mystery: 0.58,
      },
    },
    {
      keywords: [
        "少年",
        "少年感",
        "高中生",
        "青春",
        "年輕",
      ],
      tags: [
        "少年",
        "青春",
        "學生",
        "清爽",
      ],
      traits: {
        depth: 0.28,
        energy: 0.82,
        maturity: 0.24,
        brightness: 0.88,
        cuteness: 0.68,
      },
    },
    {
      keywords: [
        "活潑",
        "陽光",
        "開朗",
        "元氣",
        "熱情",
        "有活力",
      ],
      tags: [
        "活潑",
        "陽光",
        "開朗",
        "元氣",
        "熱情",
      ],
      traits: {
        energy: 0.94,
        brightness: 0.92,
        warmth: 0.78,
      },
    },
    {
      keywords: [
        "可愛",
        "軟萌",
        "萌",
        "甜妹",
        "甜美",
        "少女感",
      ],
      tags: [
        "可愛",
        "軟萌",
        "甜美",
        "少女感",
      ],
      traits: {
        depth: 0.20,
        softness: 0.90,
        brightness: 0.92,
        cuteness: 0.98,
        maturity: 0.25,
      },
    },
    {
      keywords: [
        "奶狗",
        "弟弟感",
        "黏人",
        "撒嬌",
        "小奶狗",
      ],
      tags: [
        "奶狗",
        "弟弟感",
        "黏人",
        "撒嬌",
        "可愛",
        "男友感",
      ],
      traits: {
        warmth: 0.90,
        energy: 0.78,
        softness: 0.82,
        romance: 0.86,
        cuteness: 0.96,
        maturity: 0.32,
      },
    },
    {
      keywords: [
        "狼狗",
        "小狼狗",
        "野性",
        "保護慾",
        "保護欲",
        "運動系",
      ],
      tags: [
        "狼狗",
        "野性",
        "保護欲",
        "運動系",
        "強勢",
        "男友",
      ],
      traits: {
        depth: 0.62,
        warmth: 0.76,
        energy: 0.92,
        confidence: 0.92,
        romance: 0.86,
        softness: 0.38,
      },
    },
    {
      keywords: [
        "御姐",
        "御姊",
        "姐姐感",
        "成熟姐姐",
        "成熟姊姊",
      ],
      tags: [
        "御姐",
        "御姊",
        "姊姊",
        "成熟",
        "優雅",
      ],
      traits: {
        depth: 0.62,
        maturity: 0.94,
        confidence: 0.92,
        romance: 0.84,
        elegance: 0.92,
        cuteness: 0.12,
      },
    },
    {
      keywords: [
        "女王",
        "霸氣",
        "威嚴",
        "領袖",
        "權威",
        "高貴",
      ],
      tags: [
        "女王",
        "霸氣",
        "威嚴",
        "領袖",
        "權威",
        "高貴",
      ],
      traits: {
        maturity: 0.96,
        confidence: 1.0,
        elegance: 0.96,
        softness: 0.28,
        cuteness: 0.04,
      },
    },
    {
      keywords: [
        "優雅",
        "氣質",
        "紳士",
        "高貴",
        "英倫",
        "執事",
      ],
      tags: [
        "優雅",
        "氣質",
        "紳士",
        "高貴",
        "英倫",
        "執事",
      ],
      traits: {
        elegance: 0.98,
        maturity: 0.84,
        confidence: 0.80,
      },
    },
    {
      keywords: [
        "神秘",
        "腹黑",
        "心機",
        "危險",
        "邪魅",
        "暗黑",
        "禁忌",
      ],
      tags: [
        "神秘",
        "腹黑",
        "心機",
        "危險",
        "暗黑",
        "禁忌",
      ],
      traits: {
        mystery: 0.96,
        confidence: 0.88,
        warmth: 0.36,
        brightness: 0.24,
      },
    },
    {
      keywords: [
        "性感",
        "誘惑",
        "魅惑",
        "撩人",
        "迷人",
        "魅力",
      ],
      tags: [
        "性感",
        "誘惑",
        "魅惑",
        "磁性",
        "浪漫",
      ],
      traits: {
        depth: 0.70,
        romance: 0.92,
        confidence: 0.88,
        mystery: 0.72,
      },
    },
    {
      keywords: [
        "傲嬌",
        "嘴硬心軟",
        "任性",
        "俏皮",
      ],
      tags: [
        "傲嬌",
        "嘴硬心軟",
        "任性",
        "俏皮",
        "反差",
      ],
      traits: {
        energy: 0.82,
        confidence: 0.70,
        romance: 0.72,
        cuteness: 0.86,
      },
    },
    {
      keywords: [
        "天使",
        "神聖",
        "純淨",
        "善良",
        "希望",
      ],
      tags: [
        "天使",
        "神聖",
        "純淨",
        "善良",
        "希望",
      ],
      traits: {
        warmth: 0.94,
        softness: 0.96,
        brightness: 0.90,
        elegance: 0.80,
        cuteness: 0.60,
      },
    },
    {
      keywords: [
        "精靈",
        "空靈",
        "仙氣",
        "森林",
        "奇幻",
        "夢幻",
      ],
      tags: [
        "精靈",
        "空靈",
        "仙氣",
        "森林",
        "奇幻",
        "夢幻",
      ],
      traits: {
        softness: 0.90,
        brightness: 0.84,
        elegance: 0.92,
        mystery: 0.78,
      },
    },
    {
      keywords: [
        "惡魔",
        "魔女",
        "魅魔",
        "邪惡",
      ],
      tags: [
        "惡魔",
        "誘惑",
        "危險",
        "暗黑",
        "魅惑",
      ],
      traits: {
        warmth: 0.30,
        confidence: 0.98,
        romance: 0.88,
        mystery: 0.98,
        cuteness: 0.05,
      },
    },
    {
      keywords: [
        "吸血鬼",
        "血族",
        "夜族",
        "貴族吸血鬼",
      ],
      tags: [
        "吸血鬼",
        "貴族",
        "暗黑",
        "誘惑",
        "禁忌",
      ],
      traits: {
        depth: 0.84,
        maturity: 0.88,
        romance: 0.88,
        elegance: 0.94,
        mystery: 0.98,
      },
    },
    {
      keywords: [
        "ai",
        "人工智慧",
        "機器人",
        "機械",
        "電子音",
        "科技感",
        "未來感",
      ],
      tags: [
        "AI",
        "人工智慧",
        "機器人",
        "機械",
        "科技",
        "未來",
        "理性",
      ],
      traits: {
        warmth: 0.30,
        softness: 0.30,
        confidence: 0.78,
        mystery: 0.52,
        romance: 0.22,
      },
    },
    {
      keywords: [
        "主播",
        "主持人",
        "旁白",
        "新聞",
        "播報",
      ],
      tags: [
        "主播",
        "主持人",
        "旁白",
        "新聞",
        "專業",
        "清晰",
      ],
      traits: {
        maturity: 0.88,
        confidence: 0.90,
        elegance: 0.76,
        romance: 0.28,
      },
    },
  ];

  for (const profile of keywordProfiles) {
    const isMatched = profile.keywords.some(
      (keyword) =>
        text.includes(
          String(keyword).toLowerCase()
        )
    );

    if (!isMatched) {
      continue;
    }

    for (const tag of profile.tags) {
      matchedTags.add(tag);
    }

    for (
      const [traitName, traitValue]
      of Object.entries(profile.traits)
    ) {
      traits[traitName] =
        clampVoiceTrait(traitValue);
    }
  }

  return {
    gender: String(gender || "")
      .trim()
      .toLowerCase(),

    age: normalizeVoiceAge(age),

    tags: Array.from(matchedTags),

    traits,

    description: text,
  };
}

// ============================================================
// Voice Bank：相似度評分 V2
// ============================================================

function calculateVoiceMatch(
  requested,
  candidate
) {
  const reasons = [];

  const requestedGender =
    String(requested.gender || "")
      .trim()
      .toLowerCase();

  const candidateGender =
    String(candidate.gender || "")
      .trim()
      .toLowerCase();

  // 性別明確不同，直接淘汰。
  if (
    requestedGender &&
    candidateGender &&
    requestedGender !== candidateGender
  ) {
    return {
      score: -9999,
      reasons: ["性別不符"],
    };
  }

  let score = 0;

  // ------------------------------
  // 1. 性別：20 分
  // ------------------------------
  if (
    requestedGender &&
    requestedGender === candidateGender
  ) {
    score += 20;
    reasons.push("性別符合");
  } else if (!requestedGender) {
    // 玩家沒有傳性別時，不重罰候選聲音。
    score += 10;
  }

  // ------------------------------
  // 2. 年齡感：8 分
  // ------------------------------
  const ageSimilarity =
    getVoiceAgeSimilarity(
      requested.age,
      candidate.age
    );

  if (ageSimilarity > 0) {
    score += ageSimilarity * 8;

    if (ageSimilarity === 1) {
      reasons.push("年齡感符合");
    } else {
      reasons.push("年齡感接近");
    }
  }

  // ------------------------------
  // 3. 關鍵標籤：22 分
  // ------------------------------
  const requestedTags = Array.isArray(
    requested.tags
  )
    ? requested.tags
    : [];

  const candidateTags = Array.isArray(
    candidate.tags
  )
    ? candidate.tags
    : [];

  const normalizedCandidateTags =
    new Set(
      candidateTags.map(
        normalizeVoiceTag
      )
    );

  const matchedTagNames = [];

  for (const requestedTag of requestedTags) {
    const normalizedRequestedTag =
      normalizeVoiceTag(requestedTag);

    if (
      normalizedCandidateTags.has(
        normalizedRequestedTag
      )
    ) {
      matchedTagNames.push(
        requestedTag
      );
    }
  }

  if (requestedTags.length > 0) {
    const tagMatchRatio =
      matchedTagNames.length /
      requestedTags.length;

    score += tagMatchRatio * 22;
  } else {
    // 完全沒有命中描述關鍵字時，
    // 給少量基礎分，但不讓標籤項拿滿。
    score += 5;
  }

  for (
    const tag of matchedTagNames.slice(0, 5)
  ) {
    reasons.push(tag);
  }

  // ------------------------------
  // 4. 11 項 Traits：45 分
  // ------------------------------
  const requestedTraits =
    requested.traits &&
    typeof requested.traits === "object"
      ? requested.traits
      : {};

  const candidateTraits =
    candidate.traits &&
    typeof candidate.traits === "object"
      ? candidate.traits
      : {};

  for (
    const [traitName, weight]
    of Object.entries(
      VOICE_TRAIT_WEIGHTS
    )
  ) {
    const requestedValue =
      clampVoiceTrait(
        requestedTraits[traitName]
      );

    const candidateValue =
      clampVoiceTrait(
        candidateTraits[traitName]
      );

    const difference = Math.abs(
      requestedValue - candidateValue
    );

    const similarity = Math.max(
      0,
      1 - difference
    );

    score += similarity * weight;
  }

  // ------------------------------
  // 5. Search Weight：最多 ±5 分
  // ------------------------------
  const rawSearchWeight =
    Number(candidate.searchWeight ?? 100);

  const safeSearchWeight =
    Number.isFinite(rawSearchWeight)
      ? rawSearchWeight
      : 100;

  // 90  → -2
  // 100 →  0
  // 105 → +1
  // 110 → +2
  // 115 → +3
  const searchWeightBonus =
    Math.max(
      -5,
      Math.min(
        5,
        (safeSearchWeight - 100) / 5
      )
    );

  score += searchWeightBonus;

  // 統一限制在 0～100。
  const finalScore = Math.max(
    0,
    Math.min(
      100,
      Number(score.toFixed(2))
    )
  );

  if (searchWeightBonus >= 2) {
    reasons.push("代表性聲線");
  }

  // 去除重複原因，最多回傳 6 項。
  const uniqueReasons = Array.from(
    new Set(reasons)
  ).slice(0, 6);

  return {
    score: finalScore,
    reasons: uniqueReasons,
    matchedTags: matchedTagNames,
  };
}


module.exports = {VOICE_MATCH_MIN_SCORE, normalizeVoiceAge, normalizeVoiceRequest, calculateVoiceMatch};
