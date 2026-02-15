import SwiftUI
import WidgetKit

// MARK: - Main Entry View

struct AquariumWidgetEntryView: View {
    var entry: AquariumEntry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallFishbowlWidget(entry: entry)
        case .systemMedium:
            MediumFishbowlWidget(entry: entry)
        default:
            SmallFishbowlWidget(entry: entry)
        }
    }
}

// MARK: - Small Widget (원형 어항)

struct SmallFishbowlWidget: View {
    let entry: AquariumEntry

    var body: some View {
        GeometryReader { geo in
            let bowlSize = min(geo.size.width, geo.size.height) * 0.92

            ZStack {
                // 어항 밖 배경
                entry.timeOfDay.bottomColor.opacity(0.3)

                // 원형 어항
                ZStack {
                    FishbowlWaterView(timeOfDay: entry.timeOfDay)
                    LightRaysView()
                    SandFloorView()
                    SeaweedGroupView()
                    CoralGroupView()
                    CreaturesLayerView(creatures: entry.creatures)
                    BubblesLayerView()
                    WaterSurfaceView()
                    GlassHighlightView()
                }
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.15),
                                    Color(red: 0.7, green: 0.85, blue: 0.95).opacity(0.3),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                )
                .frame(width: bowlSize, height: bowlSize)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
        }
    }
}

// MARK: - Medium Widget (파노라마 어항)

struct MediumFishbowlWidget: View {
    let entry: AquariumEntry

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.08, green: 0.10, blue: 0.20)

                // 어항 탱크
                ZStack {
                    FishbowlWaterView(timeOfDay: entry.timeOfDay)
                    LightRaysView()
                    SandFloorView()
                    SeaweedGroupView()
                    CoralGroupView()
                    CreaturesLayerView(creatures: entry.creatures)
                    BubblesLayerView()
                    WaterSurfaceView()
                    GlassHighlightView()
                }
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.45),
                                    Color.white.opacity(0.08),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .padding(8)

                // 오버레이 정보
                VStack {
                    HStack {
                        Spacer()
                        Text(entry.timeOfDay.displayName)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.black.opacity(0.25))
                            .clipShape(Capsule())
                    }
                    Spacer()
                    if !entry.creatures.isEmpty {
                        HStack {
                            Spacer()
                            Text("\(entry.creatures.count)마리")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.7))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.black.opacity(0.25))
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(16)
            }
        }
    }
}

// MARK: - 물 배경

struct FishbowlWaterView: View {
    let timeOfDay: SharedTimeOfDay

    var body: some View {
        LinearGradient(
            colors: waterColors,
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var waterColors: [Color] {
        switch timeOfDay {
        case .morning:
            return [
                Color(red: 0.55, green: 0.82, blue: 0.95),
                Color(red: 0.15, green: 0.45, blue: 0.70),
                Color(red: 0.05, green: 0.25, blue: 0.50),
            ]
        case .afternoon:
            return [
                Color(red: 0.20, green: 0.60, blue: 0.90),
                Color(red: 0.05, green: 0.30, blue: 0.65),
                Color(red: 0.02, green: 0.15, blue: 0.45),
            ]
        case .evening:
            return [
                Color(red: 0.60, green: 0.40, blue: 0.55),
                Color(red: 0.20, green: 0.15, blue: 0.40),
                Color(red: 0.08, green: 0.08, blue: 0.25),
            ]
        case .night:
            return [
                Color(red: 0.08, green: 0.12, blue: 0.25),
                Color(red: 0.03, green: 0.06, blue: 0.18),
                Color(red: 0.01, green: 0.02, blue: 0.10),
            ]
        }
    }
}

// MARK: - 빛줄기

struct LightRaysView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LightRayShape()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: geo.size.width * 0.15, height: geo.size.height * 0.7)
                    .rotationEffect(.degrees(15))
                    .position(x: geo.size.width * 0.3, y: geo.size.height * 0.3)

