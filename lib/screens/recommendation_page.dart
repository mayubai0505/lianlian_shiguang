import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/app_constants.dart';
import 'character_model.dart';
import 'character_profile_page.dart';
import 'event_page.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

// =========================================================
// 🖼️ 推薦頁圖片共用快取
// 同一個 URL + 解碼寬度重用 ImageProvider。
// =========================================================
final Map<String, ImageProvider> _recommendationImageProviderCache =
<String, ImageProvider>{};

ImageProvider _recommendationImageProvider(
    String imageUrl, {
      required int cacheWidth,
    }) {
  final normalizedUrl = imageUrl.trim();
  final cacheKey = '$cacheWidth::$normalizedUrl';

  return _recommendationImageProviderCache.putIfAbsent(
    cacheKey,
        () => ResizeImage(
      CachedNetworkImageProvider(normalizedUrl),
      width: cacheWidth,
    ),
  );
}

Widget _buildRecommendationCachedImage(
    BuildContext context, {
      required String imageUrl,
      required BoxFit fit,
      required int cacheWidth,
      AlignmentGeometry alignment = Alignment.center,
      required Widget fallback,
    }) {
  final normalizedUrl = imageUrl.trim();
  if (normalizedUrl.isEmpty) return fallback;

  final provider = _recommendationImageProvider(
    normalizedUrl,
    cacheWidth: cacheWidth,
  );

  return Image(
    key: ValueKey<String>('recommendation_img_${cacheWidth}_$normalizedUrl'),
    image: provider,
    fit: fit,
    alignment: alignment,
    filterQuality: FilterQuality.medium,
    gaplessPlayback: true,
    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded || frame != null) return child;
      return fallback;
    },
    errorBuilder: (context, error, stackTrace) => fallback,
  );
}

//推薦頁面
class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  RecommendationPageState createState() => RecommendationPageState();
}

