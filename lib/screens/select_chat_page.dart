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
import '../widgets/character_image_carousel.dart';
import 'package:cloud_functions/cloud_functions.dart'; //
import '../services/locale_notifier.dart'; // ✨ 翻譯的
import 'dart:math';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//邂逅頁面

class SelectChatPage extends StatefulWidget {
  const SelectChatPage({super.key});

  @override
  _SelectChatPageState createState() => _SelectChatPageState();
}

class _SelectChatPageState extends State<SelectChatPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String APP_ID = AppConfig.appId;
  String? _userId;
  Future<List<Character>>? _charactersFuture;
  Set<String> _friendIds = {};

  // ✨ 新增一個 Set 來記錄被封鎖的角色 ID
  Set<String> _blockedCharacterIds = {};

  // ✨ 2. 用這個乾淨的版本，替換你舊的 initState ✨
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _userId = user?.uid;
        });
        // 只需要呼叫這一個函式，它會處理所有後續邏輯
        _refreshAllData();
      }
    });
  }

  // ✨ 3. 用這個結構正確的版本，替換你舊的 _refreshAllData ✨
  Future<void> _refreshAllData() async {
    if (_userId == null) {
      // 使用者登出
      if (mounted) {
        setState(() {
          _friendIds.clear();
          _blockedCharacterIds.clear();
          _charactersFuture = _loadCharacters();
        });
      }
      return; // 提前結束函式
    }

    // 使用 Future.wait 平行處理，速度更快
    await Future.wait([
      _loadFriendIds(),
      _loadBlockedCharacterIds(),
    ]);

    // 最後才載入角色，因為它需要用到封鎖列表
    if (mounted) {
      setState(() {
        _charactersFuture = _loadCharacters();
      });
    }
  }

  // ✨ 步驟 1.2: 建立一個專門載入好友 ID 的新函式
  Future<void> _loadFriendIds() async {
    // 防呆機制：如果沒有 userID 就不繼續執行
    if (_userId == null) return;

    try {
      final snapshot = await _db
          .collection('users')
          .doc(_userId!)
          .collection('friends')
          .get();

      // 將查詢到的所有文件 ID (也就是 characterId) 轉換成一個 Set
      final ids = snapshot.docs.map((doc) => doc.id).toSet();

      // 使用 setState 更新我們的狀態變數，這樣 UI 才能在未來根據它做變化
      if (mounted) {
        setState(() {
          _friendIds = ids;
        });
      }
      print("✅ 成功載入 ${_friendIds.length} 位好友的 ID。");
    } catch (e) {
      print("❌ 讀取好友列表失敗: $e");
      // 可以在這裡加入一些錯誤提示 UI
    }
  }

  // ✨ 新增載入封鎖列表的函式
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
    if (AppConfig.appId == 'default-app-id') {
      print(
          "警告：正在使用預設的 App ID 'default-app-id'。請確認您的 Firestore 路徑是否正確。");
    }

    try {
      final querySnapshot = await _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .get();

      List<Character> characters = await Future.wait(
          querySnapshot.docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );

      print("成功讀取到 ${characters.length} 位公開角色。");

      // --- ✨ 測試期間暫時註解掉，方便看到自己創建的角色 ---
      // if (_userId != null) {
      //   characters.removeWhere((char) => char.createdBy == _userId);
      //   print("移除自己創建的角色後，剩下 ${characters.length} 位。");
      // }
      // --- ✨ 遊戲正式上線前，記得取消註解！ ---

      characters.removeWhere((char) => _blockedCharacterIds.contains(char.id));

      characters.shuffle();
      return characters;
    } catch (e) {
      print("讀取邂逅角色失敗: $e");
      return [];
    }
  }
  // ✨ 請把這個新函式加到 _SelectChatPageState 裡面
  Future<void> _addFriend(Character character) async {
    // 防呆機制：確認使用者已登入
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請先登入才能添加好友！')),
      );
      return;
    }

    try {
      // 步驟 1: 更新雲端資料庫 (Firestore)
      print('正在將角色 ${character.name} (ID: ${character
          .id}) 添加到好友列表...');
      // ✨ 步驟 1 升級版：把對方的「門面」一起存進去
      await _db
          .collection('users')
          .doc(_userId!)
          .collection('friends')
          .doc(character.id)
          .set({
        'characterId': character.id,
        'name': character.name,           // 🌟 存入名字
        'avatarPath': character.avatarPath, // 🌟 存入頭像
        'addedAt': FieldValue.serverTimestamp(),
      });
      print('角色 ${character.name} 已成功寫入 Firestore！');

      // 步驟 2: 即時更新本地 UI
      // 為了讓玩家立刻看到按鈕的變化，我們在資料庫寫入成功後，
      // 立刻呼叫 setState()，把這個角色的 ID 加到我們本地的 _friendIds 列表裡。
      if (mounted) {
        setState(() {
          _friendIds.add(character.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('成功添加 ${character.name} 為好友！')),
        );
      }
    } catch (e) {
      print('添加好友失敗: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('添加好友失敗，請稍後再試。')),
        );
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
              title: Text('確認移除好友'),
              content: Text('您確定要將 ${character.name} 從好友列表中移除嗎？'),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.cancelButton
                    )),
                TextButton(onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                        '移除', style: TextStyle(color: Colors.red))),
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
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('已將 ${character.name} 移除好友')));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('操作失敗，請稍後再試')));
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
              title: Text('確認封鎖'),
              content: Text('封鎖後，您將不會再看到 ${character
                  .name} 的任何資訊。確定要封鎖嗎？'),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.cancel)),
                TextButton(onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                        '封鎖', style: TextStyle(color: Colors.red))),
              ],
            )
    );

    if (confirm == true) {
      try {
        // ✨ 修正後的封鎖邏輯
        await _db.collection('users')
            .doc(_userId!)
            .collection('characters') // 🚀 統一存進這個「大名冊」
            .doc(character.id)
            .set({
          'name': character.name,
          'avatar': character.galleryPaths.isNotEmpty ? character.galleryPaths[0] : '',
          'isBlocked': true,      // 🚀 這是關鍵標籤！
          'blockedAt': FieldValue.serverTimestamp(),
          'desc': character.background,
        }, SetOptions(merge: true)); // 🚀 使用 merge，才不會蓋掉原本的好感度或其他資料
        // 封鎖後立刻重新整理畫面
        _refreshAllData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('已封鎖 ${character.name}')));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('操作失敗，請稍後再試')));
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
              title: Text('檢舉 ${character.name}'),
              content: TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                    hintText: '請輸入檢舉原因...'),
                maxLines: 3,
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.cancelButton
                    )),
                ElevatedButton(onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('提交')),
              ],
            )
    );

    if (submit == true && reasonController.text
        .trim()
        .isNotEmpty) {
      try {
        await _db.collection('reports').add({
          'reporterId': _userId,
          'reportedCharacterId': character.id,
          'reportedCharacterName': character.name,
          'reason': reasonController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'pending', // 待處理
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('感謝您的回報，我們將會盡快審核。')));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('提交失敗，請稍後再試')));
      }
    }
  }


  // ✨ 這是新的「更多選項」選單
  void _showMoreOptions(Character character, bool isFriend) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              // 「刪除好友」選項只在是好友時出現
              if (isFriend)
                ListTile(
                  leading: const Icon(
                      Icons.person_remove_outlined, color: Colors.red),
                  title: const Text(
                      '移除好友', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteFriend(character);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('檢舉此角色'),
                onTap: () {
                  Navigator.pop(context);
                  _reportCharacter(character);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.orange),
                title: const Text(
                    '封鎖此角色', style: TextStyle(color: Colors.orange)),
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

  void _refreshCharacters() {
    setState(() {
      _charactersFuture = _loadCharacters();
    });
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchCharacterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- ✨ 在這裡定義 theme，讓整個 build 方法都能使用 ---
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('遇見心儀的他'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        foregroundColor: theme.colorScheme.onBackground,
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
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            // ✨ 傳入 theme 變數
            return Center(child: _buildEndCard(theme, themeNotifier));
          }

          final characters = snapshot.data!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      '角色數量: ${characters.length}',
                      style: TextStyle(color: theme.colorScheme.onBackground),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Swiper(
                  itemCount: characters.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == characters.length) {
                      // ✨ 傳入 theme 變數
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
                    // ✨ 傳入 theme 變數
                  },
                  scrollDirection: Axis.vertical,
                  layout: SwiperLayout.STACK,
                  itemWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  itemHeight: MediaQuery
                      .of(context)
                      .size
                      .height * 0.70,
                  loop: false,
                  onTap: (index) async { //在這裡加上 async
                    if (index < characters.length) {
                      // ✨ 我們在這裡「等待」使用者從介紹頁回來
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CharacterProfilePage(
                                  character: characters[index],
                                  characterId: characters[index].id,
                                )),
                      );

                      // ✨ 當使用者回來後，我們立刻手動重新整理好友列表
                      _loadFriendIds();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- ✨ 核心修改 #1: 讓函式接收 ThemeNotifier ---
  Widget _buildEndCard(ThemeData theme, ThemeNotifier themeNotifier) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.70,
      child: Card(
        // ✨ 讓 Card 本身透明，才能顯示出底下 Container 的漸層
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: Container(
          // ✨ 使用 ThemeNotifier 中的漸層背景！
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
                  '今天的邂逅就到這裡囉！',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  '再來看看有沒有新的相遇吧！',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _refreshCharacters,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新整理', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.8),
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

  // --- ✨ 修改 #2: 使用 Card Widget 來確保圓角 ---

  Widget _buildCharacterCard(ThemeData theme, Character character) {
    final bool isFriend = _friendIds.contains(character.id);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CharacterImageCarousel(imagePaths: character.galleryPaths),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                ),
              ),
            ),
          ),

          // ✨✨✨ 新增的右上角「更多選項」按鈕 ✨✨✨
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              // 垂直的三個點
              color: Colors.white,
              // 增加一個半透明背景，讓按鈕在任何圖片上都清晰可見
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.3),
              ),
              tooltip: '更多選項',
              // 按下後，呼叫我們即將建立的新選單函式
              onPressed: () => _showMoreOptions(character, isFriend),
            ),
          ),

          Positioned(
            bottom: 25,
            left: 25,
            right: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(character.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(blurRadius: 5.0, color: Colors.black87)
                            ]),
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                          '${character.age} | ${character.occupation}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              shadows: [Shadow(blurRadius: 3.0,
                                  color: Colors.black87)
                              ]),
                          overflow: TextOverflow.ellipsis),
                    ),
                    const Spacer(),
                    // ✨ 這裡的邏輯不變，但是為了避免擁擠，我把它換成了更小的版本
                    isFriend
                        ? Chip(
                      avatar: Icon(Icons.check, size: 16),
                      label: const Text('好友'),
                      visualDensity: VisualDensity.compact,
                    )
                        : ElevatedButton.icon(
                      onPressed: () => _addFriend(character),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('好友'),
                      style: ElevatedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ... 以下你的 Text 和 Wrap 都維持原樣 ...
                Text(
                  character.storySummary.isEmpty
                      ? '這個人很神秘，什麼都沒留下...'
                      : character.storySummary,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                      shadows: [
                        Shadow(blurRadius: 3.0, color: Colors.black87)
                      ]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                if (character.personalityTags.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: character.personalityTags.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 0.5)),
                        child: Text('#$tag',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

    // ✨✨✨ 全新的可翻譯角色卡片 (放在檔案最下方，與 _SelectChatPageState 並列) ✨✨✨
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

      // 在 _CharacterCardState 類別裡

      Future<void> _translateSummary(String targetLang) async {
        if (widget.character.storySummary.isEmpty && widget.character.personalityTags.isEmpty) return;

        setState(() => _isTranslating = true);

        try {
          // 1. 打包發送翻譯請求
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

          // 2. ✨【方案 B 核心】：同步回傳給 Firestore 共享給全體玩家
          // 存儲路徑：artifacts/{appId}/public_characters/{charId}
          final charDocRef = FirebaseFirestore.instance
              .collection('artifacts')
              .doc('AppConfig.appId') // 確保 ID 正確
              .collection('public_characters')
              .doc(widget.character.id);

          await charDocRef.set({
            'translations': {
              targetLang: {
                'storySummary': newSummary,
                'personalityTags': newTags,
              }
            }
          }, SetOptions(merge: true)); // 使用 merge 才不會蓋掉原本的角色資料

          // 3. 更新本地 UI
          if (mounted) {
            setState(() {
              _translatedSummary = newSummary;
              _translatedTags = newTags;
              _isTranslating = false;
            });
          }
        } catch (e) {
          print('--- 🔴 方案 B 寫入失敗: $e ---');
          if (mounted) setState(() => _isTranslating = false);
        }
      }

      @override
      Widget build(BuildContext context) {
        final theme = Theme.of(context);
        // ✨ 1. 取得目前螢幕的寬度
        final screenWidth = MediaQuery.of(context).size.width;
        // ✨ 2. 定義什麼叫做「大螢幕」(通常大於 600 或 800 就當作電腦/平板)
        final isDesktop = screenWidth > 600;
        final primaryColor = theme.colorScheme.primary;
        final String currentAppLang = Localizations
            .localeOf(context)
            .languageCode;
        final String contentLang = widget.character.contentLanguage ?? 'zh';
        final sharedTranslation = widget.character.translations?[currentAppLang];

        // 優先序：本地翻譯 > 共享翻譯 > 原文
        final displaySummary = _translatedSummary ?? sharedTranslation?['storySummary'] ?? widget.character.storySummary;
        final displayTags = _translatedTags ?? (sharedTranslation?['personalityTags'] as List?)?.cast<String>() ?? widget.character.personalityTags;
        final String displayIdentities = (widget.character.identities != null && widget.character.identities!.isNotEmpty)
            ? widget.character.identities!.join(' / ')
            : (widget.character.occupation ?? '神秘身分');
        // 是否要顯示翻譯按鈕：
        // 1. 語言不同 2. 本地還沒翻 3. 雲端也還沒人翻過
        final bool showTranslateButton = (currentAppLang != (widget.character.contentLanguage ?? 'zh')) &&
            (_translatedSummary == null && sharedTranslation == null);

        Widget cardWidget = Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CharacterImageCarousel(imagePaths: widget.character.galleryPaths),

              // 底部漸層：從透明到深色，保護文字易讀性
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.85)
                      ],
                    ),
                  ),
                ),
              ),

              // 右上角更多選項
              Positioned(
                top: 12, right: 12,
                child: IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.3)),
                  onPressed: () =>
                      widget.onShowOptions(widget.character, widget.isFriend),
                ),
              ),

              // 核心資訊區
              Positioned(
                bottom: 25, left: 20, right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // 讓左邊的文字和右邊的按鈕在垂直方向置中對齊（或置底也可以）
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 👇 1. 用 Expanded + Column 把名字跟副標題「上下」包起來
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.character.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4), // 👈 名字跟職業之間的微小上下間距
                              Text(
                                '${widget.character.age}歲| $displayIdentities',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10), // 確保文字如果太長，不會跟右邊的按鈕黏在一起

                        // 👇 2. 好友按鈕乖乖待在右邊
                        widget.isFriend
                            ? Chip(
                          backgroundColor: primaryColor.withOpacity(0.2),
                          side: BorderSide(color: primaryColor.withOpacity(0.5)),
                          avatar: Icon(Icons.check, size: 16, color: primaryColor),
                          label: Text('好友', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                          visualDensity: VisualDensity.compact,
                        )
                            : ElevatedButton.icon(
                          onPressed: widget.onAddFriend,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('好友'),
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

                    // 翻譯與劇情簡介區
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.character.storySummary.isEmpty
                              ? '這個人很神秘...'
                              : widget.character.storySummary,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15, height: 1.5),
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
                                  : Text('查看翻譯',
                                  style: TextStyle(
                                      color: primaryColor.withOpacity(0.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        if (_translatedSummary != null) ...[
                          const SizedBox(height: 8),
                          // ✅ 翻譯框：毛玻璃透明感
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
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
                                  const Text("翻譯結果:", style: TextStyle(
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

                    // 標籤區
                    if (widget.character.personalityTags.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          // ✨ 判斷：用 _translatedTags (翻譯版)，如果沒有才用原本的
                          children: (_translatedTags ?? widget.character.personalityTags)
                              .take(3)
                              .map((tag) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
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
        // ✨✨✨ 3. 壓軸的判斷式！這裡會決定卡片要不要限制寬度 ✨✨✨
        return isDesktop
            ? Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 450), child: cardWidget))
            : cardWidget;
      }
    }