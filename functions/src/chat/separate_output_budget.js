'use strict';

// Reserve additional output capacity for creator fields, independently of prose.
function creatorStatusTokenReserve(template) {
  const text = String(template || '').trim();
  if (!text) return 0;
  const rows = text.split(/\r?\n/u).filter(line => /[：:]/u.test(line)).length;
  return Math.min(3000, Math.max(600, rows * 120, Math.ceil(text.length * 1.5)));
}

function limitNarrativeWithStatus(text, maxLength, bodyOnly) {
  if (typeof text !== 'string' || !text) return text;
  const body = bodyOnly(text);
  const footer = text.slice(body.length);
  if (body.length <= maxLength) return text;
  const cut = body.slice(0, maxLength);
  const boundary = Math.max(cut.lastIndexOf('\n\n'), cut.lastIndexOf('。'),
    cut.lastIndexOf('」'), cut.lastIndexOf('）'));
  const clipped = boundary > maxLength * 0.6 ? cut.slice(0, boundary + 1) : cut;
  return clipped.trimEnd() + (footer.trim() ? '\n\n' + footer.trimStart() : '');
}
module.exports = {creatorStatusTokenReserve, limitNarrativeWithStatus};
