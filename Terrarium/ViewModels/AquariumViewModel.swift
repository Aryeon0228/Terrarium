import SwiftUI
import Combine

@MainActor
class AquariumViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var creatures: [Creature] = []
    @Published var bubbles: [Bubble] = []
    @Published var timeOfDay: TimeOfDay = .current()
    @Published var showEditor = false

    // MARK: - Private
    private var moveTimer: Timer?
    private var bubbleTimer: Timer?
    private var timeCheckTimer: Timer?

    private let saveKey = "savedCreatures"

    // MARK: - Init
    init() {
        loadCreatures()
        startTimers()
    }

    deinit {
        moveTimer?.invalidate()
        bubbleTimer?.invalidate()
        timeCheckTimer?.invalidate()
    }

    // MARK: - Timer Management
    func startTimers() {
        // 생물 이동 타이머 (60fps에 가까운 업데이트)
        moveTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateCreaturePositions()
            }
        }

        // 거품 생성 타이머
        bubbleTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.spawnBubble()
            }
        }

        // 시간대 체크 타이머 (매 분마다)
        timeCheckTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateTimeOfDay()
            }
        }
    }

    func stopTimers() {
        moveTimer?.invalidate()
        bubbleTimer?.invalidate()
        timeCheckTimer?.invalidate()
        moveTimer = nil
        bubbleTimer = nil
        timeCheckTimer = nil
    }

    // MARK: - Creature Movement
    private func updateCreaturePositions() {
        for index in creatures.indices {
            let speed = CGFloat(creatures[index].speed) * 0.005

            if creatures[index].movingRight {
                creatures[index].positionX += speed
                if creatures[index].positionX > 0.95 {
                    creatures[index].movingRight = false
                }
            } else {
                creatures[index].positionX -= speed
                if creatures[index].positionX < 0.05 {
                    creatures[index].movingRight = true
                }
            }

            // 약간의 상하 움직임 (사인파)
            let time = Date().timeIntervalSinceReferenceDate
            let verticalOffset = sin(time * creatures[index].speed + Double(index)) * 0.01
            creatures[index].positionY += CGFloat(verticalOffset) * 0.1
            creatures[index].positionY = max(0.05, min(0.85, creatures[index].positionY))
        }
    }

    // MARK: - Bubble Management
    private func spawnBubble() {
        guard bubbles.count < 20 else { return }
        let bubble = Bubble()
        bubbles.append(bubble)

        // 거품 상승 애니메이션
        updateBubbles()
    }

    private func updateBubbles() {
        bubbles = bubbles.compactMap { bubble in
            var updated = bubble
            updated.y -= updated.speed
            updated.opacity -= 0.005
            if updated.y < -0.1 || updated.opacity <= 0 {
                return nil
            }
            return updated
        }
    }

    // MARK: - Time of Day
    private func updateTimeOfDay() {
        let newTime = TimeOfDay.current()
        if newTime != timeOfDay {
            withAnimation(.easeInOut(duration: 2.0)) {
                timeOfDay = newTime
            }
        }
    }

    // MARK: - Creature CRUD
    func addCreature(_ creature: Creature) {
        var newCreature = creature
        newCreature.positionX = CGFloat.random(in: 0.1...0.9)
        newCreature.positionY = CGFloat.random(in: 0.15...0.8)
        newCreature.movingRight = Bool.random()
        creatures.append(newCreature)
        saveCreatures()
        syncToWidget()
    }

    func removeCreature(at offsets: IndexSet) {
        creatures.remove(atOffsets: offsets)
        saveCreatures()
        syncToWidget()
    }

    func removeCreature(id: UUID) {
        creatures.removeAll { $0.id == id }
        saveCreatures()
        syncToWidget()
    }

    // MARK: - Persistence (UserDefaults)
    private func saveCreatures() {
        if let encoded = try? JSONEncoder().encode(creatures) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadCreatures() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Creature].self, from: data) {
            creatures = decoded
        } else {
            // 기본 생물 추가
            creatures = [
                Creature(name: "니모", type: .fish, size: 35, speed: 1.2),
                Creature(name: "해파리", type: .jellyfish, size: 45, speed: 0.5),
                Creature(name: "꼬북이", type: .turtle, size: 50, speed: 0.8),
            ]
            saveCreatures()
        }
    }

    // MARK: - App Groups (Widget Sync)
    func syncToWidget() {
        let shared = SharedAquariumData(
            creatures: creatures.map { SharedCreature(id: $0.id, name: $0.name, typeRawValue: $0.type.rawValue, emoji: $0.type.emoji, size: Double($0.size)) },
            timeOfDay: timeOfDay.rawValue,
            lastUpdated: Date()
        )
        SharedAquariumData.save(shared)
    }
}
