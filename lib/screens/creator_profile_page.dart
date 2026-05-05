import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🌟 記得加這個來判斷身分
import 'package:cached_network_image/cached_network_image.dart'; // 🌟 讀取雲端圖片用
import 'character_profile_page.dart';
import 'character_model.dart';
import 'creator_studio_page.dart'; // ✨ 總裁的秘密工作室檔案！
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


//公開頁面
class CreatorProfilePage extends StatelessWidget {
  final String creatorId;
  final String characterId;
  final String creatorName;
  final String APP_ID = AppConfig.appId;

  const CreatorProfilePage({
    super.key,
    required this.creatorId,
    required this.characterId,
    required this.creatorName
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final bool isOwner = currentUserId == creatorId;
    // ✨ 1. 最外層的 FutureBuilder：負責去資料庫查創作者的真實資料
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(creatorId)
          .get(),
      builder: (context, userSnapshot) {
        // 🌟 2. 準備好真實姓名與頭像資料
        String displayNickname = creatorName; // 從上一頁傳來的預設名字
        // ✨ 新增：準備好保底的 ID (UID 前 8 碼)
        String displayPlayerID = creatorId.length >= 8
            ? creatorId.substring(0, 8).toUpperCase()
            : creatorId.toUpperCase();
        String? photoUrl;
        String? avatarPath;
        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          // 先抓出兩個可能的名字
          String? nickname = userData['nickname'];
          String? displayName = userData['displayName'];
          // ✨ 修正 1：暱稱與本名的「空字串」防護網 + 備胎機制
          final fetchedNickname = (nickname ?? '').toString().trim();
          final fetchedDisplayName = (displayName ?? '').toString().trim();
          if (fetchedNickname.isNotEmpty) {
            // 第一志願：玩家自己設定的 nickname
            displayNickname = fetchedNickname;
          } else if (fetchedDisplayName.isNotEmpty) {
            // 第二志願：如果 nickname 是空的，就用第三方登入的 displayName
            displayNickname = fetchedDisplayName;
          }
          // ✨ 修正 2：終於把玩家設定好的「專屬 ID」抓出來啦！
          final fetchedPlayerID = (userData['playerID'] ?? '').toString().trim();
          if (fetchedPlayerID.isNotEmpty) {
            displayPlayerID = fetchedPlayerID;
          }
          photoUrl = userData['photoURL'] as String?;
          avatarPath = userData['avatarPath'] as String?;
        }
        ImageProvider? imageProvider;
        String? finalPath = avatarPath ?? photoUrl; // 優先順序

        if (finalPath != null && finalPath.isNotEmpty) {
          if (finalPath.startsWith('http')) {
            // ✨ 這裡是重點：如果是網路網址，用 NetworkImage
            imageProvider = NetworkImage(finalPath);
          } else {
            // ✨ 如果是預設圖路徑（assets/...），用 AssetImage
            imageProvider = AssetImage(finalPath);
          }
        }

        // 🌟 3. 開始畫出整個頁面！
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(l10n.portfolio_title(displayNickname)), // 這裡會顯示正確的名字了
            elevation: 0,
          ),
          body: Column(
            children: [
              // --- 上半部：創作者頭部資訊 ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? Icon(Icons.person, size: 45, color: Colors.grey[400])
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      displayNickname, // 顯示精準的暱稱
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),

                    // ✨ 修正 3：這裡要把硬寫死的程式碼，換成我們剛剛抓出來的變數！
                    Text(
                      'ID: $displayPlayerID', // 👈 換成這行！
                      style: const TextStyle(color: Colors.grey, letterSpacing: 1.2, fontSize: 12),
                    ),
                    // 🌟 工作室入口
                    if (isOwner) ...[
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          foregroundColor: theme.colorScheme.onPrimaryContainer,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                        ),
                        icon: const Icon(Icons.brush, size: 20),
                        label:Text(
                            l10n.enter_secret_studio, style: TextStyle(
                            fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const CreatorStudioPage()));
                        },
                      ),
                    ]
                  ],
                ),
              ),

              const Divider(indent: 32, endIndent: 32),

              // --- 下半部：創作者的作品列表 ---
              Expanded(
                child: StreamBuilder<List<Character>>( // ✨ 1. 這裡改成接收 List<Character>
                  // ✨ 2. 關鍵：使用 asyncMap 在資料流傳過來時，直接進行非同步轉換
                  stream: FirebaseFirestore.instance
                      .collection('artifacts')
                      .doc(AppConfig.appId)
                      .collection('public_characters')
                      .where('createdBy', isEqualTo: creatorId)
                      .snapshots()
                      .asyncMap((snapshot) async {
                    // 在這裡把一整條 stream 的 docs 通通轉成換好網址的 Character
                    return await Future.wait(
                        snapshot.docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
                    );
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // ✨ 3. 現在這裡直接拿到的就是 List<Character> 了！
                    final List<Character> characters = snapshot.data ?? [];

                    if (characters.isEmpty) {
                      return Center(
                          child: Text(
                              isOwner
                                  ? l10n.no_public_character_mine
                                  : l10n.no_public_character_other,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey)
                          )
                      );
                    }

                    return MasonryGridView.count(
                      padding: const EdgeInsets.all(16),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        // ✨ 4. 這裡直接拿出來就是 Character 物件，不用再 await
                        final characterObj = characters[index];
                        // 在 builder 裡面加這行
                        print("🖼️ 除錯：第 $index 個角色的頭像網址是: ${characterObj.avatarPath}");
                        final double cardHeight = index.isEven ? 240 : 300;
                        final String safeAvatar = characterObj.avatarPath ?? '';

                        ImageProvider cardImage;
                        if (safeAvatar.startsWith('http')) {
                          cardImage = CachedNetworkImageProvider(safeAvatar); // ✅ 正常的網路專屬圖片
                        } else if (safeAvatar.startsWith('gs://')) {
                          cardImage = const AssetImage('assets/images/default.png'); // 🛡️ 防呆：gs:// 變身失敗，給預設圖
                        } else if (safeAvatar.isNotEmpty) {
                          cardImage = AssetImage(safeAvatar); // ✅ 本地圖片
                        } else {
                          cardImage = const AssetImage('assets/images/default.png'); // 🛡️ 防呆：完全沒網址，給預設圖
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => CharacterProfilePage(
                                  character: characterObj,
                                  characterId: characterObj.id,)
                            ));
                          },
                          child: Container(
                            height: cardHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5))
                              ],
                              image: DecorationImage(
                                image: (characterObj.avatarPath.startsWith('http')) // 只要檢查 http 即可
                                    ? CachedNetworkImageProvider(characterObj.avatarPath) as ImageProvider
                                    : characterObj.avatarPath.startsWith('gs://')
                                    ? const AssetImage('assets/images/default.png') as ImageProvider // 🛡️ 防呆：如果是 gs 代表變身失敗，先給預設圖
                                    : AssetImage(characterObj.avatarPath.isNotEmpty
                                    ? characterObj.avatarPath
                                    : 'assets/images/default.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.1),
                                        Colors.black.withOpacity(0.8)
                                      ],
                                      stops: const [0.0, 0.6, 1.0],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          characterObj.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)
                                      ),
                                      const SizedBox(height: 4),
                                      // ✨ 6. 直接從物件拿資料，不用再手動解析 data['...']
                                      Text(
                                        '${characterObj.age ?? '??'}歲 | ${characterObj.occupation ?? '探索者'}',
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                            Icons.favorite, color: Colors.white,
                                            size: 14),
                                        const SizedBox(width: 4),
                                        Text('${characterObj.likesCount ?? 0}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
