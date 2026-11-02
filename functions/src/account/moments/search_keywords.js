'use strict';

function normalizeMomentSearchText(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/\s+/g, "")
    .replace(
      /[，。！？、；：「」『』（）()\[\],.!?;:'"`~@#$%^&*_+=|\\/<>-]/g,
      ""
    );
}

function buildMomentSearchKeywords(content, authorName) {
  const source = normalizeMomentSearchText(
    `${authorName || ""}${content || ""}`
  );

  const characters = Array.from(source);
  const keywords = new Set();

  for (let index = 0; index < characters.length; index++) {
    keywords.add(characters[index]);
  }

  for (
    let index = 0;
    index + 1 < characters.length;
    index++
  ) {
    keywords.add(
      characters[index] + characters[index + 1]
    );
  }

  return Array.from(keywords)
    .filter(
      (keyword) =>
        typeof keyword === "string" &&
        keyword.length > 0
    )
    .slice(0, 800);
}

module.exports = { normalizeMomentSearchText, buildMomentSearchKeywords };
