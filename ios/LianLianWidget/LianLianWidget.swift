import WidgetKit
import SwiftUI
import UIKit
import ImageIO
import AppIntents

private let appGroupId = "group.com.yubaimo.lianlian_shiguang"

private enum LLSize: String {
    case small, medium, large

    var title: String {
        switch self {
        case .small: return "小"
        case .medium: return "中"
        case .large: return "大"
        }
    }
}

private enum LLStore {
    static var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroupId)
    }

    static func key(_ id: String, _ field: String) -> String {
        "widget_\(id)_\(field)"
    }

    static func string(_ id: String, _ field: String) -> String {
        defaults?.string(forKey: key(id, field)) ?? ""
    }


    static func double(
        _ id: String,
        _ field: String,
        fallback: Double
    ) -> Double {
        if let number = defaults?.object(
            forKey: key(id, field)
        ) as? NSNumber {
            return min(
                max(number.doubleValue, 0.0),
                1.0
            )
        }

        return fallback
    }

    static func configIds() -> [String] {
        guard
            let raw = defaults?.string(forKey: "ios_widget_config_ids_json"),
            let data = raw.data(using: .utf8),
            let ids = try? JSONDecoder().decode([String].self, from: data)
        else { return [] }

        return ids.filter {
            !$0.isEmpty &&
            defaults?.bool(forKey: key($0, "disabled")) != true
        }
    }

    static func configIds(for size: LLSize) -> [String] {
        configIds().filter { string($0, "size") == size.rawValue }
    }

    static func typeTitle(_ type: String) -> String {
        switch type {
        case "character_post": return "最新動態"
        case "period_care": return "生理期陪伴"
        case "daily_quote": return "每日一句"
        case "anniversary": return "紀念日"
        case "character_status": return "角色狀態"
        default: return "桌面小工具"
        }
    }

    static func imagePath(_ id: String) -> String? {
        let explicitPath = defaults?.string(
            forKey: key(id, "image_path")
        )?.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let homeWidgetPath = defaults?.string(
            forKey: key(id, "image")
        )?.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let rawPath: String?
        if let explicitPath, !explicitPath.isEmpty {
            rawPath = explicitPath
        } else if let homeWidgetPath, !homeWidgetPath.isEmpty {
            rawPath = homeWidgetPath
        } else {
            rawPath = nil
        }

        guard let rawPath else {
            return nil
        }

        let normalizedPath: String
        if rawPath.hasPrefix("file://"),
           let url = URL(string: rawPath) {
            normalizedPath = url.path
        } else {
            normalizedPath = rawPath
        }

        // 先用 HomeWidget 回傳的完整路徑。
        if FileManager.default.fileExists(atPath: normalizedPath) {
            return normalizedPath
        }

        // 若 iOS 重新安裝後 App Group container UUID 改變，
        // 舊的絕對路徑會失效；以目前 Extension 可見的 App Group
        // container + home_widget + 檔名重新組出正確路徑。
        guard let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupId
        ) else {
            return nil
        }

        let fileName = URL(fileURLWithPath: normalizedPath).lastPathComponent
        let rebuiltURL = groupURL
            .appendingPathComponent("home_widget", isDirectory: true)
            .appendingPathComponent(fileName, isDirectory: false)

        return FileManager.default.fileExists(atPath: rebuiltURL.path)
            ? rebuiltURL.path
            : nil
    }

    static func entry(id requestedId: String?, size: LLSize) async -> LLEntry {
        let id: String?

        if let requestedId,
           string(requestedId, "size") == size.rawValue {
            id = requestedId
        } else {
            id = configIds(for: size).first
        }

        guard let id else {
            return LLEntry(
                date: Date(),
                configId: nil,
                characterName: "戀戀拾光",
                layout: "full_background",
                lines: ["請先在 App 建立\(size.title)尺寸小工具"],
                imagePath: nil,
                focusX: 0.5,
                focusY: size == .large ? 0.33 : 0.05,
                imageScale: 1.0
            )
        }

        let name = string(id, "character_name")
        let layout = string(id, "layout")
        let lines = (1...4)
            .map { string(id, "line_\($0)") }
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

        return LLEntry(
            date: Date(),
            configId: id,
            characterName: name.isEmpty ? "戀戀拾光" : name,
            layout: layout.isEmpty ? "full_background" : layout,
            lines: lines,
            imagePath: imagePath(id),
            focusX: double(
                id,
                "focus_x",
                fallback: 0.5
            ),
            focusY: double(
                id,
                "focus_y",
                fallback: size == .large
                    ? 0.33
                    : 0.05
            ),
            imageScale: min(
                max(
                    double(
                        id,
                        "image_scale",
                        fallback: 1.0
                    ),
                    1.0
                ),
                3.0
            )
        )
    }
}

