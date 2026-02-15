import SwiftUI

enum CreatureType: String, CaseIterable, Codable, Identifiable {
    case fish = "물고기"
    case pufferfish = "복어"
    case jellyfish = "해파리"
    case turtle = "거북이"
    case shark = "상어"
    case octopus = "문어"
    case crab = "게"
    case shell = "조개"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .fish: return "🐠"
        case .pufferfish: return "🐡"
        case .jellyfish: return "🪼"
        case .turtle: return "🐢"
        case .shark: return "🦈"
        case .octopus: return "🐙"
        case .crab: return "🦀"
        case .shell: return "🐚"
        }
    }
}

struct Creature: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: CreatureType
    var color: CodableColor
    var size: CGFloat
    var speed: Double
    var positionX: CGFloat
    var positionY: CGFloat
    var movingRight: Bool

    init(
        id: UUID = UUID(),
        name: String = "",
        type: CreatureType = .fish,
        color: CodableColor = CodableColor(color: .orange),
        size: CGFloat = 40,
        speed: Double = 1.0,
        positionX: CGFloat = 0.5,
        positionY: CGFloat = 0.5,
        movingRight: Bool = Bool.random()
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.color = color
        self.size = size
        self.speed = speed
        self.positionX = positionX
        self.positionY = positionY
        self.movingRight = movingRight
    }
}

struct CodableColor: Codable, Equatable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(color: Color) {
        // Default fallback values
        self.red = 1.0
        self.green = 0.5
        self.blue = 0.0
        self.opacity = 1.0
    }

    init(red: Double, green: Double, blue: Double, opacity: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}
