import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:card_swiper/card_swiper.dart';
import 'dart:ui';
import 'dart:math';
import 'character_model.dart';
import 'character_profile_page.dart';
import 'search_character_page.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb, listEquals;

import 'dart:async';

// =========================================================
// 🖼️ 邂逅頁圖片共用快取
// 同一個 URL + 解碼寬度會重用同一個 ImageProvider。
// 從角色頁返回、切分類、Swiper rebuild 時，都盡量沿用已載入圖片。
// =========================================================
final Map<String, ImageProvider> _encounterImageProviderCache =
<String, ImageProvider>{};

ImageProvider _encounterImageProvider(
    String imageUrl, {
      required int cacheWidth,
    }) {
  final String normalizedUrl = imageUrl.trim();
  final String cacheKey = '$cacheWidth::$normalizedUrl';

  return _encounterImageProviderCache.putIfAbsent(
    cacheKey,
        () => ResizeImage(
      CachedNetworkImageProvider(normalizedUrl),
      width: cacheWidth,
    ),
  );
}

Widget _buildEncounterCachedImage(
    BuildContext context, {
      required String imageUrl,
      required BoxFit fit,
      required AlignmentGeometry alignment,
      required int cacheWidth,
      Widget? placeholder,
      Widget? errorWidget,
    }) {
  final String normalizedUrl = imageUrl.trim();

  final Widget fallback = errorWidget ??
      Image.asset(
        'assets/images/blank_avatar.png',
        fit: fit,
        alignment: alignment,
      );

  if (normalizedUrl.isEmpty) {
    return fallback;
  }

  final provider = _encounterImageProvider(
    normalizedUrl,
    cacheWidth: cacheWidth,
  );

  return Image(
    key: ValueKey<String>('encounter_img_${cacheWidth}_$normalizedUrl'),
    image: provider,
    fit: fit,
    alignment: alignment,
    filterQuality: FilterQuality.medium,
    gaplessPlayback: true,
    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded || frame != null) {
        return child;
      }

      // 第一次真正尚未載入時只顯示靜態底圖，不顯示轉圈圈。
      return placeholder ??
          Image.asset(
            'assets/images/blank_avatar.png',
            fit: fit,
            alignment: alignment,
          );
    },
    errorBuilder: (context, error, stackTrace) => fallback,
  );
}

// 邂逅頁面
class SelectChatPage extends StatefulWidget {
  const SelectChatPage({super.key});

  @override
  SelectChatPageState createState() => SelectChatPageState();
}

