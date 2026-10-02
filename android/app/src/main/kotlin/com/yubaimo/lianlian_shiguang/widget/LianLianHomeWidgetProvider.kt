package com.yubaimo.lianlian_shiguang.widget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import com.yubaimo.lianlian_shiguang.MainActivity
import com.yubaimo.lianlian_shiguang.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File

class LianLianHomeWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val configId = resolveConfigId(
                widgetId = widgetId,
                widgetData = widgetData,
            )

            val views = RemoteViews(
                context.packageName,
                R.layout.lianlian_home_widget,
            )

            if (configId != null &&
                widgetData.getBoolean(
                    key(configId, "disabled"),
                    false,
                )
            ) {
                bindDisabledWidget(views)
            } else {
                bindActiveWidget(
                    views = views,
                    widgetData = widgetData,
                    configId = configId,
                )
            }

            val characterId =
                if (configId == null) {
                    widgetData.getString(
                        "widget_character_id",
                        "",
                    ) ?: ""
                } else {
                    widgetData.getString(
                        key(configId, "character_id"),
                        "",
                    ) ?: ""
                }

            val pendingIntent =
                if (characterId.isNotBlank()) {
                    HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse(
                            "lianlian://widget/chat?characterId=" +
                                Uri.encode(characterId),
                        ),
                    )
                } else {
                    HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                    )
                }

            views.setOnClickPendingIntent(
                R.id.widget_root,
                pendingIntent,
            )

            appWidgetManager.updateAppWidget(
                widgetId,
                views,
            )
        }
    }

    /**
     * Every Android launcher widget has its own appWidgetId.
     * The first time a newly pinned widget is updated, bind that
     * Android id to the config id prepared by Flutter.
     */
    private fun resolveConfigId(
        widgetId: Int,
        widgetData: SharedPreferences,
    ): String? {
        val bindingKey = "widget_binding_$widgetId"

        val existing =
            widgetData.getString(bindingKey, null)
                ?.trim()
                .orEmpty()

        if (existing.isNotEmpty()) {
            return existing
        }

        val pending =
            widgetData.getString(
                "widget_pending_config_id",
                null,
            )
                ?.trim()
                .orEmpty()

        if (pending.isEmpty()) {
            // Legacy widget created before per-instance binding.
            return null
        }

        widgetData.edit()
            .putString(bindingKey, pending)
            .remove("widget_pending_config_id")
            .apply()

        return pending
    }

    private fun bindActiveWidget(
        views: RemoteViews,
        widgetData: SharedPreferences,
        configId: String?,
    ) {
        val characterName = readString(
            widgetData = widgetData,
            configId = configId,
            field = "character_name",
            legacyKey = "widget_character_name",
            fallback = "戀戀拾光",
        )

        val line1 = readString(
            widgetData,
            configId,
            "line_1",
            "widget_line_1",
            "",
        )
        val line2 = readString(
            widgetData,
            configId,
            "line_2",
            "widget_line_2",
            "",
        )
        val line3 = readString(
            widgetData,
            configId,
            "line_3",
            "widget_line_3",
            "",
        )

        views.setTextViewText(
            R.id.widget_character_name,
            characterName,
        )
        bindLine(views, R.id.widget_line_1, line1)
        bindLine(views, R.id.widget_line_2, line2)
        bindLine(views, R.id.widget_line_3, line3)

        val imageKey =
            if (configId == null) {
                "widget_image"
            } else {
                key(configId, "image")
            }

        val imagePath =
            widgetData.getString(imageKey, null)

        var imageVisible = false

        if (!imagePath.isNullOrBlank()) {
            val imageFile = File(imagePath)

            if (imageFile.exists()) {
                val bitmap =
                    BitmapFactory.decodeFile(
                        imageFile.absolutePath,
                    )

                if (bitmap != null) {
                    views.setImageViewBitmap(
                        R.id.widget_character_image,
                        bitmap,
                    )
                    views.setViewVisibility(
                        R.id.widget_character_image,
                        View.VISIBLE,
                    )
                    imageVisible = true
                }
            }
        }

        if (!imageVisible) {
            views.setViewVisibility(
                R.id.widget_character_image,
                View.GONE,
            )
        }
    }

    private fun bindDisabledWidget(
        views: RemoteViews,
    ) {
        views.setTextViewText(
            R.id.widget_character_name,
            "戀戀拾光",
        )

        bindLine(
            views,
            R.id.widget_line_1,
            "此小工具已從 App 移除",
        )
        bindLine(
            views,
            R.id.widget_line_2,
            "請長按桌面移除，或回 App 重新建立。",
        )
        bindLine(
            views,
            R.id.widget_line_3,
            "",
        )

        views.setViewVisibility(
            R.id.widget_character_image,
            View.GONE,
        )
    }

    private fun readString(
        widgetData: SharedPreferences,
        configId: String?,
        field: String,
        legacyKey: String,
        fallback: String,
    ): String {
        val value =
            if (configId == null) {
                widgetData.getString(
                    legacyKey,
                    fallback,
                )
            } else {
                widgetData.getString(
                    key(configId, field),
                    fallback,
                )
            }

        return value ?: fallback
    }

    private fun key(
        configId: String,
        field: String,
    ): String {
        return "widget_${configId}_$field"
    }

    override fun onDeleted(
        context: Context,
        appWidgetIds: IntArray,
    ) {
        super.onDeleted(context, appWidgetIds)

        // Only remove Android-id bindings. Keep App-side configs intact:
        // removing a widget from the launcher should not delete the user's
        // saved setup inside the app.
        val prefs =
            context.getSharedPreferences(
                "HomeWidgetPreferences",
                Context.MODE_PRIVATE,
            )

        val editor = prefs.edit()

        appWidgetIds.forEach { widgetId ->
            editor.remove("widget_binding_$widgetId")
        }

        editor.apply()
    }

    private fun bindLine(
        views: RemoteViews,
        viewId: Int,
        value: String,
    ) {
        if (value.isBlank()) {
            views.setViewVisibility(
                viewId,
                View.GONE,
            )
        } else {
            views.setViewVisibility(
                viewId,
                View.VISIBLE,
            )
            views.setTextViewText(
                viewId,
                value,
            )
        }
    }
}
