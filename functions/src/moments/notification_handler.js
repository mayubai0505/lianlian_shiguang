'use strict';
// 拾光牆通知：保持 V58 原始驗證與站內信寫入流程。
function createMomentNotificationHandler({db,APP_ID,HttpsError,FieldValue}) {
  return   async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "請先登入");
    }

    const uid = request.auth.uid;


    const appId = (request.data.appId || APP_ID).toString();
    const momentId = (request.data.momentId || "").toString().trim();
    const type = (request.data.type || "").toString().trim();
    const commentId = request.data.commentId
      ? request.data.commentId.toString().trim()
      : null;

    if (!momentId) {
      throw new HttpsError("invalid-argument", "缺少 momentId");
    }

    if (!["like", "comment"].includes(type)) {
      throw new HttpsError("invalid-argument", "不支援的通知類型");
    }

    const momentRef = db
      .collection("artifacts")
      .doc(appId)
      .collection("moments")
      .doc(momentId);

    const momentDoc = await momentRef.get();

    if (!momentDoc.exists) {
      throw new HttpsError("not-found", "找不到這篇動態");
    }

    const momentData = momentDoc.data() || {};
    const recipientId = (momentData.createdBy || "").toString().trim();

    if (!recipientId) {
      return {
        ok: false,
        skipped: "missing_recipient",
      };
    }

    // 自己按自己的文，不寄信
    if (recipientId === uid) {
      return {
        ok: true,
        skipped: "self_notification",
      };
    }

    // 防止亂呼叫：按讚通知必須真的有 like 文件
    if (type === "like") {
      const likeDoc = await momentRef.collection("likes").doc(uid).get();

      if (!likeDoc.exists) {
        return {
          ok: false,
          skipped: "like_not_found",
        };
      }
    }

    // 防止亂呼叫：留言通知必須真的有 comment 文件，而且作者是本人
    if (type === "comment") {
      if (!commentId) {
        throw new HttpsError("invalid-argument", "留言通知缺少 commentId");
      }

      const commentDoc = await momentRef
        .collection("comments")
        .doc(commentId)
        .get();

      if (!commentDoc.exists) {
        return {
          ok: false,
          skipped: "comment_not_found",
        };
      }

      const commentData = commentDoc.data() || {};

      if (commentData.authorId !== uid) {
        return {
          ok: false,
          skipped: "comment_author_mismatch",
        };
      }
    }

    const senderDoc = await db.collection("users").doc(uid).get();
    const senderData = senderDoc.exists ? senderDoc.data() || {} : {};

    const rawPlayerID = (senderData.playerID || "").toString().trim();
    const nickname = (senderData.nickname || "").toString().trim();
    const displayName = (senderData.displayName || "").toString().trim();

    let senderName = "某位朋友";

    if (rawPlayerID) {
      const cleanPlayerID = rawPlayerID.startsWith("@")
        ? rawPlayerID.substring(1)
        : rawPlayerID;
      senderName = `@${cleanPlayerID}`;
    } else if (nickname) {
      senderName = nickname;
    } else if (displayName) {
      senderName = displayName;
    }

    let notificationId;
    let title;
    let body;

    if (type === "like") {
      // 按讚通知優先顯示按讚者目前的暱稱，而非固定玩家 ID。
      // 每次通知都已重新讀取 users/{uid}，因此暱稱修改後的新通知會更新。
      senderName = nickname || displayName || senderName;
      notificationId = `moment_like_${momentId}_${uid}`;
      title = "新的按讚";
      body = `${senderName} 喜歡了你的瞬間動態。`;
    } else {
      notificationId = `moment_comment_${momentId}_${commentId}`;
      title = "新留言";
      body = `${senderName} 回覆了你的瞬間動態。`;
    }

        const mailboxData = {
          type,
          fromId: uid,
          fromName: senderName,
          title,
          body,
          postId: momentId,
          createdAt: FieldValue.serverTimestamp(),
          isRead: false,
          source: "cloud_function",
        };

        if (commentId) {
          mailboxData.commentId = commentId;
        }

        await db
          .collection("users")
          .doc(recipientId)
          .collection("mailbox")
          .doc(notificationId)
          .set(mailboxData, { merge: true });

    return {
      ok: true,
      recipientId,
      notificationId,
    };
  };
}
module.exports={createMomentNotificationHandler};
