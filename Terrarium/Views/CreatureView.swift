import SwiftUI

struct CreatureView: View {
    let creature: Creature

    var body: some View {
        Text(creature.type.emoji)
            .font(.system(size: creature.size))
            .scaleEffect(x: creature.movingRight ? 1 : -1, y: 1)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
    }
}

#Preview {
    ZStack {
        Color.blue.opacity(0.3)
        CreatureView(creature: Creature(name: "니모", type: .fish, size: 50))
    }
}
