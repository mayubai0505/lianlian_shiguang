"use strict";
// V46: 角色調整通知的原始 callback；Firebase 包裝仍保留在 core.js。
function createCharacterAdjustmentNoticeHandler({db, APP_ID, FieldValue, HttpsError, requireRewardCampaignAdmin}) {
  return async (request) => {
    const adminUid =
      requireRewardCampaignAdmin(request);

    const data = request.data || {};

    const characterId = String(
      data.characterId || ""
    ).trim();

    const reason = String(
      data.reason || ""
    ).trim();

    const requirePrivate =
      data.requirePrivate === true;

    if (!characterId) {
      throw new HttpsError(
        "invalid-argument",
        "缺少角色編號"
      );
    }

    if (!reason) {
      throw new HttpsError(
        "invalid-argument",
        "請填寫需要調整的內容"
      );
    }

    if (reason.length > 1000) {
      throw new HttpsError(
        "invalid-argument",
        "調整內容不能超過 1000 字"
      );
    }

    // 必須由後端讀取真正的角色擁有者，
    // 不接受前端自行指定收件人。
    const characterRef = db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("public_characters")
      .doc(characterId);

    const characterSnapshot =
      await characterRef.get();

    if (!characterSnapshot.exists) {
      throw new HttpsError(
        "not-found",
        "找不到這個公開角色"
      );
    }

    const characterData =
      characterSnapshot.data() || {};

    const creatorId = String(
      characterData.createdBy || ""
    ).trim();

    const characterName = String(
      characterData.name || "未命名角色"
    ).trim();

    if (!creatorId) {
      throw new HttpsError(
        "failed-precondition",
        "此角色沒有創作者資料"
      );
    }

    const mailboxRef = db
      .collection("users")
      .doc(creatorId)
      .collection("mailbox")
      .doc();

    const noticeLogRef = db
      .collection("artifacts")
      .doc(APP_ID)
      .collection(
        "character_adjustment_notices"
      )
      .doc(mailboxRef.id);

    const privateSuggestion =
      requirePrivate
        ? "\n\n為避免其他玩家在調整期間繼續看到相關內容，建議你先將此角色轉為私人，完成調整後再重新公開。"
        : "";

    const body =
      `你好，我們在審查角色「${characterName}」時，`
      + "發現部分內容可能需要調整。\n\n"
      + `【需要調整的內容】\n${reason}`
      + privateSuggestion
      + "\n\n請完成調整後再次確認角色內容。"
      + "若你對通知有疑問，可以透過客服與我們聯繫。";

    const batch = db.batch();

    batch.set(mailboxRef, {
      type:
        "character_adjustment_notice",

      title:
        `角色「${characterName}」需要調整`,

      body,

      characterId,
      characterName,
      creatorId,

      adjustmentReason: reason,
      requirePrivate,

      adminUid,
      isRead: false,

      createdAt:
        FieldValue.serverTimestamp(),
    });

    // 保存管理員寄送紀錄
    batch.set(noticeLogRef, {
      mailId: mailboxRef.id,

      characterId,
      characterName,
      creatorId,

      reason,
      requirePrivate,

      status: "sent",
      adminUid,

      createdAt:
        FieldValue.serverTimestamp(),
    });

    await batch.commit();

    console.log(
      "📨 已寄送角色調整通知",
      {
        characterId,
        characterName,
        creatorId,
        adminUid,
        mailId: mailboxRef.id,
      }
    );

    return {
      success: true,
      mailId: mailboxRef.id,
      creatorId,
      characterName,
    };
  };
}
module.exports = {createCharacterAdjustmentNoticeHandler};
