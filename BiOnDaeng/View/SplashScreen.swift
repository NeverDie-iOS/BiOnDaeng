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
            LottieView(fileName: "splash", loopMode: .loop)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
                .background(Color(hex: "006FC2")!)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct LottieView: UIViewRepresentable {
    let fileName: String
    let loopMode: LottieLoopMode

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name: fileName)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleToFill // 변경된 부분
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        // Constraints를 수정하여 애니메이션이 전체 화면을 차지하도록 설정
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // 필요 시 업데이트 로직을 추가할 수 있음
    }
}
