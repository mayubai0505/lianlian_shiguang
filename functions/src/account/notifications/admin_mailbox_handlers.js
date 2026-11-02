'use strict';
// V41: 管理員站內信 UID 查詢與寄信；原處理器內容完整搬移。
function createAdminMailboxHandlers({db,APP_ID,FieldValue,HttpsError,requireRewardCampaignAdmin}) {
 return {
  lookupAdminMailboxRecipientUs: async (request) => {
    requireRewardCampaignAdmin(request);

    const recipientUid = String(
      request.data?.recipientUid || ""
    ).trim();

    if (!recipientUid) {
      throw new HttpsError(
        "invalid-argument",
        "請輸入玩家 UID"
      );
    }

    const userSnapshot = await db
      .collection("users")
      .doc(recipientUid)
      .get();

    if (!userSnapshot.exists) {
      return {
        success: true,
        exists: false,
      };
    }

    const userData =
      userSnapshot.data() || {};

    const recipientName =
      String(
        userData.nickname ||
        userData.displayName ||
        userData.name ||
        "未設定暱稱的玩家"
      ).trim();

    return {
      success: true,
      exists: true,
      recipientUid,
      recipientName,
    };
  },
  sendAdminMailboxMessageUs: async (request) => {
    const adminUid =
      requireRewardCampaignAdmin(request);

    const recipientUid = String(
      request.data?.recipientUid || ""
    ).trim();

    const title = String(
      request.data?.title || ""
    ).trim();

    const body = String(
      request.data?.body || ""
    ).trim();

    if (!recipientUid) {
      throw new HttpsError(
        "invalid-argument",
        "缺少收件人 UID"
      );
    }

    if (!title) {
      throw new HttpsError(
        "invalid-argument",
        "請輸入信件標題"
      );
    }

    if (!body) {
      throw new HttpsError(
        "invalid-argument",
        "請輸入信件內容"
      );
    }

    if (title.length > 100) {
      throw new HttpsError(
        "invalid-argument",
        "信件標題不能超過 100 字"
      );
    }

    if (body.length > 3000) {
      throw new HttpsError(
        "invalid-argument",
        "信件內容不能超過 3000 字"
      );
    }

    const recipientRef = db
      .collection("users")
      .doc(recipientUid);

    const recipientSnapshot =
      await recipientRef.get();

    if (!recipientSnapshot.exists) {
      throw new HttpsError(
        "not-found",
        "找不到這位玩家"
      );
    }

    const recipientData =
      recipientSnapshot.data() || {};

    const recipientName =
      String(
        recipientData.nickname ||
        recipientData.displayName ||
        recipientData.name ||
        "未設定暱稱的玩家"
      ).trim();

    const mailboxRef = recipientRef
      .collection("mailbox")
      .doc();

    const mailLogRef = db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("admin_mail_logs")
      .doc(mailboxRef.id);

    const batch = db.batch();

    batch.set(mailboxRef, {
      type: "admin_mail",

      title,
      body,

      fromId: adminUid,
      fromName: "戀戀拾光管理團隊",

      isRead: false,

      createdAt:
        FieldValue.serverTimestamp(),
    });

    batch.set(mailLogRef, {
      mailId: mailboxRef.id,

      recipientUid,
      recipientName,

      title,
      body,

      adminUid,
      status: "sent",

      createdAt:
        FieldValue.serverTimestamp(),
    });

    await batch.commit();

    console.log(
      "📨 管理員玩家信件已寄出",
      {
        mailId: mailboxRef.id,
        recipientUid,
        recipientName,
        adminUid,
      }
    );

    return {
      success: true,
      mailId: mailboxRef.id,
      recipientUid,
      recipientName,
    };
  }
 };
}
module.exports={createAdminMailboxHandlers};
