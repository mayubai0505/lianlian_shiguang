import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';
import '../utils/character_navigator.dart';
import 'character_model.dart';
import 'character_profile_page.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

//搜尋頁面
class SearchCharacterPage extends StatefulWidget {
  const SearchCharacterPage({super.key});

  @override
  State<SearchCharacterPage> createState() => _SearchCharacterPageState();
}

class _SearchCharacterPageState extends State<SearchCharacterPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  late final Stream<QuerySnapshot> _charactersStream;
  final String APP_ID = AppConfig.appId;
  static const String _recentSearchesKey = 'character_recent_searches';
  static const int _maxRecentSearches = 10;
  List<String> _recentSearches = [];
  Timer? _searchSaveDebounce;
  late final Stream<QuerySnapshot> charactersStream;
  Set<String> _blockedCharacterIds = {};
  Set<String> _blockedCreatorIds = {};
  StreamSubscription<QuerySnapshot>? _blockedCharactersSub;
  StreamSubscription<QuerySnapshot>? _blockedCreatorsSub;
  @override
  void initState() {
    super.initState();

    _charactersStream = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('public_characters')
        .where('isPublic', isEqualTo: true)
        .where('status', isEqualTo: 'published')
        .orderBy('createdAt', descending: true)
        .limit(200)
        .snapshots();

    _loadRecentSearches();
    _listenBlockedCharacters();
    _listenBlockedCreators();
  }

  int _parseLikesCount(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;

  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_recentSearchesKey) ?? const <String>[];

    if (!mounted) return;
    setState(() {
      _recentSearches = saved
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .take(_maxRecentSearches)
          .toList();
    });
  }
  void _listenBlockedCharacters() {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    _blockedCharactersSub =
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('blockedCharacters')
            .snapshots()
            .listen(
              (snapshot) {
            if (!mounted) return;

            setState(() {
              _blockedCharacterIds =
                  snapshot.docs
                      .map((doc) => doc.id)
                      .toSet();
            });
          },
          onError: (e) {
            debugPrint(
              '❌ 搜尋頁讀取封鎖角色失敗：$e',
            );
          },
        );
  }

  void _listenBlockedCreators() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    _blockedCreatorsSub = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('blockedCreators')
        .snapshots()
        .listen(
          (snapshot) {
        if (!mounted) return;

        setState(() {
          _blockedCreatorIds =
              snapshot.docs.map((doc) => doc.id).toSet();
        });
      },
      onError: (e) {
        debugPrint('❌ 搜尋頁讀取封鎖創作者失敗：$e');
      },
    );
  }

  Future<void> _saveRecentSearch(String query) async {
    final keyword = query.trim();
    if (keyword.isEmpty) return;

    final updated = <String>[
      keyword,
      ..._recentSearches.where(
            (item) => item.toLowerCase() != keyword.toLowerCase(),
      ),
    ].take(_maxRecentSearches).toList();

    if (mounted) {
      setState(() => _recentSearches = updated);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchesKey, updated);
  }

  Future<void> _clearRecentSearches() async {
    if (mounted) {
      setState(() => _recentSearches = []);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
  }

  Future<void> _removeRecentSearch(String query) async {
    final updated = _recentSearches
        .where((item) => item != query)
        .toList();

    if (mounted) {
      setState(() {
        _recentSearches = updated;
      });
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _recentSearchesKey,
      updated,
    );
  }

  void _scheduleRecentSearchSave(String query) {
    _searchSaveDebounce?.cancel();

    final keyword = query.trim();
    if (keyword.isEmpty) return;

    _searchSaveDebounce = Timer(
      const Duration(milliseconds: 800),
          () => _saveRecentSearch(keyword),
    );
  }

  void _applyRecentSearch(String query) {
    _searchController.text = query;
    _searchController.selection = TextSelection.collapsed(
      offset: query.length,
    );
    setState(() => _searchQuery = query);
    _saveRecentSearch(query);
  }

  @override
  void dispose() {
    _blockedCharactersSub?.cancel();
    _blockedCreatorsSub?.cancel();
    _searchSaveDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = MediaQuery.sizeOf(context).width >= 850;

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: isDesktop ? null : AppBar(
          title: Text(
            l10n.search_companion_title,
            style: GoogleFonts.notoSerifTc(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme.colorScheme.onSurface,
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: IgnorePointer(
                child: Opacity(
                  opacity: isDarkMode ? 0.07 : 0.13,
                  child: Image.asset(
                    'assets/images/blocked_top_right_botanical.png',
                    width: MediaQuery.sizeOf(context).width * 0.34,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            // 網頁寬版原本隱藏 AppBar，額外提供返回鍵；不影響置中的標題。
            if (kIsWeb && isDesktop)
              Positioned(
                top: 23,
                left: 20,
                child: IconButton(
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ),
            Column(
              children: [
                if (isDesktop)
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 14),
                    child: Column(
                      children: [
                        Text(
                          l10n.search_companion_title,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 230,
                          height: 1,
                          color: theme.colorScheme.primary.withValues(alpha: 0.30),
                        ),
                      ],
                    ),
                  ),
                // 🔍 搜尋框
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 24 : 16,
                    vertical: isDesktop ? 12 : 8,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isDesktop ? 830 : double.infinity),
                    child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: l10n.search_character_hint,
                      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.5)),
                      prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                      suffixIcon: _searchQuery.isEmpty
                          ? null
                          : IconButton(
                        tooltip: l10n.search_character_clear,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchSaveDebounce?.cancel();
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),
                      filled: true,
                      fillColor: theme.cardColor.withValues(alpha:isDarkMode ? 0.70 : 0.75),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: theme.colorScheme.primary.withValues(alpha:0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: theme.colorScheme.primary.withValues(alpha:0.30)),
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      final keyword = value.trim();
                      setState(() => _searchQuery = keyword);

                      if (keyword.isEmpty) {
                        _searchSaveDebounce?.cancel();
                      } else {
                        _scheduleRecentSearchSave(keyword);
                      }
                    },
                    onSubmitted: (value) {
                      _searchSaveDebounce?.cancel();
                      _saveRecentSearch(value);
                    },
                    ),
                  ),
                ),

                if (_searchQuery.isEmpty && _recentSearches.isNotEmpty)
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isDesktop ? 1180 : double.infinity),
                      child: _buildRecentSearches(theme),
                    ),
                  ),

                // 📜 雙排格網結果
                Expanded(
                  child: _buildGridResults(theme),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildRecentSearches(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.search_character_recent,
                  style: GoogleFonts.notoSerifTc(
                    color: onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              TextButton(
                onPressed: _clearRecentSearches,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 24),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
                child: Text(
                  l10n.search_character_clear,
                  style: GoogleFonts.notoSerifTc(
                    color: onSurface.withValues(alpha: 0.44),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          SizedBox(
            height: 27,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _recentSearches.length,
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              itemBuilder: (context, index) {
                final query = _recentSearches[index];

                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 118),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 2, 5, 2),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.018),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: primary.withValues(alpha: 0.11),
                        width: 0.7,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _applyRecentSearch(query),
                            child: Transform.translate(
                              offset: const Offset(0, 1),
                              child: Text(
                                query,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSerifTc(
                                  color: onSurface.withValues(alpha: 0.70),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _removeRecentSearch(query),
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: Icon(
                              Icons.close_rounded,
                              size: 12,
                              color: onSurface.withValues(alpha: 0.38),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridResults(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: _charactersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          debugPrint('搜尋角色查詢失敗：${snapshot.error}');

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.search_character_load_failed,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final List<QueryDocumentSnapshot> allDocs =
        snapshot.data!.docs.where((doc) {
          if (_blockedCharacterIds.contains(doc.id)) {
            return false;
          }

          final data = doc.data() as Map<String, dynamic>;
          final creatorId =
              data['createdBy']?.toString().trim() ?? '';

          return creatorId.isEmpty ||
              !_blockedCreatorIds.contains(creatorId);
        }).toList();

        final String keyword =
        _searchQuery.trim().toLowerCase();

        late final List<QueryDocumentSnapshot> docs;

        if (keyword.isEmpty) {
          final List<QueryDocumentSnapshot> popularDocs =
          List<QueryDocumentSnapshot>.from(allDocs);

          popularDocs.sort((a, b) {
            final aData =
            a.data() as Map<String, dynamic>;

            final bData =
            b.data() as Map<String, dynamic>;

            final int aLikes =
            _parseLikesCount(aData['likesCount']);

            final int bLikes =
            _parseLikesCount(bData['likesCount']);

            return bLikes.compareTo(aLikes);
          });

          docs = popularDocs.take(6).toList();
        } else {
          docs = allDocs.where((doc) {
            final data =
            doc.data() as Map<String, dynamic>;

            final String name =
                data['name']
                    ?.toString()
                    .toLowerCase() ??
                    '';

            final String creatorName =
                data['creatorName']
                    ?.toString()
                    .toLowerCase() ??
                    '';

            final String occupation =
                data['occupation']
                    ?.toString()
                    .toLowerCase() ??
                    '';

            final String storySummary =
                data['storySummary']
                    ?.toString()
                    .toLowerCase() ??
                    '';

            final String background =
                data['background']
                    ?.toString()
                    .toLowerCase() ??
                    '';

            final List<String> tags =
            List<String>.from(
              data['personalityTags'] ??
                  const [],
            )
                .map(
                  (tag) =>
                  tag.toLowerCase(),
            )
                .toList();

            final List<String> identities =
            List<String>.from(
              data['identities'] ??
                  const [],
            )
                .map(
                  (value) =>
                  value.toLowerCase(),
            )
                .toList();

            return name.contains(keyword) ||
                creatorName.contains(keyword) ||
                occupation.contains(keyword) ||
                storySummary.contains(keyword) ||
                background.contains(keyword) ||
                identities.any(
                      (value) =>
                      value.contains(keyword),
                ) ||
                tags.any(
                      (tag) =>
                      tag.contains(keyword),
                );
          }).toList();
        }

        if (MediaQuery.sizeOf(context).width >= 850) {
          return _buildDesktopResults(theme, allDocs, docs, keyword, l10n);
        }

        if (docs.isEmpty) {
          return Center(
            child: Text(
              l10n.search_no_match_hint,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
          );
        }

        final String resultHeader =
        keyword.isEmpty
            ? l10n.search_character_popular
            : l10n.search_character_result_count(docs.length);

        return Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                6,
              ),
              child: Text(
                resultHeader,
                style: TextStyle(
                  color:
                  theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  16,
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: docs.length,
                itemBuilder: (
                    context,
                    index,
                    ) {
                  return _buildCharacterCard(
                    docs[index],
                    theme,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Desktop-only presentation; mobile cards and all search/filter logic remain intact.
  Widget _buildDesktopResults(
    ThemeData theme,
    List<QueryDocumentSnapshot> allDocs,
    List<QueryDocumentSnapshot> docs,
    String keyword,
    AppLocalizations l10n,
  ) {
    final popular = keyword.isEmpty ? docs.take(5).toList() : <QueryDocumentSnapshot>[];
    final popularIds = popular.map((doc) => doc.id).toSet();
    final results = keyword.isEmpty
        ? allDocs.where((doc) => !popularIds.contains(doc.id)).take(15).toList()
        : docs;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = (constraints.maxWidth - 40).clamp(0.0, 1240.0).toDouble();
        final columns = contentWidth >= 1050 ? 5 : (contentWidth >= 760 ? 4 : 3);
        final gap = 18.0;
        final cardWidth = (contentWidth - gap * (columns - 1)) / columns;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 42),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (keyword.isEmpty && popular.isNotEmpty) ...[
                    _desktopSectionHeading(
                      theme, Icons.local_fire_department_rounded,
                      l10n.search_character_popular,
                    ),
                    const SizedBox(height: 16),
                    _desktopCardWrap(theme, popular, cardWidth, gap),
                    const SizedBox(height: 32),
                  ],
                  if (results.isNotEmpty) ...[
                    _desktopSectionHeading(
                      theme, Icons.search_rounded,
                      keyword.isEmpty
                          ? l10n.search_character_result_count(results.length)
                          : l10n.search_character_result_count(docs.length),
                    ),
                    const SizedBox(height: 16),
                    _desktopCardWrap(theme, results, cardWidth, gap),
                  ] else if (popular.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Text(l10n.search_no_match_hint,
                            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: .65))),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _desktopSectionHeading(ThemeData theme, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(width: 9),
        Text(label, style: GoogleFonts.notoSerifTc(
          color: theme.colorScheme.onSurface,
          fontSize: 21,
          fontWeight: FontWeight.w700,
        )),
      ],
    );
  }

  Widget _desktopCardWrap(ThemeData theme, List<QueryDocumentSnapshot> docs,
      double width, double gap) {
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: docs.map((doc) => SizedBox(
        width: width,
        child: _buildDesktopCharacterCard(doc, theme),
      )).toList(),
    );
  }

  Widget _buildDesktopCharacterCard(DocumentSnapshot doc, ThemeData theme) {
    final data = doc.data() as Map<String, dynamic>;
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final imageUrl = (data['avatar'] ?? data['avatarPath'] ?? '').toString().trim();
    final tags = <String>[];
    for (final key in ['identities', 'personalityTags']) {
      final value = data[key];
      if (value is List) {
        for (final item in value) {
          final tag = item.toString().trim();
          if (tag.isNotEmpty && !tags.contains(tag) && tags.length < 2) tags.add(tag);
        }
      }
    }
    if (tags.isEmpty) {
      final occupation = data['occupation']?.toString().trim() ?? '';
      if (occupation.isNotEmpty) tags.add(occupation);
    }
    return Material(
      color: theme.cardColor.withValues(alpha: isDark ? .92 : .90),
      elevation: 3,
      shadowColor: primary.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          if (_searchQuery.isNotEmpty) await _saveRecentSearch(_searchQuery);
          final target = await Character.fromFirestoreAsync(doc);
          if (!context.mounted) return;
          await CharacterNavigator.open(context,
            characterId: target.id, fallbackName: target.name);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.15,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.15),
                      memCacheWidth: 640,
                      errorWidget: (_, __, ___) => _buildCharacterImageFallback(theme),
                      placeholder: (_, __) => _buildCharacterImageFallback(theme),
                    )
                  else
                    _buildCharacterImageFallback(theme),
                  Positioned(
                    top: 9, right: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .65),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.favorite, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text('${_parseLikesCount(data['likesCount'])}',
                          style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 9, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['name']?.toString() ?? '',
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      color: theme.colorScheme.onSurface,
                      fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 7),
                  SizedBox(
                    height: 25,
                    child: Row(children: [
                      for (final tag in tags)
                        Flexible(child: Container(
                          margin: const EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: isDark ? .22 : .09),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(tag, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: primary, fontSize: 12)),
                        )),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(
      DocumentSnapshot doc,
      ThemeData theme,
      ) {
    final charData =
    doc.data() as Map<String, dynamic>;

    final primaryColor =
        theme.colorScheme.primary;

    final l10n =
    AppLocalizations.of(context)!;

    final dynamic rawLikesCount = charData['likesCount'];
    final int likesCount = rawLikesCount is num
        ? rawLikesCount.toInt()
        : int.tryParse(rawLikesCount?.toString() ?? '') ?? 0;

    final String imageUrl = (
        charData['avatar'] ??
            charData['avatarPath'] ??
            ''
    ).toString().trim();

    return GestureDetector(
      onTap: () async {
        if (_searchQuery.isNotEmpty) {
          await _saveRecentSearch(_searchQuery);
        }

        final targetCharacter =
        await Character.fromFirestoreAsync(doc);

        if (!context.mounted) return;

        await CharacterNavigator.open(
          context,
          characterId: targetCharacter.id,
          fallbackName: targetCharacter.name,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color: primaryColor.withValues(
              alpha: 0.1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.06,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // =========================
              // 角色背景圖片
              // =========================
              if (imageUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,

                  // 稍微往上取景，避免角色臉部被裁掉。
                  alignment:
                  const Alignment(0, -0.15),

                  // 只限制解碼寬度，避免非正方形圖片被壓扁。
                  memCacheWidth: 720,

                  filterQuality:
                  FilterQuality.medium,

                  placeholder: (
                      context,
                      url,
                      ) {
                    return Container(
                      color: theme.colorScheme
                          .secondaryContainer,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 26,
                        height: 26,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      ),
                    );
                  },

                  errorWidget: (
                      context,
                      url,
                      error,
                      ) {
                    return _buildCharacterImageFallback(
                      theme,
                    );
                  },
                )
              else
                _buildCharacterImageFallback(
                  theme,
                ),

              // =========================
              // 底部漸層遮罩
              // =========================
              Align(
                alignment:
                Alignment.bottomCenter,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin:
                      Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(
                          alpha: 0.82,
                        ),
                        Colors.black.withValues(
                          alpha: 0.25,
                        ),
                        Colors.transparent,
                      ],
                      stops: const [
                        0,
                        0.55,
                        1,
                      ],
                    ),
                  ),
                ),
              ),

              // =========================
              // 右上角心動數
              // =========================
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$likesCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // =========================
              // 底部角色資料
              // =========================
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding:
                  const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        charData['name']
                            ?.toString() ??
                            '',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 18,
                          shadows: [
                            Shadow(
                              color:
                              Colors.black54,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _buildCharacterInfoText(
                          charData,
                          l10n,
                        ),
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white
                              .withValues(
                            alpha: 0.9,
                          ),
                          fontSize: 12,
                          shadows: const [
                            Shadow(
                              color:
                              Colors.black54,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCharacterImageFallback(
      ThemeData theme,
      ) {
    return Container(
      color: theme.colorScheme
          .secondaryContainer,
    );
  }
  String _buildCharacterInfoText(
      Map<String, dynamic> charData,
      AppLocalizations l10n,
      ) {
    final String age =
        charData['age']?.toString() ?? '??';

    final String occupation =
        charData['occupation']
            ?.toString()
            .trim() ??
            '';

    if (occupation.isNotEmpty) {
      return l10n.character_info_full(
        age,
        occupation,
      );
    }

    return l10n.character_info_age_only(
      age,
    );
  }
}