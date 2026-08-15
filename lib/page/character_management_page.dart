//封鎖頁面
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/character_block_service.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CharacterManagementPage extends StatelessWidget {
  const CharacterManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (uid == null)
      return const Scaffold(body: Center(child: Text("請先登入系統")));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cloud_character_mgmt),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('blockedCharacters')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text(l10n.connection_error));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          // ✨ 完美細節：處理空狀態
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 60,
                      color: colorScheme.outline),
                  const SizedBox(height: 16),
                   Text(l10n.no_characters_met),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final charData = docs[index].data() as Map<String, dynamic>;
              final String charId = docs[index].id;
              final String avatarPath =
                  charData['avatarPath']?.toString().trim() ?? '';
              const bool isBlocked = true;

              return Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                      color: colorScheme.outlineVariant.withOpacity(0.5)),
                ),
                child: ListTile(
                  leading: Hero(
                    tag: 'avatar_$charId', // 加上 Hero 動畫標籤
                    child: CircleAvatar(
                      backgroundColor: isBlocked
                          ? colorScheme.surfaceVariant
                          : colorScheme.primaryContainer,
                      backgroundImage: avatarPath.isNotEmpty
                          ? CachedNetworkImageProvider(avatarPath)
                          : null,
                      child: avatarPath.isEmpty
                          ? Text(
                        (charData['name']?.toString().isNotEmpty ?? false)
                            ? charData['name'].toString()[0]
                            : '?',
                        style: TextStyle(
                          color: colorScheme.primary,
                        ),
                      )
                          : null,
                    ),
                  ),
                  title: Text(charData['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    isBlocked ? l10n.status_paused : l10n.status_in_progress,
                    style: TextStyle(
                        color: isBlocked ? colorScheme.error : colorScheme
                            .primary),
                  ),
                  trailing: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () => _confirmUnblock(
                      context,
                      uid,
                      charId,
                      charData['name'] ?? '角色',
                    ),
                    child: Text(l10n.unblock),
                  ),
                  onTap: () => _showCharDetail(context, charData),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ✨ 邏輯優化：封鎖前的確認對話框
  Future<void> _confirmUnblock(
      BuildContext context,
      String uid,
      String charId,
      String charName,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.unblock),
        content: Text('確定要解除封鎖「$charName」嗎？解除後，相關內容可能會再次顯示。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.unblock),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await CharacterBlockService.unblockCharacter(
        context: context,
        characterId: charId,
      );
    }
  }

  // ✨ 邏輯 B：顯示詳情 (優化行高版)
  void _showCharDetail(BuildContext context, Map<String, dynamic> data) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        final theme = Theme.of(context);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. 頂部小橫條 (增加細節感)
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)
                ),
              ),
              // 2. 名字
              Text(
                  data['name'],
                  style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 16),
              // 3. 介紹文字 (就在這裡加上 height: 1.6 !)
              Text(
                data['desc'] ?? l10n.no_char_info,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6, // ✨ 這就是讓文字呼吸的魔法數字
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}