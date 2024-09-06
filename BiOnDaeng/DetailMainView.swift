import SwiftUI

struct DetailMainView: View {
    var body: some View {
        VStack {
            HStack(spacing: 6) {
                VStack {
                    Text("최고 습도")
                    Image("Drop")
                    Text("60%")
                }
                .frame(width: 153 * UIScreen.main.bounds.width / 393, height: 159 * UIScreen.main.bounds.height / 852)
                .overlay( RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "4B81C2")!, lineWidth: 1)
                )
                VStack {
                    Text("최저 습도")
                    Image("Drop")
                    Text("40%")
                }
                .frame(width: 153 * UIScreen.main.bounds.width / 393, height: 159 * UIScreen.main.bounds.height / 852)
                .overlay( RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "4B81C2")!, lineWidth: 1)
                )
            }
            .padding(.top, 32)
            
            Text("강수 확률")
                .font(.pretendardMedium(size: 12))
                .foregroundStyle(Color(hex: "707070")!)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 26)
                .padding(.leading, 40)
            
            VStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 18) {
                        ForEach(1...24, id: \.self) { index in
                            VStack {
                                Text("오후 12시")
                                    .font(.pretendardExtraLight(size: 10))
                                    .foregroundStyle(Color(.white))
                                    .fixedSize()
                                Image("Rainy")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                Text("50%")
                                    .font(.pretendardExtraLight(size: 12.5))
                                    .fixedSize()
                                    .foregroundStyle(Color(hex: "FFDA3F")!)
                            }
                            .frame(width: 38 * UIScreen.main.bounds.width / 386, height: 82 * UIScreen.main.bounds.height / 848)
                        }
                    }
                }
                .frame(width: 270 * UIScreen.main.bounds.width / 393, height: 130 * UIScreen.main.bounds.height / 848)
                .padding(.horizontal, 26)
                
                Text("현재 강수 확률 60%")
                    .padding(.bottom, 26)
                    .font(.pretendardMedium(size: 12))
            }
            .background(Color(hex: "4B81C2"))
            .clipShape(RoundedRectangle(cornerRadius: 17))
            .padding(.top, 8)
            
            Text("대기질")
                .font(.pretendardMedium(size: 12))
                .foregroundStyle(Color(hex: "707070")!)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 26)
                .padding(.leading, 40)
            
            
            HStack{
                Image("Dog")
                    .resizable()
                    .frame(width: 176 * UIScreen.main.bounds.width / 393, height: 176 * UIScreen.main.bounds.height / 848)
                
                VStack {
                    HStack {
                        Text("미세먼지")
                            .font(.pretendardMedium(size: 12))
                            .foregroundStyle(Color(hex: "FBFCFE")!)
                        Text("나쁨")
                            .font(.pretendardMedium(size: 12))
                            .foregroundStyle(Color(hex: "FBFCFE")!)
                    }
                    
                    Spacer().frame(height: 15)
                    
                    HStack {
                        Text("초미세먼지")
                            .font(.pretendardMedium(size: 12))
                            .foregroundStyle(Color(hex: "FBFCFE")!)
                        Text("나쁨")
                            .font(.pretendardMedium(size: 12))
                            .foregroundStyle(Color(hex: "FBFCFE")!)
                    }
                }
            }
            .frame(width: 313 * UIScreen.main.bounds.width / 393, height: 163 * UIScreen.main.bounds.height / 852)
            .background(Color(hex: "4B81C2"))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.top, 8)

            
            Spacer()
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
