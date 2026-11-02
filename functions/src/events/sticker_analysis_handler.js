'use strict';
// 原樣保留活動貼紙視覺分析；Firebase 部署設定仍由 core.js 管理。
function createStickerAnalysisHandler({requireRewardCampaignAdmin, downloadMediaAsBase64, HttpsError, geminiApiKey}) {
  return async (request) => {
    requireRewardCampaignAdmin(request);

    const imageUrl = String(request.data?.imageUrl || "").trim();

    if (!imageUrl) {
      throw new HttpsError("invalid-argument", "請先提供貼紙圖片");
    }

    const media = await downloadMediaAsBase64(imageUrl);

    if (!media) {
      throw new HttpsError("failed-precondition", "讀取貼紙圖片失敗");
    }

    try {
      const response = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=${geminiApiKey.value()}`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            contents: [
              {
                role: "user",
                parts: [
                  {
                    text: [
                      "你正在替戀愛聊天 App 建立貼紙的『視覺 metadata』。",
                      "請只根據圖片看得到的內容分析，不要替玩家推斷聊天當下真正意圖。",
                      "例如畫面看起來害羞，可以描述臉紅、遮臉、躲避視線；",
                      "但不要寫成『玩家在撒嬌』『玩家想求和』『玩家在挑釁』。",
                      "真正語意會在聊天當下結合上下文另外判斷。",
                      "",
                      "請使用台灣繁體中文，輸出 JSON，欄位固定如下：",
                      "stickerName: 2~8 字的貼紙名稱",
                      "visualTags: 3~6 個簡短視覺標籤陣列",
                      "baseEmotion: 1~3 個畫面直接呈現的基礎情緒，用頓號分隔",
                      "visualDescription: 1~2 句，只描述人物表情、動作、姿勢、可見符號與整體視覺氛圍",
                      "",
                      "如果圖片資訊有限，就保守描述，不要補不存在的細節。",
                    ].join("\n"),
                  },
                  {
                    inline_data: {
                      mime_type: media.mimeType,
                      data: media.base64,
                    },
                  },
                ],
              },
            ],
            generationConfig: {
              temperature: 0.2,
              responseMimeType: "application/json",
            },
          }),
        }
      );

      if (!response.ok) {
        const errorText = await response.text();
        console.error(
          "❌ 活動貼紙 AI 分析失敗:",
          response.status,
          errorText
        );
        throw new HttpsError("internal", "貼紙 AI 分析失敗，請稍後再試");
      }

      const data = await response.json();
      const rawText = (
        data?.candidates?.[0]?.content?.parts
          ?.map((part) => part.text || "")
          .join("")
          .trim() || ""
      );

      if (!rawText) {
        throw new HttpsError("internal", "AI 沒有回傳貼紙分析結果");
      }

      let parsed;
      try {
        parsed = JSON.parse(rawText);
      } catch (_) {
        const cleaned = rawText
          .replace(/^```json\s*/i, "")
          .replace(/^```\s*/i, "")
          .replace(/\s*```$/i, "")
          .trim();
        parsed = JSON.parse(cleaned);
      }

      const stickerName = String(parsed?.stickerName || "貼紙").trim();
      const visualTags = Array.isArray(parsed?.visualTags)
        ? parsed.visualTags
            .map((value) => String(value || "").trim())
            .filter(Boolean)
            .slice(0, 6)
        : [];
      const baseEmotion = String(parsed?.baseEmotion || "").trim();
      const visualDescription = String(
        parsed?.visualDescription || ""
      ).trim();

      if (!visualDescription) {
        throw new HttpsError("internal", "AI 無法可靠描述這張貼紙");
      }

      return {
        success: true,
        analysis: {
          stickerName: stickerName.slice(0, 30),
          visualTags,
          baseEmotion: baseEmotion.slice(0, 80),
          visualDescription: visualDescription.slice(0, 500),
          analysisSource: "gemini_vision",
        },
      };
    } catch (error) {
      if (error instanceof HttpsError) throw error;

      console.error("❌ analyzeEventStickerImage 發生錯誤:", error);
      throw new HttpsError("internal", "貼紙 AI 分析失敗，請稍後再試");
    }
  };
}
module.exports = {createStickerAnalysisHandler};
