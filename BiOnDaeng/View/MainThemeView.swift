import SwiftUI
struct MainThemeView: View {
    @StateObject private var weatherNow = NowModel()
    @Binding var myLocation: String
    
    var body: some View {
        Image("MainTheme")
            .resizable()
            .padding(.horizontal)
            .overlay(
                VStack {
                    ZStack {
                        Text("\(weatherNow.temperature.isEmpty ? "-°" : weatherNow.temperature + "°")")
                            .font(.pretendardMedium(size: 36))
                            .foregroundStyle(Color(hex: "FBFCFE")!)
                        Text("25° / 12° / 흐림")
                            .font(.pretendardExtraLight(size: 7))
                            .foregroundStyle(Color(hex: "FBFCFE")!)
                            .offset(x: 42, y: 11)
                    }
                    Text("강수 확률 60%")
                        .font(.pretendardMedium(size: 12))
                        .foregroundStyle(Color(hex: "FBFCFE")!)
                        .padding(.leading, 40)
                }
                .onAppear {
                    weatherNow.fetchWeather()
                }
                .onChange(of: myLocation) { newValue in
                    weatherNow.fetchWeather()
                }
                .padding(.top, 20)
                .padding(.leading, 10),
                alignment: .topLeading
            )
    }
}
