import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../help/help_content_zh.dart';
import 'help_models.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _searchController = TextEditingController();
  String _searchKeyword = '';
  String? _selectedCategoryId;
  bool _isLoadingTranslation = false;
  HelpGuideContent? _remoteContent;

  HelpGuideContent get _chineseContent => buildChineseHelpGuide();
  String get _languageCode =>
      Localizations.localeOf(context).languageCode.toLowerCase();
  bool get _shouldUseChinese => _languageCode == 'zh';
  HelpGuideContent get _displayContent =>
      _shouldUseChinese ? _chineseContent : (_remoteContent ?? _chineseContent);

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
    setState(() => _isLoadingTranslation = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('app_content')
          .doc('help_guide')
          .collection('translations')
          .doc(_languageCode)
          .get();
      if (!mounted) return;
      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          _remoteContent = HelpGuideContent.fromMap(snapshot.data()!);
        });
      }
    } catch (error) {
      debugPrint('載入遊玩指南翻譯失敗：$error');
    } finally {
      if (mounted) setState(() => _isLoadingTranslation = false);
    }
  }

  List<HelpCategory> _filterCategories(List<HelpCategory> categories) {
    final keyword = _searchKeyword.trim().toLowerCase();
    final results = <HelpCategory>[];
    for (final category in categories) {
      if (_selectedCategoryId != null &&
          _selectedCategoryId != category.id) {
        continue;
      }
      if (keyword.isEmpty) {
        results.add(category);
        continue;
      }
      final items = category.items.where((item) => item.matches(keyword)).toList();
      if (items.isNotEmpty) {
        results.add(HelpCategory(
          id: category.id,
          title: category.title,
          icon: category.icon,
          items: items,
        ));
      }
    }
    return results;
  }

  TextStyle _serif({
    double size = 14,
    Color? color,
    FontWeight? weight,
    double? height,
    double? spacing,
  }) =>
      GoogleFonts.notoSerifTc(
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: height,
        letterSpacing: spacing,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = _displayContent;
    final categories = _filterCategories(content.categories);
    final fallback = !_shouldUseChinese &&
        _remoteContent == null &&
        !_isLoadingTranslation;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          _decorations(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _header(theme, content)),
                if (fallback) SliverToBoxAdapter(child: _fallback(theme)),
                SliverToBoxAdapter(child: _welcome(theme, content)),
                SliverToBoxAdapter(child: _search(theme, content)),
                SliverToBoxAdapter(
                  child: _filters(theme, content.categories),
                ),
                if (categories.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _empty(theme, content),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 48),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        ...categories.asMap().entries.map(
                              (entry) => _categorySection(
                            theme,
                            entry.value,
                            entry.key,
                          ),
                        ),
                        _footer(theme),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _decorations() => IgnorePointer(
    child: Stack(children: [
      Positioned(
        top: -26,
        right: -44,
        width: 205,
        child: Opacity(
          opacity: .20,
          child: Image.asset(
            'assets/images/guide/guide_top_right_botanical.png',
          ),
        ),
      ),
      Positioned(
        left: -45,
        bottom: -34,
        width: 205,
        child: Opacity(
          opacity: .17,
          child: Image.asset(
            'assets/images/guide/guide_bottom_left_botanical.png',
          ),
        ),
      ),
    ]),
  );

  Widget _header(ThemeData theme, HelpGuideContent content) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 8, 16, 12),
    child: SizedBox(
      height: 53,
      child: Stack(alignment: Alignment.center, children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 23),
          ),
        ),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            content.pageTitle,
            style: _serif(size: 24, weight: FontWeight.w600, spacing: 2.8),
          ),
          const SizedBox(height: 6),
          Row(mainAxisSize: MainAxisSize.min, children: [
            _line(theme, 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Icon(
                Icons.view_comfy_alt_rounded,
                size: 10,
                color: theme.colorScheme.primary.withValues(alpha: .55),
              ),
            ),
            _line(theme, 48),
          ]),
        ]),
        if (!_shouldUseChinese)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed:
              _isLoadingTranslation ? null : _loadRemoteTranslation,
              icon: _isLoadingTranslation
                  ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.translate_rounded, size: 21),
            ),
          ),
      ]),
    ),
  );

  Widget _line(ThemeData theme, double width) => Container(
    width: width,
    height: 1,
    color: theme.colorScheme.primary.withValues(alpha: .25),
  );

  Widget _fallback(ThemeData theme) => Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: theme.colorScheme.primaryContainer.withValues(alpha: .6),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Text(
      '目前尚未提供此語言的遊玩指南，暫時顯示繁體中文。',
      textAlign: TextAlign.center,
      style: _serif(size: 11.5),
    ),
  );

  Widget _welcome(ThemeData theme, HelpGuideContent content) {
    final primary = theme.colorScheme.primary;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      constraints: const BoxConstraints(minHeight: 150),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: .9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withValues(alpha: .16)),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: .07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        Positioned(
          right: -5,
          bottom: -18,
          width: 175,
          child: Opacity(
            opacity: .84,
            child: Image.asset(
              'assets/images/guide/guide_welcome_butterfly.png',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 23, 150, 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.welcomeTitle,
                style: _serif(
                  size: 19,
                  color: primary,
                  weight: FontWeight.w600,
                  spacing: .7,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                content.welcomeBody,
                style: _serif(
                  size: 12.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: .7),
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _search(ThemeData theme, HelpGuideContent content) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchKeyword = value),
      style: _serif(size: 14),
      decoration: InputDecoration(
        hintText: content.searchHint,
        hintStyle: _serif(
          size: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: .46),
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: theme.colorScheme.primary,
          size: 25,
        ),
        suffixIcon: _searchKeyword.isEmpty
            ? null
            : IconButton(
          onPressed: () {
            _searchController.clear();
            setState(() => _searchKeyword = '');
          },
          icon: const Icon(Icons.close_rounded),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface.withValues(alpha: .9),
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
        border: _searchBorder(theme, false),
        enabledBorder: _searchBorder(theme, false),
        focusedBorder: _searchBorder(theme, true),
      ),
    ),
  );

  OutlineInputBorder _searchBorder(ThemeData theme, bool focused) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(
          color: theme.colorScheme.primary
              .withValues(alpha: focused ? .60 : .20),
          width: focused ? 1.4 : 1,
        ),
      );

  Widget _filters(ThemeData theme, List<HelpCategory> categories) {
    final entries = <({String? id, String label, String asset})>[
      (
      id: null,
      label: '全部',
      asset: 'assets/images/guide/guide_category_moments.png',
      ),
      ...categories.map(
            (item) => (
        id: item.id,
        label: item.title,
        asset: _asset(item.title, categories.indexOf(item)),
        ),
      ),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 2),
      child: Row(
        children: entries.map((item) {
          final selected = _selectedCategoryId == item.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => setState(() => _selectedCategoryId = item.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                decoration: BoxDecoration(
                  color: selected
                      ? theme.colorScheme.primary.withValues(alpha: .11)
                      : theme.colorScheme.surface.withValues(alpha: .75),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: theme.colorScheme.primary
                        .withValues(alpha: selected ? .48 : .16),
                  ),
                ),
                child: Row(children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Image.asset(
                      item.asset,
                      fit: BoxFit.contain,
                      opacity: AlwaysStoppedAnimation(selected ? .95 : .70),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: _serif(
                      size: 12,
                      weight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _categorySection(ThemeData theme, HelpCategory category, int index) {
    return _guideSection(
      theme,
      title: category.title,
      subtitle: _subtitle(category.title),
      asset: _asset(category.title, index),
      items: category.items
          .map((item) => (question: item.question, answer: item.answer))
          .toList(),
    );
  }

  String _subtitle(String title) {
    if (title.contains('生活') || title.contains('陪伴')) return '日常功能與貼心小幫手';
    if (title.contains('AI') || title.contains('聊天') || title.contains('語音')) {
      return '聊天、語音與智慧互動相關';
    }
    if (title.contains('角色') || title.contains('創作')) return '角色設定與創作功能相關';
    if (title.contains('搜尋') || title.contains('遊玩')) return '探索角色與遊戲內容';
    if (title.contains('關懷')) return '溫柔陪伴與日常關懷';
    return '常見功能與操作說明';
  }

  String _asset(String title, int index) {
    if (title.contains('生活') || title.contains('陪伴')) {
      return 'assets/images/guide/guide_category_companion.png';
    }
    if (title.contains('關懷')) return 'assets/images/guide/guide_category_care.png';
    if (title.contains('語音')) return 'assets/images/guide/guide_category_voice.png';
    if (title.contains('AI') || title.contains('聊天')) {
      return 'assets/images/guide/guide_category_ai_chat.png';
    }
    if (title.contains('角色') || title.contains('創作')) {
      return 'assets/images/guide/guide_category_create.png';
    }
    if (title.contains('搜尋') || title.contains('遊玩')) {
      return 'assets/images/guide/guide_category_search.png';
    }
    const fallback = [
      'assets/images/guide/guide_category_character.png',
      'assets/images/guide/guide_category_moments.png',
      'assets/images/guide/guide_category_chat.png',
    ];
    return fallback[index % fallback.length];
  }

  Widget _guideSection(
      ThemeData theme, {
        required String title,
        required String subtitle,
        required String asset,
        required List<({String question, String answer})> items,
      }) {
    final primary = theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 4, 10),
          child: Row(children: [
            Container(
              width: 46,
              height: 46,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(asset, fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: _serif(
                      size: 17.5,
                      weight: FontWeight.w600,
                      spacing: .6,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: _serif(
                      size: 11.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: .47),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: .88),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primary.withValues(alpha: .14)),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: .055),
                blurRadius: 15,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Column(children: [
                Theme(
                  data: theme.copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 17),
                    childrenPadding: const EdgeInsets.fromLTRB(17, 0, 17, 17),
                    iconColor: primary,
                    collapsedIconColor: primary.withValues(alpha: .65),
                    title: Text(
                      item.question,
                      style: _serif(size: 13.5, weight: FontWeight.w500, height: 1.45),
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.answer,
                          style: _serif(
                            size: 12.5,
                            color: theme.colorScheme.onSurface.withValues(alpha: .68),
                            height: 1.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < items.length - 1)
                  Divider(
                    height: 1,
                    indent: 17,
                    endIndent: 17,
                    color: primary.withValues(alpha: .10),
                  ),
              ]);
            }),
          ),
        ),
      ]),
    );
  }

  Widget _footer(ThemeData theme) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _line(theme, 48),
      const SizedBox(width: 10),
      Icon(
        Icons.grass_rounded,
        size: 18,
        color: theme.colorScheme.primary.withValues(alpha: .52),
      ),
      const SizedBox(width: 5),
      Text(
        'Loving Dovey',
        style: GoogleFonts.cormorantGaramond(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: theme.colorScheme.primary.withValues(alpha: .55),
        ),
      ),
      const SizedBox(width: 10),
      _line(theme, 48),
    ]),
  );

  Widget _empty(ThemeData theme, HelpGuideContent content) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          Icons.search_off_rounded,
          size: 58,
          color: theme.colorScheme.primary.withValues(alpha: .4),
        ),
        const SizedBox(height: 14),
        Text(
          content.noResultsTitle,
          style: _serif(size: 17, weight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          content.noResultsBody,
          textAlign: TextAlign.center,
          style: _serif(
            size: 12.5,
            height: 1.6,
            color: theme.colorScheme.onSurface.withValues(alpha: .58),
          ),
        ),
      ]),
    ),
  );
}