                LightRayShape()
                    .fill(Color.white.opacity(0.04))
                    .frame(width: geo.size.width * 0.12, height: geo.size.height * 0.6)
                    .rotationEffect(.degrees(20))
                    .position(x: geo.size.width * 0.55, y: geo.size.height * 0.35)

                LightRayShape()
                    .fill(Color.white.opacity(0.03))
                    .frame(width: geo.size.width * 0.10, height: geo.size.height * 0.5)
                    .rotationEffect(.degrees(10))
                    .position(x: geo.size.width * 0.75, y: geo.size.height * 0.3)
            }
        }
    }
}

struct LightRayShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX - rect.width * 0.3, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.3, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.5, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - rect.width * 0.5, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - 모래 바닥

struct SandFloorView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 메인 모래
                SandShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.85, green: 0.75, blue: 0.55),
                                Color(red: 0.72, green: 0.62, blue: 0.42),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: geo.size.height * 0.35)
                    .offset(y: geo.size.height * 0.65)

                // 모래 하이라이트
                SandShape()
                    .fill(Color(red: 0.90, green: 0.82, blue: 0.65).opacity(0.4))
                    .frame(height: geo.size.height * 0.33)
                    .offset(y: geo.size.height * 0.66)

                // 작은 조약돌
                Circle()
                    .fill(Color(red: 0.68, green: 0.58, blue: 0.38).opacity(0.5))
                    .frame(width: 3, height: 3)
                    .position(x: geo.size.width * 0.2, y: geo.size.height * 0.88)
                Circle()
                    .fill(Color(red: 0.72, green: 0.62, blue: 0.42).opacity(0.4))
                    .frame(width: 2.5, height: 2.5)
                    .position(x: geo.size.width * 0.6, y: geo.size.height * 0.90)
                Circle()
                    .fill(Color(red: 0.68, green: 0.58, blue: 0.38).opacity(0.3))
                    .frame(width: 2, height: 2)
                    .position(x: geo.size.width * 0.45, y: geo.size.height * 0.87)
                Circle()
                    .fill(Color(red: 0.75, green: 0.65, blue: 0.45).opacity(0.35))
                    .frame(width: 2.5, height: 2.5)
                    .position(x: geo.size.width * 0.78, y: geo.size.height * 0.89)
            }
        }
    }
}

struct SandShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: 0, y: h * 0.35))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.25, y: h * 0.20),
            control: CGPoint(x: w * 0.12, y: h * 0.12)
        )
        path.addQuadCurve(
            to: CGPoint(x: w * 0.50, y: h * 0.30),
            control: CGPoint(x: w * 0.38, y: h * 0.38)
        )
        path.addQuadCurve(
            to: CGPoint(x: w * 0.75, y: h * 0.18),
            control: CGPoint(x: w * 0.62, y: h * 0.12)
        )
        path.addQuadCurve(
            to: CGPoint(x: w, y: h * 0.28),
            control: CGPoint(x: w * 0.88, y: h * 0.28)
        )
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.closeSubpath()
        return path
    }
}

// MARK: - 해초

struct SeaweedGroupView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                SeaweedStrand(
                    baseX: geo.size.width * 0.14,
                    baseY: geo.size.height * 0.79,
                    height: geo.size.height * 0.30,
                    width: 4,
                    color: Color(red: 0.18, green: 0.58, blue: 0.28)
                )
                SeaweedStrand(
                    baseX: geo.size.width * 0.22,
                    baseY: geo.size.height * 0.81,
                    height: geo.size.height * 0.18,
                    width: 3,
                    color: Color(red: 0.28, green: 0.68, blue: 0.32)
                )
                SeaweedStrand(
                    baseX: geo.size.width * 0.83,
                    baseY: geo.size.height * 0.78,
                    height: geo.size.height * 0.27,
                    width: 3.5,
                    color: Color(red: 0.15, green: 0.52, blue: 0.25)
                )
                SeaweedStrand(
                    baseX: geo.size.width * 0.76,
                    baseY: geo.size.height * 0.80,
                    height: geo.size.height * 0.20,
                    width: 3,
                    color: Color(red: 0.25, green: 0.62, blue: 0.30)
                )
            }
        }
    }
}

