import 'package:flutter/material.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
// ⚠️ 記得 import 妳的 Character 模型檔案

class PrivateCharacterProfilePage extends StatelessWidget {
  final Character character;

  const PrivateCharacterProfilePage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 🌟 1. 取得多國語系字典
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, shadows: [Shadow(blurRadius: 10, color: Colors.black54)]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 450,
              child: Image.network(
                character.avatarPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[800], child: const Icon(Icons.person, color: Colors.white, size: 100)),
              ),
            ),

            Container(
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        character.name,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.5)),
                        ),
                        // 🚀 替換創作者專屬
                        child: Text(l10n.creatorExclusive, style: const TextStyle(color: Colors.pinkAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 🚀 替換年齡與職業 (用 .toString() 確保型別安全)
                  Text(
                    l10n.ageAndOccupation(character.age.toString(), character.occupation),
                    style: TextStyle(fontSize: 16, color: Colors.blueAccent.shade200, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      // 🚀 替換喜歡/不喜歡，並把 l10n 傳進去
                      Expanded(child: _buildInfoCard(l10n.likesLabel, character.likes, Colors.pinkAccent, l10n)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoCard(l10n.dislikesLabel, character.dislikes, Colors.blueGrey, l10n)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 🚀 替換生日與身高
                      Text(l10n.birthdayLabel(character.birthday), style: const TextStyle(color: Colors.grey)),
                      Text(l10n.heightLabel(character.height.toString()), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Divider(height: 40),

                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: character.personalityTags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(tag, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // 🚀 替換背景故事
                  Text(l10n.backgroundStoryLabel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    character.background,
                    style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🌟 接收 l10n 以便翻譯裡面的「無」
  Widget _buildInfoCard(String title, String content, Color color, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          // 🚀 替換空值顯示的「無」
          Text(content.isEmpty ? l10n.noneLabel : content, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}