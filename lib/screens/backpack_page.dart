//背包頁面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/toast_utils.dart';
import 'character_model.dart'; // 請確保引入您的角色模型
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class BackpackPage extends StatelessWidget {
  final Character character;
  final Function(Map<String, dynamic> eggData) onUseEgg;

  const BackpackPage({
    super.key,
    required this.character,
    required this.onUseEgg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;
    if (user == null) return Scaffold(body: Center(child: Text(l10n.please_login_first)));

    // 指向這個角色的專屬背包
    final backpackRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(character.id)
        .collection('backpack')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.char_exclusive_memory(character.name)),
        backgroundColor: theme.appBarTheme.backgroundColor?.withValues(alpha:0.8) ?? theme.colorScheme.surface,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: backpackRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final eggs = snapshot.data!.docs;

          // ✨ 空背包的精美提示畫面
          if (eggs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_mosaic_outlined, size: 80, color: theme.colorScheme.primary.withValues(alpha:0.3)),
                  const SizedBox(height: 16),
                  Text(l10n.empty_treasure_box,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.5), height: 1.5, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: eggs.length,
            itemBuilder: (context, index) {
              final eggDoc = eggs[index];
              final eggData = eggDoc.data() as Map<String, dynamic>;
              // ✨ 將卡片設計成精緻的「記憶碎片」
              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha:0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha:0.2), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              eggData['title'] ?? l10n.unknown_story,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        eggData['teaser'] ?? '',
                        style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.8), height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            foregroundColor: theme.colorScheme.onPrimaryContainer,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.lock_open, size: 20), // 解鎖的 Icon
                          label:Text(l10n.open_this_memory, style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            // 1. 彈窗再次確認
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: Row(
                                  children: [
                                    Icon(Icons.key, color: Colors.amber),
                                    SizedBox(width: 8),
                                    Text(l10n.open_exclusive_story
                                    ),
                                  ],
                                ),
                                content: Text(l10n.confirm_use_egg(eggData['title'])),                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child:  Text(l10n.wait_a_bit, style: TextStyle(color: Colors.grey)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // 🚀 核心防禦：安全非同步執行順序
                                      Navigator.pop(ctx); // 1. 先關閉確認對話框

                                      // 2. 顯示魔法發動的提示
                                      // ✨ 總裁級：充滿儀式感的隱藏故事轉場提示！
                                      ToastUtils.showCenterToast(
                                        context,
                                        '✨ ${l10n.guiding_into_story(eggData['title'])}',
                                        customIcon: Icons.auto_awesome, // 放一個閃閃發光的魔法小圖示，完美呼應彩蛋氛圍！
                                      );

                                      // 3. 觸發聊天室的回呼函式，送出劇本指令
                                      onUseEgg(eggData);

                                      // 4. 從資料庫銷毀這個彩蛋 (消耗品)
                                      await eggDoc.reference.delete();

                                      // 5. 確認畫面還在，再安全地關閉背包退回聊天室
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child:Text(l10n.use_now),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
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
}