struct SeaweedStrand: View {
    let baseX: CGFloat
    let baseY: CGFloat
    let height: CGFloat
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: baseX, y: baseY))
                let segments = 5
                let segH = height / CGFloat(segments)
                for i in 0..<segments {
                    let startY = baseY - CGFloat(i) * segH
                    let endY = startY - segH
                    let ctrlX = baseX + (i.isMultiple(of: 2) ? 7 : -7)
                    let endX = baseX + (i.isMultiple(of: 2) ? 2.5 : -2.5)
                    path.addQuadCurve(
                        to: CGPoint(x: endX, y: endY),
                        control: CGPoint(x: ctrlX, y: (startY + endY) / 2)
                    )
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: width, lineCap: .round))

            // 잎 끝
            Path { path in
                let topY = baseY - height
                path.move(to: CGPoint(x: baseX, y: topY))
                path.addQuadCurve(
                    to: CGPoint(x: baseX + 5, y: topY - 4),
                    control: CGPoint(x: baseX + 6, y: topY)
                )
            }
            .stroke(color.opacity(0.7), style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
    }
}

// MARK: - 산호

struct CoralGroupView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                CoralBranch(
                    baseX: geo.size.width * 0.38,
                    baseY: geo.size.height * 0.82,
                    height: geo.size.height * 0.17,
                    color: Color(red: 1.0, green: 0.42, blue: 0.48)
                )
                CoralBranch(
                    baseX: geo.size.width * 0.60,
                    baseY: geo.size.height * 0.84,
                    height: geo.size.height * 0.13,
                    color: Color(red: 1.0, green: 0.58, blue: 0.28)
                )
            }
        }
    }
}

struct CoralBranch: View {
    let baseX: CGFloat
    let baseY: CGFloat
    let height: CGFloat
    let color: Color

    var body: some View {
        ZStack {
            // 줄기
            Path { path in
                path.move(to: CGPoint(x: baseX, y: baseY))
                path.addLine(to: CGPoint(x: baseX, y: baseY - height))
            }
            .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))

            // 왼쪽 가지
            Path { path in
                path.move(to: CGPoint(x: baseX, y: baseY - height * 0.50))
                path.addQuadCurve(
                    to: CGPoint(x: baseX - height * 0.40, y: baseY - height * 0.85),
                    control: CGPoint(x: baseX - height * 0.35, y: baseY - height * 0.50)
                )
            }
            .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round))

            // 오른쪽 가지
            Path { path in
                path.move(to: CGPoint(x: baseX, y: baseY - height * 0.35))
                path.addQuadCurve(
                    to: CGPoint(x: baseX + height * 0.35, y: baseY - height * 0.70),
                    control: CGPoint(x: baseX + height * 0.28, y: baseY - height * 0.35)
                )
            }
            .stroke(color, style: StrokeStyle(lineWidth: 1.8, lineCap: .round))

            // 위쪽 작은 가지
            Path { path in
                path.move(to: CGPoint(x: baseX, y: baseY - height * 0.80))
                path.addQuadCurve(
                    to: CGPoint(x: baseX + height * 0.20, y: baseY - height),
                    control: CGPoint(x: baseX + height * 0.18, y: baseY - height * 0.80)
                )
            }
            .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))

            // 가지 끝 점
            Circle().fill(color.opacity(0.7))
                .frame(width: 4.5, height: 4.5)
                .position(x: baseX, y: baseY - height)
            Circle().fill(color.opacity(0.7))
                .frame(width: 4, height: 4)
                .position(x: baseX - height * 0.40, y: baseY - height * 0.85)
            Circle().fill(color.opacity(0.7))
                .frame(width: 3.5, height: 3.5)
                .position(x: baseX + height * 0.35, y: baseY - height * 0.70)
            Circle().fill(color.opacity(0.7))
                .frame(width: 3.5, height: 3.5)
                .position(x: baseX + height * 0.20, y: baseY - height)
        }
    }
}

