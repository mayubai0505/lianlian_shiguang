//翻譯介面

import 'package:cloud_firestore/cloud_firestore.dart';

class LoreTranslateService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🌟 功能 1：呼叫 AI 執行翻譯
  Future<Map<String, String>> translateLore({
    required String targetLang,
    required String title,
    required String content,
  }) async {
    try {
      print("🌐 [AI 翻譯] 正在將碎片翻譯為 $targetLang...");

      // 🚀 總裁指令：這裡未來要換成妳的 http.post (Grok/OpenAI API)
      // 這裡示範傳給 AI 的系統指令
      final String systemPrompt = """
        你是一位充滿感性的遊戲在地化翻譯官。
        請將這段名為「記憶碎片」的內容翻譯成 $targetLang。
        要求：
        1. 語氣要像原創一樣自然，保持角色的性格情感。
        2. 標題要簡潔，內容要感人，不要有機器人感。
      """;

      // 模擬 API 呼叫的延遲
      await Future.delayed(const Duration(seconds: 2));

      // 假設這是 AI 翻譯後回傳的結果
      return {
        'title': "【譯】$title",
        'content': "（這是 AI 翻譯後的感性內容）\n\n$content",
      };
    } catch (e) {
      print("🔴 [AI 翻譯] 失敗: $e");
      throw Exception("翻譯失敗: $e");
    }
  }

  // 🌟 功能 2：將翻譯結果存回雲端 (緩存機制)
  Future<void> saveTranslationToFirebase({
    required String appId,         // UI 傳入的 _appId
    required String characterId,   // UI 傳入的 widget.character.id
    required String loreId,        // 該則碎片的 doc.id
    required String lang,          // 玩家的語言代碼 (如 'zh')
    required Map<String, String> result, // 翻譯後的標題與內容
  }) async {
    try {
      await _db
          .collection('artifacts')
          .doc(appId)
          .collection('public_characters')
          .doc(characterId)
          .collection('lores')
          .doc(loreId)
          .update({
        // 使用動態 Key 值存入 translations 欄位下
        'translations.$lang': result
      });
      print("✅ [雲端緩存] 碎片 $loreId 的 $lang 翻譯版本已儲存！");
    } catch (e) {
      print("🔴 [雲端緩存] 存檔失敗: $e");
    }
  }
}