struct LLEntry: TimelineEntry {
    let date: Date
    let configId: String?
    let characterName: String
    let layout: String
    let lines: [String]
    let imagePath: String?
    let focusX: Double
    let focusY: Double
    let imageScale: Double
}

// MARK: - Small selection
struct LLSmallEntity: AppEntity, Identifiable, Hashable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "小尺寸設定")
    static var defaultQuery = LLSmallQuery()

    let id: String
    let name: String
    let subtitle: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)－\(subtitle)",
            subtitle: "小尺寸"
        )
    }

    static func make(_ id: String) -> LLSmallEntity? {
        guard LLStore.string(id, "size") == LLSize.small.rawValue else { return nil }
        let name = LLStore.string(id, "character_name")
        guard !name.isEmpty else { return nil }
        return LLSmallEntity(
            id: id,
            name: name,
            subtitle: LLStore.typeTitle(LLStore.string(id, "type"))
        )
    }
}

struct LLSmallQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [LLSmallEntity] {
        identifiers.compactMap(LLSmallEntity.make)
    }

    func suggestedEntities() async throws -> [LLSmallEntity] {
        LLStore.configIds(for: .small).compactMap(LLSmallEntity.make)
    }

    func defaultResult() async -> LLSmallEntity? {
        LLStore.configIds(for: .small).compactMap(LLSmallEntity.make).first
    }
}

struct LLSmallIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "戀戀拾光・小"

    @Parameter(title: "顯示內容")
    var configuration: LLSmallEntity?
}

// MARK: - Medium selection
struct LLMediumEntity: AppEntity, Identifiable, Hashable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "中尺寸設定")
    static var defaultQuery = LLMediumQuery()

    let id: String
    let name: String
    let subtitle: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)－\(subtitle)",
            subtitle: "中尺寸"
        )
    }

    static func make(_ id: String) -> LLMediumEntity? {
        guard LLStore.string(id, "size") == LLSize.medium.rawValue else { return nil }
        let name = LLStore.string(id, "character_name")
        guard !name.isEmpty else { return nil }
        return LLMediumEntity(
            id: id,
            name: name,
            subtitle: LLStore.typeTitle(LLStore.string(id, "type"))
        )
    }
}

struct LLMediumQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [LLMediumEntity] {
        identifiers.compactMap(LLMediumEntity.make)
    }

    func suggestedEntities() async throws -> [LLMediumEntity] {
        LLStore.configIds(for: .medium).compactMap(LLMediumEntity.make)
    }

    func defaultResult() async -> LLMediumEntity? {
        LLStore.configIds(for: .medium).compactMap(LLMediumEntity.make).first
    }
}

struct LLMediumIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "戀戀拾光・中"

    @Parameter(title: "顯示內容")
    var configuration: LLMediumEntity?
}

// MARK: - Large selection
struct LLLargeEntity: AppEntity, Identifiable, Hashable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "大尺寸設定")
    static var defaultQuery = LLLargeQuery()

    let id: String
    let name: String
    let subtitle: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)－\(subtitle)",
            subtitle: "大尺寸"
        )
    }

    static func make(_ id: String) -> LLLargeEntity? {
        guard LLStore.string(id, "size") == LLSize.large.rawValue else { return nil }
        let name = LLStore.string(id, "character_name")
        guard !name.isEmpty else { return nil }
        return LLLargeEntity(
            id: id,
            name: name,
            subtitle: LLStore.typeTitle(LLStore.string(id, "type"))
        )
    }
}

struct LLLargeQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [LLLargeEntity] {
        identifiers.compactMap(LLLargeEntity.make)
    }

    func suggestedEntities() async throws -> [LLLargeEntity] {
        LLStore.configIds(for: .large).compactMap(LLLargeEntity.make)
    }

    func defaultResult() async -> LLLargeEntity? {
        LLStore.configIds(for: .large).compactMap(LLLargeEntity.make).first
    }
}

