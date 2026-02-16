import Foundation

/// Widget과 앱 간 공유되는 생물 데이터 모델
struct SharedCreature: Codable, Identifiable {
    let id: UUID
    let name: String
    let typeRawValue: String
    let emoji: String
    let size: Double

    init(id: UUID = UUID(), name: String, typeRawValue: String, emoji: String, size: Double = 40) {
        self.id = id
        self.name = name
        self.typeRawValue = typeRawValue
        self.emoji = emoji
        self.size = size
    }
}

struct SharedAquariumData: Codable {
    let creatures: [SharedCreature]
    let timeOfDay: String
    let lastUpdated: Date

    static let appGroupID = "group.com.terrarium.app"
    static let suiteName = "group.com.terrarium.app"
    static let dataKey = "sharedAquariumData"

    static func save(_ data: SharedAquariumData) {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else { return }
        if let encoded = try? JSONEncoder().encode(data) {
            userDefaults.set(encoded, forKey: dataKey)
        }
    }

    static func load() -> SharedAquariumData? {
        guard let userDefaults = UserDefaults(suiteName: suiteName),
              let data = userDefaults.data(forKey: dataKey),
              let decoded = try? JSONDecoder().decode(SharedAquariumData.self, from: data)
        else { return nil }
        return decoded
    }
}
