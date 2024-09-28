import SwiftUI
import Combine
import Alamofire
import AVKit

struct DetailMainView: View {
    @StateObject private var viewModel = CctvViewModel()
    @AppStorage("myLocation") var myLocation: String = "지역(구/동)을 설정하세요."
    @State private var isVideoPlayerVisible = false
    @State private var showAlert = false // 지역 미설정 상태에 cctv 버튼 클릭 시
    @StateObject private var weatherNow = NowModel()
    @StateObject private var weatherShort = ShortTermModel()
    @AppStorage("longitude") var longitude: String = "0"
    @AppStorage("latitude") var latitude: String = "0"
    
    
    var body: some View {
        ZStack {
            VStack {
                weatherInfoView
                weatherDetailView
                Spacer()
            }
            .onAppear {
                weatherNow.fetchWeather()
                weatherShort.fetchPopPty()
            }
            .onChange(of: myLocation) { newValue in
                weatherNow.fetchWeather()
                weatherShort.fetchPopPty()
            }
            
            if isVideoPlayerVisible, let url = viewModel.closestCCTV?.cctvurl {
                videoPlayerView(url: url)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("위치 설정 필요"),
                message: Text("지역(구/동)을 선택해주세요."),
                dismissButton: .default(Text("확인"))
            )
        }
    }
    private var weatherInfoView: some View {
        HStack(spacing: 12) {
            weatherCard(title: "강수량", value: weatherNow.rainfall) {
                if myLocation == "지역(구/동)을 설정하세요." {
                    showAlert = true
                } else {
                    viewModel.getCCTVUrl(lat: Double(latitude)!, lng: Double(longitude)!)
                    isVideoPlayerVisible = true
                }
            }
            weatherCard(title: "습도", value: weatherNow.humidity + "%")
        }
    }
    
