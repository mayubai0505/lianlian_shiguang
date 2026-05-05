import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/theme_notifier.dart';
import 'character_model.dart';
import 'character_edit_page.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//公開與不公開的頁面

class MyCharactersListPage extends StatefulWidget {
  const MyCharactersListPage({super.key});

  @override
  State<MyCharactersListPage> createState() => _MyCharactersListPageState();
}

class _MyCharactersListPageState extends State<MyCharactersListPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String APP_ID = AppConfig.appId;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  late Future<List<Character>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _charactersFuture = _fetchAllMyCharacters();
  }

  Future<List<Character>> _fetchAllMyCharacters() async {
    if (_userId == null) return [];
    try {
      // 1. 同時從兩個地方抓取原始資料 (這部分您原本寫得很棒！)
      final responses = await Future.wait([
        _db.collection('artifacts').doc(AppConfig.appId).collection('public_characters').where('createdBy', isEqualTo: _userId).get(),
        _db.collection('artifacts').doc(AppConfig.appId).collection('users').doc(_userId!).collection('private_characters').get(),
      ]);

      // 2. ✨ 關鍵：使用 Future.wait 讓所有「預約單」同時去換回「角色實體」
      // 這樣才能把 gs:// 網址在後台偷偷換成網頁版看得懂的 https://
      final publicChars = await Future.wait(
          responses[0].docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );

      final privateChars = await Future.wait(
          responses[1].docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );

      // 3. 合併已經變身完成的名單
      final List<Character> myCharacters = [...publicChars, ...privateChars];

      // 4. 排序 (這時候大家都是真正的 Character 了，可以放心比較時間)
      myCharacters.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return myCharacters;
    } catch (e) {
      print("讀取我創建的角色列表失敗: $e");
      return [];
    }
  }

  ImageProvider _getImageProvider(String path) {
    if (path.isEmpty) return const AssetImage('assets/images/blank_avatar.png');
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path);
  }

  void _refreshList() {
    setState(() {
      _charactersFuture = _fetchAllMyCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✨ 核心：抓取當前玩家設定的主題
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Container(
      // ✅ 背景：完全跟隨 themeNotifier 的設定（可能是玩家自選的漸層）
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent, // 讓漸層背景透上來
        appBar: AppBar(
          title: Text('我創建的角色', style: TextStyle(color: theme.colorScheme.onSurface)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // ✅ 返回按鈕顏色自動適配
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        ),
        body: FutureBuilder<List<Character>>(
          future: _charactersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: primaryColor));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('尚未創建角色', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5))),
              );
            }

            final characters = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  // ✅ 毛玻璃效果：根據主題亮度自動調整透明度
                  color: theme.cardColor.withOpacity(isDarkMode ? 0.7 : 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    // ✨ 增加一個細微的邊框，讓卡片在漸層上更精緻
                    side: BorderSide(color: primaryColor.withOpacity(0.1), width: 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // ✨ 頭像外圈的小光環，連動主題色
                        border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: _getImageProvider(character.avatarPath),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                            character.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface
                            )
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(character.isPublic, theme),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome, size: 14, color: primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            '遊玩次數: ${character.playCount}',
                            style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    trailing: Icon(Icons.edit_note, color: primaryColor),
                    onTap: () async {
                      final bool? didUpdate = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (context) => CharacterEditPage(character: character)),
                      );
                      if (didUpdate == true) _refreshList();
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ✨ 動態標籤：顏色會根據「公開/私人」與「主題亮度」微調
  Widget _buildStatusBadge(bool isPublic, ThemeData theme) {
    final color = isPublic ? Colors.teal : Colors.blueGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        isPublic ? '公開' : '私人',
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}