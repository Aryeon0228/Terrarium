import SwiftUI

struct Bubble: Identifiable {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var speed: Double

    init(
        id: UUID = UUID(),
        x: CGFloat = CGFloat.random(in: 0.1...0.9),
        y: CGFloat = 1.0,
        size: CGFloat = CGFloat.random(in: 4...12),
        opacity: Double = Double.random(in: 0.3...0.7),
        speed: Double = Double.random(in: 0.003...0.008)
    ) {
        self.id = id
        self.x = x
        self.y = y
        self.size = size
        self.opacity = opacity
        self.speed = speed
    }
}