// MARK: - 생물 레이어

struct CreaturesLayerView: View {
    let creatures: [SharedCreature]

    private let positions: [(CGFloat, CGFloat)] = [
        (0.35, 0.33), (0.68, 0.42), (0.48, 0.55),
        (0.26, 0.48), (0.72, 0.30), (0.55, 0.38),
    ]
    private let facingRight: [Bool] = [true, false, true, false, true, false]

    var body: some View {
        GeometryReader { geo in
            let display = Array(creatures.prefix(6))
            ForEach(Array(display.enumerated()), id: \.element.id) { index, creature in
                let pos = positions[index % positions.count]
                CreatureDrawing(
                    creature: creature,
                    facing: facingRight[index % facingRight.count]
                )
                .position(
                    x: geo.size.width * pos.0,
                    y: geo.size.height * pos.1
                )
            }
        }
    }
}

// MARK: - 생물 드로잉 (커스텀 렌더링)

struct CreatureDrawing: View {
    let creature: SharedCreature
    let facing: Bool

    var body: some View {
        creatureView
            .scaleEffect(x: facing ? 1 : -1, y: 1)
            .scaleEffect(scaleFactor)
    }

    private var scaleFactor: CGFloat {
        let base = CGFloat(creature.size) / 40.0
        return min(max(base, 0.7), 1.4)
    }

    @ViewBuilder
    private var creatureView: some View {
        switch creature.typeRawValue {
        case "물고기": fishView
        case "복어": pufferfishView
        case "해파리": jellyfishView
        case "거북이": turtleView
        case "상어": sharkView
        case "문어": octopusView
        case "게": crabView
        case "조개": shellView
        default: fishView
        }
    }

