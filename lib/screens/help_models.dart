import 'package:flutter/material.dart';

class HelpItem {
  final String question;
  final String answer;
  final List<String> keywords;

  const HelpItem({
    required this.question,
    required this.answer,
    this.keywords = const [],
  });

  bool matches(String keyword) {
    final normalizedKeyword =
    keyword.trim().toLowerCase();

    if (normalizedKeyword.isEmpty) {
      return true;
    }

    final searchableText = [
      question,
      answer,
      ...keywords,
    ].join(' ').toLowerCase();

    return searchableText.contains(
      normalizedKeyword,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'keywords': keywords,
    };
  }

  factory HelpItem.fromMap(
      Map<String, dynamic> map,
      ) {
    return HelpItem(
      question:
      map['question']?.toString() ?? '',
      answer:
      map['answer']?.toString() ?? '',
      keywords:
      (map['keywords'] as List<dynamic>? ??
          const [])
          .map((item) => item.toString())
          .toList(),
    );
  }
}

class HelpCategory {
  final String id;
  final String title;
  final IconData icon;
  final List<HelpItem> items;

  const HelpCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,

      // Firestore 不適合直接儲存 IconData，
      // 所以只存 icon key。
      'iconKey': helpIconKeyFromIcon(icon),

      'items': items
          .map((item) => item.toMap())
          .toList(),
    };
  }

  factory HelpCategory.fromMap(
      Map<String, dynamic> map,
      ) {
    return HelpCategory(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      icon: helpIconFromKey(
        map['iconKey']?.toString() ?? '',
      ),
      items:
      (map['items'] as List<dynamic>? ??
          const [])
          .whereType<Map>()
          .map(
            (item) => HelpItem.fromMap(
          Map<String, dynamic>.from(
            item,
          ),
        ),
      )
          .toList(),
    );
  }
}

class HelpGuideContent {
  final String languageCode;
  final int version;
  final String pageTitle;
  final String welcomeTitle;
  final String welcomeBody;
  final String searchHint;
  final String noResultsTitle;
  final String noResultsBody;
  final List<HelpCategory> categories;

  const HelpGuideContent({
    required this.languageCode,
    required this.version,
    required this.pageTitle,
    required this.welcomeTitle,
    required this.welcomeBody,
    required this.searchHint,
    required this.noResultsTitle,
    required this.noResultsBody,
    required this.categories,
  });

  Map<String, dynamic> toMap() {
    return {
      'languageCode': languageCode,
      'version': version,
      'pageTitle': pageTitle,
      'welcomeTitle': welcomeTitle,
      'welcomeBody': welcomeBody,
      'searchHint': searchHint,
      'noResultsTitle': noResultsTitle,
      'noResultsBody': noResultsBody,
      'categories': categories
          .map(
            (category) =>
            category.toMap(),
      )
          .toList(),
    };
  }

  factory HelpGuideContent.fromMap(
      Map<String, dynamic> map,
      ) {
    return HelpGuideContent(
      languageCode:
      map['languageCode']?.toString() ??
          'zh',
      version:
      (map['version'] as num?)?.toInt() ??
          1,
      pageTitle:
      map['pageTitle']?.toString() ??
          '遊玩指南',
      welcomeTitle:
      map['welcomeTitle']?.toString() ??
          '',
      welcomeBody:
      map['welcomeBody']?.toString() ??
          '',
      searchHint:
      map['searchHint']?.toString() ??
          '',
      noResultsTitle:
      map['noResultsTitle']
          ?.toString() ??
          '',
      noResultsBody:
      map['noResultsBody']?.toString() ??
          '',
      categories:
      (map['categories']
      as List<dynamic>? ??
          const [])
          .whereType<Map>()
          .map(
            (category) =>
            HelpCategory.fromMap(
              Map<String, dynamic>.from(
                category,
              ),
            ),
      )
          .toList(),
    );
  }
}

IconData helpIconFromKey(String key) {
  switch (key) {
    case 'flower':
      return Icons.local_florist_outlined;

    case 'favorite':
      return Icons.favorite_border_rounded;

    case 'moments':
      return Icons.dynamic_feed_outlined;

    case 'voice':
      return Icons.graphic_eq_rounded;

    case 'creator':
      return Icons.palette_outlined;

    case 'explore':
      return Icons.travel_explore_rounded;

    case 'account':
      return Icons.person_outline_rounded;

    case 'points':
      return Icons.local_florist_rounded;

    case 'support':
      return Icons.support_agent_rounded;

    default:
      return Icons.help_outline_rounded;
  }
}

String helpIconKeyFromIcon(
    IconData icon,
    ) {
  if (icon == Icons.local_florist_outlined) {
    return 'flower';
  }

  if (icon ==
      Icons.favorite_border_rounded) {
    return 'favorite';
  }

  if (icon ==
      Icons.dynamic_feed_outlined) {
    return 'moments';
  }

  if (icon == Icons.graphic_eq_rounded) {
    return 'voice';
  }

  if (icon == Icons.palette_outlined) {
    return 'creator';
  }

  if (icon ==
      Icons.travel_explore_rounded) {
    return 'explore';
  }

  if (icon ==
      Icons.person_outline_rounded) {
    return 'account';
  }

  if (icon ==
      Icons.local_florist_rounded) {
    return 'points';
  }

  if (icon ==
      Icons.support_agent_rounded) {
    return 'support';
  }

  return 'help';
}