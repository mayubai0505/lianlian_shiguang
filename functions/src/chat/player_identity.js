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

  if (safeProfileId !== "default" && (!matchedProfile || !String(matchedProfile.name || "").trim())) {
    return {id: safeProfileId, name: "你", gender: "未設定", birthday: "未設定", profile: null, resolved: false};
  }

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
      String(matchedProfile.name).trim(),
    // 自訂檔案未設定性別時保持未知，不能繼承帳號性別。
    gender:
      canonicalPlayerGender(matchedProfile.gender) || "未設定",
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
  requireStableBinding = false,
}) {
  const safeAppId = String(appId || APP_ID).trim() || APP_ID;
  const safeUserId = String(userId || "").trim();
  const safeCharacterId = String(characterId || "").trim();
  const safeSessionId = String(sessionId || "").trim();
  let effectiveProfileId = String(requestedProfileId || "").trim();

  let resolvedUserData = userData;
  let roomData = null;
  let roomReadFailed = false;

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
          (!safeCharacterId || roomCharacterId === safeCharacterId)
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
      roomReadFailed = true;
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
  const requested = String(requestedProfileId || "").trim();
  const mirror = String(roomData?.playerProfileId || "").trim();
  const selected = safeSessionId && roomData
    ? String(safeUserData.roomProfiles?.[safeSessionId] ?? '').trim() : '';
  // The explicit room selection normally wins. Never replace a known custom
  // request with an account nickname during a transient default/mirror conflict.
  effectiveProfileId = selected || mirror || requested || "default";
  if (effectiveProfileId === "default" && requested && requested !== "default") {
    effectiveProfileId = requested;
  }
  // A default mapping conflicting with a custom room mirror is ambiguous.
  // Do not expose the account nickname while the room selection is syncing.
  if (effectiveProfileId === 'default' && mirror && mirror !== 'default') {
    effectiveProfileId = '__unresolved__';
  }
  if (safeSessionId && !roomData && (roomReadFailed || !requested)) {
    effectiveProfileId = requested && requested !== 'default' ? requested : '__unresolved__';
  }
  const profiles = Array.isArray(safeUserData.profiles) ? safeUserData.profiles : [];
  const profileExists = effectiveProfileId === 'default' || profiles.some(profile =>
    String(profile?.id || '').trim() === effectiveProfileId && String(profile?.name || '').trim());
  // A delayed background job must never be re-bound to another persona.
  // Conflicting or missing authoritative room bindings are skipped, not guessed.
  if (requireStableBinding && (!safeSessionId || !roomData || !requested ||
      !(mirror || selected) || (mirror && mirror !== requested) ||
      (selected && selected !== requested) || effectiveProfileId !== requested || !profileExists)) {
    console.warn('MEMORY_PROFILE_BINDING_UNRESOLVED_SKIP', {sessionId:safeSessionId});
    return null;
  }
  if (!profileExists) {
    console.warn('PLAYER_PROFILE_UNRESOLVED_NO_ACCOUNT_FALLBACK', {sessionId:safeSessionId});
  }

  // 可以安全補回舊房間，之後每次都以 room 綁定為準。
  if (
    safeSessionId &&
    safeUserId &&
    roomData && profileExists &&
    (!selected || selected === effectiveProfileId) &&
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