    // 물고기 🐠
    private var fishView: some View {
        ZStack {
            TriangleShape()
                .fill(Color.orange.opacity(0.8))
                .frame(width: 8, height: 9)
                .offset(x: -12)
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color.orange, Color(red: 1.0, green: 0.6, blue: 0.2)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: 18, height: 11)
            Ellipse()
                .fill(Color.white.opacity(0.35))
                .frame(width: 3, height: 8)
                .offset(x: 2)
            Ellipse()
                .fill(Color.orange.opacity(0.7))
                .frame(width: 7, height: 3.5)
                .offset(x: -1, y: -6.5)
            Circle().fill(.white).frame(width: 4.5, height: 4.5).offset(x: 5, y: -1.5)
            Circle().fill(.black).frame(width: 2.2, height: 2.2).offset(x: 5.5, y: -1.5)
        }
    }

    // 복어 🐡
    private var pufferfishView: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                let angle = Double(i) * 45.0
                Capsule()
                    .fill(Color(red: 0.85, green: 0.75, blue: 0.3).opacity(0.6))
                    .frame(width: 1.5, height: 3)
                    .rotationEffect(.degrees(angle))
                    .offset(
                        x: cos(angle * .pi / 180) * 9.5,
                        y: sin(angle * .pi / 180) * 9.5
                    )
            }
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.yellow, Color(red: 0.88, green: 0.78, blue: 0.28)],
                        center: .center, startRadius: 0, endRadius: 9
                    )
                )
                .frame(width: 16, height: 16)
            Ellipse()
                .fill(Color.white.opacity(0.35))
                .frame(width: 8, height: 5)
                .offset(y: 2)
            Circle().fill(.white).frame(width: 4.5, height: 4.5).offset(x: 3, y: -2.5)
            Circle().fill(.black).frame(width: 2.2, height: 2.2).offset(x: 3.5, y: -2.5)
            Ellipse()
                .stroke(Color(red: 0.6, green: 0.4, blue: 0.2), lineWidth: 0.8)
                .frame(width: 2.5, height: 1.5)
                .offset(x: 7, y: 1)
        }
    }

    // 해파리 🪼
    private var jellyfishView: some View {
        ZStack {
            // 촉수
            ForEach(0..<4, id: \.self) { i in
                let xOff = CGFloat(i) * 4.0 - 6.0
                WavyLineShape()
                    .stroke(
                        Color.purple.opacity(0.45),
                        style: StrokeStyle(lineWidth: 1.5, lineCap: .round)
                    )
                    .frame(width: 6, height: 12)
                    .offset(x: xOff, y: 10)
            }
            // 글로우
            Circle()
                .fill(Color.purple.opacity(0.12))
                .frame(width: 24, height: 24)
                .offset(y: -1)
            // 돔
            HalfCircleShape()
                .fill(
                    RadialGradient(
                        colors: [Color.purple.opacity(0.3), Color.purple.opacity(0.6)],
                        center: .top, startRadius: 0, endRadius: 12
                    )
                )
                .frame(width: 16, height: 10)
                .offset(y: -2)
            HalfCircleShape()
                .stroke(Color.white.opacity(0.3), lineWidth: 0.8)
                .frame(width: 10, height: 6)
                .offset(y: -2)
        }
    }

    // 거북이 🐢
    private var turtleView: some View {
        ZStack {
            // 지느러미
            Ellipse().fill(Color(red: 0.30, green: 0.62, blue: 0.30)).frame(width: 6, height: 3).offset(x: -7, y: 5)
            Ellipse().fill(Color(red: 0.30, green: 0.62, blue: 0.30)).frame(width: 6, height: 3).offset(x: 7, y: 5)
            Ellipse().fill(Color(red: 0.30, green: 0.62, blue: 0.30)).frame(width: 5, height: 3).offset(x: -8, y: -3)
            Ellipse().fill(Color(red: 0.30, green: 0.62, blue: 0.30)).frame(width: 5, height: 3).offset(x: 8, y: -3)
            // 등딱지
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color(red: 0.45, green: 0.72, blue: 0.32), Color(red: 0.28, green: 0.52, blue: 0.22)],
                        center: .center, startRadius: 0, endRadius: 10
                    )
                )
                .frame(width: 18, height: 14)
            Ellipse()
                .stroke(Color(red: 0.35, green: 0.58, blue: 0.26).opacity(0.5), lineWidth: 0.8)
                .frame(width: 10, height: 8)
            // 머리
            Ellipse().fill(Color(red: 0.30, green: 0.62, blue: 0.30)).frame(width: 7, height: 6).offset(x: 11)
            Circle().fill(.white).frame(width: 3, height: 3).offset(x: 12.5, y: -1.5)
            Circle().fill(.black).frame(width: 1.5, height: 1.5).offset(x: 13, y: -1.5)
        }
    }

    // 상어 🦈
    private var sharkView: some View {
        ZStack {
            // 꼬리
            TriangleShape()
                .fill(Color(red: 0.52, green: 0.56, blue: 0.60))
                .frame(width: 9, height: 12)
                .offset(x: -14)
            // 몸
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.58, green: 0.62, blue: 0.66), Color(red: 0.48, green: 0.52, blue: 0.56)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: 22, height: 10)
            // 배
            Ellipse()
                .fill(Color.white.opacity(0.45))
                .frame(width: 15, height: 4)
                .offset(y: 2)
            // 등지느러미
            TriangleShape()
                .fill(Color(red: 0.52, green: 0.56, blue: 0.60))
                .frame(width: 5, height: 7)
                .rotationEffect(.degrees(90))
                .offset(x: -2, y: -7)
            Circle().fill(.white).frame(width: 3.5, height: 3.5).offset(x: 7, y: -1.5)
            Circle().fill(.black).frame(width: 2, height: 2).offset(x: 7.5, y: -1.5)
        }
    }

    // 문어 🐙
    private var octopusView: some View {
        ZStack {
            // 다리
            ForEach(0..<5, id: \.self) { i in
                let xOff = CGFloat(i) * 4.5 - 9.0
                WavyLineShape()
                    .stroke(
                        Color(red: 0.88, green: 0.38, blue: 0.48).opacity(0.7),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .frame(width: 5, height: 10)
                    .offset(x: xOff, y: 9)
            }
            // 머리
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color(red: 1.0, green: 0.50, blue: 0.58), Color(red: 0.82, green: 0.28, blue: 0.38)],
                        center: .top, startRadius: 0, endRadius: 10
                    )
                )
                .frame(width: 16, height: 14)
                .offset(y: -2)
            Circle().fill(.white).frame(width: 5, height: 5).offset(x: -3, y: -3)
            Circle().fill(.white).frame(width: 5, height: 5).offset(x: 3, y: -3)
            Circle().fill(.black).frame(width: 2.5, height: 2.5).offset(x: -2.5, y: -3)
            Circle().fill(.black).frame(width: 2.5, height: 2.5).offset(x: 3.5, y: -3)
        }
    }

    // 게 🦀
    private var crabView: some View {
        ZStack {
            // 다리
            ForEach(0..<3, id: \.self) { i in
                let yOff = CGFloat(i) * 2.5
                Capsule().fill(Color.red.opacity(0.65)).frame(width: 7, height: 1.5)
                    .rotationEffect(.degrees(Double(20 + i * 15))).offset(x: -10, y: yOff)
                Capsule().fill(Color.red.opacity(0.65)).frame(width: 7, height: 1.5)
                    .rotationEffect(.degrees(Double(-20 - i * 15))).offset(x: 10, y: yOff)
            }
            // 집게 팔
            Capsule().fill(Color.red.opacity(0.8)).frame(width: 7, height: 2)
                .rotationEffect(.degrees(-20)).offset(x: -9, y: -3)
            Capsule().fill(Color.red.opacity(0.8)).frame(width: 7, height: 2)
                .rotationEffect(.degrees(20)).offset(x: 9, y: -3)
            // 집게
            Circle().fill(Color.red).frame(width: 5, height: 5).offset(x: -13, y: -5)
            Circle().fill(Color.red).frame(width: 5, height: 5).offset(x: 13, y: -5)
            // 몸
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color(red: 1.0, green: 0.30, blue: 0.22), Color(red: 0.78, green: 0.18, blue: 0.12)],
                        center: .center, startRadius: 0, endRadius: 8
                    )
                )
                .frame(width: 16, height: 12)
            // 눈
            Circle().fill(.white).frame(width: 3.5, height: 3.5).offset(x: -3, y: -5.5)
            Circle().fill(.white).frame(width: 3.5, height: 3.5).offset(x: 3, y: -5.5)
            Circle().fill(.black).frame(width: 1.8, height: 1.8).offset(x: -2.5, y: -5.8)
            Circle().fill(.black).frame(width: 1.8, height: 1.8).offset(x: 3.5, y: -5.8)
        }
    }

    // 조개 🐚
    private var shellView: some View {
        ZStack {
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 1.0, green: 0.90, blue: 0.80), Color(red: 0.92, green: 0.72, blue: 0.58)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .frame(width: 16, height: 12)
            ForEach(0..<3, id: \.self) { i in
                Ellipse()
                    .stroke(Color(red: 0.82, green: 0.62, blue: 0.48).opacity(0.45), lineWidth: 0.8)
                    .frame(width: CGFloat(6 + i * 4), height: CGFloat(5 + i * 3))
                    .offset(x: -1)
            }
            Circle()
                .fill(Color.white.opacity(0.7))
                .frame(width: 3, height: 3)
                .offset(x: -3)
        }
    }
}

