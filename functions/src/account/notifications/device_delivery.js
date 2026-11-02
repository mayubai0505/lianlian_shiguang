'use strict';

// Verbatim extracted FCM token lookup and send logic.
function createDeviceDelivery({db, getMessaging}) {
async function getUserFcmTokens(userId) {

    const userRef = db.collection("users").doc(userId);

    const tokensSnapshot = await userRef.collection("fcmTokens").get();

    const tokens = tokensSnapshot.docs
        .map((doc) => {
            const data = doc.data() || {};
            return data.token || doc.id;
        })
        .filter((token) => typeof token === "string" && token.length > 20);

    if (tokens.length > 0) {
        return [...new Set(tokens)];
    }

    // 舊版相容：如果還沒有 fcmTokens 子集合，就退回讀 users/{uid}.fcmToken
    const userDoc = await userRef.get();
    if (!userDoc.exists) return [];

    const legacyToken = userDoc.data().fcmToken;

    if (typeof legacyToken === "string" && legacyToken.length > 20) {
        return [legacyToken];
    }

    return [];
}

async function sendToUserDevices(userId, messageBase) {
    const tokens = await getUserFcmTokens(userId);

    if (tokens.length === 0) {
        console.log(`玩家 ${userId} 沒有任何 FCM token，無法發送推播`);
        return { successCount: 0, failureCount: 0, tokenCount: 0 };
    }

    const response = await getMessaging().sendEachForMulticast({
        tokens,
        notification: messageBase.notification,
        data: messageBase.data || {},
        android: messageBase.android,
        apns: messageBase.apns,
    });

    console.log(`✅ 推播發送完成 user=${userId}, success=${response.successCount}, failure=${response.failureCount}`);


    const deleteTasks = [];

    response.responses.forEach((result, index) => {
        if (!result.success) {
            const code = result.error?.code || "";
            const badToken = tokens[index];

            console.error(
                `❌ 推播 token 失敗 user=${userId}, code=${code}, ` +
                `message=${result.error?.message || ""}`
            );

            if (
                code === "messaging/registration-token-not-registered" ||
                code === "messaging/invalid-registration-token"
            ) {
                deleteTasks.push(
                    db.collection("users")
                        .doc(userId)
                        .collection("fcmTokens")
                        .doc(badToken)
                        .delete()
                        .catch(() => null)
                );
            }
        }
    });

    if (deleteTasks.length > 0) {
        await Promise.all(deleteTasks);
    }
    return { successCount: response.successCount, failureCount: response.failureCount, tokenCount: tokens.length };
}



return {getUserFcmTokens, sendToUserDevices};
}
module.exports = {createDeviceDelivery};
