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
        String creatorBio = '';
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
          creatorBio =
              (userData['bio'] ?? '')
                  .toString()
                  .trim();
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
        return StreamBuilder<List<Character>>(
          stream: FirebaseFirestore.instance
              .collection('artifacts')
              .doc(AppConfig.appId)
              .collection('public_characters')
              .where(
            'createdBy',
            isEqualTo: creatorId,
          )
              .snapshots()
              .asyncMap((snapshot) async {
            return Future.wait(
              snapshot.docs
                  .map(
                    (doc) =>
                    Character.fromFirestoreAsync(doc),
              )
                  .toList(),
            );
          }),
          builder: (context, characterSnapshot) {
            final List<Character> characters =
                characterSnapshot.data ?? [];

            final int totalLikes = characters.fold<int>(
              0,
                  (sum, character) =>
              sum + character.likesCount,
            );

            return Scaffold(
              backgroundColor:
              theme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  l10n.portfolio_title(
                    displayNickname,
                  ),
                ),
                elevation: 0,
              ),
              body: Column(
                children: [
                  _buildCreatorHeader(
                    context,
                    theme,
                    displayNickname:
                    displayNickname,
                    displayPlayerID:
                    displayPlayerID,
                    creatorBio:
                    creatorBio,
                    imageProvider:
                    imageProvider,
                    isOwner:
                    isOwner,
                    workCount:
                    characters.length,
                    totalLikes:
                    totalLikes,
                  ),

                  const Divider(
                    indent: 32,
                    endIndent: 32,
                  ),

                  Expanded(
                    child: _buildCreatorWorks(
                      context,
                      theme,
                      l10n,
                      characters,
                      isOwner,
                      characterSnapshot,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildCreatorHeader(
      BuildContext context,
      ThemeData theme, {
        required String displayNickname,
        required String displayPlayerID,
        required String creatorBio,
        required ImageProvider? imageProvider,
        required bool isOwner,
        required int workCount,
        required int totalLikes,
      }) {
    final l10n =
    AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: 24,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor:
            Colors.grey.shade200,
            backgroundImage:
            imageProvider,
            child: imageProvider == null
                ? Icon(
              Icons.person,
              size: 46,
              color:
              Colors.grey.shade400,
            )
                : null,
          ),

          const SizedBox(height: 14),

          Text(
            displayNickname,
            textAlign: TextAlign.center,
            style: theme
                .textTheme
                .headlineSmall
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'ID: $displayPlayerID',
            style: TextStyle(
              color: theme
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.48),
              letterSpacing: 1.2,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              _buildCreatorStat(
                theme,
                value: '$workCount',
                label: '公開作品',
              ),

              Container(
                width: 1,
                height: 32,
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                color: theme
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.12),
              ),

              _buildCreatorStat(
                theme,
                value: '$totalLikes',
                label: '獲得喜歡',
              ),
            ],
          ),

          if (creatorBio.isNotEmpty) ...[
            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.72),
                borderRadius:
                BorderRadius.circular(18),
                border: Border.all(
                  color: theme
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.12),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration:
                        BoxDecoration(
                          color: theme
                              .colorScheme
                              .primary,
                          borderRadius:
                          BorderRadius.circular(
                            99,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '關於我',
                        style: TextStyle(
                          color: theme
                              .colorScheme
                              .primary,
                          fontSize: 15,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    creatorBio,
                    style: TextStyle(
                      color: theme
                          .colorScheme
                          .onSurface
                          .withValues(
                        alpha: 0.78,
                      ),
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (isOwner) ...[
            const SizedBox(height: 22),

            ElevatedButton.icon(
              style:
              ElevatedButton.styleFrom(
                backgroundColor: theme
                    .colorScheme
                    .primaryContainer,
                foregroundColor: theme
                    .colorScheme
                    .onPrimaryContainer,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(
                Icons.brush,
                size: 20,
              ),
              label: Text(
                l10n.enter_secret_studio,
                style: const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const CreatorStudioPage(),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildCreatorStat(
      ThemeData theme, {
        required String value,
        required String label,
      }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color:
            theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: theme
                .colorScheme
                .onSurface
                .withValues(alpha: 0.52),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  Widget _buildCreatorWorks(
      BuildContext context,
      ThemeData theme,
      AppLocalizations l10n,
      List<Character> characters,
      bool isOwner,
      AsyncSnapshot<List<Character>>
      characterSnapshot,
      ) {
    if (characterSnapshot.connectionState ==
        ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (characterSnapshot.hasError) {
      return Center(
        child: Text(
          '讀取作品失敗：'
              '${characterSnapshot.error}',
        ),
      );
    }

    if (characters.isEmpty) {
      return Center(
        child: Text(
          isOwner
              ? l10n.no_public_character_mine
              : l10n.no_public_character_other,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final characterObj =
        characters[index];

        final double cardHeight =
        index.isEven ? 240 : 300;

        final String safeAvatar =
        characterObj.avatarPath.trim();

        final ImageProvider cardImage;

        if (safeAvatar.startsWith('http')) {
          cardImage =
              CachedNetworkImageProvider(
                safeAvatar,
              );
        } else if (safeAvatar
            .startsWith('assets/')) {
          cardImage =
              AssetImage(safeAvatar);
        } else {
          cardImage = const AssetImage(
            'assets/images/default.png',
          );
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CharacterProfilePage(
                      character: characterObj,
                      characterId:
                      characterObj.id,
                    ),
              ),
            );
          },
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                image: cardImage,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(24),
                    gradient:
                    LinearGradient(
                      begin:
                      Alignment.topCenter,
                      end:
                      Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black
                            .withValues(
                          alpha: 0.1,
                        ),
                        Colors.black
                            .withValues(
                          alpha: 0.8,
                        ),
                      ],
                      stops: const [
                        0,
                        0.6,
                        1,
                      ],
                    ),
                  ),
                  padding:
                  const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.end,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        characterObj.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${characterObj.age}歲 | '
                            '${characterObj.occupation}',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          color:
                          Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withValues(
                        alpha: 0.4,
                      ),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${characterObj.likesCount}',
                          style:
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
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
  }
}
