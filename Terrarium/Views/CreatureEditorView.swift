import SwiftUI

struct CreatureEditorView: View {
    @ObservedObject var viewModel: AquariumViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var selectedType: CreatureType = .fish
    @State private var size: CGFloat = 40
    @State private var speed: Double = 1.0

    var body: some View {
        NavigationStack {
            Form {
                // 미리보기
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Text(selectedType.emoji)
                                .font(.system(size: size))
                            Text(name.isEmpty ? selectedType.rawValue : name)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 12)
                        Spacer()
                    }
                }

                // 이름
                Section("이름") {
                    TextField("생물 이름을 입력하세요", text: $name)
                }

                // 종류 선택
                Section("종류") {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 60))
                    ], spacing: 12) {
                        ForEach(CreatureType.allCases) { type in
                            Button {
                                selectedType = type
                                if name.isEmpty {
                                    name = type.rawValue
                                }
                            } label: {
                                VStack(spacing: 4) {
                                    Text(type.emoji)
                                        .font(.system(size: 32))
                                    Text(type.rawValue)
                                        .font(.caption2)
                                        .foregroundStyle(.primary)
                                }
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedType == type
                                              ? Color.blue.opacity(0.2)
                                              : Color.clear)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedType == type
                                                ? Color.blue
                                                : Color.clear, lineWidth: 2)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // 크기
                Section("크기: \(Int(size))") {
                    Slider(value: $size, in: 20...80, step: 5) {
                        Text("크기")
                    }
                }

                // 속도
                Section("속도: \(String(format: "%.1f", speed))x") {
                    Slider(value: $speed, in: 0.2...3.0, step: 0.2) {
                        Text("속도")
                    }
                }

                // 기존 생물 목록
                if !viewModel.creatures.isEmpty {
                    Section("수족관 생물 (\(viewModel.creatures.count)마리)") {
                        ForEach(viewModel.creatures) { creature in
                            HStack {
                                Text(creature.type.emoji)
                                    .font(.title2)
                                VStack(alignment: .leading) {
                                    Text(creature.name)
                                        .font(.body)
                                    Text("크기: \(Int(creature.size)) · 속도: \(String(format: "%.1f", creature.speed))x")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                        }
                        .onDelete { offsets in
                            viewModel.removeCreature(at: offsets)
                        }
                    }
                }
            }
            .navigationTitle("생물 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("추가") {
                        let creature = Creature(
                            name: name.isEmpty ? selectedType.rawValue : name,
                            type: selectedType,
                            size: size,
                            speed: speed
                        )
                        viewModel.addCreature(creature)
                        dismiss()
                    }
                }
            }
        }
    }
}
