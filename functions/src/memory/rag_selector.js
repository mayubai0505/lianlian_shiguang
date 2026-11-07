'use strict';
const {buildSearchTerms} = require('./search_index');
// 原封不動搬移原 RAG 輕量檢索函式。
function createRagSelector({chatMode, finalUserMessage}) {
                                                                                                function buildRetrievalTerms(value) {
                                                                                                    const raw = String(value || "")
                                                                                                        .toLowerCase()
                                                                                                        .replace(/\s+/g, " ")
                                                                                                        .trim();

                                                                                                    if (!raw) return [];

                                                                                                    const terms = new Set();

                                                                                                    // 英數詞
                                                                                                    for (const token of raw.match(/[a-z0-9_\-]{2,}/g) || []) {
                                                                                                        terms.add(token);
                                                                                                    }

                                                                                                    // 中文 2-gram，對人名、物件、地點與事件關鍵字很實用
                                                                                                    const cjk = (raw.match(/[\u4e00-\u9fff]/g) || []).join("");
                                                                                                    for (let i = 0; i < cjk.length - 1; i++) {
                                                                                                        terms.add(cjk.slice(i, i + 2));
                                                                                                    }

                                                                                                    return [...terms].slice(0, 180);
                                                                                                }

                                                                                                // 低成本語意擴展（不呼叫第三方 Embedding API）。
                                                                                                // 對常見的同義說法擴充檢索詞；完整向量檢索須另建索引。
                                                                                                function expandRoleplayRetrievalTerms(terms) {
                                                                                                    if (!["immersive", "resonance"].includes(chatMode)) return terms;
                                                                                                    const groups = [
                                                                                                        ["打雷", "雷聲", "雷雨", "轟隆", "雷鳴", "怕雷"],
                                                                                                        ["結婚", "已婚", "成親", "婚禮", "夫君", "妻子", "夫妻", "新婚"],
                                                                                                        ["修為", "突破", "境界", "修煉", "晉升", "渡劫"],
                                                                                                        ["懷孕", "身孕", "有孕", "孩子", "寶寶"],
                                                                                                        ["承諾", "約定", "誓言", "答應", "說好"],
                                                                                                        ["受傷", "傷勢", "傷口", "療傷", "康復"],
                                                                                                        ["討厭", "不喜歡", "排斥", "反感"],
                                                                                                    ];
                                                                                                    const result = new Set(terms);
                                                                                                    // 僅在 query 具有完整關鍵語時擴充，避免二字片段的過量誤命中。
                                                                                                    const query = String(finalUserMessage || "");
                                                                                                    for (const group of groups) {
                                                                                                        if (group.some(word => query.includes(word))) {
                                                                                                            for (const word of group) result.add(word);
                                                                                                        }
                                                                                                    }
                                                                                                    return [...result].slice(0, 210);
                                                                                                }

                                                                                                function scoreRelevantCandidate(queryTerms, textValue, important = false) {
                                                                                                    const haystack = String(textValue || "").normalize("NFKC").toLowerCase();
                                                                                                    const indexed = new Set(buildSearchTerms(haystack));
                                                                                                    let score = important ? 6 : 0;

                                                                                                    for (const term of queryTerms) {
                                                                                                        if (term && (haystack.includes(term) || indexed.has(term))) {
                                                                                                            score += term.length >= 3 ? 3 : 1;
                                                                                                        }
                                                                                                    }

                                                                                                    return score;
                                                                                                }

                                                                                                function selectRelevantCandidates(items, query, limit, toText) {
                                                                                                    if (!Array.isArray(items) || items.length === 0) return [];

                                                                                                    const queryTerms = [...new Set([...buildSearchTerms(query), ...expandRoleplayRetrievalTerms(buildRetrievalTerms(query))])];

                                                                                                    const ranked = items.map((item, index) => ({
                                                                                                        item,
                                                                                                        index,
                                                                                                        score:
                                                                                                            scoreRelevantCandidate(
                                                                                                                queryTerms,
                                                                                                                toText(item),
                                                                                                                item?.important === true
                                                                                                            ) +
                                                                                                            // Firestore 原本即依時間倒序；只給很小的近期加權
                                                                                                            Math.max(0, 1 - index * 0.08),
                                                                                                    }));

                                                                                                    ranked.sort((a, b) => b.score - a.score);

                                                                                                    const positive = ranked.filter(
                                                                                                        (entry) => entry.score > 1.05 || entry.item?.important === true
                                                                                                    );

                                                                                                    // 完全沒有命中時仍保留最近少量資料，避免角色突然失憶
                                                                                                    return (positive.length > 0 ? positive : ranked.slice(0, 2))
                                                                                                        .slice(0, limit)
                                                                                                        .map((entry) => entry.item);
                                                                                                }


return selectRelevantCandidates;
}
module.exports = {createRagSelector};
