import SwiftUI
struct MainThemeView: View {
    @StateObject private var weatherNow = NowModel()
    @StateObject private var weatherShort = ShortTermModel()
    @Binding var myLocation: String
    
    var body: some View {
        Image("MainTheme")
            .resizable()
            .padding(.horizontal)
            .overlay(
                VStack {
                    ZStack {
                        Text("\(weatherNow.temperature.isEmpty ? "-°" : weatherNow.temperature + "°")")
                            .font(.pretendardLight(size: 45))
                            .foregroundStyle(Color(hex: "FFFFFF")!)
                        Text("\(weatherShort.tmx.isEmpty ? "" : weatherShort.tmx + "°/ ") \(weatherShort.tmn.isEmpty ? "" : weatherShort.tmn + "°/ ") \(weatherShort.pty.isEmpty  ? "" : getPrecipitationDescription(pty: weatherShort.pty[0]))")
                            .font(.pretendardExtraLight(size: 7))
                            .foregroundStyle(Color(hex: "FBFCFE")!)
                            .offset(x: 45, y: 11)
                    }
                    .padding(.leading, 10)
                    
                    Text("강수 확률 \(weatherShort.pop.isEmpty  ? "-%" : weatherShort.pop[0] + "%")")
                        .font(.pretendardVariable(size: 12))
                        .foregroundStyle(Color(hex: "FFFFFF")!)
                        .padding(.leading, 45)
                }
                .onAppear {
                    weatherNow.fetchWeather()
                    weatherShort.fetchTmxTmn()
                    weatherShort.fetchPopPty()
                }
                .onChange(of: myLocation) { newValue in
                    weatherNow.fetchWeather()
                    weatherShort.fetchTmxTmn()
                    weatherShort.fetchPopPty()
                }
                .padding(.top, 20)
                .padding(.leading, 10),
                alignment: .topLeading
            )
    }
    
    func getPrecipitationDescription(pty: String ) -> String {
            switch pty {
            case "0":
                return "맑음"
            case "1":
                return "비"
            case "2":
                return "비/눈"
            case "3":
                return "눈"
            case "4":
                return "소나기"
            default:
                return "알 수 없음"
            }
        }
}
