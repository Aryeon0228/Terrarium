import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AquariumViewModel()

    var body: some View {
        ZStack {
            // 수족관 메인 뷰
            AquariumView(viewModel: viewModel)

            // 하단 버튼
            VStack {
                Spacer()

                HStack(spacing: 16) {
                    // 생물 추가 버튼
                    Button {
                        viewModel.showEditor = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("생물 추가")
                        }
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $viewModel.showEditor) {
            CreatureEditorView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.syncToWidget()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
