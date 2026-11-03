'use strict';
// V72：活動多語翻譯 callable 處理器。僅搬移原處理內容，不變動翻譯次序／語系／權限。
function createEventContentTranslationHandler({
  requireRewardCampaignAdmin, eventTextRecord, EVENT_TRANSLATION_TARGETS,
  translateEventTextRecord,
}) {
  return async (request) => {
    requireRewardCampaignAdmin(request);

    const data = request.data || {};

    const eventSource =
      eventTextRecord(
        data.event,
        [
          "name",
          "subtitle",
          "description",
          "currencyName",
        ]
      );

    const taskSources =
      Array.isArray(data.tasks)
        ? data.tasks.map((item) =>
            eventTextRecord(
              item,
              ["title", "description"]
            )
          )
        : [];

    const milestoneSources =
      Array.isArray(data.milestones)
        ? data.milestones.map((item) =>
            eventTextRecord(
              item,
              ["title", "description"]
            )
          )
        : [];

    const shopSources =
      Array.isArray(data.shopItems)
        ? data.shopItems.map((item) =>
            eventTextRecord(
              item,
              ["title", "name", "description"]
            )
          )
        : [];

    const memorySources =
      Array.isArray(data.memories)
        ? data.memories.map((memory) => ({
            content: eventTextRecord(
              memory,
              ["title", "subtitle", "description"]
            ),
            scenes:
              Array.isArray(memory?.scenes)
                ? memory.scenes.map((scene) =>
                    eventTextRecord(
                      scene,
                      ["text"]
                    )
                  )
                : [],
          }))
        : [];

    const localized = {
      event: {},
      tasks: taskSources.map(() => ({})),
      milestones: milestoneSources.map(() => ({})),
      shopItems: shopSources.map(() => ({})),
      memories: memorySources.map((memory) => ({
        scenes: memory.scenes.map(() => ({})),
      })),
    };

    for (
      const [localeKey, targetLanguage]
      of Object.entries(EVENT_TRANSLATION_TARGETS)
    ) {
      localized.event[localeKey] =
        await translateEventTextRecord(
          eventSource,
          targetLanguage
        );

      for (let i = 0; i < taskSources.length; i++) {
        localized.tasks[i][localeKey] =
          await translateEventTextRecord(
            taskSources[i],
            targetLanguage
          );
      }

      for (let i = 0; i < milestoneSources.length; i++) {
        localized.milestones[i][localeKey] =
          await translateEventTextRecord(
            milestoneSources[i],
            targetLanguage
          );
      }

      for (let i = 0; i < shopSources.length; i++) {
        localized.shopItems[i][localeKey] =
          await translateEventTextRecord(
            shopSources[i],
            targetLanguage
          );
      }

      for (let i = 0; i < memorySources.length; i++) {
        localized.memories[i][localeKey] =
          await translateEventTextRecord(
            memorySources[i].content,
            targetLanguage
          );

        for (
          let j = 0;
          j < memorySources[i].scenes.length;
          j++
        ) {
          localized.memories[i].scenes[j][localeKey] =
            await translateEventTextRecord(
              memorySources[i].scenes[j],
              targetLanguage
            );
        }
      }
    }

    console.log("✅ 活動多語翻譯完成", {
      eventName: eventSource.name || "",
      locales:
        Object.keys(EVENT_TRANSLATION_TARGETS),
      taskCount: taskSources.length,
      milestoneCount: milestoneSources.length,
      shopItemCount: shopSources.length,
      memoryCount: memorySources.length,
    });

    return {
      success: true,
      sourceLocale: "zh_Hant",
      localized,
    };
  };
}

module.exports = {createEventContentTranslationHandler};