// MARK: - 거품

struct BubblesLayerView: View {
    private let bubbles: [(x: CGFloat, y: CGFloat, size: CGFloat, opacity: Double)] = [
        (0.24, 0.26, 5.0, 0.50),
        (0.56, 0.18, 3.5, 0.40),
        (0.72, 0.36, 4.0, 0.42),
        (0.40, 0.44, 3.0, 0.35),
        (0.17, 0.50, 2.5, 0.30),
        (0.82, 0.24, 3.5, 0.38),
    ]

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<bubbles.count, id: \.self) { i in
                let b = bubbles[i]
                BubbleDot(size: b.size, bubbleOpacity: b.opacity)
                    .position(x: geo.size.width * b.x, y: geo.size.height * b.y)
            }
        }
    }
}

struct BubbleDot: View {
    let size: CGFloat
    let bubbleOpacity: Double

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(bubbleOpacity * 0.5),
                            Color.white.opacity(bubbleOpacity * 0.15),
                            Color.clear,
                        ],
                        center: UnitPoint(x: 0.35, y: 0.35),
                        startRadius: 0,
                        endRadius: size * 0.5
                    )
                )
            Circle()
                .stroke(Color.white.opacity(bubbleOpacity * 0.6), lineWidth: 0.5)
            // 하이라이트
            Circle()
                .fill(Color.white.opacity(bubbleOpacity * 0.8))
                .frame(width: size * 0.25, height: size * 0.25)
                .offset(x: -size * 0.15, y: -size * 0.15)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - 물결 수면

