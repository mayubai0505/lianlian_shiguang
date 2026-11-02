'use strict';
// Dependency-injected existing admin health handler; permission check stays first.
function createAdminSystemHealthHandler({requireRewardCampaignAdmin,getAiHealthTaipeiDateKey,db,APP_ID}) {
const getAdminSystemHealthHandler = async (request) => {
    requireRewardCampaignAdmin(
      request
    );

    const dateKey =
      getAiHealthTaipeiDateKey();

    const snapshot = await db
      .collection("artifacts")
      .doc(APP_ID)
      .collection("ai_usage_daily")
      .doc(dateKey)
      .get();

    if (!snapshot.exists) {
      return {
        dateKey,

        requests: 0,
        apiAttempts: 0,

        successCount: 0,
        failureCount: 0,
        cancelledCount: 0,

        fallbackCount: 0,
        contentFilterCount: 0,
        timeoutCount: 0,

        totalLatencyMs: 0,

        inputTokens: 0,
        outputTokens: 0,
        totalTokens: 0,

        successRate: 0,
        failureRate: 0,
        fallbackRate: 0,

        averageLatencyMs: 0,

        lastModelId: "",
      };
    }

    const data =
      snapshot.data() || {};

    const requests =
      Number(
        data.requests || 0
      );

    const successCount =
      Number(
        data.successCount || 0
      );

    const failureCount =
      Number(
        data.failureCount || 0
      );

    const fallbackCount =
      Number(
        data.fallbackCount || 0
      );

    const totalLatencyMs =
      Number(
        data.totalLatencyMs || 0
      );

    // 玩家自己取消的不列入成功 / 失敗率分母
    const completedRequests =
      successCount +
      failureCount;

    const successRate =
      completedRequests > 0
        ? successCount /
          completedRequests *
          100
        : 0;

    const failureRate =
      completedRequests > 0
        ? failureCount /
          completedRequests *
          100
        : 0;

    const fallbackRate =
      requests > 0
        ? fallbackCount /
          requests *
          100
        : 0;

    const averageLatencyMs =
      requests > 0
        ? totalLatencyMs /
          requests
        : 0;

    return {
      dateKey,

      requests,

      apiAttempts:
        Number(
          data.apiAttempts || 0
        ),

      successCount,
      failureCount,

      cancelledCount:
        Number(
          data.cancelledCount || 0
        ),

      fallbackCount,

      contentFilterCount:
        Number(
          data.contentFilterCount || 0
        ),

      timeoutCount:
        Number(
          data.timeoutCount || 0
        ),

      totalLatencyMs,

      inputTokens:
        Number(
          data.inputTokens || 0
        ),

      outputTokens:
        Number(
          data.outputTokens || 0
        ),

      totalTokens:
        Number(
          data.totalTokens || 0
        ),

      successRate,
      failureRate,
      fallbackRate,
      averageLatencyMs,

      lastModelId:
        String(
          data.lastModelId || ""
        ),
    };
  };
return getAdminSystemHealthHandler;
}
module.exports={createAdminSystemHealthHandler};
