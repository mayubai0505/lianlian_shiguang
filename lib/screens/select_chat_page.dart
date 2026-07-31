import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';
import 'dart:ui';
import 'character_model.dart';
import 'character_profile_page.dart';
import 'search_character_page.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// 邂逅頁面
class SelectChatPage extends StatefulWidget {
  const SelectChatPage({super.key});

  @override
  SelectChatPageState createState() => SelectChatPageState();
}

class SelectChatPageState extends State<SelectChatPage> with TickerProviderStateMixin {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String APP_ID = AppConfig.appId;
  String? _userId;
  Future<List<Character>>? _charactersFuture;
  Set<String> _friendIds = {};
  Set<String> _blockedCharacterIds = {};
  final Set<String> _preloadedImageUrls = {};
  late TabController _mainTabController;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _userId = user?.uid;
        });
        _refreshAllData();
      }
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    super.dispose();
  }

  void refreshEncounters() {
    setState(() {
      _charactersFuture = null;
    });
    _refreshAllData();
  }

  Future<void> _refreshAllData() async {
    if (_userId == null) {
      if (mounted) {
        setState(() {
          _friendIds.clear();
          _blockedCharacterIds.clear();
          _charactersFuture = _loadCharacters();
        });
      }
      return;
    }
    await Future.wait([
      _loadFriendIds(),
      _loadBlockedCharacterIds(),
    ]);
    if (mounted) {
      setState(() {
        _charactersFuture = _loadCharacters();
      });
    }
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
      List<Character> characters = await Future.wait(
          querySnapshot.docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );
      characters.removeWhere((char) => _blockedCharacterIds.contains(char.id));
      return characters;
    } catch (e) {
      print("讀取邂逅角色失敗: $e");
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

  Future<void> _blockCharacter(Character character) async {
    final l10n = AppLocalizations.of(context)!;
    if (_userId == null) return;
    final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(l10n.dialog_title_block),
              content: Text(l10n.dialog_msg_block(character.name)),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.cancel)),
                TextButton(onPressed: () => Navigator.of(context).pop(true),
                    child: Text(l10n.block, style: const TextStyle(color: Colors.red))),
              ],
            )
    );

    if (confirm == true) {
      try {
        await _db.collection('users')
            .doc(_userId!)
            .collection('characters')
            .doc(character.id)
            .set({
          'name': character.name,
          'avatar': character.galleryPaths.isNotEmpty ? character.galleryPaths[0] : '',
          'isBlocked': true,
          'blockedAt': FieldValue.serverTimestamp(),
          'desc': character.background,
        }, SetOptions(merge: true));
        _refreshAllData();
        if (mounted) {
          _showResultDialog(l10n.snackbar_blocked(character.name));
        }
      } catch (e) {
        if (mounted) _showResultDialog(l10n.snackbar_operation_failed, isError: true);
      }
    }
  }

  Future<void> _reportCharacter(Character character) async {
    final l10n = AppLocalizations.of(context)!;
    if (_userId == null) return;
    final reasonController = TextEditingController();
    final bool? submit = await showDialog<bool>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(l10n.dialog_title_report(character.name)),
              content: TextField(
                controller: reasonController,
                decoration: InputDecoration(
                    hintText: l10n.input_hint_report_reason),
                maxLines: 3,
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.cancelButton)),
                ElevatedButton(onPressed: () => Navigator.of(context).pop(true),
                    child: Text(l10n.action_submit)),
              ],
            )
    );

    if (submit == true && reasonController.text.trim().isNotEmpty) {
      try {
        await _db.collection('reports').add({
          'reporterId': _userId,
          'reportedCharacterId': character.id,
          'reportedCharacterName': character.name,
          'reason': reasonController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'pending',
        });
        if (mounted) {
          _showResultDialog(l10n.snackbar_report_success);
        }
      } catch (e) {
        if (mounted) _showResultDialog(l10n.snackbar_report_fail, isError: true);
      }
    }
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

  // 🌟 小橢圓膠囊按鈕建構器
  Widget _buildSmallPillButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        // 🌟 修正：讓標題文字具備彈性縮放與防溢位機制
        title: Row(
          children: [
            Flexible(
              child: Text(
                l10n.title_meet_him,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16, // 字體稍微精簡，更契合手機 AppBar
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis, // 空間不足時自動顯示 ...
              ),
            ),
            const SizedBox(width: 8), // 縮小間距
            AnimatedBuilder(
              animation: _mainTabController,
              builder: (context, child) {
                final currentIndex = _mainTabController.index;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSmallPillButton(
                      text: l10n.daily_encounter,
                      isSelected: currentIndex == 0,
                      onTap: () => _mainTabController.animateTo(0),
                      theme: theme,
                    ),
                    const SizedBox(width: 4), // 縮小按鈕間距
                    _buildSmallPillButton(
                      text: l10n.discovery_hall,
                      isSelected: currentIndex == 1,
                      onTap: () => _mainTabController.animateTo(1),
                      theme: theme,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _navigateToSearch,
          ),
        ],
      ),
      body: FutureBuilder<List<Character>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: _buildEndCard(theme, themeNotifier));
          }

          final characters = snapshot.data!;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _precacheCharacterImages(context, characters);
          });

          // 🌟 直接渲染 TabBarView，頂部空間已完全釋放！
          return TabBarView(
            controller: _mainTabController,
            children: [
              // ------------------------------------
              // 1. 滑卡模式主頁
              // ------------------------------------
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Text(
                          l10n.text_character_count(characters.length),
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Swiper(
                      itemCount: characters.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == characters.length) {
                          return _buildEndCard(theme, themeNotifier);
                        }
                        final character = characters[index];
                        final bool isFriend = _friendIds.contains(character.id);

                        return CharacterCard(
                          character: character,
                          isFriend: isFriend,
                          onAddFriend: () => _addFriend(character),
                          onShowOptions: (char, isFriend) => _showMoreOptions(char, isFriend),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      layout: SwiperLayout.STACK,
                      itemWidth: MediaQuery.of(context).size.width * 0.9,
                      itemHeight: MediaQuery.of(context).size.height * 0.70,
                      loop: false,
                      onTap: (index) async {
                        if (index < characters.length) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CharacterProfilePage(
                                      character: characters[index],
                                      characterId: characters[index].id,
                                    )),
                          );
                          _loadFriendIds();
                        }
                      },
                    ),
                  ),
                ],
              ),

              // ------------------------------------
              // 2. 探索大廳 (三子分頁)
              // ------------------------------------
              _DiscoveryHallView(
                allCharacters: characters,
                friendIds: _friendIds,
                onAddFriend: _addFriend,
                onShowOptions: _showMoreOptions,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEndCard(ThemeData theme, ThemeNotifier themeNotifier) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.70,
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: themeNotifier.currentBackground,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard, size: 60,
                    color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  l10n.msg_no_more_encounters_today,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.msg_check_new_encounters,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7)
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: refreshEncounters,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.action_refresh, style: const TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.8),
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
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
// ==========================================
// 🏛️ 探索大廳檢視元件 (包含三個子分頁)
// ==========================================
class _DiscoveryHallView extends StatelessWidget {
  final List<Character> allCharacters;
  final Set<String> friendIds;
  final Function(Character) onAddFriend;
  final Function(Character, bool) onShowOptions;

