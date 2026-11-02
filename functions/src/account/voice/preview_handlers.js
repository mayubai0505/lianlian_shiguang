'use strict';
// V54: ElevenLabs preview, preview-finalization and TTS sample handlers.
// Existing request validation, API error mapping and voice parameters are retained.
function createVoicePreviewHandlers({requireLogin, HttpsError, elevenLabsApiKey}) {
async function postElevenLabsJson(path, body) {
  const response = await fetch(
    `https://api.elevenlabs.io${path}`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "xi-api-key": elevenLabsApiKey.value(),
      },
      body: JSON.stringify(body),
    }
  );

  const text = await response.text();

  let parsedBody;

  try {
    parsedBody = text ? JSON.parse(text) : {};
  } catch (_) {
    parsedBody = text;
  }

  if (!response.ok) {
    console.error(
      "========== ElevenLabs API ERROR =========="
    );
    console.error("path:", path);
    console.error("status:", response.status);
    console.error("body:", parsedBody);

    let code = "internal";
    let message = "ElevenLabs 請求失敗";

    switch (response.status) {
      case 400:
        code = "invalid-argument";
        message = "語音資料格式不正確";
        break;

      case 401:
      case 403:
        code = "permission-denied";
        message =
          "ElevenLabs API Key 無效或沒有權限";
        break;

      case 404:
        code = "not-found";
        message =
          "找不到指定的聲音，可能已過期";
        break;

      case 409:
        code = "already-exists";
        message =
          "這個預覽聲音可能已經被正式建立過";
        break;

      case 422:
        code = "invalid-argument";
        message =
          "ElevenLabs 無法處理這份語音資料";
        break;

      case 429:
        code = "resource-exhausted";
        message =
          "ElevenLabs 額度不足或請求過於頻繁";
        break;

      default:
        if (response.status >= 500) {
          code = "unavailable";
          message =
            "ElevenLabs 服務暫時異常，請稍後再試";
        }
    }

    throw new HttpsError(
      code,
      message,
      {
        status: response.status,
        path,
        elevenLabsBody: parsedBody,
      }
    );
  }

  return parsedBody;
}


