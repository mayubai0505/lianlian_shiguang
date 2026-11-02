'use strict';

function protectCharacterTranslationTokens(text) {
  const tokens = [];
  let protectedText = String(text || "");

  const patterns = [
    /\{\{[^{}]{1,120}\}\}/g,
    /\(玩家名字\)/g,
    /（玩家名字）/g,
  ];

  for (const pattern of patterns) {
    protectedText = protectedText.replace(pattern, (match) => {
      const index = tokens.length;
      tokens.push(match);
      return `__LLPH_${index}__`;
    });
  }

  return { protectedText, tokens };
}

function restoreCharacterTranslationTokens(text, tokens) {
  let restored = String(text || "");

  tokens.forEach((token, index) => {
    const marker = new RegExp(`__LLPH_${index}__`, "gi");
    restored = restored.replace(marker, token);
  });

  return restored;
}

module.exports = { protectCharacterTranslationTokens, restoreCharacterTranslationTokens };
