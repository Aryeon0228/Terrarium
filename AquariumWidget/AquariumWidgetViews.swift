import SwiftUI
import WidgetKit

struct AquariumWidgetEntryView: View {
    var entry: AquariumEntry

    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        ZStack {
            // 배경 그라데이션
            LinearGradient(
                colors: [
                    entry.timeOfDay.topColor,
                    entry.timeOfDay.bottomColor
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            switch widgetFamily {
            case .systemSmall:
                smallWidgetContent
            case .systemMedium:
                mediumWidgetContent
            default:
                smallWidgetContent
            }
        }
    }

    // MARK: - Small Widget
    private var smallWidgetContent: some View {
        VStack(spacing: 4) {
            // 생물 이모지 표시 (최대 4개)
            let displayCreatures = Array(entry.creatures.prefix(4))

            if displayCreatures.isEmpty {
                VStack(spacing: 8) {
                    Text("🐠")
                        .font(.system(size: 36))
                    Text("수족관이 비어있어요")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.8))
                }
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 6) {
                    ForEach(displayCreatures) { creature in
                        Text(creature.emoji)
                            .font(.system(size: 28))
                    }
                }
                .padding(.top, 8)

                Spacer()

                HStack {
                    Text(entry.timeOfDay.displayName)
                        .font(.caption2)
                    Spacer()
                    Text("\(entry.creatures.count)마리")
                        .font(.caption2)
                }
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal, 4)
                .padding(.bottom, 4)
            }
        }
        .padding(8)
    }

    // MARK: - Medium Widget
    private var mediumWidgetContent: some View {
        HStack(spacing: 12) {
            // 왼쪽: 생물 목록
            VStack(alignment: .leading, spacing: 4) {
                Text("🐠 나의 수족관")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                if entry.creatures.isEmpty {
                    Text("생물을 추가해보세요!")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.7))
                } else {
                    ForEach(Array(entry.creatures.prefix(3))) { creature in
                        HStack(spacing: 4) {
                            Text(creature.emoji)
                                .font(.system(size: 18))
                            Text(creature.name)
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.9))
                                .lineLimit(1)
                        }
                    }
                    if entry.creatures.count > 3 {
                        Text("+\(entry.creatures.count - 3)마리 더")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }

                Spacer()
            }

            Spacer()

            // 오른쪽: 큰 이모지 디스플레이
            VStack {
                let display = Array(entry.creatures.prefix(6))
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 4) {
                    ForEach(display) { creature in
                        Text(creature.emoji)
                            .font(.system(size: 24))
                    }
                }

                Spacer()

                Text(entry.timeOfDay.displayName)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(12)
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    AquariumWidget()
} timeline: {
    AquariumEntry(
        date: Date(),
        creatures: [
            SharedCreature(from: Creature(name: "니모", type: .fish)),
            SharedCreature(from: Creature(name: "해파리", type: .jellyfish)),
            SharedCreature(from: Creature(name: "꼬북이", type: .turtle)),
        ],
        timeOfDay: .afternoon
    )
}
