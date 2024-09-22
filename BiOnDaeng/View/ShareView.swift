import SwiftUI
import UIKit
import KakaoSDKShare

struct ShareView: View {
    @State private var showShareSheet = false
    @State private var imageToShare: URL? = nil

    var body: some View {
        VStack {
            // 공유할 뷰
            shareableView
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()

            Button(action: {
                if let image = createImageFromView() {
                    // 이미지 로컬에 저장
                    saveImageToDocuments(image: image) { url in
                        if let url = url {
                            imageToShare = url
                            showShareSheet = true
                        }
                    }
                }
            }) {
                Text("이미지 공유하기")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let imageUrl = imageToShare {
                ShareSheet(activityItems: [imageUrl]) // ShareSheet 호출
            }
        }
    }

    // 공유할 뷰를 정의하는 computed property
    var shareableView: some View {
        VStack {
            Text("공유할 뷰입니다!")
                .font(.largeTitle)
                .padding()
            Image(systemName: "star.fill") // 예시 이미지
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.yellow)
        }
        .padding()
    }

    // UIImage를 생성하는 함수
    func createImageFromView() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 200))
        return renderer.image { context in
            let view = UIHostingController(rootView: shareableView)
            view.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
            view.view.backgroundColor = .clear
            view.view.layer.render(in: context.cgContext)
        }
    }

    // 이미지를 Documents 디렉토리에 저장하는 함수
    func saveImageToDocuments(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let data = image.pngData() else {
            completion(nil)
            return
        }
        
        // Documents 디렉토리 경로
        let filename = getDocumentsDirectory().appendingPathComponent("sharedImage.png")
        
        do {
            try data.write(to: filename)
            completion(filename) // 저장된 파일의 URL 반환
        } catch {
            print("이미지 저장 실패: \(error)")
            completion(nil)
        }
    }

    // Documents 디렉토리의 경로를 가져오는 함수
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
 
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView()
    }
}