struct LLLargeIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "戀戀拾光・大"

    @Parameter(title: "顯示內容")
    var configuration: LLLargeEntity?
}

// MARK: - Providers
struct LLSmallProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LLEntry {
        placeholderEntry(.small)
    }

    func snapshot(for configuration: LLSmallIntent, in context: Context) async -> LLEntry {
        await LLStore.entry(id: configuration.configuration?.id, size: .small)
    }

    func timeline(for configuration: LLSmallIntent, in context: Context) async -> Timeline<LLEntry> {
        let entry = await LLStore.entry(id: configuration.configuration?.id, size: .small)
        return Timeline(entries: [entry], policy: .never)
    }
}

struct LLMediumProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LLEntry {
        placeholderEntry(.medium)
    }

    func snapshot(for configuration: LLMediumIntent, in context: Context) async -> LLEntry {
        await LLStore.entry(id: configuration.configuration?.id, size: .medium)
    }

    func timeline(for configuration: LLMediumIntent, in context: Context) async -> Timeline<LLEntry> {
        let entry = await LLStore.entry(id: configuration.configuration?.id, size: .medium)
        return Timeline(entries: [entry], policy: .never)
    }
}

struct LLLargeProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LLEntry {
        placeholderEntry(.large)
    }

    func snapshot(for configuration: LLLargeIntent, in context: Context) async -> LLEntry {
        await LLStore.entry(id: configuration.configuration?.id, size: .large)
    }

    func timeline(for configuration: LLLargeIntent, in context: Context) async -> Timeline<LLEntry> {
        let entry = await LLStore.entry(id: configuration.configuration?.id, size: .large)
        return Timeline(entries: [entry], policy: .never)
    }
}

private func placeholderEntry(_ size: LLSize) -> LLEntry {
    LLEntry(
        date: Date(),
        configId: nil,
        characterName: "戀戀拾光",
        layout: "full_background",
        lines: ["\(size.title)尺寸小工具", "請先在 App 建立設定"],
        imagePath: nil,
        focusX: 0.5,
        focusY: size == .large ? 0.33 : 0.05,
        imageScale: 1.0
    )
}