class SelectChatPageState extends State<SelectChatPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String APP_ID = AppConfig.appId;
  String? _userId;
  Future<List<Character>>? _charactersFuture;
  String? _lastFirstCharacterId;
  Set<String> _blockedCharacterIds = {};
  Set<String> _blockedCreatorIds = {};
  final Set<String> _preloadedImageUrls = {};
  StreamSubscription<User?>? _authStateSub;

  @override
  void initState() {
    super.initState();

    _userId = FirebaseAuth.instance.currentUser?.uid;
    _charactersFuture = _prepareCharacters();

    _authStateSub =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          final nextUserId = user?.uid;

          // Firebase 啟動時常會再次送出目前使用者；
          // UID 沒變就不要重新載入，避免 loading 閃兩次。
          if (nextUserId == _userId) return;
          if (!mounted) return;

          setState(() {
            _userId = nextUserId;
            _charactersFuture = _prepareCharacters();
          });
        });
  }

  void refreshEncounters() {
    if (!mounted) return;

    setState(() {
      _charactersFuture = _prepareCharacters();
    });
  }

  Future<List<Character>> _prepareCharacters() async {
    final stopwatch = Stopwatch()..start();

    try {
      if (_userId == null) {
        _blockedCharacterIds.clear();
        _blockedCreatorIds.clear();

        final characters = await _loadCharacters();

        debugPrint(
          '⚡ 邂逅頁載入完成：${stopwatch.elapsedMilliseconds} ms，'
              '角色數：${characters.length}',
        );

        return characters;
      }

      // 好友／封鎖資料彼此無相依，維持平行讀取。
      await Future.wait([
        _loadBlockedCharacterIds(),
        _loadBlockedCreatorIds(),
      ]);

      final characters = await _loadCharacters();

      debugPrint(
        '⚡ 邂逅頁載入完成：${stopwatch.elapsedMilliseconds} ms，'
            '角色數：${characters.length}',
      );

      return characters;
    } finally {
      stopwatch.stop();
    }
  }

  Future<void> _refreshAllData() async {
    if (!mounted) return;

    final future = _prepareCharacters();

    setState(() {
      _charactersFuture = future;
    });

    await future;
  }

  String _profileHeaderImageUrl(Character character) {
    final gallery = character.gallery;

    if (gallery != null && gallery.isNotEmpty) {
      final url = gallery.first.imageUrl.trim();
      if (url.isNotEmpty) return url;
    }

    if (character.galleryPaths.isNotEmpty) {
      final url = character.galleryPaths.first.trim();
      if (url.isNotEmpty) return url;
    }

    return (character.avatarPath ?? '').trim();
  }

  void _precacheCharacterImages(
      BuildContext context,
      List<Character> characters,
      ) {
    for (final character in characters.take(8)) {
      final urls = <String>{
        _profileHeaderImageUrl(character),
        character.bannerImagePath.trim(),
      }..removeWhere((url) => url.isEmpty);

      for (final imageUrl in urls) {
        final cacheKey = '720::$imageUrl';
        if (_preloadedImageUrls.contains(cacheKey)) continue;

        _preloadedImageUrls.add(cacheKey);

        final provider = _encounterImageProvider(
          imageUrl,
          cacheWidth: 720,
        );

        precacheImage(provider, context).catchError((error) {
          _preloadedImageUrls.remove(cacheKey);
          debugPrint('預載邂逅角色圖片失敗：$error');
        });
      }
    }
  }

  Future<void> _loadBlockedCharacterIds() async {
    if (_userId == null) return;
    try {
      final snapshot = await _db.collection('users').doc(_userId!).collection(
          'blockedCharacters').get();
      if (mounted) {
        setState(() {
          _blockedCharacterIds = snapshot.docs.map((doc) => doc.id).toSet();
        });
      }
    } catch (e) {
      print("❌ 讀取封鎖列表失敗: $e");
    }
  }

  Future<void> _loadBlockedCreatorIds() async {
    if (_userId == null) return;

    try {
      final snapshot = await _db
          .collection('users')
          .doc(_userId!)
          .collection('blockedCreators')
          .get();

      if (mounted) {
        setState(() {
          _blockedCreatorIds =
              snapshot.docs.map((doc) => doc.id).toSet();
        });
      }
    } catch (e) {
      debugPrint('❌ 讀取封鎖創作者列表失敗: $e');
    }
  }


  Future<List<Character>> _loadCharacters() async {
    try {
      // 邂逅頁需要完整公開角色池來隨機洗牌與分類，
      // 所以保留完整 query；真正昂貴的 N+1 photos 查詢已由 Lite parser 移除。
      final querySnapshot = await _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .where('isPublic', isEqualTo: true)
          .where('status', isEqualTo: 'published')
          .get();

      // 邂逅首頁只需要主文件上的角色資料。
      // 不要在這裡對每一隻角色再查 photos 子集合／Storage，
      // 否則會形成 N+1 查詢，角色越多首頁越慢。
      final List<Character> characters = querySnapshot.docs
          .map(
            (doc) => Character.fromFirestoreLite(doc),
      )
          .toList();

      // 排除「單獨封鎖的角色」以及「被封鎖創作者建立的角色」。
      // 因為檢查 createdBy，所以創作者日後新增角色也不會重新出現。
      characters.removeWhere(
            (character) =>
        _blockedCharacterIds.contains(character.id) ||
            _blockedCreatorIds.contains(character.createdBy),
      );

      if (characters.isEmpty) {
        return [];
      }

      // 每次重新進入邂逅頁時，重新打亂角色順序。
      characters.shuffle();

      // 若有兩位以上角色，避免刷新後第一位
      // 又剛好是上一輪的第一位。
      if (characters.length > 1 &&
          characters.first.id == _lastFirstCharacterId) {
        final differentIndex = characters.indexWhere(
              (character) =>
          character.id != _lastFirstCharacterId,
        );

        if (differentIndex > 0) {
          final firstCharacter = characters.first;

          characters[0] = characters[differentIndex];
          characters[differentIndex] = firstCharacter;
        }
      }

      _lastFirstCharacterId = characters.first.id;

      return characters;
    } catch (e) {
      debugPrint('❌ 讀取邂逅角色失敗：$e');
      return [];
    }
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchCharacterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.title_meet_him,
          style: GoogleFonts.notoSerifTc(
            color: theme.colorScheme.onSurface,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: _navigateToSearch,
          ),
        ],
      ),
      body: FutureBuilder<List<Character>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                l10n.encounter_load_failed,
                style: GoogleFonts.notoSerifTc(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  fontSize: 14,
                ),
              ),
            );
          }

          final characters = snapshot.data ?? const <Character>[];

          if (characters.isEmpty) {
            return Center(
              child: Text(
                l10n.encounter_no_available_characters,
                style: GoogleFonts.notoSerifTc(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  fontSize: 14,
                ),
              ),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _precacheCharacterImages(context, characters);
          });

          return _DiscoveryHallView(
            allCharacters: characters,
            blockedCharacterIds: _blockedCharacterIds,
            onRefresh: _refreshAllData,
          );
        },
      ),
    );
  }


  @override
  void dispose() {
    _authStateSub?.cancel();
    super.dispose();
  }

}

Widget buildCachedCharacterAvatar(
    BuildContext context,
    Character character, {
      double radius = 30,
    }) {
  final String avatarUrl =
  (character.avatarPath ?? '').trim();

  final String imageUrl =
  avatarUrl.isNotEmpty
      ? avatarUrl
      : character.galleryPaths.isNotEmpty
      ? character.galleryPaths.first.trim()
      : '';

  if (imageUrl.isEmpty) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context)
          .colorScheme
          .secondaryContainer,
      child: const Icon(Icons.person),
    );
  }

  return CircleAvatar(
    radius: radius,
    backgroundColor: Theme.of(context)
        .colorScheme
        .secondaryContainer,
    backgroundImage:
    CachedNetworkImageProvider(imageUrl),
    onBackgroundImageError: (
        error,
        stackTrace,
        ) {
      debugPrint(
        '人氣榜角色頭像載入失敗：$error',
      );
    },
  );
}

