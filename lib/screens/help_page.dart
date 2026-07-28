import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../help/help_content_zh.dart';
import 'help_models.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() =>
      _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController
  _searchController =
  TextEditingController();

  String _searchKeyword = '';

  bool _isLoadingTranslation = false;

  HelpGuideContent? _remoteContent;

  HelpGuideContent get _chineseContent =>
      buildChineseHelpGuide();

  String get _languageCode =>
      Localizations.localeOf(context)
          .languageCode
          .toLowerCase();

  bool get _shouldUseChinese {
    return _languageCode == 'zh';
  }

  HelpGuideContent get _displayContent {
    if (_shouldUseChinese) {
      return _chineseContent;
    }

    return _remoteContent ??
        _chineseContent;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_shouldUseChinese &&
        _remoteContent == null &&
        !_isLoadingTranslation) {
      _loadRemoteTranslation();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRemoteTranslation() async {
    setState(() {
      _isLoadingTranslation = true;
    });

    try {
      final snapshot =
      await FirebaseFirestore.instance
          .collection('app_content')
          .doc('help_guide')
          .collection('translations')
          .doc(_languageCode)
          .get();

      if (!mounted) return;

      if (snapshot.exists &&
          snapshot.data() != null) {
        setState(() {
          _remoteContent =
              HelpGuideContent.fromMap(
                snapshot.data()!,
              );
        });
      }
    } catch (error) {
      debugPrint(
        '載入遊玩指南翻譯失敗：$error',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTranslation = false;
        });
      }
    }
  }

  List<HelpCategory> _filterCategories(
      List<HelpCategory> categories,
      ) {
    final keyword =
    _searchKeyword.trim().toLowerCase();

    if (keyword.isEmpty) {
      return categories;
    }

    final results = <HelpCategory>[];

    for (final category in categories) {
      final matchedItems = category.items
          .where(
            (item) => item.matches(keyword),
      )
          .toList();

      if (matchedItems.isNotEmpty) {
        results.add(
          HelpCategory(
            id: category.id,
            title: category.title,
            icon: category.icon,
            items: matchedItems,
          ),
        );
      }
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = _displayContent;

    final categories = _filterCategories(
      content.categories,
    );

    final bool showingChineseFallback =
        !_shouldUseChinese &&
            _remoteContent == null &&
            !_isLoadingTranslation;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          content.pageTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!_shouldUseChinese)
            IconButton(
              tooltip: '重新載入翻譯',
              onPressed: _isLoadingTranslation
                  ? null
                  : _loadRemoteTranslation,
              icon: _isLoadingTranslation
                  ? const SizedBox.square(
                dimension: 20,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Icon(
                Icons.translate_rounded,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (showingChineseFallback)
              Container(
                width: double.infinity,
                color: theme
                    .colorScheme
                    .primaryContainer,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(
                  '目前尚未提供此語言的遊玩指南，暫時顯示繁體中文。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme
                        .onPrimaryContainer,
                    fontSize: 12,
                  ),
                ),
              ),

            _buildTopArea(
              theme,
              content,
            ),

            Expanded(
              child: categories.isEmpty
                  ? _buildEmptyView(
                theme,
                content,
              )
                  : ListView.builder(
                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  4,
                  16,
                  32,
                ),
                itemCount:
                categories.length,
                itemBuilder:
                    (context, index) {
                  return _buildCategory(
                    theme,
                    categories[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopArea(
      ThemeData theme,
      HelpGuideContent content,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        12,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary
                  .withValues(alpha: 0.08),
              borderRadius:
              BorderRadius.circular(18),
              border: Border.all(
                color: theme.colorScheme.primary
                    .withValues(alpha: 0.14),
              ),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  content.welcomeTitle,
                  style: TextStyle(
                    color:
                    theme.colorScheme.primary,
                    fontSize: 17,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  content.welcomeBody,
                  style: TextStyle(
                    color: theme
                        .colorScheme.onSurface
                        .withValues(alpha: 0.72),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _searchController,
            textInputAction:
            TextInputAction.search,
            onChanged: (value) {
              setState(() {
                _searchKeyword = value;
              });
            },
            decoration: InputDecoration(
              hintText: content.searchHint,
              prefixIcon: const Icon(
                Icons.search_rounded,
              ),
              suffixIcon:
              _searchKeyword.isNotEmpty
                  ? IconButton(
                tooltip: '清除搜尋',
                onPressed: () {
                  _searchController
                      .clear();

                  setState(() {
                    _searchKeyword = '';
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                ),
              )
                  : null,
              filled: true,
              fillColor:
              theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme
                      .colorScheme.outline
                      .withValues(alpha: 0.18),
                ),
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme
                      .colorScheme.outline
                      .withValues(alpha: 0.18),
                ),
              ),
              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(16),
                borderSide: BorderSide(
                  color:
                  theme.colorScheme.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(
      ThemeData theme,
      HelpCategory category,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.fromLTRB(
              4,
              4,
              4,
              10,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme
                        .colorScheme.primary
                        .withValues(alpha: 0.10),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category.icon,
                    size: 20,
                    color:
                    theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius:
              BorderRadius.circular(18),
              border: Border.all(
                color: theme
                    .colorScheme.outline
                    .withValues(alpha: 0.14),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: List.generate(
                category.items.length,
                    (index) {
                  final item =
                  category.items[index];

                  return Column(
                    children: [
                      Theme(
                        data: theme.copyWith(
                          dividerColor:
                          Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          childrenPadding:
                          const EdgeInsets
                              .fromLTRB(
                            16,
                            0,
                            16,
                            18,
                          ),
                          iconColor: theme
                              .colorScheme.primary,
                          title: Text(
                            item.question,
                            style:
                            const TextStyle(
                              fontSize: 14,
                              fontWeight:
                              FontWeight.w600,
                              height: 1.35,
                            ),
                          ),
                          children: [
                            Align(
                              alignment: Alignment
                                  .centerLeft,
                              child: Text(
                                item.answer,
                                style: TextStyle(
                                  color: theme
                                      .colorScheme
                                      .onSurface
                                      .withValues(
                                    alpha: 0.72,
                                  ),
                                  fontSize: 13,
                                  height: 1.65,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index <
                          category.items.length -
                              1)
                        Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: theme
                              .colorScheme.outline
                              .withValues(
                            alpha: 0.10,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(
      ThemeData theme,
      HelpGuideContent content,
      ) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: theme.colorScheme.primary
                  .withValues(alpha: 0.45),
            ),
            const SizedBox(height: 16),
            Text(
              content.noResultsTitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content.noResultsBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme
                    .colorScheme.onSurface
                    .withValues(alpha: 0.58),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}