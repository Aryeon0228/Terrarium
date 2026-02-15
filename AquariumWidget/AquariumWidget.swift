import WidgetKit
import SwiftUI

struct AquariumEntry: TimelineEntry {
    let date: Date
    let creatures: [SharedCreature]
    let timeOfDay: SharedTimeOfDay
}

struct AquariumTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> AquariumEntry {
        AquariumEntry(
            date: Date(),
            creatures: [],
            timeOfDay: .current()
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (AquariumEntry) -> Void) {
        let entry = createEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AquariumEntry>) -> Void) {
        let entry = createEntry()

        // 1시간마다 새로고침 (시간대 변경 반영)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func createEntry() -> AquariumEntry {
        if let data = SharedAquariumData.load() {
            let timeOfDay = SharedTimeOfDay(rawValue: data.timeOfDay) ?? .current()
            return AquariumEntry(
                date: Date(),
                creatures: data.creatures,
                timeOfDay: timeOfDay
            )
        }
        return AquariumEntry(
            date: Date(),
            creatures: [],
            timeOfDay: .current()
        )
    }
}

struct AquariumWidget: Widget {
    let kind: String = "AquariumWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: AquariumTimelineProvider()
        ) { entry in
            AquariumWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("나의 수족관")
        .description("수족관의 생물들을 홈화면에서 확인하세요")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
