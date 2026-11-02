'use strict';
// V52: extract the original character voice request handler without changing its behavior.
function createCharacterVoiceRequestHandler({db,APP_ID,HttpsError,FieldValue,crypto}) {
  return {requestCharacterVoiceHandler: async (request) => {
  if (!request.auth?.uid) {
    throw new HttpsError("unauthenticated", "請先登入再提出聲音邀請");
  }
  const playerUid = request.auth.uid;
  const characterId = String(request.data?.characterId || "").trim();
  if (!/^[a-zA-Z0-9_-]{1,160}$/.test(characterId)) {
    throw new HttpsError("invalid-argument", "角色 ID 不正確");
  }
  const characterRef = db.collection("artifacts").doc(APP_ID)
      .collection("public_characters").doc(characterId);
  const characterSnap = await characterRef.get();
  if (!characterSnap.exists) {
    throw new HttpsError("not-found", "這位角色已不存在");
  }
  const character = characterSnap.data() || {};
  const creatorUid = String(character.createdBy || "").trim();
  const characterName = String(character.name || "角色").trim().slice(0, 100);
  const voiceId = String(character.voiceId || character.voice_id || "").trim();
  if (voiceId) {
    return {sent: false, voiceAvailable: true};
  }
  if (!creatorUid) {
    throw new HttpsError("failed-precondition", "找不到角色創作者");
  }
  const creatorSnap = await db.collection("users").doc(creatorUid).get();
  if (!creatorSnap.exists) {
    throw new HttpsError("failed-precondition", "找不到創作者帳號");
  }
  const playerSnap = await db.collection("users").doc(playerUid).get();
  const player = playerSnap.data() || {};
  const playerName = String(player.nickname || player.displayName ||
      request.auth.token?.name || "有位玩家").trim().slice(0, 60) || "有位玩家";
  const requestId = "voice_request_" + crypto.createHash("sha256")
      .update(playerUid + ":" + characterId).digest("hex").slice(0, 36);
  const mailRef = db.collection("users").doc(creatorUid)
      .collection("mailbox").doc(requestId);
  try {
    await mailRef.create({
      type: "voice_request",
      title: "角色聲音邀請",
      body: `${playerName} 正在期待「${characterName}」的聲音！要不要幫角色建立專屬聲音呢？`,
      fromUserId: playerUid,
      fromUserName: playerName,
      toUserId: creatorUid,
      characterId,
      characterName,
      createdAt: FieldValue.serverTimestamp(),
      isRead: false,
      read: false,
    });
  } catch (error) {
    if (error?.code === 6 || error?.code === "6" ||
        String(error?.message || "").includes("ALREADY_EXISTS")) {
      return {sent: false, alreadyRequested: true};
    }
    throw error;
  }
  return {sent: true, alreadyRequested: false};
}};
}
module.exports={createCharacterVoiceRequestHandler};