// ==========================================
// 🏛️ 探索大廳：單頁式探索首頁
// ==========================================
class _DiscoveryHallView extends StatelessWidget {
  final List<Character> allCharacters;
  final Future<void> Function() onRefresh;
  // ⭐ 新增
  final Set<String> blockedCharacterIds;


  const _DiscoveryHallView({
    required this.allCharacters,
    required this.onRefresh,
    // ⭐ 新增
    required this.blockedCharacterIds,

  });

  @override
  Widget build(BuildContext context) {
    return _LatestTab(
      allCharacters: allCharacters,
      blockedCharacterIds: blockedCharacterIds,
      onRefresh: onRefresh,
    );
  }
}

// 🌟 分頁一：最新推薦 (保持完美比例 + 呈現時尚的高低交錯感)
class _LatestTab extends StatefulWidget {
  final List<Character> allCharacters;
  final Future<void> Function() onRefresh;
  // ⭐ 新增
  final Set<String> blockedCharacterIds;


  const _LatestTab({
    required this.allCharacters,
    required this.onRefresh,
    // ⭐ 新增
    required this.blockedCharacterIds,

  });

  @override
  State<_LatestTab> createState() =>
      _LatestTabState();
}

class _LatestTabState extends State<_LatestTab> {
  String _selectedCategory = '全部';

  // 邂逅首頁固定使用的大分類。
  // 「其他」一定放最後；首頁為單排橫向滑動。
  static const List<String> _discoveryCategories = <String>[
    '全部',
    '霸總',
    '年上',
    '年下',
    '校園',
    '職場',
    '古風',
    '仙俠',
    '病嬌',
    '忠犬',
    '高冷',
    '青梅竹馬',
    '師徒',
    '甜寵',
    '非人',
    '其他',
  ];

  String _categoryLabel(
      String category,
      AppLocalizations l10n,
      ) {
    switch (category) {
      case '全部':
        return l10n.encounter_category_all;
      case '霸總':
        return l10n.preference_tag_ceo;
      case '年上':
        return l10n.preference_tag_older;
      case '年下':
        return l10n.preference_tag_younger;
      case '校園':
        return l10n.preference_tag_school;
      case '職場':
        return l10n.preference_tag_workplace;
      case '古風':
        return l10n.preference_tag_ancient;
      case '仙俠':
        return l10n.encounter_category_xianxia;
      case '病嬌':
        return l10n.preference_tag_yandere;
      case '忠犬':
        return l10n.preference_tag_loyal;
      case '高冷':
        return l10n.preference_tag_cold;
      case '青梅竹馬':
        return l10n.encounter_category_childhood_friend;
      case '師徒':
        return l10n.encounter_category_master_disciple;
      case '甜寵':
        return l10n.encounter_category_sweet_romance;
      case '非人':
        return l10n.preference_tag_nonhuman;
      case '其他':
        return l10n.encounter_category_other;
      default:
        return category;
    }
  }

  // 舊角色仍可能使用較細的 personalityTags，
  // 先用常見同義詞做相容；之後若角色建立頁新增 discoveryTags，
  // 可以再直接改成讀取 discoveryTags。
  static const Map<String, List<String>> _categoryKeywords =
  <String, List<String>>{
    '霸總': <String>['霸總', '霸道總裁', '總裁', '財閥', 'CEO', 'ceo'],
    '年上': <String>['年上', '成熟', '叔系'],
    '年下': <String>['年下', '弟弟', '弟系'],
    '校園': <String>['校園', '學生', '學長', '學弟', '同學', '老師'],
    '職場': <String>['職場', '上司', '老闆', '秘書', '總監', '經理', '辦公室'],
    '古風': <String>['古風', '古代', '王爺', '皇帝', '太子', '將軍', '江湖', '武俠'],
    '仙俠': <String>['仙俠', '修仙', '仙門', '宗主', '師尊', '仙尊', '魔尊'],
    '病嬌': <String>['病嬌', '偏執', '瘋批', '黑化'],
    '忠犬': <String>['忠犬', '黏人', '專一', '守護', '忠誠'],
    '高冷': <String>['高冷', '冷淡', '寡言', '禁慾', '疏離'],
    '青梅竹馬': <String>['青梅竹馬', '竹馬', '幼馴染'],
    '師徒': <String>['師徒', '師父', '師尊', '徒弟'],
    '甜寵': <String>['甜寵', '寵溺', '溫柔', '治癒', '甜'],
    '非人': <String>['非人', '吸血鬼', '狼人', '妖', '魔', '神明', '精靈', '獸人', '人魚'],
  };

  List<Character> get _visibleAllCharacters {
    return widget.allCharacters
        .where(
          (character) =>
      !widget.blockedCharacterIds.contains(
        character.id,
      ),
    )
        .toList();
  }
  late List<Character> _shuffledBannerCharacters;
  late List<Character> _shuffledGridCharacters;

