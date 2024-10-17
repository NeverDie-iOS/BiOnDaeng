import SwiftUI
import SafariServices
import KakaoSDKCommon
import KakaoSDKShare

struct ShareView: View {
    @Binding var showShareView: Bool
    var myLocation: String
    var rainfall: String
    var precipitationType: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showShareView = false
                }
            
            VStack {
                ShareImageView(myLocation: myLocation, rainfall: rainfall, precipitationType: precipitationType)
                
                HStack {
                    Button(action: {
                        shareToKakao()
                    }) {
                        Image("KakaoShareButton")
                            .resizable()
                            .frame(width: 56, height: 56)
                    }
                    Spacer()
                    Button(action: {
                        shareToInstagram()
                    }) {
                        Image("InstaShareButton")
                            .resizable()
                            .frame(width: 56, height: 56)
                    }
                    Spacer()
                    Button(action: {
                        shareContent()
                    }) {
                        Image("ShareButton")
                            .resizable()
                            .frame(width: 56, height: 56)
                    }
                }
                .padding(.top, 45)
                .padding(.bottom, 45)
                .padding(.horizontal, 30)
            }
            .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.6)
            .background(Color.white)
            .cornerRadius(13)
            .offset(y: 60)
        }
    }
    
    func shareContent() {
        let imageToShare = ShareImageView(myLocation: myLocation, rainfall: rainfall, precipitationType: precipitationType).getImage() ?? UIImage()
        
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func shareToKakao() {
        guard let imageToShare = ShareImageView(myLocation: myLocation, rainfall: rainfall, precipitationType: precipitationType).getImage() else {
            print("Failed to get image.")
            return
        }
        
        ShareApi.shared.imageUpload(image: imageToShare) { (imageUploadResult, error) in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            
            guard let uploadedImageURL = imageUploadResult?.infos.original.url else {
                print("Failed to get uploaded image URL.")
                return
            }
            
            let feedTemplateJsonStringData =
            """
            {
                "object_type": "feed",
                "content": {
                    "title": "지금 여기 날씨는~?",
                    "description": "#외출 전 비가 오면 알려주는 댕댕이",
                    "image_url": "\(uploadedImageURL)",
                    "link": {
                        "mobile_web_url": "https://apps.apple.com/us/app/%EB%B9%84%EC%98%A8%EB%8C%95/id6736566563",
                        "web_url": "https://apps.apple.com/us/app/%EB%B9%84%EC%98%A8%EB%8C%95/id6736566563"
                    }
                },
                "buttons": [
                    {
                        "title": "앱으로 보기",
                        "link": {
                            "ios_execution_params": "key1=value1&key2=value2"
                        }
                    }
                ]
            }
            """.data(using: .utf8)!
            
            guard let templatable = try? JSONSerialization.jsonObject(with: feedTemplateJsonStringData, options: []) as? [String: Any] else {
                print("Failed to decode feed template")
                return
            }
            
            if ShareApi.isKakaoTalkSharingAvailable() {
                ShareApi.shared.shareDefault(templateObject: templatable) { sharingResult, error in
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        print("shareDefault() success.")
                        if let sharingResult = sharingResult {
                            UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
    }
    
    func shareToInstagram() {
        
        guard let imageToShare = ShareImageView(myLocation: myLocation, rainfall: rainfall, precipitationType: precipitationType).getImage() else {
            return
        }

        let temporaryDirectory = FileManager.default.temporaryDirectory
        let instagramImageURL = temporaryDirectory.appendingPathComponent("instagram.igo")
        
        if let imageData = imageToShare.pngData() {
            do {
                try imageData.write(to: instagramImageURL)
  
                let shareURL = URL(string: Bundle.main.metaAppKey)!
                
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor" : "#FFFFFF",
                    "com.instagram.sharedSticker.backgroundBottomColor" : "#FFFFFF"
                ]
                
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
        
                if UIApplication.shared.canOpenURL(shareURL) {
                    UIApplication.shared.open(shareURL, options: [:], completionHandler: nil)
                }
            } catch {
                print("Error writing image data \(error)")
            }
        }
    }
}
    
    struct ShareImageView: View {
        @StateObject private var weatherShort = ShortTermModel()
        var myLocation: String
        var rainfall: String
        var precipitationType: String
        
        var body: some View {
            ZStack(alignment: .topLeading) {
                let mainImage = (precipitationType.isEmpty || precipitationType == "0" || precipitationType == "3" || precipitationType == "7") ? "ShareBackground_Sunny" : "ShareBackground"
                let message = mainImage == "ShareBackground_Sunny" ?
                "맑댕" : "\(rainfall) 비온댕"
                
                Image(mainImage)
                    .resizable()
                    .scaledToFit()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(currentTime())
                        .font(.pretendardExtraLight(size: 12))
                        .foregroundColor(.white)
                        .padding(.leading, 19)
                        .opacity(0.5)
                    
                    Text("\(myLocation)은")
                        .font(.pretendardExtraLight(size: 15))
                        .foregroundColor(.white)
                        .padding(.leading, 19)
                        .opacity(0.5)
                    
                    Text(message)
                        .font(.pretendardLight(size: 28))
                        .foregroundColor(.white)
                        .padding(.leading, 19)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 19)
            .padding(.top, 20)
        }
        
        func currentTime() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "a hh:mm"
            formatter.locale = Locale(identifier: "ko_KR")
            let dateString = formatter.string(from: Date())
            return dateString.replacingOccurrences(of: "AM", with: "오전").replacingOccurrences(of: "PM", with: "오후")
        }
        
        func getImage() -> UIImage? {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
            return renderer.image { context in
                
                context.cgContext.setFillColor(UIColor(red: 0x00/255.0, green: 0x6F/255.0, blue: 0xC2/255.0, alpha: 1.0).cgColor)
                context.cgContext.fill(CGRect(x: 0, y: 0, width: 300, height: 300))
                
                let mainImage = (precipitationType.isEmpty || precipitationType == "0" || precipitationType == "3" || precipitationType == "7") ? "ShareBackground_Sunny" : "ShareBackground"
                
                if let background = UIImage(named: mainImage)?.cgImage {
                    context.cgContext.saveGState()
                    context.cgContext.translateBy(x: 0, y: 300)
                    context.cgContext.scaleBy(x: 1, y: -1)
                    context.cgContext.draw(background, in: CGRect(x: 0, y: 0, width: 300, height: 300))
                    context.cgContext.restoreGState()
                }
                
                let timeAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "Pretendard-ExtraLight", size: 12) ?? UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.5)
                ]
                
                let locationAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "Pretendard-ExtraLight", size: 15) ?? UIFont.systemFont(ofSize: 15),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.5)
                ]
                
                
                let messageAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "Pretendard-Light", size: 28) ?? UIFont.systemFont(ofSize: 28),
                    .foregroundColor: UIColor.white
                ]
                
                let timeText = currentTime()
                let locationText = "\(myLocation)"
                let message = mainImage == "ShareBackground_Sunny" ? "맑댕" : "\(rainfall) 비온댕"
                
                timeText.draw(at: CGPoint(x: 19, y: 10), withAttributes: timeAttributes)
                locationText.draw(at: CGPoint(x: 19, y: 23), withAttributes: locationAttributes)
                message.draw(at: CGPoint(x: 19, y: 37), withAttributes: messageAttributes)
            }
        }
    }
    
    struct SafariView: UIViewControllerRepresentable {
        let url: URL
        func makeUIViewController(context: Context) -> SFSafariViewController {
            return SFSafariViewController(url: url)
        }
        func updateUIViewController(_ uiViewController: SFSafariViewController,
                                    context: Context) {}
    }
    
    struct Previews: PreviewProvider {
        static var previews: some View {
            Group {
                MainView()
                    .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                    .previewDisplayName("iPhone 15 Pro")
                MainView()
                    .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                    .previewDisplayName("iPhone SE (3rd generation)")
            }
        }
    }
