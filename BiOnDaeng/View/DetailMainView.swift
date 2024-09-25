import SwiftUI
import Combine
import Alamofire
import AVKit

struct DetailMainView: View {
    @StateObject private var viewModel = CctvViewModel()
    @AppStorage("myLocation") var myLocation: String = "지역(구/동)을 설정하세요."
    @State private var isVideoPlayerVisible = false
    @State private var showAlert = false // 지역 미설정 상태에 cctv 버튼 클릭 시 띄우는 Alert

    var body: some View {
        ZStack {
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
                                if myLocation == "지역(구/동)을 설정하세요." {
                                    showAlert = true
                                } else {
                                    viewModel.getCCTVUrl(lat: 35.1711249999999, lng: 126.914122222222)
                                    isVideoPlayerVisible = true // 비디오 플레이어 표시
                                }
                            }) {
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
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                    }
                    .frame(width: 167 * UIScreen.main.bounds.width / 393, height: 163 * UIScreen.main.bounds.height / 852, alignment: .topLeading)
                    .background(Color(hex: "006FC2"))
                    .clipShape(RoundedRectangle(cornerRadius: 27))
                
                    VStack(alignment: .leading) {
                        HStack {
                            Image("Humidity")
                                .resizable()
                                .frame(width: 10, height: 16)
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
                    .frame(width: 167 * UIScreen.main.bounds.width / 393, height: 163 * UIScreen.main.bounds.height / 852, alignment: .topLeading)
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
                        .padding(.top, 16)
                        
                        Text("5mm")
                            .padding(.leading, 4)
                            .font(.pretendardExtraLight(size: 30))
                            .foregroundStyle(Color.white)
                            .padding(.top, 17)
                        Text(
"""
‘약한비'가 내리고 있습니다.
1mm 이하의 강수량이라서 일상생활에 큰 지장을 주진 않아요.
‘이슬비'라고도 이야기하는 가벼운 비에요.
가볍게 작은 우산을 챙겨도 좋을 거 같네요!
""")
                            .padding(.leading, 4)
                            .font(.pretendardExtraLight(size: 10))
                            .lineSpacing(12)
                            .foregroundStyle(Color.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
             
                Spacer()
            }
            
            if isVideoPlayerVisible, let url = viewModel.closestCCTV?.cctvurl {
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
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("위치 설정 필요"),
                message: Text("지역(구/동)을 먼저 선택해주세요."),
                dismissButton: .default(Text("확인"))
            )
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
