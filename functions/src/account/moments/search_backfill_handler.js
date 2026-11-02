'use strict';

// Maintains the original admin-only public moment search index backfill.
function createMomentSearchBackfillHandler({db, APP_ID, HttpsError, FieldPath, FieldValue, buildMomentSearchKeywords}) {
  return async (request) => {
    const officialCreatorUids = new Set([
      "B71k2kyooubYsOtIO1nkiBwyBXt2",
    ]);

    const uid = request.auth?.uid;

    if (!uid) {
      throw new HttpsError(
        "unauthenticated",
        "請先登入管理員帳號"
      );
    }

    if (!officialCreatorUids.has(uid)) {
      throw new HttpsError(
        "permission-denied",
        "你沒有執行貼文索引補建的權限"
      );
    }

    const momentsRef = db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("moments");

    let lastDocument = null;
    let scannedCount = 0;
    let updatedCount = 0;
    let batchCount = 0;

    try {
      while (true) {
        let query = momentsRef
          .where("isPublic", "==", true)
          .orderBy(FieldPath.documentId())
          .limit(350);

        if (lastDocument) {
          query = query.startAfter(lastDocument);
        }

        const snapshot = await query.get();

        if (snapshot.empty) {
          break;
        }

        const batch = db.batch();

        for (const document of snapshot.docs) {
          const data = document.data();

          const searchKeywords =
            buildMomentSearchKeywords(
              data.content,
              data.authorName
            );

          batch.update(document.ref, {
            searchKeywords,
            searchIndexedAt:
              FieldValue.serverTimestamp(),
          });

          scannedCount++;
          updatedCount++;
        }

        await batch.commit();

        batchCount++;
        lastDocument =
          snapshot.docs[snapshot.docs.length - 1];

        console.log(
          `🔎 搜尋索引補建：已完成 ${updatedCount} 篇，` +
          `目前批次 ${batchCount}`
        );

        if (snapshot.size < 350) {
          break;
        }
      }

      return {
        success: true,
        scannedCount,
        updatedCount,
        batchCount,
      };
    } catch (error) {
      console.error(
        "❌ 舊公開貼文搜尋索引補建失敗：",
        error
      );

      throw new HttpsError(
        "internal",
        "補建搜尋索引失敗",
        {
          scannedCount,
          updatedCount,
          batchCount,
          message:
            error?.message || String(error),
        }
      );
    }
  };
}

module.exports = {createMomentSearchBackfillHandler};