    private func weatherCard(title: String, value: String, action: (() -> Void)? = nil) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(title == "강수량" ? "Rainfall" : "Humidity")
                    .resizable()
                    .frame(width: 10, height: 16)
                Text(title)
                    .font(.pretendardExtraLight(size: 12))
                    .foregroundStyle(Color.white)
            }
            .padding(.leading, 24)
            .padding(.top, 16)
            
            VStack(spacing: 3) {
                Text(value.isEmpty ? "-" : value)
                    .font(.pretendardMedium(size: 30))
                    .foregroundStyle(Color.white)
                
                if let action = action {
                    Button(action: action) {
                        HStack(spacing: 4) {
                            Image("CCTV")
                                .resizable()
                                .frame(width: 16, height: 14)
                            Text("CCTV")
                                .font(.pretendardMedium(size: 11))
                                .foregroundStyle(Color.black)
                        }
                    }
                    .frame(width: 70, height: 33)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 17))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
        }
        .frame(width: 167 * UIScreen.main.bounds.width / 393, height: 163 * UIScreen.main.bounds.height / 852, alignment: .topLeading)
        .background(Color(hex: "006FC2"))
        .clipShape(RoundedRectangle(cornerRadius: 27))
    }
    
    private var weatherDetailView: some View {
        ZStack(alignment: .top) {
            Image("DetailViewTheme")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(alignment: .leading, spacing: 17) {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 20) {
                        ForEach(weatherShort.pop.indices, id: \.self) { index in
                            precipitationView(for: index)
                        }
                    }
                    .padding(.leading, 27)
                    .padding(.trailing, 37)
                }
                .frame(width: 318 * UIScreen.main.bounds.width / 393, height: 85 * UIScreen.main.bounds.height / 852)
                .background(Color(hex: "00B1FF"))
                .clipShape(RoundedRectangle(cornerRadius: 27))
                .overlay(RoundedRectangle(cornerRadius: 27)
                    .stroke(Color(hex: "FFFFF")!, lineWidth: 1)
                )
                .padding(.top, 16)
                
                Text(rainfallDescription())
                    .padding(.leading, 4)
                    .padding(.top, 10)
                    .font(.pretendardExtraLight(size: 10))
                    .lineSpacing(12)
                    .foregroundStyle(Color.white)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func precipitationView(for index: Int) -> some View {
        VStack {
            let currentDate = Date()
            let calendar = Calendar.current
            let targetHour = calendar.component(.hour, from: currentDate) + index + 1
            let adjustedHour = targetHour % 24
            
            Text("\(weatherShort.pop[index] + "%")")
                .font(.pretendardMedium(size: 8))
                .foregroundStyle(Color(.white))
                .fixedSize()
            Image("\(getPrecipitationDescription(pty: weatherShort.pty[index]))")
                .resizable()
                .frame(width: 20, height: 20)
            Text("\(adjustedHour)시")
                .font(.pretendardMedium(size: 8))
                .fixedSize()
                .foregroundStyle(Color.white)
        }
        .frame(width: 38 * UIScreen.main.bounds.width / 393, height: 82 * UIScreen.main.bounds.height / 852)
    }
    
    private func videoPlayerView(url: String) -> some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VideoPlayerView(url: url)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
                    .cornerRadius(10)
                
                Spacer().frame(height: 30)
                
                Button(action: {
                    isVideoPlayerVisible = false
                }) {
                    Text("닫기")
                        .font(.headline)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
        }
        .transition(.opacity)
    }
    
    private func rainfallDescription() -> String {
        if weatherNow.rainfall == "30~50mm" {
            return """
                '폭우'라고 불리는 수준의 비입니다. 
                비로 인한 본격적인 피해가 예상되므로 
                호우 대비가 필요해요.
                """
        } else if weatherNow.rainfall == "50.0mm 이상" {
            return """
                흔히 말하는 장대비로, 
                세차게 쏟아지는 비입니다.
                비로 인해 시야가 확보되지 않아요. 
                마치 하늘에서 누군가가 양동이로 
                물을 퍼붓는다는 느낌을 줘요.
                """
        } else if weatherNow.rainfall == "0mm" {
            return """
                지금은 비가 오지 않아요.
                오늘은 날씨가 맑아요.
                가볍게 작은 우산을 챙겨도 좋을 것 같네요.
                좋은 하루 보내세요~!
                """
        } else {
            switch weatherNow.rainfall {
                case let x where x.hasSuffix("mm"):
                    let numericValueString = x.replacingOccurrences(of: "mm", with: "")
                    if let numericValue = Double(numericValueString) {
                        switch numericValue {
                            case 0..<1:
                                return """
                            ‘매우 약한 비'가 내리고 있습니다.
                            1mm 이하의 강수량이라서
                            일상생활에 큰 지장을 주진 않아요.
                            ‘이슬비'라고도 이야기하는 가벼운 비입니다.
                            가볍게 작은 우산을 챙겨도 좋을 것 같네요!
                            """
                            case 1..<4:
                                return """
                            ‘약한 비'가 내리고 있습니다.
                            비가 내리는 시간이 길어질 경우,
                            배수시설이 잘 되어 있지 않으면 
                            물이 고일 수 있어요.
                            """
                            case 4..<8:
                                return """
                            ‘보통 비'가 내리고 있습니다.
                            도로에 물 웅덩이가 생길 수 있어요.
                            따라서 길을 걸을 때 
                            신발과 옷을 주의하세요!
                            또한 비로 인한 교통체증이 예상됩니다.
                            """
                            case 8..<15:
                                return """
                            ‘많은 비'가 내리고 있습니다.
                            이 정도의 비는 
                            쏟아붓는 느낌의 비입니다.
                            외출 혹은 차량 운행은 
                            자제하는 것이 좋아요.
                            """
                            case 15..<30:
                                return """
                            ‘강한 비'가 내리고 있습니다.
                            이 정도의 비는 단시간에 쏟아질 경우 도로가 잠기고
                            교통이 순간적으로 마비될 수 있어요.
                            주택의 지대가 낮거나 지하 시설의 경우 
                            침수가 발생할 수 있어요.
                            """
                            default:
                                return ""
                        }
                    }
                default:
                    return ""
            }
        }
        return ""
    }
    
    func getPrecipitationDescription(pty: String ) -> String {
        switch pty {
            case "0":
                return "Sunny"
            case "1":
                return "Rainy"
            case "2":
                return "SnowyAndRainy"
            case "3":
                return "Snowy"
            case "4":
                return "Shower"
            default:
                return ""
        }
    }
}

struct DetailMainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailMainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone 15 Pro")
            DetailMainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE (3rd generation)")
        }
    }
}
