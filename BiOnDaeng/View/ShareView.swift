import SwiftUI

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
                    Button(action: {}) {
                        Image("KakaoShareButton")
                            .resizable()
                            .frame(width: 56, height: 56)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image("InstaShareButton")
                            .resizable()
                            .frame(width: 56, height: 56)
                    }
                    Spacer()
                    Button(action: {}) {
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
                
                Text("\(myLocation)은")
                    .font(.pretendardExtraLight(size: 15))
                    .foregroundColor(.white)
                    .padding(.leading, 19)
                
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
