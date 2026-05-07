import 'package:flutter/material.dart';
import '../services/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🌟 解決 QuerySnapshot 和 FirebaseFirestore
import '../services/app_constants.dart';             // 🌟 解決 AppConfig (請根據妳的檔案路徑調整)
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
      ),
      // 🌟 1. body 裡面只放一個 StreamBuilder
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
          // 2. 檢查連線狀態
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 3. 準備 cgList
          List<CharacterPhoto> cgList;
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            cgList = [
              CharacterPhoto(
                imageUrl: character.avatarPath,
                requiredAffection: 0,
                description: l10n.first_encounter, // ✨ 完美換上翻譯
              )
            ];
          } else {
            cgList = snapshot.data!.docs.map((doc) {
              return CharacterPhoto.fromFirestore(doc);
            }).toList();
          }

          // ✨ 🌟 4. 重點：GridView 必須在 builder 的 return 裡面！
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
                      // --- 底層圖片 ---
                      Container(
                        color: Colors.grey[300],
                        child: cg.imageUrl.startsWith('http')
                            ? Image.network(
                          cg.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                        )
                            : Image.asset(
                          cg.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // --- 未解鎖遮罩 ---
                      if (!isUnlocked)
                        Container(
                          color: Colors.black.withValues(alpha:0.6),
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

                      // --- 圖片標題 ---
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withValues(alpha:0.8), Colors.transparent],
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.change_chat_bg),
        content: Text(l10n.confirm_change_chat_bg(cg.description, character.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false)
                  .setCharacterBackground(character.name, cg.imageUrl);

              Navigator.pop(context);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // ✨ 修復了這裡的語法錯誤：使用字串拼貼
                  content: Text('${l10n.bg_changed_to} ✨'),
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