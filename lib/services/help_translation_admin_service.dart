import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../help/help_content_zh.dart';
import '../screens/help_models.dart';

class HelpTranslationAdminService {
  HelpTranslationAdminService._();

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseFunctions _functions =
  FirebaseFunctions.instanceFor(
    region: 'asia-east1',
  );

  static Future<String> _translateText({
    required String text,
    required String targetLanguage,
  }) async {
    if (text.trim().isEmpty) {
      return text;
    }

    final callable = _functions.httpsCallable(
      'translateText',
      options: HttpsCallableOptions(
        timeout: const Duration(
          seconds: 120,
        ),
      ),
    );

    final result = await callable.call({
      'text': text,
      'targetLanguage': targetLanguage,
    });

    final data = result.data;

    if (data is Map &&
        data['translatedText'] != null) {
      return data['translatedText']
          .toString()
          .trim();
    }

    throw StateError(
      'translateText 沒有回傳 translatedText。',
    );
  }

  static Future<List<String>>
  _translateBatch({
    required List<String> texts,
    required String targetLanguage,
  }) async {
    const separator =
        '\n\n<<<LLS_TRANSLATION_ITEM>>>\n\n';

    final combinedText =
    texts.join(separator);

    final translated =
    await _translateText(
      text: combinedText,
      targetLanguage: targetLanguage,
    );

    final parts = translated
        .split(separator)
        .map((item) => item.trim())
        .toList();

    // 有些模型可能會稍微更動 separator。
    // 若解析失敗，就改成逐項翻譯保底。
    if (parts.length != texts.length) {
      final fallbackResults = <String>[];

      for (final text in texts) {
        fallbackResults.add(
          await _translateText(
            text: text,
            targetLanguage:
            targetLanguage,
          ),
        );
      }

      return fallbackResults;
    }

    return parts;
  }

  static Future<HelpCategory>
  _translateCategory({
    required HelpCategory category,
    required String targetLanguage,
    required void Function(String message)
    onProgress,
  }) async {
    onProgress(
      '正在翻譯分類：${category.title}',
    );

    final sourceTexts = <String>[
      category.title,
      ...category.items.expand(
            (item) => [
          item.question,
          item.answer,
        ],
      ),
    ];

    final translatedTexts =
    await _translateBatch(
      texts: sourceTexts,
      targetLanguage: targetLanguage,
    );

    int cursor = 0;

    final translatedTitle =
    translatedTexts[cursor++];

    final translatedItems = <HelpItem>[];

    for (final sourceItem
    in category.items) {
      final translatedQuestion =
      translatedTexts[cursor++];

      final translatedAnswer =
      translatedTexts[cursor++];

      translatedItems.add(
        HelpItem(
          question: translatedQuestion,
          answer: translatedAnswer,

          // keywords 保留中文，並加入翻譯後問題，
          // 讓中外文關鍵字都可以搜尋。
          keywords: [
            ...sourceItem.keywords,
            translatedQuestion,
          ],
        ),
      );
    }

    return HelpCategory(
      id: category.id,
      title: translatedTitle,
      icon: category.icon,
      items: translatedItems,
    );
  }

  static Future<void> syncLanguage({
    required String targetLanguage,
    required void Function(String message)
    onProgress,
  }) async {
    final source = buildChineseHelpGuide();

    onProgress(
      '準備翻譯 ${targetLanguage.toUpperCase()}...',
    );

    final fixedTexts =
    await _translateBatch(
      targetLanguage: targetLanguage,
      texts: [
        source.pageTitle,
        source.welcomeTitle,
        source.welcomeBody,
        source.searchHint,
        source.noResultsTitle,
        source.noResultsBody,
      ],
    );

    final translatedCategories =
    <HelpCategory>[];

    for (int index = 0;
    index < source.categories.length;
    index++) {
      onProgress(
        '翻譯進度 ${index + 1}/'
            '${source.categories.length}',
      );

      translatedCategories.add(
        await _translateCategory(
          category:
          source.categories[index],
          targetLanguage:
          targetLanguage,
          onProgress: onProgress,
        ),
      );
    }

    final translatedContent =
    HelpGuideContent(
      languageCode: targetLanguage,
      version: source.version,
      pageTitle: fixedTexts[0],
      welcomeTitle: fixedTexts[1],
      welcomeBody: fixedTexts[2],
      searchHint: fixedTexts[3],
      noResultsTitle: fixedTexts[4],
      noResultsBody: fixedTexts[5],
      categories: translatedCategories,
    );

    onProgress('正在寫入 Firestore...');

    final rootRef = _firestore
        .collection('app_content')
        .doc('help_guide');

    await rootRef.set({
      'sourceLanguage': 'zh',
      'version': source.version,
      'updatedAt':
      FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await rootRef
        .collection('translations')
        .doc(targetLanguage)
        .set({
      ...translatedContent.toMap(),
      'updatedAt':
      FieldValue.serverTimestamp(),
    });

    onProgress(
      '${targetLanguage.toUpperCase()} '
          '翻譯同步完成！',
    );
  }
}