'use strict';

function canonicalPlayerGender(value) {
  const raw = String(value ?? '').trim().toLowerCase();
  if (['male','m','男','男性','男生'].includes(raw)) return '男性';
  if (['female','f','女','女性','女生'].includes(raw)) return '女性';
  if (['other','其他'].includes(raw)) return '其他';
  if (['unset','未設定','未選擇','未选择','not selected'].includes(raw)) return '未設定';
  return '';
}

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
    // 自訂拾光檔案的明確性別優先；舊檔案無性別時仍沿用帳號。
    gender:
      canonicalPlayerGender(matchedProfile.gender) || accountGender,
    birthday:
      String(matchedProfile.birthday || "未設定").trim() || "未設定",
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
  // The profile picker writes the explicit room selection to user.roomProfiles.
  // It may arrive before the session mirror is updated. Never use a draft or
  // global activeProfileId for an existing room.
  if (roomData && safeSessionId) {
    const selected = String(safeUserData.roomProfiles?.[safeSessionId] ?? '').trim();
    if (selected) effectiveProfileId = selected;
  }

  if (!roomData && safeSessionId) {
    const roomProfiles =
      safeUserData.roomProfiles && typeof safeUserData.roomProfiles === "object"
        ? safeUserData.roomProfiles
        : {};

    effectiveProfileId =
      String(roomProfiles[safeSessionId] || "").trim() || effectiveProfileId;
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

function buildResolvedPlayerProfileText(identity) {
  const profile = identity.profile || {};
  const clean = (value, max=1200) => String(value ?? '').trim().slice(0,max);
  const rows = [
    ['稱呼', identity.name], ['性別', canonicalPlayerGender(identity.gender) || '未設定'],
    ['生日', identity.birthday], ['年齡', profile.age], ['身高', profile.height],
    ['外貌特徵', profile.appearance], ['職業背景', profile.occupation],
    ['個性與自我介紹', profile.intro],
  ];
  return '【目前聊天室選定的玩家檔案｜身分資料】\n' + rows
    .filter(([key,value]) => clean(value)).map(([key,value]) => `- ${key}：${clean(value)}`).join('\n') +
    '\n僅依據此檔案辨識玩家本人。未設定的資料保持未知；其他姓名可能是 NPC、舊檔案或範例，不可自行認定為玩家姓名。';
}
module.exports = {createPlayerIdentityTools, canonicalPlayerGender, buildResolvedPlayerProfileText};
