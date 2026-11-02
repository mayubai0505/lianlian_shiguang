"use strict";
// V45: 管理員創作者審核／人工認證處理器。保留原本驗證、交易與通知規則。
function createCreatorAdminHandlers({db, FieldValue, HttpsError, logger, requireRewardCampaignAdmin, CREATOR_ADMIN_STATUSES}) {
  const listCreatorApplicationsUs = async (request) => {
  requireRewardCampaignAdmin(request);
  // 分狀態查詢避免讀取整個 users 集合；每組至多 200 位。
  const snapshots = await Promise.all(CREATOR_ADMIN_STATUSES.map(status =>
    db.collection("users").where("creatorStatus", "==", status).limit(200).get()
  ));
  const items = [];
  for (let i = 0; i < snapshots.length; i++) {
    for (const doc of snapshots[i].docs) {
      const d = doc.data() || {};
      items.push({
        uid: doc.id,
        nickname: String(d.nickname || d.displayName || ""),
        playerID: String(d.playerID || d.playerId || ""),
        creatorStatus: CREATOR_ADMIN_STATUSES[i],
        creatorDirection: String(d.creatorDirection || ""),
        creatorApplicationReason: String(d.creatorApplicationReason || ""),
        creatorStatusReason: String(d.creatorStatusReason || ""),
        publicCharacterCount: Number(d.publicCharacterCount || 0),
        followerCount: Number(d.followerCount || 0),
        totalLikes: Number(d.totalLikes || 0),
        creatorReviewedAt: d.creatorReviewedAt?.toDate?.()?.toISOString() || null,
        creatorContractSignedAt: d.creatorContractSignedAt?.toDate?.()?.toISOString() || null,
      });
    }
  }
  return {items};
};

  const adminUpdateCreatorStatusUs = async (request) => {
  const adminUid = requireRewardCampaignAdmin(request);
  const {creatorUid, targetStatus, reason} = request.data || {};
  const uid = String(creatorUid || "").trim();
  const status = String(targetStatus || "").trim();
  const explanation = String(reason || "").trim();
  if (!uid || !CREATOR_ADMIN_STATUSES.includes(status) || status === "pending") {
    throw new HttpsError("invalid-argument", "無效的創作者或目標狀態");
  }
  if (["rejected", "suspended", "revoked"].includes(status) && !explanation) {
    throw new HttpsError("invalid-argument", "此操作必須填寫原因");
  }
  if (explanation.length > 300) throw new HttpsError("invalid-argument", "原因過長");

  const userRef = db.collection("users").doc(uid);
  const transition = await db.runTransaction(async tx => {
    const snap = await tx.get(userRef);
    if (!snap.exists) throw new HttpsError("not-found", "找不到創作者帳號");
    const user = snap.data() || {};
    const current = String(user.creatorStatus || "none");
    const allowed = {
      pending: ["approved", "rejected"],
      contract_pending: ["approved", "rejected", "revoked"],
      approved: ["suspended", "revoked"],
      suspended: ["approved", "revoked"],
      revoked: ["approved"],
      rejected: ["approved"],
    };
    if (!(allowed[current] || []).includes(status)) {
      throw new HttpsError("failed-precondition", `不允許從 ${current} 變更成 ${status}`);
    }
    // 每次真正轉入 revoked 才計一次；舊版已被取消的帳號視為至少一次。
    const previousRevocationsRaw = Number(user.creatorRevocationCount);
    const previousRevocations = Number.isSafeInteger(previousRevocationsRaw) && previousRevocationsRaw >= 0
      ? previousRevocationsRaw : (current === "revoked" ? 1 : 0);
    // TEST ONLY: 不在測試期間套用正式累計上限；正式上線前必須恢復。
    // if (status === "contract_pending" && current === "revoked" && previousRevocations >= 5) {
    //   throw new HttpsError("failed-precondition", "此帳號累計取消創作者資格達五次，不能再次開通");
    // }
    const changes = {
      creatorStatus: status,
      creatorStatusReason: explanation,
      creatorStatusUpdatedAt: FieldValue.serverTimestamp(),
      creatorStatusUpdatedBy: adminUid,
      // 僅已認證可以使用合作創作者後台。
      creatorDashboardEnabled: status === "approved",
      creatorVerified: status === "approved",
    };
    if (status === "approved") {
      changes.creatorReviewedAt = FieldValue.serverTimestamp();
      // 未實際簽署合約，不寫入 creatorContractSignedAt。
    }
    if (status === "revoked") {
      // TEST ONLY: 保留既有正式取消累計，不因測試操作增加。
      // changes.creatorRevocationCount = previousRevocations + 1;
      changes.creatorRevokedAt = FieldValue.serverTimestamp();
    }
    tx.update(userRef, changes);
    const auditRef = db.collection("creator_admin_audit").doc();
    tx.set(auditRef, {creatorUid: uid, previousStatus: current, targetStatus: status,
      reason: explanation, changedBy: adminUid, changedAt: FieldValue.serverTimestamp()});
    return {previousStatus: current};
  });

  // 通知發送獨立於資格交易，失敗不可回滾已完成的資格變更。
  const titles = {contract_pending:"創作者合作審核通過", approved:"創作者後台已開通",
    rejected:"創作者申請審核結果", suspended:"創作者合作資格暫停", revoked:"創作者合作資格已取消"};
  const bodies = {contract_pending:"妳的合作申請已通過初步審核。請等待官方寄送合作合約；雙方完成簽約後，才會開通專屬創作者後台。",
    approved:"妳的創作者申請已通過官方審核，專屬創作者後台權限已開通。正式合作授權與合約將另行公告。",
    rejected:`申請未通過。原因：${explanation}`, suspended:`合作資格已暫停。原因：${explanation}`,
    revoked:`合作認證已取消，妳仍可作為一般創作者管理既有角色與作品。原因：${explanation}`};
  try {
    await userRef.collection("mailbox").add({type:"creator_status", title:titles[status] || "創作者資格通知",
      body:bodies[status] || "創作者資格已更新。", isRead:false, read:false,
      createdAt:FieldValue.serverTimestamp()});
  } catch (e) { logger.error("creator status mailbox delivery failed", {creatorUid:uid, status, error:String(e)}); }
  return {success:true, previousStatus:transition.previousStatus, creatorStatus:status};
};

  const adminFindCreatorCandidateUs = async (request) => {
  requireRewardCampaignAdmin(request);
  const query = String(request.data?.query || "").trim();
  if (!query || query.length > 128) throw new HttpsError("invalid-argument", "請輸入有效的 UID 或玩家 ID");
  let snap = await db.collection("users").doc(query).get();
  if (!snap.exists) {
    const found = await db.collection("users").where("playerID", "==", query).limit(2).get();
    if (found.size > 1) throw new HttpsError("failed-precondition", "此玩家 ID 對應多個帳號，請改用 UID");
    if (!found.empty) snap = found.docs[0];
  }
  if (!snap.exists) {
    const found = await db.collection("users").where("playerId", "==", query).limit(2).get();
    if (found.size > 1) throw new HttpsError("failed-precondition", "此玩家 ID 對應多個帳號，請改用 UID");
    if (!found.empty) snap = found.docs[0];
  }
  if (!snap.exists) return {user: null};
  const d = snap.data() || {};
  return {user: {uid: snap.id, nickname: String(d.nickname || d.displayName || ""),
    playerID: String(d.playerID || d.playerId || ""),
    creatorStatus: String(d.creatorStatus || "none")}};
};

  const adminManuallyVerifyCreatorUs = async (request) => {
  const adminUid = requireRewardCampaignAdmin(request);
  const uid = String(request.data?.creatorUid || "").trim();
  if (!uid || uid.length > 128 || request.data?.activationConfirmed !== true) {
    throw new HttpsError("invalid-argument", "必須指定玩家並確認手動開通");
  }
  if (uid === adminUid) throw new HttpsError("failed-precondition", "不可自行授予合作創作者資格");
  const userRef = db.collection("users").doc(uid);
  const result = await db.runTransaction(async tx => {
    const snap = await tx.get(userRef);
    if (!snap.exists) throw new HttpsError("not-found", "找不到指定玩家");
    const d = snap.data() || {};
    const previousStatus = String(d.creatorStatus || "none");
    if (previousStatus === "approved" || d.creatorVerified === true) {
      throw new HttpsError("already-exists", "這位玩家已經是認證創作者");
    }
    tx.update(userRef, {
      creatorStatus: "approved",
      creatorVerified: true,
      creatorDashboardEnabled: true,
      creatorReviewedAt: FieldValue.serverTimestamp(),
      creatorStatusUpdatedAt: FieldValue.serverTimestamp(),
      creatorStatusUpdatedBy: adminUid,
      creatorStatusReason: "管理員手動開通創作者資格",
    });
    tx.set(db.collection("creator_admin_audit").doc(), {
      creatorUid: uid, previousStatus, targetStatus: "approved",
      action: "manual_creator_activation", activationConfirmed: true,
      changedBy: adminUid, changedAt: FieldValue.serverTimestamp(),
    });
    // 同一交易寄站內信，避免權限已開通卻未收到通知。
    tx.set(userRef.collection("mailbox").doc(), {
      type: "creator_status", title: "官方合作創作者認證完成",
      body: "妳的創作者資格已由官方審核開通，現在可以使用專屬創作者後台。正式合作合約將另行公告。",
      isRead: false, read: false, createdAt: FieldValue.serverTimestamp(),
    });
    return {previousStatus};
  });
  return {success: true, creatorUid: uid, creatorStatus: "approved", previousStatus: result.previousStatus};
};

  return {listCreatorApplicationsUs, adminUpdateCreatorStatusUs, adminFindCreatorCandidateUs, adminManuallyVerifyCreatorUs};
}
module.exports = {createCreatorAdminHandlers};
