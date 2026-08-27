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
import 'package:shared_preferences/shared_preferences.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import '../services/character_report_service.dart';
import '../services/character_block_service.dart';
import 'dart:async';

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
  Set<String> _friendIds = {};
  Set<String> _blockedCharacterIds = {};
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
    if (_userId == null) {
      _friendIds.clear();
      _blockedCharacterIds.clear();
      return _loadCharacters();
    }

    await Future.wait([
      _loadFriendIds(),
      _loadBlockedCharacterIds(),
    ]);

    return _loadCharacters();
  }

  Future<void> _refreshAllData() async {
    if (!mounted) return;

    final future = _prepareCharacters();

    setState(() {
      _charactersFuture = future;
    });

    await future;
  }

  void _precacheCharacterImages(
      BuildContext context,
      List<Character> characters,
      ) {
    for (final character in characters.take(5)) {
      if (character.galleryPaths.isEmpty) continue;

      final imageUrl = character.galleryPaths.first;

      if (_preloadedImageUrls.contains(imageUrl)) {
        continue;
      }

      _preloadedImageUrls.add(imageUrl);

      precacheImage(
        CachedNetworkImageProvider(imageUrl),
        context,
      ).catchError((error) {
        _preloadedImageUrls.remove(imageUrl);
        debugPrint('預載邂逅角色圖片失敗：$error');
      });
    }
  }

  Future<void> _loadFriendIds() async {
    if (_userId == null) return;
    try {
      final snapshot = await _db
          .collection('users')
          .doc(_userId!)
          .collection('friends')
          .get();
      final ids = snapshot.docs.map((doc) => doc.id).toSet();
      if (mounted) {
        setState(() {
          _friendIds = ids;
        });
      }
    } catch (e) {
      print("❌ 讀取好友列表失敗: $e");
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

  Future<List<Character>> _loadCharacters() async {
    try {
      final querySnapshot = await _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .where('isPublic', isEqualTo: true)
          .where('status', isEqualTo: 'published')
          .get();

      final List<Character> characters = await Future.wait(
        querySnapshot.docs
            .map(
              (doc) => Character.fromFirestoreAsync(doc),
        )
            .toList(),
      );

      // 排除已封鎖角色。
      characters.removeWhere(
            (character) =>
            _blockedCharacterIds.contains(character.id),
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

      debugPrint(
        '🎲 本次邂逅第一位角色：'
            '${characters.first.name} '
            '(${characters.first.id})',
      );

      return characters;
    } catch (e) {
      debugPrint('❌ 讀取邂逅角色失敗：$e');
      return [];
    }
  }

  // 1. 專屬加好友成功彈窗
  Future<void> _showAddFriendSuccessDialog(String characterName) async {
    final prefs = await SharedPreferences.getInstance();
    final todayStr = DateTime.now().toString().substring(0, 10);
    final l10n = AppLocalizations.of(context)!;
    if (prefs.getString('hideAddFriendDate') == todayStr) return;
    if (!mounted) return;

    bool dontShowAgain = false;
    final theme = Theme.of(context);

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setStateInDialog) {
                return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    backgroundColor: Colors.white,
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite, size: 60, color: theme.colorScheme.primary),
                          const SizedBox(height: 16),
                          Text(l10n.add_friend_success(characterName),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                      value: dontShowAgain,
                                      activeColor: theme.colorScheme.primary,
                                      onChanged: (val) {
                                        setStateInDialog(() => dontShowAgain = val ?? false);
                                      }
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(l10n.do_not_show_again_today, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ]
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                onPressed: () async {
                                  if (dontShowAgain) {
                                    await prefs.setString('hideAddFriendDate', todayStr);
                                  }
                                  Navigator.pop(context);
                                },
                                child: Text(l10n.ok_button, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              )
                          )
                        ]
                    )
                );
              }
          );
        }
    );
  }

  // 2. 通用結果彈窗
  void _showResultDialog(String message, {bool isError = false}) {
    final l10n = AppLocalizations.of(context)!;
    if (!mounted) return;
    final theme = Theme.of(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: Colors.white,
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
                        size: 60, color: isError ? Colors.redAccent : theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isError ? Colors.redAccent : theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.deleteAccountDialogActionConfirm, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ]
              )
          );
        }
    );
  }

  Future<void> _addFriend(Character character) async {
    final l10n = AppLocalizations.of(context)!;
    if (_userId == null) {
      _showResultDialog(l10n.error_login_required_add_friend, isError: true);
      return;
    }

    try {
      final String charId = character.id;
      final String userId = _userId!;

      final encounterRef = _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(charId)
          .collection('unique_encounters')
          .doc(userId);

      final charDocRef = _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(charId);

      final myFriendRef = _db
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(charId);

      await _db.runTransaction((transaction) async {
        final encounterDoc = await transaction.get(encounterRef);
        if (!encounterDoc.exists) {
          transaction.update(charDocRef, {
            'playCount': FieldValue.increment(1),
          });
          transaction.set(encounterRef, {
            'encounteredAt': FieldValue.serverTimestamp(),
          });
        }
        transaction.set(myFriendRef, {
          'characterId': character.id,
          'name': character.name,
          'avatarPath': character.avatarPath,
          'addedAt': FieldValue.serverTimestamp(),
        });
      });

      if (mounted) {
        setState(() {
          _friendIds.add(character.id);
        });
        _showAddFriendSuccessDialog(character.name);
      }
    } catch (e) {
      if (mounted) {
        _showResultDialog(l10n.add_friend_failed_retry, isError: true);
      }
    }
  }

  Future<void> _deleteFriend(Character character) async {
    final l10n = AppLocalizations.of(context)!;
    if (_userId == null) return;
    final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(l10n.dialog_title_remove_friend),
              content: Text(l10n.dialog_msg_remove_friend(character.name)),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.cancelButton)),
                TextButton(onPressed: () => Navigator.of(context).pop(true),
                    child: Text(l10n.action_remove, style: const TextStyle(color: Colors.red))),
              ],
            )
    );
    if (confirm == true) {
      try {
        await _db.collection('users').doc(_userId!).collection('friends').doc(
            character.id).delete();
        if (mounted) {
          setState(() {
            _friendIds.remove(character.id);
          });
          _showResultDialog(l10n.snackbar_friend_removed(character.name));
        }
      } catch (e) {
        if (mounted) _showResultDialog(l10n.snackbar_operation_failed, isError: true);
      }
    }
  }

  Future<void> _blockCharacter(
      Character character,
      ) async {
    final bool blocked =
    await CharacterBlockService
        .showBlockDialog(
      context: context,
      character: character,
    );

    if (!blocked || !mounted) {
      return;
    }

    // 畫面立即排除，不必等重新進 App
    setState(() {
      _blockedCharacterIds.add(
        character.id,
      );
    });

    await _refreshAllData();
  }

  Future<void> _reportCharacter(
      Character character,
      ) async {
    await CharacterReportService
        .showReportDialog(
      context: context,
      character: character,
      source: 'encounter',
    );
  }

  void _showMoreOptions(Character character, bool isFriend) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              if (isFriend)
                ListTile(
                  leading: const Icon(Icons.person_remove_outlined, color: Colors.red),
                  title: Text(l10n.remove_friend, style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteFriend(character);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title:  Text(l10n.report_character),
                onTap: () {
                  Navigator.pop(context);
                  _reportCharacter(character);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.orange),
                title: Text(l10n.block_character, style: TextStyle(color: Colors.orange)),
                onTap: () {
                  Navigator.pop(context);
                  _blockCharacter(character);
                },
              ),
            ],
          ),
        );
      },
    );
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
                '邂逅資料載入失敗，請稍後再試。',
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
                '目前還沒有可以邂逅的角色',
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
            friendIds: _friendIds,
            blockedCharacterIds: _blockedCharacterIds,
            onAddFriend: _addFriend,
            onShowOptions: _showMoreOptions,
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
  final Set<String> friendIds;
  final Future<void> Function() onRefresh;
  // ⭐ 新增
  final Set<String> blockedCharacterIds;

  final Function(Character) onAddFriend;
  final Function(Character, bool) onShowOptions;

  const _DiscoveryHallView({
    required this.allCharacters,
    required this.friendIds,
    required this.onRefresh,
    // ⭐ 新增
    required this.blockedCharacterIds,

    required this.onAddFriend,
    required this.onShowOptions,
  });

  @override
  Widget build(BuildContext context) {
    return _LatestTab(
      allCharacters: allCharacters,
      friendIds: friendIds,
      blockedCharacterIds: blockedCharacterIds,
      onAddFriend: onAddFriend,
      onShowOptions: onShowOptions,
      onRefresh: onRefresh,
    );
  }
}

