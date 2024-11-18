import SwiftUI

struct MainThemeView: View {
    @StateObject private var weatherNow = NowModel()
    @StateObject private var weatherShort = ShortTermModel()
    @Binding var myLocation: String
    @State private var isFirstAppear = true
    
    var body: some View {
        let mainImage = (weatherNow.precipitationType.isEmpty || weatherNow.precipitationType == "0" || weatherNow.precipitationType == "3" || weatherNow.precipitationType == "7") ? "MainTheme_Sunny" : "MainTheme"
        
        Image(mainImage)
            .resizable()
            .padding(.horizontal)
            .overlay(
                VStack(spacing: -5) {
                    ZStack {
                        Text("\(weatherNow.temperature.isEmpty ? "⁻°" : weatherNow.temperature + "°")")
                            .font(.pretendardMedium(size: 45))
                            .foregroundStyle(Color(hex: "FFFFFF")!)
                        
                        let minTemp = weatherShort.tmn.isEmpty ? "" : String(Int(Double(weatherShort.tmn)!))
                        let maxTemp = weatherShort.tmx.isEmpty ? "" : String(Int(Double(weatherShort.tmx)!))
                        let precipitationDesc = weatherNow.precipitationType.isEmpty ? "" : getPrecipitationDescription(pty: weatherNow.precipitationType).0
                        
                        Text("\(minTemp)°/\(maxTemp)°/\(precipitationDesc)")
                                                    .font(.pretendardExtraLight(size: 9.5))
                                                    .foregroundStyle(Color(hex: "FBFCFE")!)
                                                    .offset(x: 45, y: 11)
                        
                        Image("\(weatherNow.precipitationType.isEmpty ? "Sunny" : getPrecipitationDescription(pty: weatherNow.precipitationType).1)")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .offset(x: 63, y: -6)
                    }
                    .padding(.leading, 10)
                    
                    Text("강수 확률 \(weatherShort.pop.isEmpty  ? "-%" : weatherShort.pop[0] + "%")")
                        .font(.pretendardVariable(size: 13))
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
                return ("비ㆍ눈", "SnowyAndRainy")
            case "3":
                return ("눈", "Snowy")
            case "5":
                return ("빗방울", "Rainfall")
            case "6":
                return ("빗방울눈날림", "SnowyAndRainy")
            case "7":
                return ("눈날림", "Snowy")
            default:
                return ("-", "-")
        }
    }
}
