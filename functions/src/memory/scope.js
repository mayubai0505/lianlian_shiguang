'use strict';

// Extracted verbatim from V3 core.js; only dependency injection and exports added.
function createMemoryScopeTools({db, APP_ID}) {
function normalizeMemoryFactKey(value) {
  return String(value || "")
    .trim()
    .toLowerCase()
    .replace(/\s+/g, "_")
    .replace(/[^a-z0-9._:-]/g, "")
    .replace(/\.{2,}/g, ".")
    .replace(/^\.|\.$/g, "")
    .slice(0, 120);
}

const MEMORY_FACT_KEY_EXACT = new Set([
  "identity.name",
  "identity.gender",
  "identity.occupation",
  "identity.birthday",
  "identity.residence",
  "identity.family",
  "identity.pet",
  "interaction.preferred_address",
  "interaction.preferred_treatment",
  "relationship.status",
  "worldline.pregnancy_status",
  "worldline.identity",
]);

const MEMORY_FACT_KEY_PREFIXES = [
  "preference.food.",
  "preference.drink.",
  "preference.hobby.",
  "preference.activity.",
  "preference.media.",
  "preference.other.",
  "habit.",
  "trait.",
  "important_event.",
  "relationship.event.",
  "worldline.preference.",
  "worldline.event.",
];

const MEMORY_FACT_KEY_ALIASES = new Map([
  ["personal.job", "identity.occupation"],
  ["personal.occupation", "identity.occupation"],
  ["identity.job", "identity.occupation"],
  ["relationship.preferred_name", "interaction.preferred_address"],
  ["relationship.preferred_address", "interaction.preferred_address"],
  ["story.relationship_status", "relationship.status"],
  ["story.pregnancy_status", "worldline.pregnancy_status"],
  ["pregnancy.status", "worldline.pregnancy_status"],
  ["habit.alcohol", "preference.drink.alcohol"],
  ["habit.coffee", "preference.drink.coffee"],
  ["preference.coffee", "preference.drink.coffee"],
  ["preference.alcohol", "preference.drink.alcohol"],
]);

function canonicalizeMemoryFactKey(value, {userMessage = "", category = ""} = {}) {
  let key = normalizeMemoryFactKey(value);
  if (!key) return "";

  key = MEMORY_FACT_KEY_ALIASES.get(key) || key;

  // 常見「同一事實、不同分類」的模型漂移，伺服器再做一次收斂。
  const message = String(userMessage || "").toLowerCase();
  const normalizedCategory = String(category || "").trim().toLowerCase();

  // 已經是明確 identity 欄位時，不要再因為值裡含有「咖啡」等字樣被食物/飲料規則覆蓋。
  // 例：「我是咖啡師」的 factKey=identity.occupation，不能被「咖啡」誤改成 preference.drink.coffee。
  if (MEMORY_FACT_KEY_EXACT.has(key) && key.startsWith("identity.")) {
    return key;
  }

  // 如果模型已經給了「有效而且更具體」的偏好主題，就不要只因為句子背景提到
  // 咖啡店、酒吧等詞，把主題粗暴覆蓋掉。
  // 例：「我在咖啡店不喝拿鐵」若模型已判 preference.drink.latte，
  // 必須保留 latte，不能因為「咖啡店」被改成 coffee。
  const hasSpecificDrinkKey =
    key.startsWith("preference.drink.") &&
    !["preference.drink.drink", "preference.drink.other"].includes(key);

  const hasSpecificFoodKey =
    key.startsWith("preference.food.") &&
    !["preference.food.food", "preference.food.other"].includes(key);

  if (!hasSpecificDrinkKey && /(不喝咖啡|喝咖啡|喜歡咖啡|愛喝咖啡|討厭咖啡|每天(?:都)?喝咖啡|coffee)/i.test(message)) {
    key = "preference.drink.coffee";
  } else if (!hasSpecificDrinkKey && /(不喝酒|喝酒|喜歡喝酒|愛喝酒|討厭喝酒|酒精|alcohol|wine|beer)/i.test(message)) {
    key = "preference.drink.alcohol";
  } else if ((!hasSpecificFoodKey || key === "preference.food.cake") && /(草莓蛋糕|strawberry\s*cake)/i.test(message)) {
    key = "preference.food.strawberry_cake";
  } else if (!hasSpecificFoodKey && /(甜食|甜點|dessert|sweets?)/i.test(message)) {
    key = "preference.food.sweets";
  } else if (!hasSpecificFoodKey && /(香菜|cilantro|coriander)/i.test(message)) {
    key = "preference.food.cilantro";
  }

  // 關係狀態屬於同一 canonical fact。
  // scope 只決定這個事實在哪一層成立，不應讓「結婚 / 離婚 / 交往 / 分手」
  // 因為措辭不同而漂成 relationship.event.*。
  if (/(結婚|已婚|夫妻|離婚|分手|交往|在一起|戀人|情侶|曖昧)/i.test(message)) {
    key = "relationship.status";
  }

  // 若模型把一般偏好誤編成 worldline.preference.*，在有明確語意主題時
  // 收斂回 preference.*；世界線限定應由 scope=session 表示。
  if (key === "worldline.preference.sweets") {
    key = "preference.food.sweets";
  } else if (key === "worldline.preference.strawberry_cake") {
    key = "preference.food.strawberry_cake";
  } else if (key === "worldline.preference.coffee") {
    key = "preference.drink.coffee";
  }

  if (
    normalizedCategory === "personal" &&
    /^(personal\.|identity\.).*(job|occupation|career|work)$/.test(key)
  ) {
    key = "identity.occupation";
  }

  if (MEMORY_FACT_KEY_EXACT.has(key)) return key;

  for (const prefix of MEMORY_FACT_KEY_PREFIXES) {
    if (!key.startsWith(prefix)) continue;
    const subject = key.slice(prefix.length);
    // 第三層主題必須穩定且不能再偷偷帶更多階層。
    if (/^[a-z0-9][a-z0-9_]{0,63}$/.test(subject)) {
      return key;
    }
    return "";
  }

  return "";
}

function normalizeMemoryFactValue(value) {
  return String(value || "")
    .trim()
    .toLowerCase()
    .replace(/[，。！？、；：,.!?;:\s"'「」『』（）()【】\[\]]/g, "")
    .slice(0, 240);
}

function memoryTimestampToMillis(value) {
  if (!value) return 0;
  if (typeof value.toMillis === "function") {
    try {
      return Number(value.toMillis()) || 0;
    } catch (_) {
      return 0;
    }
  }
  if (value instanceof Date) return value.getTime();
  if (typeof value === "number") return value;
  return 0;
}

function resolveMemoryConflicts(entries = []) {
  if (!Array.isArray(entries) || entries.length === 0) return [];

  const scopeRank = {
    session: 3,
    character: 2,
    profile: 1,
    legacy: 0,
  };

  const noKey = [];
  const bestByFactKey = new Map();

  for (const rawEntry of entries) {
    if (!rawEntry || rawEntry.active === false) continue;

    const entry = {
      ...rawEntry,
      factKey: canonicalizeMemoryFactKey(rawEntry.factKey, {
        category: rawEntry.category,
      }),
    };

    if (!entry.factKey) {
      noKey.push(entry);
      continue;
    }

    const current = bestByFactKey.get(entry.factKey);
    if (!current) {
      bestByFactKey.set(entry.factKey, entry);
      continue;
    }

    const entryRank = scopeRank[entry.scope] ?? 0;
    const currentRank = scopeRank[current.scope] ?? 0;

    if (entryRank > currentRank) {
      bestByFactKey.set(entry.factKey, entry);
      continue;
    }

    if (
      entryRank === currentRank &&
      memoryTimestampToMillis(entry.timestamp) >
        memoryTimestampToMillis(current.timestamp)
    ) {
      bestByFactKey.set(entry.factKey, entry);
    }
  }

  return [
    ...bestByFactKey.values(),
    ...noKey,
  ];
}

async function loadScopedMemoryEntries({
  appId = APP_ID,
  userId,
  characterId,
  playerProfileId,
  sessionId,
  perScopeLimit = 8,
}) {
  const safeAppId = String(appId || APP_ID).trim() || APP_ID;
  const safeUserId = String(userId || "").trim();
  const safeCharacterId = String(characterId || "").trim();
  const safeProfileId = String(playerProfileId || "default").trim() || "default";
  const safeSessionId = String(sessionId || "").trim();

  if (!safeUserId || !safeCharacterId || !safeSessionId) {
    return [];
  }

  const profileMemoriesRef = db
    .collection("users")
    .doc(safeUserId)
    .collection("profile_memories")
    .doc(safeProfileId)
    .collection("memories");

  const characterMemoriesRef = db
    .collection("users")
    .doc(safeUserId)
    .collection("profile_memories")
    .doc(safeProfileId)
    .collection("characters")
    .doc(safeCharacterId)
    .collection("memories");

  const sessionMemoriesRef = db
    .collection("artifacts")
    .doc(safeAppId)
    .collection("chat_sessions")
    .doc(safeSessionId)
    .collection("memories");

  const [profileSnapshot, characterSnapshot, sessionSnapshot] =
    await Promise.all([
      profileMemoriesRef
        .orderBy("timestamp", "desc")
        .limit(perScopeLimit)
        .get(),
      characterMemoriesRef
        .orderBy("timestamp", "desc")
        .limit(perScopeLimit)
        .get(),
      sessionMemoriesRef
        .orderBy("timestamp", "desc")
        .limit(perScopeLimit)
        .get(),
    ]);

  const entries = [];

  const append = (snapshot, scope) => {
    for (const doc of snapshot.docs) {
      const data = doc.data() || {};
      const content =
        String(data.text || data.content || "").trim().slice(0, 700);
      if (!content) continue;

      entries.push({
        id: doc.id,
        scope,
        title: String(data.title || "").trim().slice(0, 80),
        content,
        factKey: canonicalizeMemoryFactKey(data.factKey, {
          category: data.category,
        }),
        factValue: String(data.factValue || "").trim().slice(0, 240),
        active: data.active !== false,
        confidence: Number(data.confidence || 0),
        timestamp: data.timestamp || null,
      });
    }
  };

  // 世界線事實最靠近當前聊天室，其次角色關係，最後才是玩家跨角色穩定資料。
  append(sessionSnapshot, "session");
  append(characterSnapshot, "character");
  append(profileSnapshot, "profile");

  return resolveMemoryConflicts(entries);
}


function repairMemoryScope({
  scope,
  shouldRemember,
  factKey,
  userMessage,
}) {
  let safeScope = String(scope || "none").trim().toLowerCase();
  const message = String(userMessage || "").trim();

  // 目前角色／聊天室專屬稱呼一律屬於 session。
  // 即使 Extractor 已先判成 character，也要在這裡修正，
  // 避免同角色不同聊天室互相污染「寶寶／老婆／老公」等稱呼。
  if (
    factKey === "interaction.preferred_address" &&
    /(你叫我|你喊我|你稱呼我|你可以叫我|我喜歡你叫我|不要再叫我|不要叫我|改叫我|叫我老婆|叫我老公|叫我寶寶)/i.test(message)
  ) {
    return "session";
  }

  if (["profile", "character", "session"].includes(safeScope)) {
    return safeScope;
  }

  if (shouldRemember !== true || !factKey) {
    return "none";
  }

  // 明確世界線限定，一律 session。
  if (/(在這個世界(?:裡|中)?|這個世界線|這條世界線|在這個聊天室|這個聊天室裡)/i.test(message)) {
    return "session";
  }

  // 只有在模型已判定 shouldRemember=true、factKey 也合法，
  // 且句子有明確穩定語意時，才把錯誤的 none 修回 profile。
  const stableSignal =
    /(最喜歡|最愛|很喜歡|喜歡|討厭|不喜歡|不吃|不喝|每天|固定|習慣|我是|我的職業|叫我.+就好|以後叫我|大家都叫我)/i.test(message);

  const ephemeralOnly =
    /(今天(?:突然)?想|剛剛|突然想|今晚想|這次想|等等想|現在想(?:吃|喝|做|看|去))/i.test(message);

  if (stableSignal && !ephemeralOnly) {
    if (
      factKey.startsWith("identity.") ||
      factKey.startsWith("preference.") ||
      factKey.startsWith("habit.") ||
      factKey.startsWith("trait.") ||
      factKey === "interaction.preferred_address" ||
      factKey === "interaction.preferred_treatment"
    ) {
      return "profile";
    }
  }

  return "none";
}



return {normalizeMemoryFactKey, canonicalizeMemoryFactKey, normalizeMemoryFactValue, memoryTimestampToMillis, resolveMemoryConflicts, loadScopedMemoryEntries, repairMemoryScope};
}

module.exports = {createMemoryScopeTools};
