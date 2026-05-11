import 'package:flutter/material.dart';
import '../services/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🌟 解決 QuerySnapshot 和 FirebaseFirestore
import '../services/app_constants.dart';             // 🌟 解決 AppConfig (請根據妳的檔案路徑調整)
import 'dart:ui'; // ✨ 記得加這行！
// 專屬相簿背景

class BackgroundSettingsPage extends StatelessWidget {
  final Character character;
  final int currentFriendship;
  final String characterId;

  // ✨ 1. 最乾淨的建構子，把舊的 cgList 宣告全部拔掉！
  const BackgroundSettingsPage({
    super.key,
    required this.character,
    required this.characterId,
    required this.currentFriendship,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.char_exclusive_memory(character.name)),
        // 👇 🌟 總裁，重置按鈕加在這裡！放在標題的右邊
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.layers_clear, color: Colors.redAccent, size: 20),
            label: Text(
                l10n.reset_to_default,
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)
            ),
            onPressed: () {
              // 彈出確認視窗
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
                        // 1. 呼叫我們寫好的重置魔法！
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .resetCharacterBackground(character.name);

                        // 2. 關掉確認對話框
                        Navigator.pop(dialogContext);

                        // 3. 彈出成功提示
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            content: Text(l10n.reset_bg_success),
                            backgroundColor: Colors.grey,
                          ),
                        );
                      },
                      child:  Text(l10n.confirm_reset, style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('public_characters')
            .doc(characterId)
            .collection('photos')
            .orderBy('requiredAffection')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<CharacterPhoto> cgList;
          // ✨✨✨ 修正後的智慧讀取邏輯 ✨✨✨
          // 1. 如果子集合有資料，用子集合的
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            cgList = snapshot.data!.docs.map((doc) => CharacterPhoto.fromFirestore(doc)).toList();
          }
          // 2. 如果子集合沒資料，但 character 裡面有原本存的 gallery，用原本的
          else if (character.gallery != null && character.gallery!.isNotEmpty) {
            cgList = character.gallery!;
          }
          // 3. 真的都沒資料，才用大頭貼保底
          else {
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
              final isUnlocked = currentFriendship >= cg.requiredAffection;

              return GestureDetector(
                onTap: () {
                  if (isUnlocked) {
                    _showConfirmDialog(context, cg);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.affection_required_to_unlock(cg.requiredAffection)),
                        backgroundColor: Colors.pinkAccent,
                      ),
                    );
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // --- 1. 底層圖片 (加入毛玻璃) ---
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

                      // --- 2. 未解鎖遮罩 (0.4 透明度) ---
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

                      // --- 3. 圖片標題 (漸層) ---
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
      ),
    );
  }

  // ✨ 彈出確認更換背景的視窗
  void _showConfirmDialog(BuildContext context, CharacterPhoto cg) {
    final l10n = AppLocalizations.of(context)!;

    // 🚩 總裁攻略：先捕捉 Messenger，避免 pop 之後 context 找不到家
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.change_chat_bg),
        // 這裡妳原本就寫對了，繼續延用
        content: Text(l10n.confirm_change_chat_bg(cg.description, character.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // 1. 執行背景更換邏輯
              Provider.of<ThemeNotifier>(context, listen: false)
                  .setCharacterBackground(character.name, cg.imageUrl);

              // 2. 關閉對話框
              Navigator.pop(context);
              // 3. 關閉相簿頁面 (回到聊天室)
              Navigator.pop(context);

              // 4. 顯示成功 SnackBar
              // 🚩 這裡改用妳現有的 gallery_unlocked_msg，並把照片描述傳進去
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(l10n.gallery_unlocked_msg(cg.description)),
                  backgroundColor: Colors.purple,
                ),
              );
            },
            child: Text(l10n.confirm_change),
          ),
        ],
      ),
    );
  }
}