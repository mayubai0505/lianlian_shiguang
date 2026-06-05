import 'package:flutter/material.dart';
import 'character_model.dart';
// ⚠️ 記得 import 妳的 Character 模型檔案
// import 'models/character.dart';

class PrivateCharacterProfilePage extends StatelessWidget {
  final Character character; // 接收傳進來的角色資料

  const PrivateCharacterProfilePage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // 🌟 讓圖片可以延伸到最頂端 (沉浸式體驗)
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
            // 🖼️ 頂部：滿版帥氣大圖
            SizedBox(
              width: double.infinity,
              height: 450,
              child: Image.network(
                character.avatarPath, // 顯示大頭貼或相簿第一張
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[800], child: const Icon(Icons.person, color: Colors.white, size: 100)),
              ),
            ),

            // 📝 下半部：專屬私密檔案
            Container(
              transform: Matrix4.translationValues(0.0, -20.0, 0.0), // 稍微往上移，蓋住圖片底部邊緣
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 標題與「專屬私人」標籤
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
                        child: const Text('🔒 創作者專屬', style: TextStyle(color: Colors.pinkAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 年齡與職業
                  Text(
                    '${character.age}歲 | ${character.occupation}',
                    style: TextStyle(fontSize: 16, color: Colors.blueAccent.shade200, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // 喜歡與不喜歡
                  Row(
                    children: [
                      Expanded(child: _buildInfoCard('💖 喜歡', character.likes, Colors.pinkAccent)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoCard('👎 不喜歡', character.dislikes, Colors.blueGrey)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 生日與身高
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('生日: ${character.birthday}', style: const TextStyle(color: Colors.grey)),
                      Text('身高: ${character.height} cm', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Divider(height: 40),

                  // 🏷️ 個性標籤 (完美還原圖二的 Tag)
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

                  // 📖 背景故事
                  const Text('背景故事', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    character.background,
                    style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.grey),
                  ),
                  const SizedBox(height: 40), // 底部留白
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 輔助畫出喜歡/不喜歡的小卡片
  Widget _buildInfoCard(String title, String content, Color color) {
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
          Text(content.isEmpty ? '無' : content, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}