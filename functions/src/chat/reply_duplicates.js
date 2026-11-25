'use strict';

// Only prose participates in similarity checks. Creator status is carried separately.
function narrativeBody(value, template = '') {
    const text = String(value || '').replace(/\r\n/g, '\n')
        .replace(/^\s*時間\s*[：:][^\n]*\n\s*地點\s*[：:][^\n]*\n?/u, '');
    const labels = String(template).split('\n')
        .map(line => line.trim())
        .filter(line => line && !/^(?:#{1,6}\s*|【|請|規則|每回合|每輪)/u.test(line))
        .map(line => line.match(/^(.{1,40}?[：:])/u)?.[1])
        .filter(Boolean);
    const lines = text.split('\n');
    // A status label must start a line after removing the leading story header.
    const start = lines.findIndex(line =>
        labels.some(label => line.trimStart().startsWith(label)));
    return (start < 0 ? text : lines.slice(0, start).join('\n'))
        .replace(/^\s*時間\s*[：:][^\n]*\n\s*地點\s*[：:][^\n]*\n?/u, '')
        .trim();
}

function normalize(text) {
    return String(text).toLowerCase().replace(/[\p{P}\p{S}\s]/gu, '');
}

function similarity(left, right) {
    const counts = new Map();
    for (let index = 0; index < left.length - 2; index++) {
        const gram = left.slice(index, index + 3);
        counts.set(gram, (counts.get(gram) || 0) + 1);
    }
    let shared = 0;
    for (let index = 0; index < right.length - 2; index++) {
        const gram = right.slice(index, index + 3);
        const remaining = counts.get(gram) || 0;
        if (remaining > 0) {
            shared++;
            counts.set(gram, remaining - 1);
        }
    }
    return 2 * shared / Math.max(1, left.length + right.length - 4);
}

function findRepeatedNarrative(candidate, history, template = '') {
    const body = narrativeBody(candidate, template);
    const normalized = normalize(body);
    if (normalized.length < 24) return null;
    const paragraphs = body.split(/\n+/u).map(text => ({text, normalized: normalize(text)}))
        .filter(paragraph => paragraph.normalized.length >= 70);
    for (let index = 0; index < paragraphs.length; index++) {
        const repeated = paragraphs.slice(0, index).find(previous =>
            similarity(previous.normalized, paragraphs[index].normalized) >= 0.94);
        if (repeated) return {reason: 'within_reply', excerpt: repeated.text.slice(0, 500)};
    }
    for (const message of history) {
        const previousBody = narrativeBody(message.content ?? message.text, template);
        const previous = normalize(previousBody);
        if (previous.length < 24) continue;
        if (previous === normalized) {
            return {reason: 'identical_reply', excerpt: previousBody.slice(0, 500)};
        }
        if (Math.min(previous.length, normalized.length) >= 120 &&
            similarity(previous, normalized) >= 0.9) {
            return {reason: 'similar_reply', excerpt: previousBody.slice(0, 500)};
        }
        const previousParagraphs = previousBody.split(/\n+/u)
            .map(text => ({text, normalized: normalize(text)}))
            .filter(paragraph => paragraph.normalized.length >= 70);
        for (const paragraph of paragraphs) {
            // A small incidental sentence in a long reply should not force a retry.
            if (paragraph.normalized.length < 140 &&
                paragraph.normalized.length < normalized.length * 0.25) continue;
            const match = previousParagraphs.find(old =>
                similarity(old.normalized, paragraph.normalized) >= 0.9);
            if (match) return {reason: 'repeated_paragraph', excerpt: match.text.slice(0, 500)};
        }
    }
    return null;
}

// Short-chat only: meaningful clauses, not greetings or short catchphrases.
function casualKey(text) {
    return normalize(String(text || '').normalize('NFKC'));
}
function intentionalRepeat(message) {
    return /再說(?:一遍|一次)|重複(?:一遍|一次|我|這|那)|再念(?:一遍|一次)|跟著我說|跟我說一遍|複誦|復誦|原話|逐字|repeat\b|say (?:it|that) again|quote verbatim/iu.test(String(message || ''));
}
function meaningful(key) {
    const han = (key.match(/\p{Script=Han}/gu) || []).length;
    return han >= 10 || (han === 0 && key.length >= 28);
}
function casualClauses(body) {
    return String(body || '').replace(/[（(][^（）()\n]*[）)]/gu, '\n')
        .split(/[。！？!?；;\n]+/u).map(s => s.trim()).filter(Boolean)
        .map(text => ({text, key:casualKey(text)})).filter(x => meaningful(x.key));
}
function findRepeatedCasual(candidate, history, message = '') {
    if (intentionalRepeat(message)) return null;
    const body = narrativeBody(candidate);
    const key = casualKey(body);
    const clauses = casualClauses(body);
    const dialogueKey = casualKey(body.replace(/[（(][^（）()\n]*[）)]/gu, ''));
    for (const item of (Array.isArray(history) ? history : []).filter(m => m?.role === 'assistant').slice(-6).reverse()) {
        const old = narrativeBody(item.content ?? item.text);
        const oldKey = casualKey(old);
        const oldDialogue = casualKey(old.replace(/[（(][^（）()\n]*[）)]/gu, ''));
        if ((meaningful(key) && (key === oldKey || (key.length >= 18 && oldKey.length >= 18 && similarity(key, oldKey) >= 0.90))) ||
            (meaningful(dialogueKey) && dialogueKey === oldDialogue)) {
            return {reason:'casual_repeated_reply', excerpt:old.slice(0,160)};
        }
        const previous = casualClauses(old);
        for (const clause of clauses) {
            // Do not reject a new answer merely for a familiar incidental phrase.
            if (clause.key.length < 12 || clause.key.length < dialogueKey.length * 0.60) continue;
            if (previous.some(p => p.key === clause.key || (clause.key.length >= 20 && p.key.length >= 20 && similarity(p.key, clause.key) >= 0.92))) {
                return {reason:'casual_repeated_clause', excerpt:clause.text.slice(0,160)};
            }
        }
    }
    return null;
}
module.exports = {narrativeBody, findRepeatedNarrative, findRepeatedCasual, intentionalRepeat, meaningful, casualKey};