// 🌟 分頁一：最新推薦 (保持完美比例 + 呈現時尚的高低交錯感)
class _LatestTab extends StatefulWidget {
  final List<Character> allCharacters;
  final Set<String> friendIds;
  final Future<void> Function() onRefresh;
  // ⭐ 新增
  final Set<String> blockedCharacterIds;

  final Function(Character) onAddFriend;
  final Function(Character, bool) onShowOptions;

  const _LatestTab({
    required this.allCharacters,
    required this.friendIds,
    required this.onRefresh,
    // ⭐ 新增
    required this.blockedCharacterIds,

    required this.onAddFriend,
    required this.onShowOptions,
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

  @override
  void initState() {
    super.initState();
    _rebuildBannerCharacters();
  }

  @override
  void didUpdateWidget(
      covariant _LatestTab oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    _rebuildBannerCharacters();
  }

  String _normalizeCategoryText(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'^#+'), '')
        .replaceAll(' ', '')
        .toLowerCase();
  }

  bool _matchesCategory(Character character, String category) {
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
    final list = _visibleAllCharacters
        .where((character) => _matchesCategory(character, _selectedCategory))
        .toList();

    // 同一分類固定以人氣排序，避免 setState 後角色位置不停跳。
    list.sort((a, b) => b.playCount.compareTo(a.playCount));
    return list;
  }

