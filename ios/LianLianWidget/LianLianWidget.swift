//
//  LianLianWidget.swift
//  LianLianWidget
//
//  iOS Home Widget for 戀戀拾光
//

import WidgetKit
import SwiftUI
import UIKit

private let appGroupId = "group.com.yubaimo.lianlian_shiguang"

struct LianLianWidgetEntry: TimelineEntry {
    let date: Date
    let widgetType: String
    let characterName: String
    let layout: String
    let lines: [String]
    let imagePath: String?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> LianLianWidgetEntry {
        LianLianWidgetEntry(
            date: Date(),
            widgetType: "character_status",
            characterName: "程聿",
            layout: "full_background",
            lines: [
                "心情｜平靜",
                "狀態｜正在想妳",
                "地點｜拾光咖啡館"
            ],
            imagePath: nil
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (LianLianWidgetEntry) -> Void
    ) {
        completion(loadEntry())
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<LianLianWidgetEntry>) -> Void
    ) {
        let entry = loadEntry()

        // Flutter 端 HomeWidget.updateWidget(...) 會主動要求重新整理。
        // 這裡不用固定每小時硬刷新。
        let timeline = Timeline(
            entries: [entry],
            policy: .never
        )

        completion(timeline)
    }

    private func loadEntry() -> LianLianWidgetEntry {
        let defaults = UserDefaults(
            suiteName: appGroupId
        )

        let widgetType =
            defaults?.string(
                forKey: "widget_type"
            ) ?? "character_status"

        let characterName =
            defaults?.string(
                forKey: "widget_character_name"
            ) ?? "戀戀拾光"

        let layout =
            defaults?.string(
                forKey: "widget_layout"
            ) ?? "full_background"

        let lines = [
            defaults?.string(
                forKey: "widget_line_1"
            ) ?? "",
            defaults?.string(
                forKey: "widget_line_2"
            ) ?? "",
            defaults?.string(
                forKey: "widget_line_3"
            ) ?? "",
            defaults?.string(
                forKey: "widget_line_4"
            ) ?? ""
        ]
        .filter {
            !$0.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).isEmpty
        }

        let imagePath =
            defaults?.string(
                forKey: "widget_image"
            )

        return LianLianWidgetEntry(
            date: Date(),
            widgetType: widgetType,
            characterName: characterName,
            layout: layout,
            lines: lines,
            imagePath: imagePath
        )
    }
}

struct LianLianWidgetEntryView: View {
    @Environment(\.widgetFamily)
    private var family

    let entry: LianLianWidgetEntry

    private var loadedImage: UIImage? {
        guard
            let path = entry.imagePath,
            !path.isEmpty
        else {
            return nil
        }

        if path.hasPrefix("file://"),
           let url = URL(string: path) {
            return UIImage(
                contentsOfFile: url.path
            )
        }

        return UIImage(
            contentsOfFile: path
        )
    }

    private var maxLineCount: Int {
        switch family {
        case .systemSmall:
            return 2

        case .systemMedium:
            return 3

        case .systemLarge:
            return 4

        default:
            return 3
        }
    }

    private var titleFontSize: CGFloat {
        switch family {
        case .systemSmall:
            return 15

        case .systemMedium:
            return 17

        case .systemLarge:
            return 19

        default:
            return 16
        }
    }

    private var lineFontSize: CGFloat {
        switch family {
        case .systemSmall:
            return 11

        case .systemMedium:
            return 12

        case .systemLarge:
            return 13

        default:
            return 12
        }
    }

    var body: some View {
        ZStack {
            backgroundLayer

            LinearGradient(
                colors: [
                    Color.black.opacity(
                        loadedImage == nil
                            ? 0.00
                            : 0.08
                    ),
                    Color.black.opacity(
                        loadedImage == nil
                            ? 0.00
                            : 0.48
                    )
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            contentLayer
        }
    }

    @ViewBuilder
    private var backgroundLayer: some View {
        if
            entry.layout == "full_background",
            let image = loadedImage
        {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Color(
                red: 0.97,
                green: 0.95,
                blue: 0.98
            )
        }
    }

    private var contentLayer: some View {
        VStack(
            alignment: .leading,
            spacing: family == .systemSmall
                ? 5
                : 7
        ) {
            Spacer(
                minLength: 0
            )

            Text(
                entry.characterName.isEmpty
                    ? "戀戀拾光"
                    : entry.characterName
            )
            .font(
                .system(
                    size: titleFontSize,
                    weight: .semibold,
                    design: .serif
                )
            )
            .foregroundStyle(
                loadedImage == nil
                    ? Color.primary
                    : Color.white
            )
            .lineLimit(1)

            ForEach(
                Array(
                    entry.lines
                        .prefix(maxLineCount)
                        .enumerated()
                ),
                id: \.offset
            ) { _, line in
                Text(line)
                    .font(
                        .system(
                            size: lineFontSize,
                            weight: .regular,
                            design: .serif
                        )
                    )
                    .foregroundStyle(
                        loadedImage == nil
                            ? Color.primary.opacity(0.78)
                            : Color.white.opacity(0.94)
                    )
                    .lineLimit(
                        family == .systemLarge
                            ? 2
                            : 1
                    )
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .bottomLeading
        )
        .padding(
            family == .systemSmall
                ? 14
                : 16
        )
    }
}

struct LianLianWidget: Widget {
    // 必須跟 Flutter DesktopWidgetNativeService.iosWidgetKind 完全一致。
    let kind: String = "LianLianHomeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            if #available(iOS 17.0, *) {
                LianLianWidgetEntryView(
                    entry: entry
                )
                .containerBackground(
                    .clear,
                    for: .widget
                )
            } else {
                LianLianWidgetEntryView(
                    entry: entry
                )
            }
        }
        .configurationDisplayName(
            "戀戀拾光"
        )
        .description(
            "把喜歡的角色與陪伴內容放在桌面。"
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge
        ])
    }
}

#Preview(
    as: .systemSmall
) {
    LianLianWidget()
} timeline: {
    LianLianWidgetEntry(
        date: .now,
        widgetType: "character_status",
        characterName: "程聿",
        layout: "full_background",
        lines: [
            "心情｜平靜",
            "狀態｜正在想妳"
        ],
        imagePath: nil
    )
}
