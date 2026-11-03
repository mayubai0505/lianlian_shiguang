'use strict';

// V78: keep original media download and Gemini image/audio helper bodies unchanged.
// Dependencies are supplied by core.js; global fetch stays the original runtime fetch.
function createMediaAnalysisHelpers({admin, geminiApiKey}) {

async function downloadMediaAsBase64(mediaUrlOrPath) {
    if (!mediaUrlOrPath) return null;

    try {
        if (
            mediaUrlOrPath.startsWith("http://") ||
            mediaUrlOrPath.startsWith("https://")
        ) {
            const response = await fetch(mediaUrlOrPath);

            if (!response.ok) {
                console.error("❌ 下載媒體 URL 失敗:", response.status, mediaUrlOrPath);
                return null;
            }

            const arrayBuffer = await response.arrayBuffer();
            const contentType =
                response.headers.get("content-type") || "application/octet-stream";

            return {
                base64: Buffer.from(arrayBuffer).toString("base64"),
                mimeType: contentType,
            };
        }

        const bucket = admin.storage().bucket();
        const file = bucket.file(mediaUrlOrPath);
        const [buffer] = await file.download();
        const [metadata] = await file.getMetadata();

        return {
            base64: buffer.toString("base64"),
            mimeType: metadata.contentType || "application/octet-stream",
        };
    } catch (error) {
        console.error("❌ downloadMediaAsBase64 失敗:", error);
        return null;
    }
}

async function describeImageWithGemini(imageUrlOrPath) {
  const media = await downloadMediaAsBase64(imageUrlOrPath);

  if (!media) return "";

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
                  text: "請用台灣繁體中文簡潔描述這張圖片。重點包括：畫面中有什麼、人物表情/動作、氛圍、可能想表達的情緒。不要編造看不到的內容。",
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
        }),
      }
    );

    if (!response.ok) {
      const errorText = await response.text();
      console.error("❌ Gemini 讀圖失敗:", response.status, errorText);
      return "";
    }

    const data = await response.json();

    return (
      data?.candidates?.[0]?.content?.parts
        ?.map((part) => part.text || "")
        .join("")
        .trim() || ""
    );
  } catch (error) {
    console.error("❌ describeImageWithGemini 失敗:", error);
    return "";
  }
}

async function transcribeAudioWithGemini(audioUrlOrPath) {
    const media = await downloadMediaAsBase64(audioUrlOrPath);

    if (!media) return "";

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
                                    text: "請將這段語音轉成台灣繁體中文文字。只輸出語音內容本身，不要加解釋。如果聽不清楚，請輸出：語音內容聽不清楚。",
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
                }),
            }
        );

        if (!response.ok) {
            const errorText = await response.text();
            console.error("❌ Gemini 語音辨識失敗:", response.status, errorText);
            return "";
        }

        const data = await response.json();

        return (
            data?.candidates?.[0]?.content?.parts
                ?.map((part) => part.text || "")
                .join("")
                .trim() || ""
        );
    } catch (error) {
        console.error("❌ transcribeAudioWithGemini 失敗:", error);
        return "";
    }
}

  return {downloadMediaAsBase64,describeImageWithGemini,transcribeAudioWithGemini};
}

module.exports={createMediaAnalysisHelpers};
