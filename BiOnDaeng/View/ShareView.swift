//import SwiftUI
//import SafariServices
//import KakaoSDKCommon
//import KakaoSDKShare
//import KakaoSDKTemplate
//
//struct ShareView: View {
//    @State private var safariViewURL: URL? = nil
//    @State private var showSafariView = false
//    var body: some View {
//        VStack {
//            Button(action: {
//                shareToKakaoTalk()
//            }) {
//                Text("카카오톡으로 공유하기")
//                    .padding()
//                    .background(Color.yellow)
//                    .cornerRadius(8)
//            }
//            .sheet(isPresented: $showSafariView) {
//                if let url = safariViewURL {
//                    SafariView(url: url)
//                }
//            }
//        }
//    }
//    
//    func shareToKakaoTalk() {
//        let feedTemplateJsonStringData = """
//        {
//            "object_type": "feed",
//            "content": {
//            "title": "비온댕: 우산을 챙겨주는 강아지",
//            "image_url":
//            "https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png",
//            "link": {
//            "mobile_web_url": "https://developers.kakao.com",
//            "web_url": "https://developers.kakao.com"
//            }
//        }
//    }
//    """.data(using: .utf8)!
//        
//        // JSON 문자열을 Dictionary로 변환
//        guard let templatable = try? JSONSerialization.jsonObject(with:
//                                                                    feedTemplateJsonStringData, options: []) as? [String: Any] else {
//            print("Failed to decode feed template")
//            return
//        }
//        // 카카오톡 설치 여부 확인
//        if ShareApi.isKakaoTalkSharingAvailable() {
//            ShareApi.shared.shareDefault(templateObject: templatable) {
//                sharingResult, error in
//                if let error = error {
//                    print("Error: \(error)")
//                } else {
//                    print("shareDefault() success.")
//                    if let sharingResult = sharingResult {
//                        UIApplication.shared.open(sharingResult.url,
//                                                  options: [:], completionHandler: nil)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct SafariView: UIViewControllerRepresentable {
//    let url: URL
//    func makeUIViewController(context: Context) -> SFSafariViewController {
//        return SFSafariViewController(url: url)
//    }
//    func updateUIViewController(_ uiViewController: SFSafariViewController,
//        context: Context) {}
//}
//
//struct ContentView: View {
//    var body: some View {
//        ShareView()
//    }
//}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareView()
//    }
//}