  Widget _buildCategoryStrip(
      BuildContext context,
      bool useDesktopLayout,
      ) {
    final theme = Theme.of(context);

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
                    category,
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Center(
        child: Text(
          '這個分類目前還沒有角色',
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
                  final result =
                  await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterProfilePage(
                        character: character,
                        characterId: character.id,
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
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          memCacheWidth: useDesktopLayout ? 700 : 520,
                          placeholder: (_, __) => Container(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                          errorWidget: (_, __, ___) => Image.asset(
                            'assets/images/blank_avatar.png',
                            fit: BoxFit.cover,
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
                final result =
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CharacterProfilePage(
                          character: char,
                          characterId: char.id,
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

    return CachedNetworkImage(
      imageUrl: bannerImg,
      width: double.infinity,
      height: double.infinity,

      // 關鍵：直接把圖片填滿整個 Banner。
      fit: BoxFit.cover,

      // 稍微往上取景，優先保留人物臉部。
      alignment: const Alignment(0, -0.18),

      memCacheWidth: 1080,
      filterQuality: FilterQuality.medium,
      placeholder: (context, url) => Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
      errorWidget: (context, url, error) =>
          Image.asset(
            'assets/images/blank_avatar.png',
            fit: BoxFit.cover,
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
      CachedNetworkImage(
        imageUrl: bannerImg,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        memCacheWidth: 1600,
        placeholder: (context, url) => Container(
          color: Colors.black12,
        ),
        errorWidget: (context, url, error) =>
            Container(
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
        child: CachedNetworkImage(
          imageUrl: bannerImg,
          fit: BoxFit.contain,
          alignment: Alignment.center,
          memCacheWidth: 1400,
          placeholder: (context, url) =>
          const SizedBox.shrink(),
          errorWidget: (context, url, error) =>
              Image.asset(
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
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    alignment:
                    Alignment.topCenter,
                    memCacheWidth:
                    isDesktop ? 900 : 720,
                    placeholder:
                        (context, url) =>
                        Container(
                          color: Colors.grey.shade200,
                        ),
                    errorWidget:
                        (context, url, error) =>
                        Image.asset(
                          'assets/images/blank_avatar.png',
                          fit: BoxFit.cover,
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
                          CachedNetworkImage(
                            imageUrl:
                            imageUrl,
                            fit: BoxFit
                                .cover,
                            alignment:
                            Alignment
                                .topCenter,
                            memCacheWidth:
                            useDesktopLayout
                                ? 900
                                : 720,
                            placeholder:
                                (_, __) =>
                                Container(
                                  color: Theme.of(
                                      context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                ),
                            errorWidget:
                                (_, __,
                                ___) =>
                                Image
                                    .asset(
                                  'assets/images/blank_avatar.png',
                                  fit: BoxFit
                                      .cover,
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

// ✨✨✨ 全新的可翻譯角色卡片 ✨✨✨
class CharacterCard extends StatefulWidget {
  final Character character;
  final bool isFriend;
  final VoidCallback onAddFriend;
  final Function(Character, bool) onShowOptions;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isFriend,
    required this.onAddFriend,
    required this.onShowOptions,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  bool _isTranslating = false;
  String? _translatedSummary;
  List<String>? _translatedTags;

  Future<void> _translateSummary(String targetLang) async {
    if (widget.character.storySummary.isEmpty && widget.character.personalityTags.isEmpty) return;

    setState(() => _isTranslating = true);

    try {
      final tagsText = widget.character.personalityTags.join(" ; ");
      final results = await Future.wait([
        FirebaseFunctions.instanceFor(region: 'asia-east1')
            .httpsCallable('translateText')
            .call({'text': widget.character.storySummary, 'targetLanguage': targetLang}),
        FirebaseFunctions.instanceFor(region: 'asia-east1')
            .httpsCallable('translateText')
            .call({'text': tagsText, 'targetLanguage': targetLang}),
      ]);

      final String newSummary = results[0].data['translatedText'];
      final String newTagsRaw = results[1].data['translatedText'];
      final List<String> newTags = newTagsRaw.split(RegExp(r'\s*;\s*'));

      final charDocRef = FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id);

      await charDocRef.set({
        'translations': {
          targetLang: {
            'storySummary': newSummary,
            'personalityTags': newTags,
          }
        }
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _translatedSummary = newSummary;
          _translatedTags = newTags;
          _isTranslating = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  Widget _buildFirstCharacterImage() {
    final String imageUrl =
    widget.character.galleryPaths.isNotEmpty
        ? widget.character.galleryPaths.first
        : '';

    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/blank_avatar.png',
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      memCacheWidth: 1080,
      placeholder: (context, url) => Container(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
      errorWidget: (context, url, error) {
        return Image.asset(
          'assets/images/blank_avatar.png',
          fit: BoxFit.cover,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final primaryColor = theme.colorScheme.primary;
    final String currentAppLang = Localizations.localeOf(context).languageCode;
    final String contentLang = widget.character.contentLanguage ?? 'zh';
    final sharedTranslation = widget.character.translations?[currentAppLang];
    final l10n = AppLocalizations.of(context)!;

    final displaySummary = _translatedSummary ?? (sharedTranslation?['storySummary'] as String?) ?? widget.character.storySummary;
    final rawDisplayTags = _translatedTags ??
        (sharedTranslation?['personalityTags'] as List?)?.cast<String>() ??
        widget.character.personalityTags;

    final seenTags = <String>{};

    final displayTags = rawDisplayTags
        .map((tag) => tag.trim().replaceAll(RegExp(r'^#+'), '').trim())
        .where((tag) => tag.isNotEmpty)
        .where((tag) => seenTags.add(tag))
        .toList();

    final String displayIdentities = (widget.character.identities != null && widget.character.identities!.isNotEmpty)
        ? widget.character.identities!.join(' / ')
        : (widget.character.occupation);
    final bool showTranslateButton = (currentAppLang != contentLang) &&
        (_translatedSummary == null && sharedTranslation == null);

    Widget cardWidget = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFirstCharacterImage(),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(
                      alpha: 0.85,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 12, right: 12,
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.3)),
              onPressed: () =>
                  widget.onShowOptions(widget.character, widget.isFriend),
            ),
          ),
          Positioned(
            bottom: 25, left: 20, right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.character.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.character.createdBy == 'B71k2kyooubYsOtIO1nkiBwyBXt2') ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.wb_sunny_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.text_age_and_identities(
                                widget.character.age.toString(),
                                displayIdentities
                            ),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    widget.isFriend
                        ? Chip(
                      backgroundColor: primaryColor.withValues(alpha: 0.2),
                      side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                      avatar: Icon(Icons.check, size: 16, color: primaryColor),
                      label: Text(l10n.tab_friends, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                      visualDensity: VisualDensity.compact,
                    )
                        : ElevatedButton.icon(
                      onPressed: widget.onAddFriend,
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(l10n.tab_friends),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: theme.colorScheme.onPrimary,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displaySummary.isEmpty
                          ? l10n.msg_mysterious_profile
                          : displaySummary,
                      style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                      maxLines: _translatedSummary != null ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showTranslateButton)
                      GestureDetector(
                        onTap: () => _translateSummary(currentAppLang),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: _isTranslating
                              ? SizedBox(width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: primaryColor))
                              : Text(l10n.action_view_translation,
                              style: TextStyle(
                                  color: primaryColor.withValues(alpha: 0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    if (_translatedSummary != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(Icons.translate, size: 12,
                                  color: primaryColor),
                              const SizedBox(width: 6),
                              Text(l10n.label_translation_result, style: const TextStyle(
                                  color: Colors.white54, fontSize: 10))
                            ]),
                            const SizedBox(height: 4),
                            Text(_translatedSummary!,
                                style: const TextStyle(color: Colors.white,
                                    fontSize: 14,
                                    height: 1.4)),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 16),
                if (widget.character.personalityTags.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: displayTags
                          .take(3)
                          .map((tag) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white24, width: 0.5)),
                          child: Text('#$tag', style: const TextStyle(
                              color: Colors.white, fontSize: 11)),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    return isDesktop
        ? Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 450), child: cardWidget))
        : cardWidget;
  }
}