  void _rebuildGridCharacters() {
    _shuffledGridCharacters =
    List<Character>.from(_visibleAllCharacters)..shuffle();
  }

  void _rebuildBannerCharacters() {
    final random = Random();

    final visibleCharacters =
        _visibleAllCharacters;

    final sortedCharacters =
    List<Character>.from(
      visibleCharacters,
    )
      ..sort(
            (a, b) =>
            b.createdAt.compareTo(
              a.createdAt,
            ),
      );

    final recentCharacters =
    sortedCharacters
        .take(10)
        .toList()
      ..shuffle(random);

    _shuffledBannerCharacters =
        recentCharacters;
  }

  Future<void> _recordRecommendationClick({
    required Character character,
    required String source,
  }) async {
    try {
      final functions =
      FirebaseFunctions.instanceFor(
        region: 'asia-east1',
      );

      final callable =
      functions.httpsCallable(
        'recordRecommendationEvent',
        options: HttpsCallableOptions(
          timeout:
          const Duration(seconds: 20),
        ),
      );

      await callable.call({
        'type': 'click',
        'source': source,
        'characterId': character.id,
      });

      debugPrint(
        '📈 推薦點擊已記錄：'
            '$source / ${character.id}',
      );
    } catch (error) {
      debugPrint(
        '⚠️ 推薦點擊埋點失敗：$error',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _rebuildGridCharacters();
    _rebuildBannerCharacters();
  }

  @override
  void didUpdateWidget(
      covariant _LatestTab oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    // 父層因 Theme、Navigator 返回等原因 rebuild 時，
    // 不重新洗牌。只有角色清單真的改變時才重新產生隨機順序。
    final oldIds = oldWidget.allCharacters.map((e) => e.id).toList();
    final newIds = widget.allCharacters.map((e) => e.id).toList();

    if (!listEquals(oldIds, newIds)) {
      _rebuildGridCharacters();
      _rebuildBannerCharacters();
    }
  }

  String _normalizeCategoryText(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'^#+'), '')
        .replaceAll(' ', '')
        .toLowerCase();
  }

  bool _matchesCategory(Character character, String category) {
    // 分類邏輯永遠使用固定內部 key，不使用翻譯後文字判斷。
    // UI 顯示才交給 _categoryLabel() 翻譯，避免切換語言後「全部」失效，
    // 導致所有角色都被篩掉。
    if (category == '全部') return true;

    if (category == '其他') {
      return !_discoveryCategories
          .where((item) => item != '全部' && item != '其他')
          .any((item) => _matchesCategory(character, item));
    }

    final keywords = _categoryKeywords[category] ?? <String>[category];

    final searchableValues = <String>[
      ...character.personalityTags,
      character.occupation,
    ].map(_normalizeCategoryText).where((value) => value.isNotEmpty).toList();

    for (final keyword in keywords) {
      final normalizedKeyword = _normalizeCategoryText(keyword);
      if (searchableValues.any(
            (value) => value == normalizedKeyword || value.contains(normalizedKeyword),
      )) {
        return true;
      }
    }

    return false;
  }

  List<Character> get _filteredCharacters {
    // 下方角色改成隨機順序。
    // 切換分類時只從同一份隨機清單裡篩選，
    // 不會因 setState 每次重新洗牌，避免畫面一直跳。
    return _shuffledGridCharacters
        .where(
          (character) =>
      !widget.blockedCharacterIds.contains(character.id) &&
          _matchesCategory(character, _selectedCategory),
    )
        .toList();
  }

