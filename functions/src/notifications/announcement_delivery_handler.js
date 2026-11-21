'use strict';

// Global announcement push: at most one delivery attempt per notification and
// at most one FCM send per distinct device token, even across different users.
// Never log FCM tokens or announcement content.
function createAnnouncementDeliveryHandler({
  db, FieldValue, normalizeNotificationLocale, getNotificationText,
  getUserFcmTokens, getMessaging,
}) {
  return async (event) => {
    const snapshot = event.data;
    if (!snapshot) return null;
    const notificationData = snapshot.data() || {};
    if (notificationData.type !== 'global_announcement') return null;

    const notificationId = String(event.params?.notificationId || snapshot.id || '').trim();
    const announcementId = String(notificationData.announcementId || '').trim();
    if (!notificationId || !announcementId) {
      console.error('公告推播略過：缺少 notificationId 或 announcementId');
      return null;
    }

    // Firestore events are at-least-once. Claim before any FCM send so a
    // duplicate invocation cannot broadcast again. A failed/partial delivery
    // is NOT retried automatically; review logs before an explicit resend.
    const notificationRef = db.collection('system_notifications').doc(notificationId);
    const claimed = await db.runTransaction(async (tx) => {
      const current = await tx.get(notificationRef);
      if (!current.exists || current.data()?.type !== 'global_announcement' ||
          current.data()?.announcementId !== announcementId) return false;
      if (current.data()?.announcementPush?.state) return false;
      tx.update(notificationRef, {
        announcementPush: {
          state: 'sending',
          startedAt: FieldValue.serverTimestamp(),
          eventId: String(event.id || ''),
        },
      });
      return true;
    });
    if (!claimed) {
      console.log('公告推播略過：已由另一事件處理', {notificationId, announcementId});
      return null;
    }

    let status = 'completed';
    let successCount = 0;
    let failureCount = 0;
    let tokenCount = 0;
    let duplicateTokens = 0;
    try {
      const announcementSnapshot = await db.collection('announcements').doc(announcementId).get();
      if (!announcementSnapshot.exists) throw new Error('announcement_missing');
      const announcementData = announcementSnapshot.data() || {};
      const originalTitle = String(announcementData.title || '').trim();
      const originalContent = String(announcementData.content || '').trim();
      const translations = announcementData.translations &&
        typeof announcementData.translations === 'object' ? announcementData.translations : {};

      const usersSnapshot = await db.collection('users').get();
      const users = usersSnapshot.docs;
      const uniqueTokens = new Set();
      const byLocale = new Map();
      // Bounded concurrency avoids serial per-user Firestore reads taking
      // several minutes and minimizes Cloud Function timeout risk.
      const workers = Array.from({length: Math.min(12, users.length)}, async (_, worker) => {
        for (let i = worker; i < users.length; i += 12) {
          const userDoc = users[i];
          try {
            const userData = userDoc.data() || {};
            const locale = normalizeNotificationLocale(
              userData.notificationLocale || userData.locale ||
              userData.languageCode || userData.language || 'zh_Hant',
            );
            const tokens = await getUserFcmTokens(userDoc.id);
            for (const token of tokens) {
              if (uniqueTokens.has(token)) { duplicateTokens++; continue; }
              uniqueTokens.add(token);
              if (!byLocale.has(locale)) byLocale.set(locale, []);
              byLocale.get(locale).push(token);
            }
          } catch (error) {
            failureCount++;
            console.error('公告推播取得裝置失敗', {userId: userDoc.id, code: error?.code || 'unknown'});
          }
        }
      });
      await Promise.all(workers);
      tokenCount = uniqueTokens.size;

      const messaging = getMessaging();
      for (const [locale, tokens] of byLocale.entries()) {
        const translated = translations[locale] && typeof translations[locale] === 'object'
          ? translations[locale] : null;
        const genericText = getNotificationText(locale, 'announcement');
        const title = String(translated?.title || originalTitle || genericText.title).trim();
        const content = String(translated?.content || originalContent || genericText.body).trim();
        const body = content.length > 140 ? `${content.slice(0, 137)}...` : content;

        for (let offset = 0; offset < tokens.length; offset += 500) {
          const batch = tokens.slice(offset, offset + 500);
          try {
            const response = await messaging.sendEachForMulticast({
              tokens: batch,
              notification: {title, body: body || genericText.body},
              data: {type: 'global_announcement', announcementId, notificationId},
              android: {priority: 'high', notification: {
                channelId: 'high_importance_channel', sound: 'default',
                // Same announcement replaces itself on Android if OS displays twice.
                tag: `announcement_${announcementId}`,
              }},
              apns: {headers: {'apns-priority': '10'}, payload: {aps: {
                sound: 'default', 'thread-id': `announcement_${announcementId}`,
              }}},
            });
            successCount += response.successCount || 0;
            failureCount += response.failureCount || 0;
          } catch (error) {
            failureCount += batch.length;
            console.error('公告推播批次失敗', {notificationId, locale, count: batch.length,
              code: error?.code || 'unknown'});
          }
        }
      }
      if (failureCount > 0) status = 'partial';
    } catch (error) {
      status = 'failed';
      console.error('全服公告推播失敗', {notificationId, announcementId,
        code: error?.code || error?.message || 'unknown'});
    } finally {
      try {
        await notificationRef.update({
          'announcementPush.state': status,
          'announcementPush.finishedAt': FieldValue.serverTimestamp(),
          'announcementPush.successCount': successCount,
          'announcementPush.failureCount': failureCount,
          'announcementPush.uniqueTokenCount': tokenCount,
          'announcementPush.duplicateTokensSkipped': duplicateTokens,
        });
      } catch (error) {
        console.error('公告推播狀態寫入失敗', {notificationId, code: error?.code || 'unknown'});
      }
      console.log('全服公告推播結果', {notificationId, announcementId, status,
        successCount, failureCount, tokenCount, duplicateTokens});
    }
    return null;
  };
}

module.exports = {createAnnouncementDeliveryHandler};
