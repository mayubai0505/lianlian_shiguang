'use strict';

// Regular character-chat final-output guard. No model calls, no Firestore writes.
// Conservative by design: real English names, dialogue, and creator status are preserved.
function inspectAndCleanRegularReply(text, language) {
  let output = String(text ?? '');
  const stats = {removedRepeatedParagraphs:0, collapsedLatinStutters:0, suspiciousLatinRuns:0};
  const isTw = /(?:台灣繁體|臺灣繁體|繁體中文|zh[_-]hant|zh[_-]tw)/iu.test(String(language || '')) &&
    !/(?:簡體|zh[_-]hans|zh[_-]cn)/iu.test(String(language || ''));
  if (!isTw || output.length === 0) return {text:output, stats};

  // Only remove word-for-word repeated *long* standalone narrative paragraphs.
  // Never deduplicate short quotations, song-like refrains, headings, or emoji status rows.
  const blocks = output.split(/(\r?\n\s*\r?\n)/u);
  const seen = new Set();
  for (let i=0;i<blocks.length;i+=2) {
    const part = blocks[i];
    const value = part.trim().replace(/\s+/gu,' ');
    const han = (value.match(/\p{Script=Han}/gu)||[]).length;
    const isFooter = /^(?:[\p{Extended_Pictographic}\uFE0F]|(?:時間|地點|日期|狀態)\s*[：:])/u.test(value);
    if (han >= 85 && value.length >= 110 && !isFooter && seen.has(value)) {
      blocks[i] = '';
      if (i > 0 && /^\s*$/.test(blocks[i-1])) blocks[i-1] = '';
      stats.removedRepeatedParagraphs++;
    } else if (han >= 85 && value.length >= 110 && !isFooter) {
      seen.add(value);
    }
  }
  output = blocks.join('').replace(/\n{3,}/gu,'\n\n');

  // A 3+ repetition of the same 4+-letter ASCII word is a high-confidence
  // generation stutter; do not modify ordinary 2-word repetition ('no no'),
  // English names, technical strings or other locales. Leave a single token.
  output = output.replace(/(?<![A-Za-z0-9_])([A-Za-z]{4,})(?:[ \t]+\1){2,}(?![A-Za-z0-9_])/giu,
    (match, word) => { stats.collapsedLatinStutters++; return word; });

  // Observation only: counts English runs interleaved with Han characters.
  // Do not guess which words are mistakes; this needs a real player example.
  const interleaved = output.match(/[\p{Script=Han}][ \t]*[A-Za-z]{3,}(?:[ \t]+[A-Za-z]{3,}){0,3}[ \t]*[\p{Script=Han}]/gu) || [];
  stats.suspiciousLatinRuns = Math.min(interleaved.length, 99);
  return {text:output,stats};
}
const {intentionalRepeat, meaningful, casualKey} = require('./reply_duplicates');
// Exact adjacent duplicates only. Preserve punctuation, quotes and ordinary
// short repetition. Never delete a historical phrase from a new reply.
function cleanCasualRepeatedSentences(value, message = '') {
  let text = String(value ?? '');
  let removed = 0;
  if (intentionalRepeat(message)) return {text, removed};
  // Identical standalone lines (including fully quoted dialogue/action lines).
  const lines = text.split('\n');
  let last = '';
  const kept = [];
  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed) { kept.push(line); continue; }
    const key = casualKey(trimmed);
    if (!/^(?:時間|地點|日期|狀態)\s*[：:]/u.test(trimmed) && meaningful(key) && trimmed === last) {
      removed++; continue;
    }
    kept.push(line); last = trimmed;
  }
  text = kept.join('\n');
  // Same sentence directly repeated in one line; exclude quotation/action
  // delimiters from the captured sentence so surrounding formatting survives.
  text = text.replace(/([^\n。！？!?；;「」『』（）()]{10,160}[。！？!?；;])(?:[ \t]*\1)+/gu,
    (match, sentence) => {
      if (!meaningful(casualKey(sentence))) return match;
      removed++; return sentence;
    });
  return {text:removed ? text.replace(/\n{3,}/gu,'\n\n').trim() : text, removed};
}
module.exports = {inspectAndCleanRegularReply, cleanCasualRepeatedSentences};