  const _DiscoveryHallView({
    required this.allCharacters,
    required this.friendIds,
    required this.onAddFriend,
    required this.onShowOptions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 讓內容靠左對齊
        children: [
          Container(
            color: Colors.transparent,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start, // 🔑 關鍵：強制從最左邊開始排列，消滅左側空格！
              padding: EdgeInsets.zero,          // 🔑 清除預設的外距
              labelPadding: const EdgeInsets.symmetric(horizontal: 16), // 調整每個標籤之間的間距
              tabs:  [
                Tab(text: '🌟 ${l10n.latest_recommendation}'),
                Tab(text: '🔥 ${l10n.popular_ranking}'),
                Tab(text: '🏷️ ${l10n.character_features}'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _LatestTab(allCharacters: allCharacters, friendIds: friendIds, onAddFriend: onAddFriend, onShowOptions: onShowOptions),
                _PopularTab(allCharacters: allCharacters, friendIds: friendIds, onAddFriend: onAddFriend, onShowOptions: onShowOptions),
                _TagsTab(allCharacters: allCharacters, friendIds: friendIds, onAddFriend: onAddFriend, onShowOptions: onShowOptions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🌟 分頁一：最新推薦 (保持完美比例 + 呈現時尚的高低交錯感)
class _LatestTab extends StatelessWidget {
  final List<Character> allCharacters;
  final Set<String> friendIds;
  final Function(Character) onAddFriend;
  final Function(Character, bool) onShowOptions;

  const _LatestTab({
    required this.allCharacters,
    required this.friendIds,
    required this.onAddFriend,
    required this.onShowOptions,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final l10n = AppLocalizations.of(context)!;
    // 網頁或寬螢幕使用桌面版配置。
    final bool useDesktopLayout =
        kIsWeb && screenWidth >= 800;

    final double pageHorizontalPadding =
    useDesktopLayout ? 32 : 16;

    final double maxContentWidth =
    useDesktopLayout ? 1280 : double.infinity;

    final List<Character> sortedList =
    List<Character>.from(allCharacters);

    sortedList.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });

    final List<Character> bannerList =
    sortedList.take(10).toList();

    return Align(
      alignment: const Alignment(0, -0.35),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxContentWidth,
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: pageHorizontalPadding,
            vertical: 16,
          ),
          children: [
            if (bannerList.isNotEmpty) ...[
              Text(
                '🌟 ${l10n.featured_new_star}',
                style: TextStyle(
                  fontSize: useDesktopLayout ? 22 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _buildRecommendationBanner(
                context,
                bannerList,
                useDesktopLayout: useDesktopLayout,
              ),

              SizedBox(
                height: useDesktopLayout ? 36 : 24,
              ),
            ],

            Text(
              '✨ ${l10n.recently_added_characters}',
              style: TextStyle(
                fontSize: useDesktopLayout ? 22 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (useDesktopLayout)
              _buildDesktopCharacterGrid(
                context,
                sortedList,
              )
            else
              _buildMobileStaggeredGrid(
                context,
                sortedList,
              ),
          ],
        ),
      ),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CharacterProfilePage(
                      character: char,
                      characterId: char.id,
                    ),
                  ),
                );
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

// 🔥 分頁二：人氣熱榜
class _PopularTab extends StatelessWidget {
  final List<Character> allCharacters;
  final Set<String> friendIds;
  final Function(Character) onAddFriend;
  final Function(Character, bool) onShowOptions;

  const _PopularTab({required this.allCharacters, required this.friendIds, required this.onAddFriend, required this.onShowOptions});

  @override
  Widget build(BuildContext context) {
    List<Character> popularList = List.from(allCharacters);
    popularList.sort((a, b) => b.playCount.compareTo(a.playCount));
    final l10n = AppLocalizations.of(context)!;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: popularList.length,
      itemBuilder: (context, index) {
        final char = popularList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            minVerticalPadding: 10,

            leading: SizedBox(
              width: 58,
              height: 58,
              child: buildCachedCharacterAvatar(
                context,
                char,
                radius: 29,
              ),
            ),

            title: Text(
              char.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  char.storySummary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 14,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.character_play_count(char.playCount),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CharacterProfilePage(
                    character: char,
                    characterId: char.id,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// 🏷️ 分頁三：角色特徵標籤探索 (多色交錯、絕不眼花版)
class _TagsTab extends StatelessWidget {
  final List<Character> allCharacters;
  final Set<String> friendIds;
  final Function(Character) onAddFriend;
  final Function(Character, bool) onShowOptions;

  const _TagsTab({required this.allCharacters, required this.friendIds, required this.onAddFriend, required this.onShowOptions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    Set<String> uniqueTags = {};
    for (var char in allCharacters) {
      uniqueTags.addAll(char.personalityTags);
    }

    List<String> tagList = uniqueTags.toList();

    if (tagList.isEmpty) {
      return Center(
        child: Text(l10n.no_tag_data),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.4,
        ),
        itemCount: tagList.length,
        itemBuilder: (context, index) {
          final tag = tagList[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _TagFilteredCharactersPage(
                    tag: tag,
                    allCharacters: allCharacters,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(
                  alpha: 0.08,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(
                    alpha: 0.25,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                "#$tag",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}

// 🏷️ 點擊特定標籤後跳轉過去的「過濾角色列表頁」
class _TagFilteredCharactersPage extends StatelessWidget {
  final String tag;
  final List<Character> allCharacters;

  const _TagFilteredCharactersPage({required this.tag, required this.allCharacters});

  @override
  Widget build(BuildContext context) {
    final filteredChars = allCharacters.where((c) => c.personalityTags.contains(tag)).toList();
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.tag_page_title(tag),
        ),
      ),
      body: filteredChars.isEmpty
          ? Center(child: Text(l10n.no_character_with_tag))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredChars.length,
        itemBuilder: (context, index) {
          final char = filteredChars[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: buildCachedCharacterAvatar(
                context,
                char,
                radius: 30,
              ),
              title: Text(char.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(char.occupation, style: const TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CharacterProfilePage(character: char, characterId: char.id)));
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