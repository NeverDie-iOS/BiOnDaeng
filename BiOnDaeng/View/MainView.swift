import SwiftUI

struct MainView: View {
    @State var showSheet = false
    @State var shareViewVisible = false
    @StateObject private var locationManager = LocationManager()
    @AppStorage("myLocation") var myLocation: String = "지역(구/동)을 설정하세요."
    @State private var selectedTab = 0 

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack(spacing: 0) {
                        Button(action: {
                            showSheet = true
                        }) {
                            HStack {
                                Image("Search")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .scaledToFit()
                                    .padding(.leading, 7)
                                Text(myLocation)
                                    .foregroundColor(.black)
                                    .font(.pretendardMedium(size: 10))
                                Spacer()
                            }
                        }
                        .frame(width: 216, height: 31, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "E0E0E0")!, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 7)
                        .padding(.leading, 22)
                        .fullScreenCover(isPresented: $showSheet) {
                            LocationSearchView(myLocation: $myLocation)
                        }
                        
                        Button(action: {
                            locationManager.requestCurrentLocation()
                        }) {
                            Image("CurrentLocation")
                                .resizable()
                                .frame(width: 29, height: 28)
                                .scaledToFit()
                        }
                        .alert(isPresented: $locationManager.showAlert) {
                            Alert(
                                title: Text("위치 권한 필요"),
                                message: Text("위치 권한이 거부되었습니다.\n설정에서 권한을 변경해 주세요."),
                                primaryButton: .default(Text("설정으로 이동")) {
                                    locationManager.openSettings()
                                },
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SettingView()) {
                            Image("Setting")
                                .resizable()
                                .frame(width: 21, height: 21)
                                .scaledToFit()
                        }
                        .padding(.trailing, 21)
                    }
                    
                    TabView(selection: $selectedTab) {
                        MainThemeView(myLocation: $myLocation)
                            .tag(0)
                        DetailMainView()
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .padding(.top, 27)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<2, id: \.self) { index in
                            Circle()
                                .fill(selectedTab == index ? Color(hex: "006FC2")! : Color(hex:"D9D9D9")!)
                                .frame(width: 10, height: 10)
                                .onTapGesture {
                                    selectedTab = index
                                }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.top, 27)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone 15 Pro")
            MainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE (3rd generation)")
        }
    }
}
