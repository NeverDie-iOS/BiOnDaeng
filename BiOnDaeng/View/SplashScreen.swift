import SwiftUI
import Lottie

struct SplashScreen: View {
    @State private var isActive: Bool = false
    @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false

    var body: some View {
        if isActive && hasSeenWelcome {
            MainView()
        } else if isActive && !hasSeenWelcome {
            WelcomeView()
        } else {
            ZStack {
                LottieView(fileName: "test", loopMode: .loop)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct LottieView: UIViewRepresentable {
    let fileName: String
    let loopMode: LottieLoopMode

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: fileName)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        return animationView
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        // 필요 시 업데이트 로직을 추가할 수 있음
    }
}
