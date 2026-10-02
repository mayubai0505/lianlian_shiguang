import SwiftUI
import WidgetKit

private let appGroupId = "group.com.yubaimo.lianlian_shiguang"
private let widgetKind = "LianLianHomeWidget"

struct LianLianWidgetEntry: TimelineEntry {
    let date: Date
    let characterName: String
    let line1: String
    let line2: String
    let line3: String
    let image: UIImage?
}

struct LianLianWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> LianLianWidgetEntry {
        LianLianWidgetEntry(
            date: Date(),
            characterName: "程聿",
            line1: "心情｜有點疲倦",
            line2: "狀態｜剛結束工作",
            line3: "地點｜公司樓下",
            image: nil
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
        completion(
            Timeline(
                entries: [entry],
                policy: .never
            )
        )
    }

    private func loadEntry() -> LianLianWidgetEntry {
        let prefs = UserDefaults(suiteName: appGroupId)

        let name =
            prefs?.string(forKey: "widget_character_name")
            ?? "戀戀拾光"

        let line1 =
            prefs?.string(forKey: "widget_line_1")
            ?? ""

        let line2 =
            prefs?.string(forKey: "widget_line_2")
            ?? ""

        let line3 =
            prefs?.string(forKey: "widget_line_3")
            ?? ""

        var image: UIImage? = nil

        if let path = prefs?.string(forKey: "widget_image"),
           FileManager.default.fileExists(atPath: path) {
            image = UIImage(contentsOfFile: path)
        }

        return LianLianWidgetEntry(
            date: Date(),
            characterName: name,
            line1: line1,
            line2: line2,
            line3: line3,
            image: image
        )
    }
}

struct LianLianWidgetEntryView: View {
    var entry: LianLianWidgetProvider.Entry

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = entry.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.94, green: 0.87, blue: 0.97),
                        Color(red: 0.99, green: 0.96, blue: 0.98)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }

            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.72)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.characterName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)

                if !entry.line1.isEmpty {
                    Text(entry.line1)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.95))
                        .lineLimit(2)
                }

                if !entry.line2.isEmpty {
                    Text(entry.line2)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.90))
                        .lineLimit(1)
                }

                if !entry.line3.isEmpty {
                    Text(entry.line3)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.90))
                        .lineLimit(1)
                }
            }
            .padding(14)
        }
        .clipped()
        .widgetURL(URL(string: "lianlianshiguang://widget"))
    }
}

struct LianLianHomeWidget: Widget {
    let kind: String = widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: LianLianWidgetProvider()
        ) { entry in
            LianLianWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("戀戀拾光")
        .description("讓喜歡的角色陪妳出現在每一天。")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge
        ])
    }
}

@main
struct LianLianWidgetBundle: WidgetBundle {
    var body: some Widget {
        LianLianHomeWidget()
    }
}
