import SwiftUI

struct MainView: View {
    var body: some View {
        VStack() {
            Spacer().frame(height: 26)
            
            HStack(spacing: 0) {
                Spacer().frame(width: 21)
                
                Text("위치 설정 search bar")
                
                Button(action: {
                    
                }) {
                    Image("CurrentLocation")
                        .resizable()
                        .frame(width: 27, height: 27)
                        .scaledToFit()
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 17, height: 21)
                }
                
                Spacer().frame(width: 9)
                
                Button(action: {
                    
                }) {
                    Image("Setting")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                }
                Spacer().frame(width: 20)
            }
            
            TabView() {
                MainThemeView()
                DetailMainView()
            }
            .tabViewStyle(PageTabViewStyle())
             
            Spacer()
            
        }
    }
}

struct MainThemeView: View {
    var body: some View {
        Image("MainTheme")
            .resizable()
            .padding(.horizontal)
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
