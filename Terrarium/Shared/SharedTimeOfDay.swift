import SwiftUI

/// Widget에서 사용하는 시간대 헬퍼
enum SharedTimeOfDay: String, Codable {
    case morning
    case afternoon
    case evening
    case night

    static func current() -> SharedTimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return .morning
        case 12..<18:
            return .afternoon
        case 18..<21:
            return .evening
        default:
            return .night
        }
    }

    var displayName: String {
        switch self {
        case .morning: return "아침"
        case .afternoon: return "낮"
        case .evening: return "저녁"
        case .night: return "밤"
        }
    }

    var topColor: Color {
        switch self {
        case .morning:
            return Color(red: 0.53, green: 0.81, blue: 0.98)
        case .afternoon:
            return Color(red: 0.0, green: 0.48, blue: 0.80)
        case .evening:
            return Color(red: 0.95, green: 0.55, blue: 0.25)
        case .night:
            return Color(red: 0.05, green: 0.05, blue: 0.20)
        }
    }

    var bottomColor: Color {
        switch self {
        case .morning:
            return Color(red: 0.0, green: 0.35, blue: 0.55)
        case .afternoon:
            return Color(red: 0.0, green: 0.20, blue: 0.50)
        case .evening:
            return Color(red: 0.20, green: 0.10, blue: 0.40)
        case .night:
            return Color(red: 0.0, green: 0.0, blue: 0.10)
        }
    }
}
