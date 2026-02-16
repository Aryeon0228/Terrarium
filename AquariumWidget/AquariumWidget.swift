import WidgetKit
import SwiftUI

struct AquariumEntry: TimelineEntry {
    let date: Date
    let creatures: [SharedCreature]
    let timeOfDay: SharedTimeOfDay
    /// 0.0 ~ 1.0 사이의 애니메이션 위상값
    let animationPhase: Double
}

struct AquariumTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> AquariumEntry {
        AquariumEntry(
            date: Date(),
            creatures: [],
            timeOfDay: .current(),
            animationPhase: 0
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (AquariumEntry) -> Void) {
        let entry = createEntry(date: Date(), phase: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AquariumEntry>) -> Void) {
        let now = Date()
        let totalFrames = 12
        let intervalMinutes = 5

        var entries: [AquariumEntry] = []
        for i in 0..<totalFrames {
            let entryDate = Calendar.current.date(byAdding: .minute, value: i * intervalMinutes, to: now) ?? now
            let phase = Double(i) / Double(totalFrames)
            entries.append(createEntry(date: entryDate, phase: phase))
        }

        let nextUpdate = Calendar.current.date(byAdding: .minute, value: totalFrames * intervalMinutes, to: now) ?? now
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }

    private func createEntry(date: Date, phase: Double) -> AquariumEntry {
        if let data = SharedAquariumData.load() {
            let timeOfDay = SharedTimeOfDay(rawValue: data.timeOfDay) ?? .current()
            return AquariumEntry(
                date: date,
                creatures: data.creatures,
                timeOfDay: timeOfDay,
                animationPhase: phase
            )
        }
        return AquariumEntry(
            date: date,
            creatures: [],
            timeOfDay: .current(),
            animationPhase: phase
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