  Widget _buildCategoryStrip(
      BuildContext context,
      bool useDesktopLayout,
      ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: useDesktopLayout ? 46 : 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _discoveryCategories.length,
        separatorBuilder: (_, __) => SizedBox(
          width: useDesktopLayout ? 10 : 8,
        ),
        itemBuilder: (context, index) {
          final category = _discoveryCategories[index];
          final isSelected = category == _selectedCategory;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                if (category == _selectedCategory) return;
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(
                  horizontal: useDesktopLayout ? 18 : 15,
                  vertical: useDesktopLayout ? 9 : 7,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withValues(alpha: 0.20),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    _categoryLabel(category, l10n),
                    style: GoogleFonts.notoSerifTc(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.78),
                      fontSize: useDesktopLayout ? 14 : 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyCategory(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 52),
      child: Center(
        child: Text(
          l10n.encounter_category_empty,
          style: GoogleFonts.notoSerifTc(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.48),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final l10n = AppLocalizations.of(context)!;
    final bool useDesktopLayout = kIsWeb && screenWidth >= 800;

    final double pageHorizontalPadding = useDesktopLayout ? 32 : 16;
    final double maxContentWidth = useDesktopLayout ? 1280 : double.infinity;

    final List<Character> bannerList = _shuffledBannerCharacters;
    final List<Character> filteredCharacters = _filteredCharacters;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            pageHorizontalPadding,
            useDesktopLayout ? 20 : 10,
            pageHorizontalPadding,
            useDesktopLayout ? 40 : 28,
          ),
          children: [
            // 活動橫幅之後改由後端活動系統控制。
            // 七夕活動已結束，因此本次邂逅改版不再固定顯示 Qixi banner。

            if (bannerList.isNotEmpty) ...[
              Text(
                l10n.encounterJoinedToday,
                style: GoogleFonts.notoSerifTc(
                  fontSize: useDesktopLayout ? 22 : 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _buildRecommendationBanner(
                context,
                bannerList,
                useDesktopLayout: useDesktopLayout,
              ),
              SizedBox(height: useDesktopLayout ? 18 : 14),
            ],

            // 16 個大分類：單排、左右滑、點擊後直接更新下方角色。
            _buildCategoryStrip(
              context,
              useDesktopLayout,
            ),
            SizedBox(height: useDesktopLayout ? 26 : 20),

            if (filteredCharacters.isEmpty)
              _buildEmptyCategory(context)
            else if (useDesktopLayout)
              _buildDesktopCharacterGrid(
                context,
                filteredCharacters,
              )
            else
              _buildMobileStaggeredGrid(
                context,
                filteredCharacters,
              ),

            SizedBox(height: useDesktopLayout ? 40 : 28),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
      String title,
      bool useDesktopLayout,
      ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: useDesktopLayout ? 22 : 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLatestSectionHeader(
      BuildContext context,
      bool useDesktopLayout, {
        required bool showMore,
      }) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.encounterRecentlyArrived,
            style: TextStyle(
              fontSize: useDesktopLayout ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (showMore)
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _AllLatestCharactersPage(
                    allCharacters:
                    _visibleAllCharacters,
                    onRefresh:
                    widget.onRefresh,
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              visualDensity: VisualDensity.compact,
            ),
            child:  Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.encounterViewMore,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTagsSectionHeader(
      BuildContext context,
      bool useDesktopLayout,
      ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.encounterLovePrompt,
            style: TextStyle(
              fontSize: useDesktopLayout ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (_collectAllTags().length > 18)
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _AllTagsPage(
                    allCharacters:
                    _visibleAllCharacters,
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              visualDensity: VisualDensity.compact,
            ),
            child:  Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.encounterViewMore,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPopularCharactersSection(
      BuildContext context,
      bool useDesktopLayout,
      ) {
    final popularCharacters =
    List<Character>.from(
      _visibleAllCharacters,
    )
      ..sort(
            (a, b) =>
            b.playCount.compareTo(
              a.playCount,
            ),
      );

    final visibleCharacters =
    popularCharacters
        .take(10)
        .toList()
      ..sort(
            (a, b) =>
            b.playCount.compareTo(
              a.playCount,
            ),
      );

    if (visibleCharacters.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: useDesktopLayout ? 245 : 205,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: visibleCharacters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final character = visibleCharacters[index];
          final imageUrl = character.galleryPaths.isNotEmpty
              ? character.galleryPaths.first.trim()
              : character.avatarPath.trim();

          return SizedBox(
            width: useDesktopLayout ? 170 : 140,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  _recordRecommendationClick(
                    character: character,
                    source:
                    'popular_recommendation',
                  );

                  final result =
                  await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CharacterProfilePage(
                            character: character,
                            characterId:
                            character.id,
                            analyticsSource:
                            'popular_recommendation',
                          ),
                    ),
                  );

                  if (!mounted) return;

                  if (result == true) {
                    await widget.onRefresh();
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (imageUrl.isNotEmpty)
                        _buildEncounterCachedImage(
                          context,
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          cacheWidth: useDesktopLayout ? 700 : 520,
                          placeholder: Container(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                        )
                      else
                        Image.asset(
                          'assets/images/blank_avatar.png',
                          fit: BoxFit.cover,
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.78),
                            ],
                            stops: const [0.45, 1],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              character.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: useDesktopLayout ? 16 : 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.white70,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${character.playCount}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
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
        },
      ),
    );
  }

  List<String> _collectAllTags() {
    final uniqueTags = <String>{};

    for (final character
    in _visibleAllCharacters) {
      for (final rawTag in character.personalityTags) {
        final tag = rawTag.trim().replaceAll(RegExp(r'^#+'), '').trim();
        if (tag.isNotEmpty) {
          uniqueTags.add(tag);
        }
      }
    }

    return uniqueTags.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  Widget _buildTagsSection(BuildContext context) {
    final theme = Theme.of(context);
    final tags = _collectAllTags().take(18).toList();

    if (tags.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.no_tag_data,
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: tags.map((tag) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _TagFilteredCharactersPage(
                  tag: tag,
                  allCharacters:
                  _visibleAllCharacters,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.22),
              ),
            ),
            child: Text(
              '#$tag',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // =========================================================
  // 強檔推薦 Banner
  // =========================================================
  Widget _buildRecommendationBanner(
      BuildContext context,
      List<Character> bannerList, {
        required bool useDesktopLayout,
      }) {
    return SizedBox(
      height: useDesktopLayout ? 360 : 250,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: bannerList.length > 1,
        autoplayDelay: 4500,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(bottom: 8),
          builder: DotSwiperPaginationBuilder(
            activeColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.18),
            size: 6,
            activeSize: 7,
          ),
        ),
        viewportFraction: useDesktopLayout ? 0.82 : 1.0,
        scale: useDesktopLayout ? 0.92 : 1.0,
        itemBuilder: (context, index) {
          final char = bannerList[index];

          final String bannerImg =
          char.bannerImagePath.trim().isNotEmpty
              ? char.bannerImagePath.trim()
              : char.galleryPaths.isNotEmpty
              ? char.galleryPaths.first.trim()
              : char.avatarPath.trim();

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: useDesktopLayout ? 8 : 0,
            ),
            child: GestureDetector(
              onTap: () async {
                _recordRecommendationClick(
                  character: char,
                  source: 'recommendation_banner',
                );

                final result =
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CharacterProfilePage(
                          character: char,
                          characterId: char.id,
                          analyticsSource:
                          'recommendation_banner',
                        ),
                  ),
                );

                if (!mounted) return;

                if (result == true) {
                  await widget.onRefresh();
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  useDesktopLayout ? 22 : 16,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (useDesktopLayout)
                      ..._buildDesktopBannerImage(
                        bannerImg,
                      )
                    else
                      _buildMobileFullBannerImage(
                        bannerImg,
                      ),

                    // 底部漸層只負責讓名字清楚，
                    // 不會像之前一樣把整張圖壓暗。
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withValues(
                              alpha: 0.72,
                            ),
                          ],
                          stops: const [
                            0,
                            0.58,
                            1,
                          ],
                        ),
                      ),
                    ),

                    // 只保留名字與身分
                    Positioned(
                      left: useDesktopLayout ? 28 : 18,
                      right: useDesktopLayout ? 28 : 18,
                      bottom: useDesktopLayout ? 26 : 18,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            char.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                              useDesktopLayout ? 28 : 22,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          if (char.occupation
                              .trim()
                              .isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              char.occupation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: 0.88,
                                ),
                                fontSize:
                                useDesktopLayout ? 15 : 13,
                                fontWeight: FontWeight.w500,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildMobileFullBannerImage(
      String bannerImg,
      ) {
    if (bannerImg.isEmpty) {
      return Image.asset(
        'assets/images/blank_avatar.png',
        fit: BoxFit.cover,
      );
    }

    return _buildEncounterCachedImage(
      context,
      imageUrl: bannerImg,
      fit: BoxFit.cover,
      alignment: const Alignment(0, -0.18),
      cacheWidth: 720,
      placeholder: Container(
        color: Colors.black12,
      ),
    );
  }
  List<Widget> _buildDesktopBannerImage(
      String bannerImg,
      ) {
    if (bannerImg.isEmpty) {
      return [
        Image.asset(
          'assets/images/blank_avatar.png',
          fit: BoxFit.cover,
        ),
      ];
    }

    return [
      _buildEncounterCachedImage(
        context,
        imageUrl: bannerImg,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        cacheWidth: 1600,
        placeholder: Container(
          color: Colors.black12,
        ),
        errorWidget: Container(
          color: Colors.black12,
        ),
      ),

      BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          color: Colors.black.withValues(
            alpha: 0.35,
          ),
        ),
      ),

      Center(
        child: _buildEncounterCachedImage(
          context,
          imageUrl: bannerImg,
          fit: BoxFit.contain,
          alignment: Alignment.center,
          cacheWidth: 1400,
          placeholder: const SizedBox.shrink(),
          errorWidget: Image.asset(
            'assets/images/blank_avatar.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    ];
  }
  // =========================================================
  // 手機版：兩欄高低交錯
  // =========================================================
  Widget _buildMobileStaggeredGrid(
      BuildContext context,
      List<Character> sortedList,
      ) {
    final List<Character> leftCol = [];
    final List<Character> rightCol = [];

    for (int i = 0; i < sortedList.length; i++) {
      if (i.isEven) {
        leftCol.add(sortedList[i]);
      } else {
        rightCol.add(sortedList[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: leftCol.map((char) {
              return Padding(
                padding:
                const EdgeInsets.only(bottom: 12),
                child: _buildCharacterCard(
                  context,
                  char,
                  isDesktop: false,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding:
            const EdgeInsets.only(top: 30),
            child: Column(
              children: rightCol.map((char) {
                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: 12),
                  child: _buildCharacterCard(
                    context,
                    char,
                    isDesktop: false,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // 網頁版：四欄整齊排列
  // =========================================================
  Widget _buildDesktopCharacterGrid(
      BuildContext context,
      List<Character> sortedList,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int columnCount;

        if (constraints.maxWidth >= 1200) {
          columnCount = 4;
        } else if (constraints.maxWidth >= 850) {
          columnCount = 3;
        } else {
          columnCount = 2;
        }

        const double spacing = 18;

        final double cardWidth =
            (constraints.maxWidth -
                spacing * (columnCount - 1)) /
                columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: sortedList.map((char) {
            return SizedBox(
              width: cardWidth,
              child: _buildCharacterCard(
                context,
                char,
                isDesktop: true,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // =========================================================
  // 共用角色卡片
  // =========================================================
  Widget _buildCharacterCard(
      BuildContext context,
      Character char, {
        required bool isDesktop,
      }) {
    final String imageUrl =
    char.galleryPaths.isNotEmpty
        ? char.galleryPaths.first
        : '';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CharacterProfilePage(
                    character: char,
                    characterId: char.id,
                  ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            isDesktop ? 18 : 16,
          ),
          child: AspectRatio(
            aspectRatio:
            isDesktop ? 0.78 : 0.85,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (imageUrl.isNotEmpty)
                  _buildEncounterCachedImage(
                    context,
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    cacheWidth: isDesktop ? 900 : 720,
                    placeholder: Container(
                      color: Colors.grey.shade200,
                    ),
                  )
                else
                  Image.asset(
                    'assets/images/blank_avatar.png',
                    fit: BoxFit.cover,
                  ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(
                          alpha: 0.78,
                        ),
                      ],
                      stops: const [
                        0.48,
                        1,
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(
                    isDesktop ? 16 : 12,
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.end,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        char.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize:
                          isDesktop ? 18 : 15,
                          shadows: const [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      if (char.occupation
                          .trim()
                          .isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          char.occupation,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize:
                            isDesktop ? 13 : 11,
                          ),
                        ),
                      ],
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

// ✨ 全部最新角色頁
class _AllLatestCharactersPage
    extends StatefulWidget {
  final List<Character> allCharacters;
  final Future<void> Function() onRefresh;

  const _AllLatestCharactersPage({
    required this.allCharacters,
    required this.onRefresh,
  });

  @override
  State<_AllLatestCharactersPage>
  createState() =>
      _AllLatestCharactersPageState();
}

class _AllLatestCharactersPageState
    extends State<_AllLatestCharactersPage> {
  late List<Character> _visibleCharacters;
  StreamSubscription<QuerySnapshot>?
  _blockedCharactersSub;
  @override
  void initState() {
    super.initState();

    // 先放原始資料，避免畫面一開始空白
    // 沿用探索大廳載入時已經洗牌的角色順序。
    _visibleCharacters = List<Character>.from(
      widget.allCharacters,
    );

    _listenBlockedCharacters();
  }

  void _listenBlockedCharacters() {
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return;
    }

    _blockedCharactersSub =
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('blockedCharacters')
            .snapshots()
            .listen(
              (snapshot) {
            if (!mounted) return;

            final blockedIds =
            snapshot.docs
                .map((doc) => doc.id)
                .toSet();

            // 排除封鎖角色，但不重新依建立時間排序。
            final visible = widget.allCharacters
                .where(
                  (character) =>
              !blockedIds.contains(
                character.id,
              ),
            )
                .toList();

            setState(() {
              _visibleCharacters = visible;
            });
          },
          onError: (e) {
            debugPrint(
              '❌ 查看更多讀取封鎖角色失敗：$e',
            );
          },
        );
  }

  @override
  void dispose() {
    _blockedCharactersSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title:
        Text(l10n.encounterRecentlyArrivedPlain),
      ),
      body: _visibleCharacters.isEmpty
          ? Center(
        child: Text(
          l10n.encounterNoCharacters,
        ),
      )
          : LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final bool
          useDesktopLayout =
              constraints.maxWidth >=
                  800;

          final int columnCount;

          if (constraints.maxWidth >=
              1200) {
            columnCount = 4;
          } else if (constraints
              .maxWidth >=
              800) {
            columnCount = 3;
          } else {
            columnCount = 2;
          }

          return GridView.builder(
            padding:
            EdgeInsets.fromLTRB(
              useDesktopLayout
                  ? 32
                  : 16,
              20,
              useDesktopLayout
                  ? 32
                  : 16,
              32,
            ),
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
              columnCount,
              crossAxisSpacing:
              useDesktopLayout
                  ? 18
                  : 12,
              mainAxisSpacing:
              useDesktopLayout
                  ? 18
                  : 12,
              childAspectRatio:
              useDesktopLayout
                  ? 0.78
                  : 0.72,
            ),
            itemCount:
            _visibleCharacters
                .length,
            itemBuilder: (
                context,
                index,
                ) {
              final character =
              _visibleCharacters[
              index];

              final String imageUrl =
              character
                  .galleryPaths
                  .isNotEmpty
                  ? character
                  .galleryPaths
                  .first
                  .trim()
                  : character
                  .avatarPath
                  .trim();

              return MouseRegion(
                cursor:
                SystemMouseCursors
                    .click,
                child:
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CharacterProfilePage(
                              character: character,
                              characterId: character.id,
                            ),
                      ),
                    );

                    if (!mounted) return;

                    final currentUser =
                        FirebaseAuth.instance.currentUser;

                    if (currentUser == null) return;

                    // ⭐ 回到這個頁面後，直接確認角色是否已被封鎖
                    final blockedDoc =
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.uid)
                        .collection('blockedCharacters')
                        .doc(character.id)
                        .get();

                    if (!mounted) return;

                    if (blockedDoc.exists) {
                      // ⭐ 立即從目前畫面移除
                      setState(() {
                        _visibleCharacters.removeWhere(
                              (item) =>
                          item.id == character.id,
                        );
                      });

                      // ⭐ 同時通知外層探索大廳重新整理
                      await widget.onRefresh();
                    }
                  },
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius
                        .circular(
                      16,
                    ),
                    child: Stack(
                      fit:
                      StackFit.expand,
                      children: [
                        if (imageUrl
                            .isNotEmpty)
                          _buildEncounterCachedImage(
                            context,
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            cacheWidth:
                            useDesktopLayout ? 900 : 720,
                            placeholder: Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                          )
                        else
                          Image.asset(
                            'assets/images/blank_avatar.png',
                            fit: BoxFit
                                .cover,
                          ),
                        Container(
                          decoration:
                          BoxDecoration(
                            gradient:
                            LinearGradient(
                              begin:
                              Alignment
                                  .topCenter,
                              end:
                              Alignment
                                  .bottomCenter,
                              colors: [
                                Colors
                                    .transparent,
                                Colors.black
                                    .withValues(
                                  alpha:
                                  0.8,
                                ),
                              ],
                              stops:
                              const [
                                0.48,
                                1,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            mainAxisSize:
                            MainAxisSize
                                .min,
                            children: [
                              Text(
                                character
                                    .name,
                                maxLines:
                                1,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                style:
                                TextStyle(
                                  color: Colors
                                      .white,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  fontSize:
                                  useDesktopLayout
                                      ? 17
                                      : 15,
                                ),
                              ),
                              if (character
                                  .occupation
                                  .trim()
                                  .isNotEmpty) ...[
                                const SizedBox(
                                  height:
                                  3,
                                ),
                                Text(
                                  character
                                      .occupation,
                                  maxLines:
                                  1,
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                  style:
                                  const TextStyle(
                                    color: Colors
                                        .white70,
                                    fontSize:
                                    12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
// 🏷️ 全部標籤頁
class _AllTagsPage extends StatelessWidget {
  final List<Character> allCharacters;

  const _AllTagsPage({
    required this.allCharacters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uniqueTags = <String>{};
    final l10n = AppLocalizations.of(context)!;

    for (final character in allCharacters) {
      for (final rawTag in character.personalityTags) {
        final tag = rawTag
            .trim()
            .replaceAll(RegExp(r'^#+'), '')
            .trim();

        if (tag.isNotEmpty) {
          uniqueTags.add(tag);
        }
      }
    }

    final tags = uniqueTags.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return Scaffold(
      appBar: AppBar(
        title:  Text(l10n.encounterAllLoveTags),
      ),
      body: tags.isEmpty
          ? Center(
        child: Text(
          AppLocalizations.of(context)!.no_tag_data,
        ),
      )
          : LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
          constraints.maxWidth >= 800 ? 32.0 : 16.0;
          final maxWidth =
          constraints.maxWidth >= 800 ? 1100.0 : double.infinity;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  32,
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: tags.map((tag) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                _TagFilteredCharactersPage(
                                  tag: tag,
                                  allCharacters: allCharacters,
                                ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.22),
                          ),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 🏷️ 點擊特定標籤後跳轉過去的「過濾角色列表頁」
class _TagFilteredCharactersPage
    extends StatefulWidget {
  final String tag;
  final List<Character> allCharacters;

  const _TagFilteredCharactersPage({
    required this.tag,
    required this.allCharacters,
  });

  @override
  State<_TagFilteredCharactersPage>
  createState() =>
      _TagFilteredCharactersPageState();
}

class _TagFilteredCharactersPageState
    extends State<_TagFilteredCharactersPage> {
  late List<Character> _visibleCharacters;

  @override
  void initState() {
    super.initState();

    _visibleCharacters =
        widget.allCharacters
            .where(
              (character) =>
              character.personalityTags
                  .contains(widget.tag),
        )
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
    AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.tag_page_title(widget.tag),
        ),
      ),
      body: _visibleCharacters.isEmpty
          ? Center(
        child: Text(
          l10n.no_character_with_tag,
        ),
      )
          : ListView.builder(
        padding:
        const EdgeInsets.all(16),
        itemCount:
        _visibleCharacters.length,
        itemBuilder: (
            context,
            index,
            ) {
          final char =
          _visibleCharacters[index];

          return Card(
            margin:
            const EdgeInsets.only(
              bottom: 12,
            ),
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.all(
                8,
              ),
              leading:
              buildCachedCharacterAvatar(
                context,
                char,
                radius: 30,
              ),
              title: Text(
                char.name,
                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
              subtitle: Text(
                char.occupation,
                style:
                const TextStyle(
                  fontSize: 12,
                ),
              ),
              trailing:
              const Icon(
                Icons
                    .arrow_forward_ios,
                size: 16,
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CharacterProfilePage(
                          character: char,
                          characterId:
                          char.id,
                        ),
                  ),
                );

                if (!mounted) {
                  return;
                }

                final currentUser =
                    FirebaseAuth
                        .instance
                        .currentUser;

                if (currentUser ==
                    null) {
                  return;
                }

                final blockedDoc =
                await FirebaseFirestore
                    .instance
                    .collection(
                  'users',
                )
                    .doc(
                  currentUser
                      .uid,
                )
                    .collection(
                  'blockedCharacters',
                )
                    .doc(
                  char.id,
                )
                    .get();

                if (!mounted) {
                  return;
                }

                if (blockedDoc
                    .exists) {
                  setState(() {
                    _visibleCharacters
                        .removeWhere(
                          (item) =>
                      item.id ==
                          char.id,
                    );
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
