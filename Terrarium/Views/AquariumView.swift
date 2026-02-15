import SwiftUI

struct AquariumView: View {
    @ObservedObject var viewModel: AquariumViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 배경
                OceanBackgroundView(timeOfDay: viewModel.timeOfDay)

                // 거품들
                ForEach(viewModel.bubbles) { bubble in
                    BubbleView(bubble: bubble)
                        .position(
                            x: bubble.x * geometry.size.width,
                            y: bubble.y * geometry.size.height
                        )
                }

                // 바닥 모래
                sandFloor(in: geometry)

                // 해초 장식
                seaweedDecoration(in: geometry)

                // 생물들
                ForEach(viewModel.creatures) { creature in
                    CreatureView(creature: creature)
                        .position(
                            x: creature.positionX * geometry.size.width,
                            y: creature.positionY * geometry.size.height
                        )
                        .animation(
                            .easeInOut(duration: 0.3),
                            value: creature.positionX
                        )
                }

                // 시간대 표시
                VStack {
                    HStack {
                        Text(viewModel.timeOfDay.displayName)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())

                        Spacer()

                        Text("\(viewModel.creatures.count)마리")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - 바닥 모래
    private func sandFloor(in geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.76, green: 0.70, blue: 0.50).opacity(0.8),
                            Color(red: 0.60, green: 0.55, blue: 0.40).opacity(0.9)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: geometry.size.height * 0.08)
        }
    }

    // MARK: - 해초 장식
    private func seaweedDecoration(in geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            HStack(spacing: 30) {
                Text("🌿")
                    .font(.system(size: 30))
                    .rotationEffect(.degrees(-10))
                Spacer()
                Text("🌱")
                    .font(.system(size: 25))
                Text("🪸")
                    .font(.system(size: 28))
                Spacer()
                Text("🌿")
                    .font(.system(size: 35))
                    .rotationEffect(.degrees(5))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, geometry.size.height * 0.02)
        }
    }
}
