import 'package:flutter/material.dart';
import '../services/theme_notifier.dart';
import 'package:provider/provider.dart';
import '../services/toast_utils.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🌟 解決 QuerySnapshot 和 FirebaseFirestore
import 'dart:ui'; // ✨ 記得加這行！
import 'package:firebase_auth/firebase_auth.dart';
// 專屬相簿背景

class BackgroundSettingsPage extends StatelessWidget {
  final Character character;
  final String characterId;

  // ✨ 1. 大幅瘦身建構子：我們正式跟 currentFriendship 說再見，讓它自己去全局抓取！
  const BackgroundSettingsPage({
    super.key,
    required this.character,
    required this.characterId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.char_exclusive_memory(character.name)),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.layers_clear, color: Colors.redAccent, size: 20),
            label: Text(
                l10n.reset_to_default,
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title:  Text(l10n.reset_bg_title),
                  content: Text(l10n.reset_bg_content),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(l10n.cancelButton, style: const TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      onPressed: () {
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .resetCharacterBackground(character.name);
                        Navigator.pop(dialogContext);
                        // ✨ 總裁級：背景重置成功的優雅回饋，告別沉悶的灰色大方塊！
                        ToastUtils.showCenterToast(
                          context, // 💡 如果是在 async 方法裡，記得外層要加 if (context.mounted)
                          l10n.reset_bg_success,
                          customIcon: Icons.wallpaper_rounded, // 💡 用「桌布/畫布」的圖示，直覺表達背景已更新
                          // 如果你更喜歡「刷新」的感覺，也可以用 Icons.refresh_rounded
                        );
                      },
                      child:  Text(l10n.confirm_reset, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      // 🌟 核心戰術【雷達一號：全局最高好感度偵測器】
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('characters')
            .doc(characterId)
            .snapshots(),
        builder: (context, charSnapshot) {

          int maxGlobalAffection = 0;

          // 🎯 只要保險箱存在，立刻取出尊貴的 'affection' 欄位！
          if (charSnapshot.hasData && charSnapshot.data!.exists) {
            final charData = charSnapshot.data!.data() as Map<String, dynamic>;
            maxGlobalAffection = (charData['affection'] as num?)?.toInt() ?? 0;
            debugPrint("💡 [終極雷達] 成功直通全域保險箱！當前最高好感度為：$maxGlobalAffection");
          } else {
            debugPrint("⚠️ [終極雷達] 保險箱目前空空如也，好感度暫定為 0 (玩家可能還沒跟該角色同步過資料)");
          }

          // 🌟 雷達二號：相簿照片讀取器 (完全保留不用動)
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('artifacts')
                .doc(const String.fromEnvironment('APP_ID', defaultValue: 'lianlianshiguang'))
                .collection('public_characters')
                .doc(characterId)
                .collection('photos')
                .orderBy('requiredAffection')
                .snapshots(),
            builder: (context, photoSnapshot) {
              if (photoSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              List<CharacterPhoto> cgList;
              if (photoSnapshot.hasData && photoSnapshot.data!.docs.isNotEmpty) {
                cgList = photoSnapshot.data!.docs.map((doc) => CharacterPhoto.fromFirestore(doc)).toList();
              } else if (character.gallery != null && character.gallery!.isNotEmpty) {
                cgList = character.gallery!;
              } else {
                cgList = [
                  CharacterPhoto(
                    imageUrl: character.avatarPath,
                    requiredAffection: 0,
                    description: l10n.first_encounter,
                  )
                ];
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: cgList.length,
                itemBuilder: (context, index) {
                  final cg = cgList[index];

                  // 🌟 全面比對保險箱拿出來的「真．全域歷史最高紀錄」
                  final isUnlocked = maxGlobalAffection >= cg.requiredAffection;

                  return GestureDetector(
                    onTap: () {
                      if (isUnlocked) {
                        _showConfirmDialog(context, cg);
                      } else {
                        // ✨ 總裁級：溫柔的 CG 解鎖門檻提示，保留遊戲的浪漫氛圍
                        ToastUtils.showCenterToast(
                          context, // 💡 若在 async 中記得檢查 context.mounted
                          l10n.affection_required_to_unlock(cg.requiredAffection),
                          customIcon: Icons.lock_person_rounded, // 💡 總裁精選圖示 1：「心上人被鎖住」的感覺
                          // 或是使用 Icons.favorite_border_rounded (空心愛心，暗示好感度未滿)
                        );
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            color: Colors.grey[300],
                            child: Builder(builder: (context) {
                              Widget imageWidget = cg.imageUrl.startsWith('http')
                                  ? Image.network(
                                cg.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                              )
                                  : Image.asset(cg.imageUrl, fit: BoxFit.cover);

                              return isUnlocked
                                  ? imageWidget
                                  : ImageFiltered(
                                imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: imageWidget,
                              );
                            }),
                          ),
                          if (!isUnlocked)
                            Container(
                              color: Colors.black.withValues(alpha: 0.4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lock_outline, color: Colors.white, size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.unlock_affection_requirement(cg.requiredAffection),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          Positioned(
                            bottom: 0, left: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                                ),
                              ),
                              child: Text(
                                cg.description,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                textAlign: TextAlign.center,
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
          );
        },
      ),
    );
  }

  void _showConfirmDialog(BuildContext pageContext, CharacterPhoto cg) {
    final l10n = AppLocalizations.of(pageContext)!;

    showDialog(
      context: pageContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.change_chat_bg),
        content: Text(l10n.confirm_change_chat_bg(cg.description, character.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancelButton,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ThemeNotifier>(pageContext, listen: false)
                  .setCharacterBackground(character.name, cg.imageUrl);

              // 只用 dialogContext 關掉彈窗
              Navigator.pop(dialogContext);

              // 用 pageContext 離開背景設定頁，回到聊天室
              if (pageContext.mounted) {
                Navigator.pop(pageContext);
              }
            },
            child: Text(l10n.confirm_change),
          ),
        ],
      ),
    );
  }
}