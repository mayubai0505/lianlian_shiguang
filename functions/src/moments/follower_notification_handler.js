'use strict';

// V87: Keep the original follower notification handler intact.
// Dependency injection avoids re-initializing Firebase Admin in this module.
function createMomentFollowersNotificationHandler({db, FieldValue, getUserNotificationLocale, getNotificationText, sendToUserDevices}) {
  return     async (event) => {
        const snap = event.data;
        if (!snap) return null;

        const moment = snap.data() || {};
        const {appId, momentId} = event.params;
        if (moment.isPublic !== true) return null;

        const isCreatorPost = moment.isCreatorPost === true;
        let creatorId = "";
        let actorName = String(moment.authorName || "").trim();
        let characterId = "";

        if (isCreatorPost) {
            creatorId = String(moment.createdBy || moment.authorId || "").trim();
        } else {
            characterId = String(moment.authorId || "").trim();
            if (!characterId) return null;

            const charSnap = await db
                .collection("artifacts")
                .doc(appId)
                .collection("public_characters")
                .doc(characterId)
                .get();
            if (!charSnap.exists) return null;

            const charData = charSnap.data() || {};
            creatorId = String(charData.createdBy || moment.createdBy || "").trim();
            actorName = actorName || String(charData.name || "角色").trim();
        }

        if (!creatorId) return null;

        if (!actorName) {
            const creatorSnap = await db.collection("users").doc(creatorId).get();
            const creatorData = creatorSnap.data() || {};
            actorName = String(
                creatorData.nickname ||
                creatorData.displayName ||
                creatorData.name ||
                "創作者"
            ).trim();
        }

        const followersSnap = await db
            .collection("users")
            .doc(creatorId)
            .collection("followers")
            .get();
        if (followersSnap.empty) return null;

        let batch = db.batch();
        let operationCount = 0;

        const commitIfNeeded = async (force = false) => {
            if (operationCount === 0) return;
            if (force || operationCount >= 350) {
                await batch.commit();
                batch = db.batch();
                operationCount = 0;
            }
        };

        for (const followerDoc of followersSnap.docs) {
            const followerId = String(followerDoc.id || "").trim();
            if (!followerId || followerId === creatorId) continue;

            const blockedCreatorSnap = await db
                .collection("users")
                .doc(followerId)
                .collection("blockedCreators")
                .doc(creatorId)
                .get();
            if (blockedCreatorSnap.exists) continue;

            if (characterId) {
                const blockedCharacterSnap = await db
                    .collection("users")
                    .doc(followerId)
                    .collection("blockedCharacters")
                    .doc(characterId)
                    .get();
                if (blockedCharacterSnap.exists) continue;
            }

            const locale = await getUserNotificationLocale(followerId);
            const notificationType = isCreatorPost
                ? "creator_moment"
                : "character_moment";
            const text = getNotificationText(locale, notificationType, {
                name: actorName,
            });

            // 角色的新瞬間僅發 FCM 橫幅，不存進私人信箱。
            // 直接推播不設定 aps.badge，避免改動信箱未讀徽章。
            if (!isCreatorPost) {
                try {
                    await sendToUserDevices(followerId, {
                        notification: {
                            title: text.title,
                            body: text.body,
                        },
                        data: {
                            type: "character_moment",
                            postId: String(momentId),
                            characterId: String(characterId),
                            creatorId: String(creatorId),
                            click_action: "FLUTTER_NOTIFICATION_CLICK",
                        },
                        android: {
                            priority: "high",
                            notification: {
                                channelId: "high_importance_channel",
                                sound: "default",
                                defaultVibrateTimings: true,
                            },
                        },
                        apns: {
                            payload: {aps: {sound: "default"}},
                        },
                    });
                } catch (error) {
                    console.warn(`角色新瞬間推播失敗 follower=${followerId}, moment=${momentId}`, error);
                }
                continue;
            }

            // 創作者本人發文維持既有信箱與推播行為。
            const mailRef = db
                .collection("users")
                .doc(followerId)
                .collection("mailbox")
                .doc(`${notificationType}_${momentId}`);

            batch.set(mailRef, {
                type: notificationType,
                title: text.title,
                body: text.body,
                fromId: isCreatorPost ? creatorId : characterId,
                fromName: actorName,
                creatorId,
                characterId: characterId || null,
                postId: momentId,
                source: "followed_creator_moment",
                notificationLocale: locale,
                isRead: false,
                read: false,
                createdAt: FieldValue.serverTimestamp(),
            });
            operationCount++;
            await commitIfNeeded();
        }

        await commitIfNeeded(true);
        return null;
    };
}

module.exports = {createMomentFollowersNotificationHandler};