return {
  createVoicePreviews: async (request) => {
    requireLogin(request);

    const { sampleScript, voiceDescription } = request.data || {};

    if (!sampleScript || !voiceDescription) {
      throw new HttpsError(
        "invalid-argument",
        "缺少 sampleScript 或 voiceDescription"
      );
    }

    const result = await postElevenLabsJson(
      "/v1/text-to-voice/create-previews",
      {
        text: sampleScript,
        voice_description: voiceDescription,
      }
    );

    return {
      previews: result.previews || [],
    };
  },
  createVoiceFromPreview: async (request) => {
    requireLogin(request);

    const {
      voiceName,
      voiceDescription,
      generatedVoiceId,
    } = request.data || {};

    if (!voiceName || !generatedVoiceId) {
      throw new HttpsError(
        "invalid-argument",
        "缺少 voiceName 或 generatedVoiceId"
      );
    }

    console.log(
      "========== createVoiceFromPreview =========="
    );
    console.log("uid:", request.auth?.uid);
    console.log("voiceName:", voiceName);
    console.log(
      "generatedVoiceId:",
      generatedVoiceId
    );

    try {
      const result = await postElevenLabsJson(
        "/v1/text-to-voice/create-voice-from-preview",
        {
          voice_name: voiceName,
          voice_description:
            voiceDescription || "",
          generated_voice_id:
            generatedVoiceId,
        }
      );

      console.log(
        "✅ createVoiceFromPreview 成功:",
        result
      );

      const realVoiceId =
        result?.voice_id ??
        result?.voiceId ??
        "";

      if (!realVoiceId) {
        console.error(
          "ElevenLabs 成功回傳，但缺少 voice_id:",
          result
        );

        throw new HttpsError(
          "internal",
          "語音服務未回傳正式 Voice ID",
          {
            response: result,
          }
        );
      }

      return result;
    } catch (error) {
      console.error(
        "========== createVoiceFromPreview ERROR =========="
      );
      console.error("error:", error);
      console.error(
        "status:",
        error?.status ??
          error?.response?.status
      );
      console.error(
        "body:",
        error?.body ??
          error?.response?.data
      );

      // 如果原本就是我們主動拋出的 HttpsError，
      // 直接保留，不要再包一次。
      if (error instanceof HttpsError) {
        throw error;
      }

      const status =
        error?.status ??
        error?.response?.status ??
        error?.details?.status;

      const rawBody =
        error?.body ??
        error?.response?.data ??
        error?.message ??
        "";

      const bodyText =
        typeof rawBody === "string"
          ? rawBody
          : JSON.stringify(rawBody);

      if (status === 400) {
        throw new HttpsError(
          "invalid-argument",
          "預覽聲音資料無效，請重新生成聲音樣本",
          {
            status,
            elevenLabsBody: bodyText,
          }
        );
      }

      if (status === 401 ||
          status === 403) {
        throw new HttpsError(
          "permission-denied",
          "ElevenLabs API Key 無效或沒有權限",
          {
            status,
            elevenLabsBody: bodyText,
          }
        );
      }

      if (status === 404) {
        throw new HttpsError(
          "not-found",
          "找不到這個預覽聲音，可能已過期，請重新生成",
          {
            status,
            elevenLabsBody: bodyText,
          }
        );
      }

      if (status === 409) {
        throw new HttpsError(
          "already-exists",
          "這個預覽聲音可能已經被建立過",
          {
            status,
            elevenLabsBody: bodyText,
          }
        );
      }

      if (status === 429) {
        throw new HttpsError(
          "resource-exhausted",
          "ElevenLabs 額度不足或請求過於頻繁",
          {
            status,
            elevenLabsBody: bodyText,
          }
        );
      }

      if (status != null &&
          status >= 500) {
        throw new HttpsError(
          "unavailable",
          "ElevenLabs 服務暫時異常，請稍後再試",
          {
            status,
            elevenLabsBody: bodyText,
          }
        );
      }

      throw new HttpsError(
        "internal",
        "建立正式聲音失敗",
        {
          status,
          elevenLabsBody: bodyText,
        }
      );
    }
  },
  testVoiceSettings: async (request) => {
    requireLogin(request);

    const {
      voiceId,
      text,
      stability,
      style,
      speed,
    } = request.data || {};

    if (!voiceId || !text) {
      throw new HttpsError(
        "invalid-argument",
        "缺少 voiceId 或 text"
      );
    }

    console.log("========== testVoiceSettings ==========");
    console.log("uid:", request.auth?.uid);
    console.log("voiceId:", voiceId);
    console.log("textLength:", String(text).length);
    console.log("stability:", stability);
    console.log("style:", style);

    try {
      const response = await fetch(
        `https://api.elevenlabs.io/v1/text-to-speech/${voiceId}`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "xi-api-key": elevenLabsApiKey.value(),
            "Accept": "audio/mpeg",
          },
          body: JSON.stringify({
            text,
            model_id: "eleven_multilingual_v2",
            voice_settings: {
              stability: stability ?? 0.33,
              similarity_boost: 0.75,
              style: style ?? 0.75,
              speed: speed ?? 0.92,
              use_speaker_boost: true,
            },
          }),
        }
      );

      if (!response.ok) {
        const errorText = await response.text();

        console.error("========== ElevenLabs TTS ERROR ==========");
        console.error("status:", response.status);
        console.error("body:", errorText);

        let message = "ElevenLabs 試聽失敗";

        if (response.status === 401) {
          message = "ElevenLabs API Key 無效或未設定";
        } else if (response.status === 404) {
          message = "找不到指定的 Voice ID";
        } else if (response.status === 429) {
          message = "ElevenLabs 額度不足或請求過於頻繁";
        } else if (response.status >= 500) {
          message = "ElevenLabs 服務暫時異常";
        }

        throw new HttpsError(
          "internal",
          message,
          {
            status: response.status,
            elevenLabsBody: errorText,
            voiceId,
          }
        );
      }

      const arrayBuffer = await response.arrayBuffer();

      if (arrayBuffer.byteLength === 0) {
        throw new HttpsError(
          "internal",
          "ElevenLabs 回傳空白音檔"
        );
      }

      const audioBase64 =
        Buffer.from(arrayBuffer).toString("base64");

      console.log(
        "✅ testVoiceSettings 成功，bytes:",
        arrayBuffer.byteLength
      );

      return {
        audio_base_64: audioBase64,
      };
    } catch (error) {
      if (error instanceof HttpsError) {
        throw error;
      }

      console.error(
        "========== testVoiceSettings UNKNOWN ERROR =========="
      );
      console.error(error);

      throw new HttpsError(
        "internal",
        error?.message || "語音試聽發生未知錯誤"
      );
    }
  }
};
}
module.exports={createVoicePreviewHandlers};
