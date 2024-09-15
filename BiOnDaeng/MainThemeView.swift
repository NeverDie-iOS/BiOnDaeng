import SwiftUI

struct MainThemeView: View {
    var body: some View {
        Image("MainTheme")
            .resizable()
            .padding(.horizontal)
            .overlay(
                VStack {
                    ZStack {
                        Text("15°")
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
                    .padding(.top, 20)
                    .padding(.leading, 10),
                alignment: .topLeading
            )
    }
}