// MARK: - Shared view
struct LianLianWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    let entry: LLEntry

    private var characterImage: UIImage? {
        guard
            let path = entry.imagePath,
            !path.isEmpty,
            FileManager.default.fileExists(atPath: path)
        else {
            return nil
        }

        // Widget Extension 的記憶體很小。即使 Flutter 已先縮圖，
        // 這裡仍用 ImageIO 直接從檔案產生縮圖，避免 UIImage
        // 對原始像素做完整解碼時超過 Widget 記憶體限制。
        let url = URL(fileURLWithPath: path) as CFURL

        guard let source = CGImageSourceCreateWithURL(
            url,
            nil
        ) else {
            return nil
        }

        let maxPixelSize: Int
        switch family {
        case .systemSmall:
            maxPixelSize = 420
        case .systemMedium:
            maxPixelSize = 720
        case .systemLarge:
            maxPixelSize = 820
        default:
            maxPixelSize = 720
        }

        let options: CFDictionary = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true
        ] as CFDictionary

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(
            source,
            0,
            options
        ) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    private func focusedImage(
        _ image: UIImage
    ) -> some View {
        GeometryReader { proxy in
            let containerWidth = proxy.size.width
            let containerHeight = proxy.size.height
            let imageWidth = max(image.size.width, 1)
            let imageHeight = max(image.size.height, 1)

            let baseScale = max(
                containerWidth / imageWidth,
                containerHeight / imageHeight
            )

            let scale =
                baseScale * max(entry.imageScale, 1.0)

            let scaledWidth = imageWidth * scale
            let scaledHeight = imageHeight * scale

            let overflowX = max(
                scaledWidth - containerWidth,
                0
            )
            let overflowY = max(
                scaledHeight - containerHeight,
                0
            )

            Image(uiImage: image)
                .resizable()
                .frame(
                    width: scaledWidth,
                    height: scaledHeight
                )
                .offset(
                    x: -overflowX * entry.focusX,
                    y: -overflowY * entry.focusY
                )
        }
        .clipped()
    }

    private var displayedLines: [String] {
        let limit: Int
        switch family {
        case .systemSmall: limit = 2
        case .systemMedium: limit = 3
        case .systemLarge: limit = 4
        default: limit = 3
        }
        return Array(entry.lines.prefix(limit))
    }

    var body: some View {
        Group {
            if entry.layout == "character_card" {
                characterCardLayout
            } else {
                fullBackgroundLayout
            }
        }
    }

    private var fullBackgroundLayout: some View {
        ZStack {
            if let image = characterImage {
                focusedImage(image)
            } else {
                fallbackBackground
            }

            LinearGradient(
                colors: [
                    Color.black.opacity(0.04),
                    Color.black.opacity(0.66)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack {
                Spacer()
                textBlock(color: .white, shadow: true)
            }
            .padding(
                EdgeInsets(
                    top: 10,
                    leading: family == .systemSmall ? 13 : 18,
                    bottom: family == .systemSmall ? 12 : 16,
                    trailing: family == .systemSmall ? 13 : 18
                )
            )
        }
        .clipped()
    }

    private var characterCardLayout: some View {
        GeometryReader { proxy in
            if family == .systemSmall {
                ZStack {
                    if let image = characterImage {
                        focusedImage(image)
                    } else {
                        fallbackBackground
                    }

                    LinearGradient(
                        colors: [.clear, Color.black.opacity(0.68)],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    VStack {
                        Spacer()
                        textBlock(color: .white, shadow: true)
                    }
                    .padding(13)
                }
            } else {
                HStack(spacing: 0) {
                    Group {
                        if let image = characterImage {
                            focusedImage(image)
                        } else {
                            fallbackPhoto
                        }
                    }
                    .frame(
                        width: proxy.size.width * 4 / 9,
                        height: proxy.size.height,
                        alignment: .top
                    )
                    .clipped()

                    textBlock(
                        color: Color(uiColor: .label),
                        shadow: false
                    )
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .leading
                    )
                    .padding(family == .systemMedium ? 12 : 16)
                    .background(Color(uiColor: .systemBackground))
                }
            }
        }
        .background(Color(uiColor: .systemBackground))
    }

    @ViewBuilder
    private func textBlock(color: Color, shadow: Bool) -> some View {
        VStack(
            alignment: .leading,
            spacing: family == .systemSmall ? 2 : 3
        ) {
            Text(entry.characterName)
                .font(
                    .system(
                        size: family == .systemSmall ? 14 : 17,
                        weight: .bold,
                        design: .serif
                    )
                )
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .shadow(
                    color: shadow ? Color.black.opacity(0.45) : .clear,
                    radius: 5
                )

            ForEach(Array(displayedLines.enumerated()), id: \.offset) { _, line in
                Text(line)
                    .font(
                        .system(
                            size: family == .systemSmall ? 10.5 : 12.5,
                            design: .serif
                        )
                    )
                    .foregroundStyle(color.opacity(0.90))
                    .lineLimit(family == .systemSmall ? 1 : 2)
                    .minimumScaleFactor(0.80)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var fallbackBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.97, green: 0.94, blue: 0.99),
                Color(red: 0.90, green: 0.84, blue: 0.96)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var fallbackPhoto: some View {
        ZStack {
            Color(red: 0.95, green: 0.92, blue: 0.98)
            Image(systemName: "person.crop.circle")
                .font(.system(size: 30))
                .foregroundStyle(Color.secondary)
        }
    }
}

// MARK: - 3 Widget kinds
struct LianLianWidgetSmall: Widget {
    let kind = "LianLianHomeWidgetSmall"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LLSmallIntent.self,
            provider: LLSmallProvider()
        ) { entry in
            LianLianWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("戀戀拾光・小")
        .description("只顯示 App 內建立的小尺寸設定。")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

struct LianLianWidgetMedium: Widget {
    let kind = "LianLianHomeWidgetMedium"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LLMediumIntent.self,
            provider: LLMediumProvider()
        ) { entry in
            LianLianWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("戀戀拾光・中")
        .description("只顯示 App 內建立的中尺寸設定。")
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}

struct LianLianWidgetLarge: Widget {
    let kind = "LianLianHomeWidgetLarge"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LLLargeIntent.self,
            provider: LLLargeProvider()
        ) { entry in
            LianLianWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("戀戀拾光・大")
        .description("只顯示 App 內建立的大尺寸設定。")
        .supportedFamilies([.systemLarge])
        .contentMarginsDisabled()
    }
}

