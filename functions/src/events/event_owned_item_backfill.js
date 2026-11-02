'use strict';
// Preserve original one-time event-item timestamp backfill behavior.
function createEventOwnedItemBackfillHandler({db,APP_ID,FieldValue,HttpsError}) {
  return     async (request) => {
        const userId = request.auth?.uid;

        if (!userId) {
            throw new HttpsError(
                "unauthenticated",
                "請先登入"
            );
        }

        const userRef =
            db.collection("users").doc(userId);

        const userSnapshot =
            await userRef.get();

        const userData =
            userSnapshot.exists
                ? (userSnapshot.data() || {})
                : {};

        if (
            userData
                .eventOwnedItemAcquiredAtBackfillV1Done === true
        ) {
            return {
                success: true,
                alreadyDone: true,
                updatedItems: 0,
            };
        }

        const eventsRef =
            db.collection("artifacts")
                .doc(APP_ID)
                .collection("event_progress")
                .doc(userId)
                .collection("events");

        const eventsSnapshot =
            await eventsRef.get();

        let updatedItems = 0;
        let scannedEvents = 0;

        for (const eventDoc of eventsSnapshot.docs) {
            scannedEvents++;

            const progressData =
                eventDoc.data() || {};

            const rawOwned =
                progressData.ownedEventItems;

            if (
                !rawOwned ||
                typeof rawOwned !== "object"
            ) {
                continue;
            }

            const ownedEventItems = {
                ...rawOwned,
            };

            const missingItemIds =
                Object.entries(ownedEventItems)
                    .filter(([_, item]) => {
                        return (
                            item &&
                            typeof item === "object" &&
                            !item.acquiredAt
                        );
                    })
                    .map(([itemId]) => itemId);

            if (missingItemIds.length === 0) {
                continue;
            }

            const redemptionsSnapshot =
                await eventDoc.ref
                    .collection("shop_redemptions")
                    .orderBy("redeemedAt", "asc")
                    .get();

            const firstRedeemedAtByItem =
                new Map();

            for (
                const redemptionDoc
                of redemptionsSnapshot.docs
            ) {
                const redemption =
                    redemptionDoc.data() || {};

                const itemId =
                    String(
                        redemption.itemId || ""
                    ).trim();

                if (
                    !itemId ||
                    firstRedeemedAtByItem.has(itemId)
                ) {
                    continue;
                }

                const redeemedAt =
                    redemption.redeemedAt;

                if (redeemedAt) {
                    firstRedeemedAtByItem.set(
                        itemId,
                        redeemedAt
                    );
                }
            }

            let changed = false;

            for (const itemId of missingItemIds) {
                const acquiredAt =
                    firstRedeemedAtByItem.get(itemId);

                if (!acquiredAt) {
                    continue;
                }

                ownedEventItems[itemId] = {
                    ...ownedEventItems[itemId],
                    acquiredAt,
                };

                updatedItems++;
                changed = true;
            }

            if (changed) {
                await eventDoc.ref.set(
                    {
                        ownedEventItems,
                        updatedAt:
                            FieldValue.serverTimestamp(),
                    },
                    { merge: true }
                );
            }
        }

        await userRef.set(
            {
                eventOwnedItemAcquiredAtBackfillV1Done:
                    true,
                eventOwnedItemAcquiredAtBackfillV1At:
                    FieldValue.serverTimestamp(),
            },
            { merge: true }
        );

        console.log(
            "🕰️ 活動收藏日期補正完成",
            {
                userId,
                scannedEvents,
                updatedItems,
            }
        );

        return {
            success: true,
            alreadyDone: false,
            scannedEvents,
            updatedItems,
        };
    };
}
module.exports={createEventOwnedItemBackfillHandler};
