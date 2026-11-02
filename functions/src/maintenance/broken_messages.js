'use strict';
// Legacy message mojibake maintenance handlers. Behavioral copy from V69.
function createBrokenMessageHandlers({db}) {
  const scanBrokenMessages = async (req, res) => {
    try {
        const limit = Number(req.query.limit || 300);

        const snap = await db
            .collectionGroup("messages")
            .limit(limit)
            .get();

        const brokenPattern = /(æ|å|ç|ï¼|ã|â|�)/;

        const results = [];

        snap.forEach(doc => {
            const data = doc.data();

            const text = data.text || "";
            const voiceText = data.voiceText || "";
            const content = data.content || "";

            if (
                brokenPattern.test(text) ||
                brokenPattern.test(voiceText) ||
                brokenPattern.test(content)
            ) {
                results.push({
                    path: doc.ref.path,
                    sender: data.sender || "",
                    textPreview: text.substring(0, 200),
                    voicePreview: voiceText.substring(0, 100),
                    contentPreview: content.substring(0, 200),
                });
            }
        });

        return res.status(200).json({
            scanned: snap.size,
            brokenCount: results.length,
            results,
        });

    } catch (err) {
        console.error("掃描亂碼訊息失敗:", err);
        return res.status(500).json({
            error: err.message,
        });
    }
};
  const deleteBrokenMessages = async (req, res) => {
    try {
        // ===== 安全鎖：自己改成你的密碼 =====
        const ADMIN_KEY = "lianlianshiguang";

        if (req.query.key !== ADMIN_KEY) {
            return res.status(403).json({ error: "forbidden" });
        }

        const limit = Number(req.query.limit || 300);
        const dryRun = req.query.dryRun !== "false";
        // 預設 true：只預覽，不真的刪
        // 要真的刪時，用 ?dryRun=false

        const brokenPattern = /(æ|å|ç|ï¼|ã|â|�)/;

        const snap = await db
            .collectionGroup("messages")
            .limit(limit)
            .get();

        const batch = db.batch();
        const results = [];
        let deleteCount = 0;

        snap.forEach(doc => {
            const data = doc.data();

            const sender = data.sender || "";
            const text = data.text || "";
            const voiceText = data.voiceText || "";
            const content = data.content || "";

            const hasBroken =
                brokenPattern.test(text) ||
                brokenPattern.test(voiceText) ||
                brokenPattern.test(content);

            // 只刪 AI 訊息，避免誤刪玩家訊息
            if (hasBroken && sender === "ai") {
                results.push({
                    path: doc.ref.path,
                    sender,
                    textPreview: text.substring(0, 200),
                    voicePreview: voiceText.substring(0, 100),
                    contentPreview: content.substring(0, 200),
                });

                if (!dryRun) {
                    batch.delete(doc.ref);
                    deleteCount++;
                }
            }
        });

        if (!dryRun && deleteCount > 0) {
            await batch.commit();
        }

        return res.status(200).json({
            dryRun,
            scanned: snap.size,
            matched: results.length,
            deleted: dryRun ? 0 : deleteCount,
            results,
        });

    } catch (err) {
        console.error("刪除亂碼訊息失敗:", err);
        return res.status(500).json({
            error: err.message,
        });
    }
};
  return {scanBrokenMessages,deleteBrokenMessages};
}
module.exports = {createBrokenMessageHandlers};
