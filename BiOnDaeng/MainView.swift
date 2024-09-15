import SwiftUI

struct MainView: View {
    @State var showSheet = false
    @StateObject private var locationManager = LocationManager()
    @AppStorage("myLocation") var myLocation: String = ""

    var body: some View {
        VStack {
            Spacer().frame(height: 26)
            
            HStack(spacing: 0) {
                Spacer().frame(width: 21)
                
                HStack {
                    Image("Search")
                        .resizable()
                        .frame(width: 19, height: 19)
                        .padding(.vertical, 6)
                    
                    NavigationStack {
                        Button(action: {
                            showSheet = true
                        }) {
                            if myLocation.isEmpty {
                                Text("지역(구/동)을 설정하세요.")
                                    .foregroundStyle(Color.black)
                                    .font(.pretendardMedium(size: 10))
                            } else {
                                Text("\(myLocation)")
                                    .foregroundStyle(Color.black)
                                    .font(.pretendardMedium(size: 10))
                            }
                        }
                        .fullScreenCover(isPresented: $showSheet) {
                            LocationSearchView(myLocation: $myLocation)
                        }
                    }
                }
                .frame(width: 216, height: 31)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "E0E0E0")!, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                Button(action: {
                    locationManager.requestCurrentLocation()
                }) {
                    Image("CurrentLocation")
                        .resizable()
                        .frame(width: 27, height: 27)
                        .scaledToFit()
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Image("Share")
                        .resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 23, height: 23)
                }
                
                Spacer().frame(width: 6)
                
                Button(action: {
                    
                }) {
                    Image("Setting")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                }
                
                Spacer().frame(width: 20)
            }
            
            TabView {
                MainThemeView()
                DetailMainView()
            }
            .tabViewStyle(PageTabViewStyle())
            
            Spacer()
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