struct WaterSurfaceView: View {
    var body: some View {
        ZStack(alignment: .top) {
            WaveShape(amplitude: 3, frequency: 2, phase: 0)
                .fill(Color.white.opacity(0.07))
                .frame(height: 12)

            WaveShape(amplitude: 2, frequency: 3, phase: 1.2)
                .fill(Color.white.opacity(0.04))
                .frame(height: 10)
        }
    }
}

struct WaveShape: Shape {
    var amplitude: CGFloat
    var frequency: CGFloat
    var phase: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width

        path.move(to: CGPoint(x: 0, y: rect.midY))
        for x in stride(from: CGFloat(0), through: w, by: 1) {
            let relX = x / w
            let y = rect.midY + amplitude * sin(2 * .pi * frequency * relX + phase)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}

// MARK: - 유리 반사

struct GlassHighlightView: View {
    var body: some View {
        GeometryReader { geo in
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.18), Color.clear],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: geo.size.width * 0.18, height: geo.size.height * 0.42)
                .rotationEffect(.degrees(-20))
                .position(x: geo.size.width * 0.22, y: geo.size.height * 0.28)

            Circle()
                .fill(Color.white.opacity(0.22))
                .frame(width: 4, height: 4)
                .position(x: geo.size.width * 0.28, y: geo.size.height * 0.14)
        }
    }
}

// MARK: - 헬퍼 Shape

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct HalfCircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY),
            radius: rect.width / 2,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

struct WavyLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        let segments = 3
        let segH = rect.height / CGFloat(segments)
        for i in 0..<segments {
            let startY = rect.minY + CGFloat(i) * segH
            let endY = startY + segH
            let ctrlX = rect.midX + (i.isMultiple(of: 2) ? rect.width * 0.4 : -rect.width * 0.4)
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: endY),
                control: CGPoint(x: ctrlX, y: (startY + endY) / 2)
            )
        }
        return path
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

#Preview(as: .systemMedium) {
    AquariumWidget()
} timeline: {
    AquariumEntry(
        date: Date(),
        creatures: [
            SharedCreature(from: Creature(name: "니모", type: .fish)),
            SharedCreature(from: Creature(name: "해파리", type: .jellyfish)),
            SharedCreature(from: Creature(name: "꼬북이", type: .turtle)),
            SharedCreature(from: Creature(name: "뿌기", type: .pufferfish)),
        ],
        timeOfDay: .afternoon
    )
}
