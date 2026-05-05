import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'character_model.dart';
import 'package:intl/intl.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class AllFriendsPage extends StatefulWidget {
  const AllFriendsPage({super.key});

  @override
  State<AllFriendsPage> createState() => _AllFriendsPageState();
}

class _AllFriendsPageState extends State<AllFriendsPage> {
  List<Character> _allFriends = [];
  List<Character> _displayFriends = []; // ✨ 真正顯示出來的列表（過濾後）
  bool _isLoading = true;
  int _selectedCategory = 0; // 0: 全部, 1: 官方推薦, 2: 我的專屬

  // --- Firebase 變數 ---
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _appId = AppConfig.appId;
  @override
  void initState() {
    super.initState();
    _loadAllFriends();
  }

  Future<void> _loadAllFriends() async {
    if (!mounted) return;
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }
    final String userId = currentUser.uid;

    try {
      // 1. 🌟 關鍵：去抓使用者的「friends 子集合」 (也就是妳存 +好友 的地方)
      final friendsSnapshot = await _db.collection('users').doc(userId)
          .collection('friends').get();

      // 2. 抓玩家「自己的私藏角色」 (維持不變)
      final privateSnapshot = await _db.collection('artifacts').doc(_appId)
          .collection('users').doc(userId).collection('private_characters').get();

      final List<Character> tempAll = [];

      // 處理私藏角色
      for (var doc in privateSnapshot.docs) {
        final char = await Character.fromFirestoreAsync(doc);
        char.isPublic = false;
        tempAll.add(char);
      }

      // 3. 🌟 根據 friends 子集合裡的 ID，去抓官方角色的完整資料
      for (var friendDoc in friendsSnapshot.docs) {
        final charId = friendDoc.id; // 妳是用 character.id 當作 doc 名稱

        final charDoc = await _db.collection('artifacts').doc(_appId)
            .collection('public_characters').doc(charId).get();

        if (charDoc.exists) {
          final char = await Character.fromFirestoreAsync(charDoc);
          char.isPublic = true;
          tempAll.add(char);
        }
      }

      if (mounted) {
        setState(() {
          _allFriends = tempAll;
          _allFriends.sort((a, b) => b.lastChatTime.compareTo(a.lastChatTime));
          _applyFilter();
          _isLoading = false;
        });
      }
    } catch (e) {
      print("讀取好友圖鑑失敗: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ✨ 過濾邏輯：切換 官方/專屬
  void _applyFilter() {
    setState(() {
      if (_selectedCategory == 0) {
        _displayFriends = _allFriends;
      } else if (_selectedCategory == 1) {
        _displayFriends = _allFriends.where((c) => c.isPublic).toList();
      } else {
        _displayFriends = _allFriends.where((c) => !c.isPublic).toList();
      }
    });
  }

  void _navigateToChat(Character character) {
    final l10n = AppLocalizations.of(context)!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          character: character,
          chatMode: "daily",
          // 🌟 既然 ChatPage 現在變嚴格了，我們就補給它預設值
          sessionId: character.id,    // 暫時用角色 ID 當作 Session ID
          selectedLanguage: l10n.traditional_chinese, // 預設語言
          shouldSave: true,           // 預設開啟存檔
        ),
      ),
    );
  }

  ImageProvider _getAvatarProvider(String path) {
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.allFriendsTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: themeNotifier.currentBackground,
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 40),
            // ✨ 分類標籤列
            _buildCategorySelector(theme),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _displayFriends.isEmpty
                  ? Center(child: Text(l10n.noFriendsMessage))
                  : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _displayFriends.length,
                itemBuilder: (context, index) {
                  final friend = _displayFriends[index];
                  return _buildCharacterCard(theme, friend);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✨ 分類選擇器 UI
  Widget _buildCategorySelector(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final categories = [l10n.all, l10n.official_recommendation, l10n.my_exclusive];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(categories.length, (index) {
          bool isSelected = _selectedCategory == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  _selectedCategory = index;
                  _applyFilter();
                });
              },
              selectedColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                fontSize: 12,
              ),
            ),
          );
        }),
      ),
    );
  }

  // ✨ 雙排圖鑑卡片 UI
  Widget _buildCharacterCard(ThemeData theme, Character friend) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => _navigateToChat(friend),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            CircleAvatar(
              radius: 40,
              backgroundImage: _getAvatarProvider(friend.avatarPath),
            ),
            const SizedBox(height: 8),
            Text(
              friend.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // ✨ 顯示邂逅次數的小標籤
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(l10n.encounter_count(friend.playCount),
                style: TextStyle(fontSize: 10, color: theme.colorScheme.onSecondaryContainer),
              ),
            ),
            const Spacer(),
            // 標註來源
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                friend.isPublic ? l10n.official : l10n.private,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}