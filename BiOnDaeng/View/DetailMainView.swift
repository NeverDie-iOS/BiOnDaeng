import SwiftUI

struct DetailMainView: View {
    var body: some View {
        VStack {
            HStack(spacing: 6) {
                VStack(alignment: .leading) {
                    HStack {
                        Image("Rainfall")
                            .resizable()
                            .frame(width: 10, height: 16)
                        Text("강수량")
                            .font(.pretendardExtraLight(size: 12))
                            .foregroundStyle(Color.white)
                    }
                    .padding(.leading, 24)
                    .padding(.top, 16)
                    
                    VStack(spacing: 3) {
                        Text("5mm")
                            .font(.pretendardMedium(size: 30))
                            .foregroundStyle(Color.white)
                        
                        Button(action: {
                            // CCTV 불러오기
                        }){
                            HStack(spacing: 4) {
                                Image("CCTV")
                                    .resizable()
                                    .frame(width: 16,height: 14)
                                Text("CCTV")
                                    .font(.pretendardMedium(size: 11))
                                    .foregroundStyle(Color.black)
                            }
                        }
                        .frame(width: 70, height: 33)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 17))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                }
                .frame(width: 153 * UIScreen.main.bounds.width / 393, height: 159 * UIScreen.main.bounds.height / 852
                       , alignment: .topLeading)
                .background(Color(hex: "006FC2"))
                .clipShape(RoundedRectangle(cornerRadius: 17))
                
                VStack(alignment: .leading) {
                    HStack {
                        Image("Humidity")
                            .resizable()
                            .frame(width: 10,height: 16)
                        Text("습도")
                            .font(.pretendardExtraLight(size: 12))
                            .foregroundStyle(Color.white)
                    }
                    .padding(.leading, 24)
                    .padding(.top, 16)
                    
                    VStack(spacing: 3) {
                        Text("40%")
                            .font(.pretendardMedium(size: 30))
                            .foregroundStyle(Color.white)
                        Text("")
                            .frame(width: 70, height: 33)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                }
                .frame(width: 153 * UIScreen.main.bounds.width / 393, height: 159 * UIScreen.main.bounds.height / 852
                       , alignment: .topLeading)
                .background(Color(hex: "006FC2"))
                .clipShape(RoundedRectangle(cornerRadius: 17))
            }
            .padding(.top, 32)
            
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
            }
            .frame(width: 318 * UIScreen.main.bounds.width / 393, height: 85 * UIScreen.main.bounds.height / 852)
            .padding(.horizontal, 26)
            .background(Color(hex: "4B81C2"))
            .clipShape(RoundedRectangle(cornerRadius: 27))
            .padding(.top, 8)
            
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
