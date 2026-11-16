'use strict';
// 新的一般客服案件 -> 管理員 FCM。僅 reports/{reportId} 建立時觸發。
// 事件可能至少執行一次；以固定通知收據避免同案重複推播。
function createAdminSupportReportNotification({db, FieldValue, adminUids, sendToUserDevices, logger}) {
  return async (event) => {
    const snapshot = event.data;
    if (!snapshot?.exists) return;
    const reportId = String(event.params?.reportId || snapshot.id || '').trim();
    if (!reportId) return;
    const data = snapshot.data() || {};
    // 只處理玩家從 FeedbackPage 建立的一般客服/檢舉案件。
    if (data.type !== 'feedback' || !String(data.reporterId || '').trim()) return;

    const caseNumber = String(data.caseNumber || '').trim().slice(0, 50);
    const title = '📩 收到新的客服案件';
    const body = caseNumber ? `有玩家提交客服案件（${caseNumber}），請至後台查看。` : '有玩家提交新的客服案件，請至後台查看。';
    const targets = [...adminUids].filter(uid => typeof uid === 'string' && uid.length);
    await Promise.allSettled(targets.map(async (uid) => {
      // 明確使用 UID + reportId，避免 Firebase 事件重試造成同案重複通知。
      const receipt = db.collection('users').doc(uid)
        .collection('admin_support_push_receipts').doc(reportId);
      try {
        await receipt.create({reportId, createdAt:FieldValue.serverTimestamp(), type:'support_new_report'});
      } catch (error) {
        if (error?.code === 6 || error?.code === 'already-exists') return;
        logger.warn('Admin support push receipt failed', {reportId, code:String(error?.code || '')});
        return;
      }
      try {
        const result = await sendToUserDevices(uid, {
          notification:{title,body},
          data:{type:'admin_support_report', reportId, click_action:'FLUTTER_NOTIFICATION_CLICK'},
          android:{priority:'high', notification:{channelId:'high_importance_channel', priority:'high', defaultSound:true}},
          apns:{payload:{aps:{sound:'default'}}},
        });
        logger.info('Admin support push sent', {reportId, successCount:result?.successCount || 0, failureCount:result?.failureCount || 0});
      } catch(error) {
        // 保持最多一次的通知語意：不自動重試，以免推播後因網路中斷再送一次。
        logger.warn('Admin support push failed', {reportId, code:String(error?.code || ''), message:String(error?.message || '')});
      }
    }));
  };
}
module.exports = {createAdminSupportReportNotification};
