import SwiftUI
import SafariServices
import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate

struct ShareView: View {
    @State private var safariViewURL: URL? = nil
    @State private var showSafariView = false
    
    var body: some View {
        ZStack {
            VStack {
                Image("ShareTheme")
                    .resizable()
                    .frame(width:315, height: 315)
                
                Button(action: {
                    shareToKakaoTalk()
                }) {
                    Image("KakaoShareButton")
                        .resizable()
                        .frame(width: 56, height: 56)
                }
                .padding(.top, 65)
                .padding(.bottom, 10)
            }
            .padding(.top, 41)
            .padding(.horizontal, 20)
            .background(RoundedRectangle(cornerRadius: 13))
            .foregroundStyle(Color.white)
            .sheet(isPresented: $showSafariView) {
                if let url = safariViewURL {
                    SafariView(url: url)
                }
            }
        }
    }
    
    func shareToKakaoTalk() {
        // 예시로 사용할 템플릿 데이터
        let content = Content(
            title: "타이틀 문구",
            imageUrl: URL(string: "http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png")!,
            description: "#케익 #딸기 #삼평동 #카페 #분위기 #소개팅",
            link: Link(iosExecutionParams: ["second": "vvv"])
        )
        
        let template = FeedTemplate(content: content, buttons: [Button(title: "앱에서 보기", link: Link(iosExecutionParams: ["second": "vvv"]))])
        
        // JSON 인코딩
        let encoder = JSONEncoder()
        if let templateJsonData = try? encoder.encode(template) {
            // JSON 객체로 변환
            if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                // 카카오톡 설치 여부 확인
                if ShareApi.isKakaoTalkSharingAvailable() {
                    ShareApi.shared.shareDefault(templateObject: templateJsonObject) { (sharingResult, error) in
                        if let error = error {
                            print("Error: \(error)")
                        } else {
                            print("shareDefault() success.")
                            if let sharingResult = sharingResult {
                                UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                } else {
                    // 카카오톡 미설치: 웹 공유 사용
                    if let url = ShareApi.shared.makeDefaultUrl(templatable: template) {
                        safariViewURL = url
                        showSafariView = true
                    }
                }
            }
        }
    }
}
struct shareThemView: View {
    var body: some View {
        Image("ShareTheme")
    }
}


struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ShareView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone 15 Pro")
            ShareView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE (3rd generation)")
        }
    }

}
