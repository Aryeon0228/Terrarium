import SwiftUI

struct BubbleView: View {
    let bubble: Bubble

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.white.opacity(bubble.opacity * 0.8),
                        Color.white.opacity(bubble.opacity * 0.3),
                        Color.clear
                    ],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: bubble.size
                )
            )
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(bubble.opacity * 0.5), lineWidth: 0.5)
            )
            .frame(width: bubble.size, height: bubble.size)
    }
}

#Preview {
    ZStack {
        Color.blue
        BubbleView(bubble: Bubble(x: 0.5, y: 0.5, size: 20, opacity: 0.6))
    }
}