class RecommendationPageState extends State<RecommendationPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Random _random = Random();

  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _didScheduleFullRefresh = false;
  String? _errorMessage;

  List<String> _preferredTags = <String>[];
  List<_RecommendationItem> _recommendations = <_RecommendationItem>[];
  List<_RecommendationItem> _featuredItems = <_RecommendationItem>[];
  List<_RecommendationItem> _matchedItems = <_RecommendationItem>[];
  List<_RecommendationItem> _exploreItems = <_RecommendationItem>[];
  final Set<String> _preloadedImageKeys = <String>{};

  _RecommendationPhaseInfo _phase = const _RecommendationPhaseInfo();

  static const Map<String, List<String>> _tagKeywords = {
    '霸總': ['霸總', '霸道總裁', '總裁', '財閥', 'ceo', 'CEO'],
    '溫柔': ['溫柔', '溫柔系', '體貼', '暖男', '暖系', '寵溺'],
    '高冷': ['高冷', '冷淡', '寡言', '禁慾', '疏離'],
    '腹黑': ['腹黑', '心機', '城府', '狡猾'],
    '年下': ['年下', '弟弟', '弟系', '學弟'],
    '年上': ['年上', '成熟', '叔系', '學長'],
    '傲嬌': ['傲嬌', '嘴硬', '彆扭'],
    '忠犬': ['忠犬', '黏人', '專一', '守護', '忠誠'],
    '病嬌': ['病嬌', '偏執', '瘋批', '黑化'],
    '神秘': ['神秘', '謎樣', '深不可測'],
    '治癒': ['治癒', '療癒', '溫暖', '安心'],
    '反差感': ['反差', '反差感', '雙面', '外冷內熱'],
    '校園': ['校園', '學生', '學長', '學弟', '同學', '老師'],
    '職場': ['職場', '上司', '老闆', '秘書', '總監', '經理', '辦公室'],
    '古風': ['古風', '古代', '王爺', '皇帝', '太子', '將軍', '江湖', '武俠'],
    '非人': ['非人', '吸血鬼', '狼人', '妖', '魔', '神明', '精靈', '獸人', '人魚'],
  };

  bool _didStartInitialLoad = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // AppLocalizations.of(context) 需要等 inherited widgets 建立完成後才能使用。
    // 只在第一次 didChangeDependencies 時啟動初始推薦載入，避免重複查詢。
    if (_didStartInitialLoad) return;
    _didStartInitialLoad = true;
    _loadRecommendations();
  }

  Future<void> refreshRecommendations() {
    return _loadRecommendations(refresh: true);
  }

  Future<void> _loadRecommendations({bool refresh = false, bool full = false}) async {
    final l10n = AppLocalizations.of(context)!;
    if (refresh) {
      if (mounted) {
        setState(() => _isRefreshing = true);
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }
    }

    final loadStopwatch = Stopwatch()..start();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('尚未登入');
      }

      final userRef = _db.collection('users').doc(user.uid);

      final results = await Future.wait<dynamic>([
        userRef.get(),
        userRef.collection('blockedCharacters').get(),
        userRef.collection('blockedCreators').get(),
        (() {
          Query<Map<String, dynamic>> query = _db
              .collection('artifacts')
              .doc(AppConfig.appId)
              .collection('public_characters')
              .where('isPublic', isEqualTo: true)
              .where('status', isEqualTo: 'published');

          // 首次進頁只抓足夠產生推薦區塊的角色，先讓畫面出來。
          // 背景再補跑完整資料，不讓玩家一直盯著轉圈圈。
          if (!full) {
            query = query.limit(40);
          }

          return query.get();
        })(),
      ]);

      final userDoc = results[0] as DocumentSnapshot<Map<String, dynamic>>;
      final blockedCharacterSnapshot = results[1] as QuerySnapshot<Map<String, dynamic>>;
      final blockedCreatorSnapshot = results[2] as QuerySnapshot<Map<String, dynamic>>;
      final characterSnapshot = results[3] as QuerySnapshot<Map<String, dynamic>>;

      final userData = userDoc.data() ?? <String, dynamic>{};

      final preferredTags = (userData['preferredCharacterTags'] as List<dynamic>?)
          ?.map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList() ??
          <String>[];

      final behaviorScores = _parseScoreMap(userData['behaviorPreferenceScores']);

      final startedAt = await _resolveRecommendationStartAt(
        userRef: userRef,
        userData: userData,
      );

      final phase = _buildPhaseInfo(startedAt);

      final blockedCharacterIds = blockedCharacterSnapshot.docs.map((doc) => doc.id).toSet();
      final blockedCreatorIds = blockedCreatorSnapshot.docs.map((doc) => doc.id).toSet();

      final characters = characterSnapshot.docs
          .map(
            (doc) => Character.fromFirestoreLite(doc),
      )
          .toList();

      characters.removeWhere(
            (character) =>
        blockedCharacterIds.contains(character.id) ||
            blockedCreatorIds.contains(character.createdBy),
      );

      final ranked = characters
          .map(
            (character) => _scoreCharacter(
          character: character,
          preferredTags: preferredTags,
          behaviorScores: behaviorScores,
          phase: phase,
        ),
      )
          .toList();

      ranked.sort((a, b) {
        final scoreCompare = b.score.compareTo(a.score);
        if (scoreCompare != 0) return scoreCompare;

        final playCompare = b.character.playCount.compareTo(a.character.playCount);
        if (playCompare != 0) return playCompare;

        return b.randomTieBreak.compareTo(a.randomTieBreak);
      });

      final featured = ranked.take(4).toList();
      final featuredIds = featured.map((e) => e.character.id).toSet();

      final matchedPool = ranked
          .where(
            (item) =>
        !featuredIds.contains(item.character.id) &&
            (item.initialMatchedTags.isNotEmpty || item.behaviorMatchedScore > 0),
      )
          .take(6)
          .toList();

      final matchedIds = matchedPool.map((e) => e.character.id).toSet();

      final explorePool = ranked
          .where(
            (item) =>
        !featuredIds.contains(item.character.id) &&
            !matchedIds.contains(item.character.id),
      )
          .toList()
        ..shuffle(_random);

      final exploreItems = explorePool.take(6).toList();

      if (!mounted) return;

      setState(() {
        _preferredTags = preferredTags;
        _phase = phase;
        _recommendations = ranked;
        _featuredItems = featured;
        _matchedItems = matchedPool;
        _exploreItems = exploreItems;
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = null;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _precacheRecommendationImages(
          context,
          <_RecommendationItem>[
            ...featured,
            ...matchedPool,
            ...exploreItems,
          ],
        );
      });

      loadStopwatch.stop();
      debugPrint(
        '⚡ 推薦頁載入完成：${loadStopwatch.elapsedMilliseconds} ms，'
            '角色數：${characters.length}，full=$full',
      );

      // 首屏已經顯示後，再靜默補完整推薦池。
      if (!full && !_didScheduleFullRefresh) {
        _didScheduleFullRefresh = true;

        Future<void>.delayed(const Duration(milliseconds: 350), () async {
          if (!mounted) return;

          try {
            await _loadRecommendations(
              refresh: true,
              full: true,
            );
          } catch (_) {
            // 完整背景更新失敗也不影響已經顯示的首屏推薦。
          }
        });
      }
    } catch (e, stackTrace) {
      loadStopwatch.stop();
      debugPrint(
        '❌ 載入推薦失敗：$e '
            '(${loadStopwatch.elapsedMilliseconds} ms)',
      );
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = l10n.recommendation_load_failed;
      });
    }
  }

  Future<DateTime> _resolveRecommendationStartAt({
    required DocumentReference<Map<String, dynamic>> userRef,
    required Map<String, dynamic> userData,
  }) async {
    final rawStart = userData['recommendationStartedAt'];
    final rawPreferenceAt = userData['preferenceOnboardingCompletedAt'];
    final rawWelcomeAt = userData['welcomeGuideCompletedAt'];

    DateTime? startAt;

    if (rawStart is Timestamp) {
      startAt = rawStart.toDate();
    } else if (rawPreferenceAt is Timestamp) {
      startAt = rawPreferenceAt.toDate();
    } else if (rawWelcomeAt is Timestamp) {
      startAt = rawWelcomeAt.toDate();
    }

    if (startAt != null) return startAt;

    final now = DateTime.now();
    await userRef.set({
      'recommendationStartedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return now;
  }

  _RecommendationPhaseInfo _buildPhaseInfo(DateTime startedAt) {
    final now = DateTime.now();
    final elapsedDays = now.difference(
      DateTime(startedAt.year, startedAt.month, startedAt.day),
    ).inDays;

    final useBehaviorPreference = elapsedDays >= 3;

    if (useBehaviorPreference) {
      return _RecommendationPhaseInfo(
        startedAt: startedAt,
        elapsedDays: elapsedDays,
        useBehaviorPreference: true,
        initialWeight: 0.30,
        behaviorWeight: 0.55,
        popularityWeight: 0.10,
        explorationWeight: 0.05,
      );
    }

    return _RecommendationPhaseInfo(
      startedAt: startedAt,
      elapsedDays: elapsedDays,
      useBehaviorPreference: false,
      initialWeight: 0.80,
      behaviorWeight: 0.05,
      popularityWeight: 0.10,
      explorationWeight: 0.05,
    );
  }

  Map<String, double> _parseScoreMap(dynamic raw) {
    final result = <String, double>{};
    if (raw is! Map) return result;

    raw.forEach((key, value) {
      final normalizedKey = _normalize(key.toString());
      final numericValue = value is num ? value.toDouble() : double.tryParse(value.toString());
      if (normalizedKey.isEmpty || numericValue == null) return;
      result[normalizedKey] = numericValue;
    });

    return result;
  }

  _RecommendationItem _scoreCharacter({
    required Character character,
    required List<String> preferredTags,
    required Map<String, double> behaviorScores,
    required _RecommendationPhaseInfo phase,
  }) {
    final searchable = <String>[
      ...character.personalityTags,
      character.occupation,
    ].map(_normalize).where((e) => e.isNotEmpty).toList();

    final initialMatched = <String>[];
    double initialMatchScore = 0;

    for (final preference in preferredTags) {
      final keywords = (_tagKeywords[preference] ?? <String>[preference]).map(_normalize).toList();

      final isMatch = keywords.any((keyword) {
        return searchable.any(
              (value) => value == keyword || value.contains(keyword) || keyword.contains(value),
        );
      });

      if (isMatch) {
        initialMatched.add(preference);
        initialMatchScore += 1;
      }
    }

    double behaviorMatchScore = 0;
    for (final entry in behaviorScores.entries) {
      final scoreValue = entry.value;
      if (scoreValue <= 0) continue;

      final key = entry.key;
      final isMatch = searchable.any(
            (value) => value == key || value.contains(key) || key.contains(value),
      );

      if (isMatch) {
        behaviorMatchScore += scoreValue;
      }
    }

    final double popularityBoost =
    min(log(max(1, character.playCount + 1)) / ln10, 4.0)
        .toDouble();
    final explorationBoost = _random.nextDouble();
    final double normalizedBehaviorScore = behaviorMatchScore <= 0
        ? 0.0
        : min(
      log(behaviorMatchScore + 1) / ln10,
      4.0,
    ).toDouble();

    final score =
        (initialMatchScore * 12 * phase.initialWeight) +
            (normalizedBehaviorScore * 12 * phase.behaviorWeight) +
            (popularityBoost * 2.8 * phase.popularityWeight) +
            (explorationBoost * 4 * phase.explorationWeight);

    return _RecommendationItem(
      character: character,
      score: score,
      initialMatchedTags: initialMatched,
      behaviorMatchedScore: behaviorMatchScore,
      popularityScore: popularityBoost,
      randomTieBreak: explorationBoost,
    );
  }

  List<String> _extractBehaviorSignals(Character character) {
    final signals = <String>{};

    for (final tag in character.personalityTags) {
      final normalized = _normalize(tag);
      if (normalized.isNotEmpty) signals.add(normalized);
    }

    final occupation = _normalize(character.occupation);
    if (occupation.isNotEmpty) signals.add(occupation);

    return signals.toList();
  }


  String _preferenceTagLabel(
      String tag,
      AppLocalizations l10n,
      ) {
    switch (tag) {
      case '溫柔':
        return l10n.preference_tag_gentle;
      case '高冷':
        return l10n.preference_tag_cold;
      case '腹黑':
        return l10n.preference_tag_scheming;
      case '傲嬌':
        return l10n.preference_tag_tsundere;
      case '忠犬':
        return l10n.preference_tag_loyal;
      case '病嬌':
        return l10n.preference_tag_yandere;
      case '神秘':
        return l10n.preference_tag_mysterious;
      case '治癒':
        return l10n.preference_tag_healing;
      case '反差感':
        return l10n.preference_tag_gap_moe;
      case '年上':
        return l10n.preference_tag_older;
      case '年下':
        return l10n.preference_tag_younger;
      case '霸總':
        return l10n.preference_tag_ceo;
      case '校園':
        return l10n.preference_tag_school;
      case '職場':
        return l10n.preference_tag_workplace;
      case '古風':
        return l10n.preference_tag_ancient;
      case '非人':
        return l10n.preference_tag_nonhuman;
      default:
        return tag;
    }
  }

  String _translatedTagList(
      Iterable<String> tags,
      AppLocalizations l10n, {
        String separator = '・',
      }) {
    return tags
        .map((tag) => _preferenceTagLabel(tag, l10n))
        .join(separator);
  }

  String _prettyBehaviorHint(Character character) {
    final l10n = AppLocalizations.of(context)!;
    final tags = character.personalityTags.where((e) => e.trim().isNotEmpty).take(2).toList();
    if (tags.isNotEmpty) {
      return l10n.recommendation_behavior_hint_similar_type;
    }

    if (character.occupation.trim().isNotEmpty) {
      return l10n.recommendation_behavior_hint_forming;
    }

    return l10n.recommendation_behavior_hint_recent;
  }

  String _normalize(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'^#+'), '')
        .replaceAll(' ', '')
        .toLowerCase();
  }

  String _imageUrl(Character character) {
    if (character.galleryPaths.isNotEmpty) {
      final first = character.galleryPaths.first.trim();
      if (first.isNotEmpty) return first;
    }
    return character.avatarPath.trim();
  }

  void _precacheRecommendationImages(
      BuildContext context,
      Iterable<_RecommendationItem> items,
      ) {
    for (final item in items) {
      final imageUrl = _imageUrl(item.character).trim();
      if (imageUrl.isEmpty) continue;

      const cacheWidth = 720;
      final cacheKey = '$cacheWidth::$imageUrl';
      if (_preloadedImageKeys.contains(cacheKey)) continue;

      _preloadedImageKeys.add(cacheKey);

      final provider = _recommendationImageProvider(
        imageUrl,
        cacheWidth: cacheWidth,
      );

      precacheImage(provider, context).catchError((error) {
        _preloadedImageKeys.remove(cacheKey);
        debugPrint('預載推薦頁角色圖片失敗：$error');
      });
    }
  }

  Future<void> _openCharacter(Character character) async {
    await _recordBehaviorInteraction(character);

    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CharacterProfilePage(
          character: character,
          characterId: character.id,
        ),
      ),
    );
  }

  Future<void> _recordBehaviorInteraction(Character character) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userRef = _db.collection('users').doc(user.uid);
      final interactionRef = userRef.collection('recommendationInteractions').doc(character.id);
      final batch = _db.batch();

      final updates = <String, dynamic>{
        'lastRecommendationInteractionAt': FieldValue.serverTimestamp(),
        'lastRecommendedCharacterId': character.id,
        'lastRecommendedCharacterName': character.name,
      };

      for (final signal in _extractBehaviorSignals(character)) {
        final increment = _preferredTags.any((tag) => _normalize(tag) == signal) ? 2 : 1;
        updates['behaviorPreferenceScores.$signal'] = FieldValue.increment(increment);
      }

      batch.set(
        userRef,
        updates,
        SetOptions(merge: true),
      );

      batch.set(
        interactionRef,
        {
          'characterId': character.id,
          'characterName': character.name,
          'createdBy': character.createdBy,
          'signals': _extractBehaviorSignals(character),
          'openCount': FieldValue.increment(1),
          'lastOpenedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      await batch.commit();
    } catch (e) {
      debugPrint('⚠️ 記錄推薦互動失敗：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final onSurface = colors.onSurface;
    final topInset = MediaQuery.paddingOf(context).top;
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colors.primary,
          strokeWidth: 2.2,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_outlined,
                size: 52,
                color: colors.primary.withValues(alpha: 0.55),
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 14,
                  height: 1.7,
                  color: onSurface.withValues(alpha: 0.58),
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () => _loadRecommendations(),
                child: Text(
                  l10n.recommendation_reload,
                  style: GoogleFonts.notoSerifTc(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_recommendations.isEmpty) {
      return RefreshIndicator(
        color: colors.primary,
        onRefresh: () => _loadRecommendations(refresh: true, full: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24, topInset + 48, 24, 40),
          children: [
            Icon(
              Icons.spa_outlined,
              size: 48,
              color: colors.primary.withValues(alpha: 0.30),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.recommendation_empty,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                fontSize: 14,
                color: onSurface.withValues(alpha: 0.58),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: colors.primary,
      onRefresh: () => _loadRecommendations(refresh: true, full: true),
      child: CustomScrollView(
        key: const PageStorageKey<String>('recommendation_page_scroll'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, topInset + 18, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.recommendation_title,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                color: onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 🚧 送審版：活動功能仍保留，但暫時隱藏入口。
                  // const _ActiveEventEntry(),
                  if (_preferredTags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _preferredTags
                          .map(
                            (tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.14),
                            ),
                          ),
                          child: Text(
                            '#${_preferenceTagLabel(tag, l10n)}',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
          if (_featuredItems.isNotEmpty)
            SliverToBoxAdapter(
              child: _SectionTitle(
                title: l10n.recommendation_featured_title,
                subtitle: l10n.recommendation_featured_subtitle,
              ),
            ),
          if (_featuredItems.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 318,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: _featuredItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final item = _featuredItems[index];
                    return SizedBox(
                      width: 250,
                      child: _FeaturedRecommendationCard(
                        item: item,
                        imageUrl: _imageUrl(item.character),
                        reasonText: item.reasonText(
                          _phase,
                          _prettyBehaviorHint(item.character),
                          l10n,
                              (tag) => _preferenceTagLabel(tag, l10n),
                        ),
                        onTap: () => _openCharacter(item.character),
                      ),
                    );
                  },
                ),
              ),
            ),
          if (_matchedItems.isNotEmpty)
            SliverToBoxAdapter(
              child: _SectionTitle(
                title: _phase.useBehaviorPreference ? l10n.recommendation_matched_behavior_title : l10n.recommendation_matched_initial_title,
                subtitle: _phase.useBehaviorPreference
                    ? l10n.recommendation_matched_behavior_subtitle
                    : l10n.recommendation_matched_initial_subtitle,
              ),
            ),
          if (_matchedItems.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = _matchedItems[index];
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, index == 0 ? 8 : 0, 20, 12),
                    child: _CompactRecommendationCard(
                      item: item,
                      imageUrl: _imageUrl(item.character),
                      reasonText: item.reasonText(
                        _phase,
                        _prettyBehaviorHint(item.character),
                        l10n,
                            (tag) => _preferenceTagLabel(tag, l10n),
                      ),
                      onTap: () => _openCharacter(item.character),
                    ),
                  );
                },
                childCount: _matchedItems.length,
              ),
            ),
          if (_exploreItems.isNotEmpty)
            SliverToBoxAdapter(
              child: _SectionTitle(
                title: l10n.recommendation_explore_title,
                subtitle: l10n.recommendation_explore_subtitle,
              ),
            ),
          if (_exploreItems.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = _exploreItems[index];
                    return _ExploreRecommendationCard(
                      item: item,
                      imageUrl: _imageUrl(item.character),
                      onTap: () => _openCharacter(item.character),
                    );
                  },
                  childCount: _exploreItems.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.74,
                ),
              ),
            ),
          if (_isRefreshing)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Center(
                  child: Text(
                    l10n.recommendation_refreshing,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 12,
                      color: onSurface.withValues(alpha: 0.48),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActiveEventEntry extends StatelessWidget {
  const _ActiveEventEntry();

  CollectionReference<Map<String, dynamic>> _eventsRef() =>
      FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('events');

  DateTime? _date(dynamic value) => value is Timestamp ? value.toDate() : null;

  bool _isRunning(Map<String, dynamic> data) {
    if (data['isActive'] != true) return false;
    final now = DateTime.now();
    final start = _date(data['startAt']);
    final end = _date(data['endAt']);
    if (start != null && now.isBefore(start)) return false;
    if (end != null && now.isAfter(end)) return false;
    return true;
  }

  String _remaining(DateTime? end) {
    if (end == null) return '活動進行中';
    final d = end.difference(DateTime.now());
    if (d.isNegative) return '活動已結束';
    if (d.inDays >= 1) return '剩 ${d.inDays + 1} 天';
    if (d.inHours >= 1) return '剩 ${d.inHours} 小時';
    return '即將結束';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final onSurface = colors.onSurface;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      // 測試階段先不要在 query 層加 isActive 條件。
      // 直接讀 events 後由前端判斷，可同時避開資料型別/欄位異常造成完全查不到，
      // 並讓 log 能看見實際讀到哪些活動。
      stream: _eventsRef().limit(20).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint(
            '❌ 活動入口讀取失敗：appId=${AppConfig.appId} error=${snapshot.error}',
          );
          return const SizedBox.shrink();
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final now = DateTime.now();
        debugPrint(
          '🎃 活動入口讀取：appId=${AppConfig.appId} '
              'docs=${snapshot.data!.docs.length} now=$now',
        );

        for (final eventDoc in snapshot.data!.docs) {
          final eventData = eventDoc.data();
          debugPrint(
            '🎃 event=${eventDoc.id} '
                'isActive=${eventData['isActive']} '
                'startAt=${_date(eventData['startAt'])} '
                'endAt=${_date(eventData['endAt'])} '
                'running=${_isRunning(eventData)}',
          );
        }

        final docs = snapshot.data!.docs
            .where((d) => _isRunning(d.data()))
            .toList();

        if (docs.isEmpty) {
          debugPrint('⚠️ 活動入口：目前沒有符合顯示條件的活動');
          return const SizedBox.shrink();
        }

        docs.sort((a, b) {
          final aa = _date(a.data()['startAt']);
          final bb = _date(b.data()['startAt']);
          if (aa == null && bb == null) return 0;
          if (aa == null) return 1;
          if (bb == null) return -1;
          return bb.compareTo(aa);
        });

        final doc = docs.first;
        final data = doc.data();
        final name = (data['name'] ?? '期間限定活動').toString();
        final subtitle = (data['subtitle'] ?? '和他一起留下這個季節的特別回憶。').toString();
        final imageUrl = (data['bannerImageUrl'] ?? data['heroImageUrl'] ?? '').toString().trim();
        final currencyName = (data['currencyName'] ?? '活動貨幣').toString();
        final currencyIcon = (data['currencyIcon'] ?? '✦').toString();
        final endAt = _date(data['endAt']);

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EventPage(eventId: doc.id)),
              ),
              child: Ink(
                height: 136,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: colors.primary.withValues(alpha: 0.055),
                  border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (imageUrl.isNotEmpty)
                        _buildRecommendationCachedImage(
                          context,
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          cacheWidth: 900,
                          alignment: Alignment.center,
                          fallback: const SizedBox.shrink(),
                        ),
                      if (imageUrl.isNotEmpty)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withValues(alpha: 0.46),
                                Colors.black.withValues(alpha: 0.16),
                                Colors.black.withValues(alpha: 0.02),
                              ],
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: imageUrl.isNotEmpty ? Colors.white : onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 11.5,
                                      color: imageUrl.isNotEmpty
                                          ? Colors.white.withValues(alpha: 0.88)
                                          : onSurface.withValues(alpha: 0.56),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      _EventMiniPill(icon: Icons.schedule_rounded, label: _remaining(endAt)),
                                      _EventMiniPill(textIcon: currencyIcon, label: currencyName),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: imageUrl.isNotEmpty
                                    ? Colors.white.withValues(alpha: 0.92)
                                    : colors.primary.withValues(alpha: 0.10),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.arrow_forward_rounded, size: 19, color: colors.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EventMiniPill extends StatelessWidget {
  final IconData? icon;
  final String? textIcon;
  final String label;

  const _EventMiniPill({this.icon, this.textIcon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: colors.primary),
            const SizedBox(width: 4),
          ] else if ((textIcon ?? '').isNotEmpty) ...[
            Text(textIcon!, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.notoSerifTc(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final onSurface = colors.onSurface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSerifTc(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.notoSerifTc(
              fontSize: 12.5,
              height: 1.6,
              color: onSurface.withValues(alpha: 0.54),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedRecommendationCard extends StatelessWidget {
  final _RecommendationItem item;
  final String imageUrl;
  final String reasonText;
  final VoidCallback onTap;

  const _FeaturedRecommendationCard({
    required this.item,
    required this.imageUrl,
    required this.reasonText,
    required this.onTap,
  });

  String _translateKnownPreferenceTag(
      String tag,
      AppLocalizations l10n,
      ) {
    switch (tag) {
      case '溫柔':
        return l10n.preference_tag_gentle;
      case '高冷':
        return l10n.preference_tag_cold;
      case '腹黑':
        return l10n.preference_tag_scheming;
      case '傲嬌':
        return l10n.preference_tag_tsundere;
      case '忠犬':
        return l10n.preference_tag_loyal;
      case '病嬌':
        return l10n.preference_tag_yandere;
      case '神秘':
        return l10n.preference_tag_mysterious;
      case '治癒':
        return l10n.preference_tag_healing;
      case '反差感':
        return l10n.preference_tag_gap_moe;
      case '年上':
        return l10n.preference_tag_older;
      case '年下':
        return l10n.preference_tag_younger;
      case '霸總':
        return l10n.preference_tag_ceo;
      case '校園':
        return l10n.preference_tag_school;
      case '職場':
        return l10n.preference_tag_workplace;
      case '古風':
        return l10n.preference_tag_ancient;
      case '非人':
        return l10n.preference_tag_nonhuman;
      default:
        return tag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final onSurface = colors.onSurface;
    final character = item.character;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: colors.surface,
            border: Border.all(
              color: colors.outline.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (imageUrl.isNotEmpty)
                        _buildRecommendationCachedImage(
                          context,
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          cacheWidth: 720,
                          fallback: _ImageFallback.large(context),
                        )
                      else
                        _ImageFallback.large(context),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.90),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            item.initialMatchedTags.isNotEmpty ? l10n.recommendation_badge_for_you : l10n.recommendation_badge_featured,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 34, 14, 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.00),
                                Colors.black.withValues(alpha: 0.58),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                character.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                reasonText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 11.5,
                                  height: 1.5,
                                  color: Colors.white.withValues(alpha: 0.90),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (character.personalityTags.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: character.personalityTags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '#${_translateKnownPreferenceTag(tag, l10n)}',
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 10.5,
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      if (character.personalityTags.isNotEmpty) const SizedBox(height: 10),
                      Text(
                        character.occupation.trim().isNotEmpty
                            ? character.occupation
                            : l10n.recommendation_default_occupation_hint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 12,
                          color: onSurface.withValues(alpha: 0.58),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactRecommendationCard extends StatelessWidget {
  final _RecommendationItem item;
  final String imageUrl;
  final String reasonText;
  final VoidCallback onTap;

  const _CompactRecommendationCard({
    required this.item,
    required this.imageUrl,
    required this.reasonText,
    required this.onTap,
  });

  String _translateKnownPreferenceTag(
      String tag,
      AppLocalizations l10n,
      ) {
    switch (tag) {
      case '溫柔':
        return l10n.preference_tag_gentle;
      case '高冷':
        return l10n.preference_tag_cold;
      case '腹黑':
        return l10n.preference_tag_scheming;
      case '傲嬌':
        return l10n.preference_tag_tsundere;
      case '忠犬':
        return l10n.preference_tag_loyal;
      case '病嬌':
        return l10n.preference_tag_yandere;
      case '神秘':
        return l10n.preference_tag_mysterious;
      case '治癒':
        return l10n.preference_tag_healing;
      case '反差感':
        return l10n.preference_tag_gap_moe;
      case '年上':
        return l10n.preference_tag_older;
      case '年下':
        return l10n.preference_tag_younger;
      case '霸總':
        return l10n.preference_tag_ceo;
      case '校園':
        return l10n.preference_tag_school;
      case '職場':
        return l10n.preference_tag_workplace;
      case '古風':
        return l10n.preference_tag_ancient;
      case '非人':
        return l10n.preference_tag_nonhuman;
      default:
        return tag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final onSurface = colors.onSurface;
    final character = item.character;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colors.outline.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: 92,
                  height: 116,
                  child: imageUrl.isNotEmpty
                      ? _buildRecommendationCachedImage(
                    context,
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    cacheWidth: 360,
                    fallback: _ImageFallback.small(context),
                  )
                      : _ImageFallback.small(context),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      reasonText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12,
                        height: 1.55,
                        color: item.initialMatchedTags.isNotEmpty || item.behaviorMatchedScore > 0
                            ? colors.primary.withValues(alpha: 0.86)
                            : onSurface.withValues(alpha: 0.56),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (character.personalityTags.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: character.personalityTags.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '#${_translateKnownPreferenceTag(tag, l10n)}',
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 10.5,
                                color: colors.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreRecommendationCard extends StatelessWidget {
  final _RecommendationItem item;
  final String imageUrl;
  final VoidCallback onTap;

  const _ExploreRecommendationCard({
    required this.item,
    required this.imageUrl,
    required this.onTap,
  });

  String _translateKnownPreferenceTag(
      String tag,
      AppLocalizations l10n,
      ) {
    switch (tag) {
      case '溫柔':
        return l10n.preference_tag_gentle;
      case '高冷':
        return l10n.preference_tag_cold;
      case '腹黑':
        return l10n.preference_tag_scheming;
      case '傲嬌':
        return l10n.preference_tag_tsundere;
      case '忠犬':
        return l10n.preference_tag_loyal;
      case '病嬌':
        return l10n.preference_tag_yandere;
      case '神秘':
        return l10n.preference_tag_mysterious;
      case '治癒':
        return l10n.preference_tag_healing;
      case '反差感':
        return l10n.preference_tag_gap_moe;
      case '年上':
        return l10n.preference_tag_older;
      case '年下':
        return l10n.preference_tag_younger;
      case '霸總':
        return l10n.preference_tag_ceo;
      case '校園':
        return l10n.preference_tag_school;
      case '職場':
        return l10n.preference_tag_workplace;
      case '古風':
        return l10n.preference_tag_ancient;
      case '非人':
        return l10n.preference_tag_nonhuman;
      default:
        return tag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final onSurface = colors.onSurface;
    final character = item.character;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colors.outline.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (imageUrl.isNotEmpty)
                        _buildRecommendationCachedImage(
                          context,
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          cacheWidth: 480,
                          fallback: _ImageFallback.small(context),
                        )
                      else
                        _ImageFallback.small(context),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.recommendation_badge_explore,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        character.personalityTags.take(2).join('・').isNotEmpty
                            ? character.personalityTags
                            .take(2)
                            .map((tag) => _translateKnownPreferenceTag(tag, l10n))
                            .join('・')
                            : l10n.recommendation_explore_fallback,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 11.5,
                          color: onSurface.withValues(alpha: 0.52),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageFallback {
  static Widget large(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.primary.withValues(alpha: 0.05),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_outline_rounded,
        size: 48,
        color: colors.primary.withValues(alpha: 0.26),
      ),
    );
  }

  static Widget small(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.primary.withValues(alpha: 0.05),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_outline_rounded,
        size: 38,
        color: colors.primary.withValues(alpha: 0.26),
      ),
    );
  }
}

class _RecommendationItem {
  final Character character;
  final double score;
  final List<String> initialMatchedTags;
  final double behaviorMatchedScore;
  final double popularityScore;
  final double randomTieBreak;

  const _RecommendationItem({
    required this.character,
    required this.score,
    required this.initialMatchedTags,
    required this.behaviorMatchedScore,
    required this.popularityScore,
    required this.randomTieBreak,
  });

  String reasonText(
      _RecommendationPhaseInfo phase,
      String fallbackBehaviorHint,
      AppLocalizations l10n,
      String Function(String tag) translateTag,
      ) {
    if (phase.useBehaviorPreference && behaviorMatchedScore > 0) {
      return fallbackBehaviorHint;
    }

    if (initialMatchedTags.isNotEmpty) {
      final translatedTags = initialMatchedTags
          .take(2)
          .map(translateTag)
          .join('・');

      return l10n.recommendation_reason_liked_tags(
        translatedTags,
      );
    }

    if (popularityScore > 1.4) {
      return l10n.recommendation_reason_popular;
    }

    return l10n.recommendation_reason_default;
  }
}

class _RecommendationPhaseInfo {
  final DateTime? startedAt;
  final int elapsedDays;
  final bool useBehaviorPreference;
  final double initialWeight;
  final double behaviorWeight;
  final double popularityWeight;
  final double explorationWeight;

  const _RecommendationPhaseInfo({
    this.startedAt,
    this.elapsedDays = 0,
    this.useBehaviorPreference = false,
    this.initialWeight = 0.8,
    this.behaviorWeight = 0.05,
    this.popularityWeight = 0.1,
    this.explorationWeight = 0.05,
  });
}