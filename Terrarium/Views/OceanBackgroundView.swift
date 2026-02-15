import SwiftUI

struct OceanBackgroundView: View {
    let timeOfDay: TimeOfDay

    var body: some View {
        LinearGradient(
            colors: [
                timeOfDay.topColor,
                timeOfDay.bottomColor
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay(
            // 수면 빛 효과
            VStack {
                lightRays
                Spacer()
            }
        )
        .animation(.easeInOut(duration: 2.0), value: timeOfDay)
    }

    private var lightRays: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(lightOpacity),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(
                            width: CGFloat.random(in: 20...60),
                            height: geometry.size.height * 0.4
                        )
                        .rotationEffect(.degrees(Double.random(in: -15...15)))
                        .position(
                            x: geometry.size.width * CGFloat(index + 1) / 6.0,
                            y: geometry.size.height * 0.15
                        )
                }
            }
        }
    }

    private var lightOpacity: Double {
        switch timeOfDay {
        case .morning: return 0.08
        case .afternoon: return 0.12
        case .evening: return 0.05
        case .night: return 0.02
        }
    }
}

#Preview {
    OceanBackgroundView(timeOfDay: .afternoon)
}
