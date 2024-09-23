import SwiftUI

struct DetailMainView: View {
    var body: some View {
        VStack {
            HStack(spacing: 12) {
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
                .frame(width: 167 * UIScreen.main.bounds.width / 393, height: 163 * UIScreen.main.bounds.height / 852
                       , alignment: .topLeading)
                .background(Color(hex: "006FC2"))
                .clipShape(RoundedRectangle(cornerRadius: 27))
                
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
                .frame(width: 167 * UIScreen.main.bounds.width / 393, height: 163 * UIScreen.main.bounds.height / 852
                       , alignment: .topLeading)
                .background(Color(hex: "006FC2"))
                .clipShape(RoundedRectangle(cornerRadius: 27))
            }
            
            ZStack(alignment: .top) {
                Image("DetailViewTheme")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack(alignment: .leading, spacing: 17) {
                    VStack {
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 20) {
                                ForEach(1...24, id: \.self) { index in
                                    VStack {
                                        Text("오후 12시")
                                            .font(.pretendardMedium(size: 8))
                                            .foregroundStyle(Color(.white))
                                            .fixedSize()
                                        Image("Rainy")
                                            .resizable()
                                            .frame(width: 19, height: 19)
                                        Text("50%")
                                            .font(.pretendardMedium(size: 8))
                                            .fixedSize()
                                            .foregroundStyle(Color.white)
                                    }
                                    .frame(width: 38 * UIScreen.main.bounds.width / 393, height: 82 * UIScreen.main.bounds.height / 852)
                                }
                            }
                            .padding(.leading, 27)
                            .padding(.trailing, 37)
                        }
                    }
                    .frame(width: 318 * UIScreen.main.bounds.width / 393, height: 85 * UIScreen.main.bounds.height / 852)
                    .background(Color(hex: "00B1FF"))
                    .clipShape(RoundedRectangle(cornerRadius: 27))
                    .overlay(RoundedRectangle(cornerRadius: 27)
                        .stroke(Color(hex: "FFFFF")!, lineWidth: 1)
                    )
                    
                    .offset(y: 16)
                    
                    Text("비 온다~~")
                        .padding(.leading, 4)
                }
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
         
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
