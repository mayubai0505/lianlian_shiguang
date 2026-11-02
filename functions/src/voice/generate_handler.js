'use strict';
// V55: Unchanged HTTP voice generation, ElevenLabs TTS and Storage cache behavior.
function createGenerateVoiceHandler({admin,crypto,elevenLabsApiKey}) {
function cleanVoiceText(text) {
    if (!text) return "";
    // 使用 JS 的正則，剔除各種括弧、Markdown 星號及其包含的換行內容
    return text.replace(/（[\s\S]*?）|\([\s\S]*?\)|\[[\s\S]*?\]|【[\s\S]*?】|\*[\s\S]*?\*|\{[\s\S]*?\}/g, "").trim();
}

return async (req, res) => {
    // CORS 設定
    res.set("Access-Control-Allow-Origin", "*");
    if (req.method === "OPTIONS") {
        res.set("Access-Control-Allow-Methods", "POST");
        res.set("Access-Control-Allow-Headers", "Content-Type");
        return res.status(204).send("");
    }

    try {
        if (req.method !== "POST") {
            return res.status(405).json({ error: "Method not allowed" });
        }

        // 🌟 讓前端直接傳 text 進來，不用再傳麻煩的 messageId 了！
        const {
                    text: rawText,
                    voiceId,
                    stability = 0.35, // ✨ 稍微調降一點 (0.35~0.4)，情緒起伏更自然
                    style = 0.15,     // 🚨 從 0.75 降到 0.15，擺脫做作的戲劇腔！
                } = req.body || {};

        if (!rawText || !voiceId) {
            return res.status(400).json({ error: "缺少 text 或 voiceId" });
        }

        // 清理文字
        let text = cleanVoiceText(rawText);
        if (!text) {
            return res.status(400).json({ error: "沒有可生成語音的文字" });
        }

        // 生成全局唯一快取 Key
        const cacheSource = [
            voiceId,
            Number(stability).toFixed(2),
            Number(style).toFixed(2),
            text,
        ].join("|");

        const cacheKey = crypto.createHash("sha256").update(cacheSource).digest("hex");
        const filePath = `voice_cache/${voiceId}/${cacheKey}.mp3`;

        const bucket = admin.storage().bucket();
        const file = bucket.file(filePath);
        const [exists] = await file.exists();

        // 🎯 全局快取命中：Storage 已經有這句話的音檔了
        if (exists) {
            console.log("🎧 命中全局快取，直接回傳音檔網址");
            const [metadata] = await file.getMetadata();
            let token = metadata?.metadata?.firebaseStorageDownloadTokens;
            if (!token) {
                token = crypto.randomUUID();
                await file.setMetadata({ metadata: { firebaseStorageDownloadTokens: token } });
            }

            // 這裡的 createStorageDownloadUrl 依據妳後端的寫法而定，通常格式如下：
            const audioUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(filePath)}?alt=media&token=${token}`;

            return res.status(200).json({ status: "cached", audioUrl });
        }

        // 🎙️ 快取沒中，安全地呼秘書ElevenLabs
        console.log("🎙️ 呼叫 ElevenLabs 生成新語音");
                const apiKey = elevenLabsApiKey.value();

                const elevenResponse = await fetch(
                    // ✨ 把延遲優化從 3 降到 1，保證音質跟情緒的完整度
                    `https://api.elevenlabs.io/v1/text-to-speech/${voiceId}?optimize_streaming_latency=1`,
                    {
                        method: "POST",
                        headers: {
                            "accept": "audio/mpeg",
                            "xi-api-key": apiKey,
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify({
                            text: text,
                            // ✨ 升級為最新版「極速對話模型」，口語感更強！
                            model_id: "eleven_turbo_v2_5",
                            voice_settings: {
                                stability: Number(stability),
                                similarity_boost: 0.75, // 稍微降一點點，給 AI 多點喘息空間
                                style: Number(style),
                                use_speaker_boost: true,
                            },
                        }),
                    }
                );

        if (!elevenResponse.ok) {
                    const errorDetail = await elevenResponse.text();
                    // 🚨 加上這行，逼它在 GCP 後台大聲說出失敗原因！
                    console.error("🚨 ElevenLabs 拒絕存取，原因:", errorDetail);
                    return res.status(500).json({ error: "ElevenLabs 失敗", detail: errorDetail });
                }

        const audioBuffer = Buffer.from(await elevenResponse.arrayBuffer());
        const token = crypto.randomUUID();

        await file.save(audioBuffer, {
            metadata: {
                contentType: "audio/mpeg",
                metadata: { firebaseStorageDownloadTokens: token },
            },
        });

        const audioUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(filePath)}?alt=media&token=${token}`;

        return res.status(200).json({ status: "generated", audioUrl });

    } catch (err) {
        console.error("錯誤:", err);
        return res.status(500).json({ error: err.message });
    }
};
}
module.exports={createGenerateVoiceHandler};
