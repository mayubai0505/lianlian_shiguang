String normalizeMomentSearchText(String value) {
  return value.toLowerCase().replaceAll(RegExp(r'\s+'), '').replaceAll(
        RegExp(r'''[，。！？、；：「」『』（）()【】\[\],.!?;:'"`~@#\$%\^&*_+=|\\/<>-]'''),
        '',
      );
}

List<String> buildMomentSearchKeywords({
  required String content,
  required String authorName,
}) {
  final String source = normalizeMomentSearchText(
    '$authorName$content',
  );

  // 使用 Unicode code point，不以 UTF-16 code unit 切割，
  // 避免把 Emoji 拆成無效的半個字元。
  final List<int> codePoints = source.runes.toList(
    growable: false,
  );

  final Set<String> keywords = <String>{};

  // 單字搜尋
  for (int index = 0; index < codePoints.length; index++) {
    keywords.add(
      String.fromCharCode(codePoints[index]),
    );
  }

  // 相鄰兩字搜尋
  for (int index = 0; index + 1 < codePoints.length; index++) {
    keywords.add(
      String.fromCharCodes(
        <int>[
          codePoints[index],
          codePoints[index + 1],
        ],
      ),
    );
  }

  return keywords
      .where((keyword) => keyword.isNotEmpty)
      .take(800)
      .toList(growable: false);
}

String buildMomentSearchLookupKey(String query) {
  final String normalized = normalizeMomentSearchText(query);
  final List<int> codePoints = normalized.runes.toList(
    growable: false,
  );

  if (codePoints.isEmpty) return '';

  if (codePoints.length == 1) {
    return String.fromCharCode(codePoints.first);
  }

  return String.fromCharCodes(
    <int>[
      codePoints[0],
      codePoints[1],
    ],
  );
}
