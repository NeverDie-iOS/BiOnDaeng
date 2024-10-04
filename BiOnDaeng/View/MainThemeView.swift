import SwiftUI

struct MainThemeView: View {
    @StateObject private var weatherNow = NowModel()
    @StateObject private var weatherShort = ShortTermModel()
    @Binding var myLocation: String
    @State private var isFirstAppear = true

    var body: some View {
        let mainImage = (weatherShort.pty.isEmpty || (weatherShort.pty[0] != "1" && weatherShort.pty[0] != "4")) ? "MainTheme_Sunny" : "MainTheme"
        
        Image(mainImage)
            .resizable()
            .padding(.horizontal)
            .overlay(
                VStack(spacing: -5) {
                    ZStack {
                        Text("\(weatherNow.temperature.isEmpty ? "⁻°" : weatherNow.temperature + "°")")
                            .font(.pretendardMedium(size: 45))
                            .foregroundStyle(Color(hex: "FFFFFF")!)
                        Text("\(weatherShort.tmx.isEmpty ? "" : weatherShort.tmx + "°/") \(weatherShort.tmn.isEmpty ? "" : weatherShort.tmn + "°/") \(weatherShort.pty.isEmpty  ? "" : getPrecipitationDescription(pty: weatherShort.pty[0]).0)")
                            .font(.pretendardExtraLight(size: 7))
                            .foregroundStyle(Color(hex: "FBFCFE")!)
                            .offset(x: 45, y: 11)
                        Image("\(weatherShort.pty.isEmpty ? "Sunny" : getPrecipitationDescription(pty: weatherShort.pty[0]).1)")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .offset(x: 50, y: -6)
                    }
                    .padding(.leading, 10)
                    
                    Text("강수 확률 \(weatherShort.pop.isEmpty  ? "-%" : weatherShort.pop[0] + "%")")
                        .font(.pretendardVariable(size: 14))
                        .foregroundStyle(Color(hex: "FFFFFF")!)
                        .padding(.leading, 45)
                }
                .onAppear {
                    if isFirstAppear {
                        weatherNow.fetchWeather()
                        weatherShort.fetchTmxTmn()
                        weatherShort.fetchPopPty()
                        isFirstAppear = false
                    }
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
    
    func getPrecipitationDescription(pty: String) -> (String, String) {
        switch pty {
        case "0":
            return ("맑음", "Sunny")
        case "1":
            return ("비", "Rainy")
        case "2":
            return ("비/눈", "SnowyAndRainy")
        case "3":
            return ("눈", "Snowy")
        case "4":
            return ("소나기", "Shower")
        default:
            return ("-", "-")
        }
    }
}
