'use strict';

// V74: HTTP cancellation handler; the original request-handling body is preserved.
function createCancelAiResponseHandler({auth, db, APP_ID, FieldValue}) {
  return async (req, res) => {
    try {
      if (req.method !== "POST") {
        return res.status(405).json({
          status: "error",
          message: "Method not allowed",
        });
      }

      const authorization =
          req.headers.authorization || "";

      if (!authorization.startsWith("Bearer ")) {
        return res.status(401).json({
          status: "error",
          message: "尚未登入",
        });
      }

      const idToken =
          authorization.substring(7).trim();

      const decodedToken =
          await auth.verifyIdToken(
              idToken
          );

      const userId = decodedToken.uid;

      const clientRequestId = String(
        req.body?.clientRequestId || ""
      )
          .trim()
          .slice(0, 200);

      if (!clientRequestId) {
        return res.status(400).json({
          status: "error",
          message: "缺少 clientRequestId",
        });
      }

      // 取得聊天室 ID
      const rawSessionId = String(
        req.body?.sessionId || ""
      ).trim();

      if (!rawSessionId) {
        return res.status(400).json({
          status: "error",
          message: "缺少 sessionId",
        });
      }

      // 必須與 getAiResponse 建立 lock 時使用相同的清理規則
      const safeSessionId = rawSessionId
        .replace(/[\/\\#?\[\]\s]/g, "_")
        .slice(0, 150);

      const cancellationRef = db
          .collection("artifacts")
          .doc(APP_ID)
          .collection(
            "ai_request_cancellations"
          )
          .doc(clientRequestId);

      const aiLockRef = db
          .collection("users")
          .doc(userId)
          .collection("locks")
          .doc(`aiResponse_${safeSessionId}`);

      let lockReleased = false;

      await db.runTransaction(
          async (transaction) => {
              // 先讀取鎖，再執行所有寫入
              const lockSnapshot =
                  await transaction.get(
                      aiLockRef
                  );

              const lockData =
                  lockSnapshot.data() || {};

              // 建立取消紀錄
              transaction.set(
                  cancellationRef,
                  {
                      userId,
                      clientRequestId,
                      sessionId: rawSessionId,
                      cancelled: true,

                      cancelledAt:
                          FieldValue
                              .serverTimestamp(),

                      expiresAt:
                          new Date(
                              Date.now() +
                              24 * 60 * 60 * 1000
                          ),
                  },
                  {
                      merge: true,
                  }
              );

              // 只能刪除完全屬於本次請求的鎖，
              // 不得誤刪後來新請求建立的鎖。
              if (
                  lockSnapshot.exists &&
                  lockData.userId === userId &&
                  lockData.sessionId ===
                      rawSessionId &&
                  lockData.clientRequestId ===
                      clientRequestId
              ) {
                  transaction.delete(
                      aiLockRef
                  );

                  lockReleased = true;
              }
          }
      );

      console.log(
          "🛑 收到玩家主動取消 AI 請求",
          {
              userId,
              sessionId: rawSessionId,
              clientRequestId,
              lockReleased,
          }
      );

      return res.status(200).json({
          status: "cancelled",
          clientRequestId,
          lockReleased,
      });
    } catch (error) {
      console.error(
        "❌ 取消 AI 請求失敗：",
        error
      );

      return res.status(500).json({
        status: "error",
        message: "取消請求失敗",
      });
    }
  };
}

module.exports = {createCancelAiResponseHandler};
