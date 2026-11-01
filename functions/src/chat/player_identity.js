'use strict';

function createPlayerIdentityTools({db, APP_ID}) {
function resolvePlayerIdentityFromUserData(userData = {}, playerProfileId = "default") {
  const safeProfileId = String(playerProfileId || "default").trim() || "default";
  const accountName =
    String(
      userData.nickname ||
      userData.displayName ||
      userData.name ||
      "你"
    ).trim() || "你";

  const accountGender =
    String(userData.gender || "未設定").trim() || "未設定";
  const accountBirthday =
    String(userData.birthday || "未設定").trim() || "未設定";

  const profiles = Array.isArray(userData.profiles)
    ? userData.profiles
    : [];

  const matchedProfile =
    safeProfileId !== "default"
      ? profiles.find(
          (profile) =>
            String(profile?.id || "").trim() === safeProfileId
        ) || null
      : null;

  if (!matchedProfile) {
    return {
      id: "default",
      name: accountName,
      gender: accountGender,
      birthday: accountBirthday,
      profile: null,
    };
  }

  return {
    id: safeProfileId,
    name:
      String(matchedProfile.name || accountName).trim() || accountName,
    // 目前前端的自訂拾光檔案仍沿用帳號層級性別／生日；若未來 profile 自己有值則優先使用。
    gender:
      String(matchedProfile.gender || accountGender).trim() || accountGender,
    birthday:
      String(matchedProfile.birthday || accountBirthday).trim() || accountBirthday,
    profile: matchedProfile,
  };
}

async function resolveEffectivePlayerProfileId({
  appId = APP_ID,
  userId,
  characterId = "",
  sessionId = "",
  requestedProfileId = "",
  userData = null,
}) {
  const safeAppId = String(appId || APP_ID).trim() || APP_ID;
  const safeUserId = String(userId || "").trim();
  const safeCharacterId = String(characterId || "").trim();
  const safeSessionId = String(sessionId || "").trim();
  let effectiveProfileId = String(requestedProfileId || "").trim();

  let resolvedUserData = userData;
  let roomData = null;

  if (safeSessionId && safeUserId) {
    try {
      const roomSnapshot = await db
        .collection("artifacts")
        .doc(safeAppId)
        .collection("chat_sessions")
        .doc(safeSessionId)
        .get();

      if (roomSnapshot.exists) {
        const candidateRoomData = roomSnapshot.data() || {};
        const roomOwner = String(candidateRoomData.userId || "").trim();
        const roomCharacterId = String(candidateRoomData.characterId || "").trim();

        if (
          roomOwner === safeUserId &&
          (!safeCharacterId || !roomCharacterId || roomCharacterId === safeCharacterId)
        ) {
          roomData = candidateRoomData;
          const roomProfileId =
            String(candidateRoomData.playerProfileId || "").trim();
          if (roomProfileId) {
            effectiveProfileId = roomProfileId;
          }
        }
      }
    } catch (error) {
      console.warn(
        "⚠️ resolveEffectivePlayerProfileId 讀取聊天室失敗：",
        error?.message || error
      );
    }
  }

  if (!resolvedUserData && safeUserId) {
    try {
      const userSnapshot = await db
        .collection("users")
        .doc(safeUserId)
        .get();
      resolvedUserData = userSnapshot.data() || {};
    } catch (error) {
      console.warn(
        "⚠️ resolveEffectivePlayerProfileId 讀取玩家資料失敗：",
        error?.message || error
      );
      resolvedUserData = {};
    }
  }

  const safeUserData = resolvedUserData || {};

  if (!effectiveProfileId && safeSessionId) {
    const roomProfiles =
      safeUserData.roomProfiles && typeof safeUserData.roomProfiles === "object"
        ? safeUserData.roomProfiles
        : {};

    effectiveProfileId =
      String(roomProfiles[safeSessionId] || "").trim();
  }

  // 舊房間若完全沒有紀錄，視為基礎檔案，避免再落回角色共用記憶路徑。
  if (!effectiveProfileId) {
    effectiveProfileId = "default";
  }

  if (effectiveProfileId !== "default") {
    const profiles = Array.isArray(safeUserData.profiles)
      ? safeUserData.profiles
      : [];
    const profileExists = profiles.some(
      (profile) =>
        String(profile?.id || "").trim() === effectiveProfileId
    );

    if (!profileExists) {
      console.warn(
        "⚠️ 找不到指定 playerProfileId，退回基礎檔案：",
        effectiveProfileId
      );
      effectiveProfileId = "default";
    }
  }

  // 可以安全補回舊房間，之後每次都以 room 綁定為準。
  if (
    safeSessionId &&
    safeUserId &&
    roomData &&
    !String(roomData.playerProfileId || "").trim()
  ) {
    try {
      await db
        .collection("artifacts")
        .doc(safeAppId)
        .collection("chat_sessions")
        .doc(safeSessionId)
        .set(
          {
            playerProfileId: effectiveProfileId,
          },
          {merge: true}
        );
    } catch (error) {
      console.warn(
        "⚠️ 回填聊天室 playerProfileId 失敗：",
        error?.message || error
      );
    }
  }

  return effectiveProfileId;
}

return {resolvePlayerIdentityFromUserData, resolveEffectivePlayerProfileId};
}

module.exports = {createPlayerIdentityTools};
