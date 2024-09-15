import SwiftUI

struct LocationSearchView: View {
    @State var searchText: String = ""
    @State private var locations: [String: (String, String)] = loadCSV()
    @Binding var myLocation: String
    @Environment(\.presentationMode) var presentationMode
    
    var filteredLocations: [String] {
        if searchText.isEmpty || searchText == " "{
            return []
        } else {
            return locations.keys.filter { $0.contains(searchText) }.sorted { $0.count < $1.count
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image("Search")
                    .resizable()
                    .frame(width: 19, height: 19)
                    .padding(.leading, 7)
                    .padding(.vertical, 6)
                
                TextField("지역(구/동)을 입력하세요.", text: $searchText)
                    .font(.pretendardMedium(size: 10))
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("취소")
                        .padding(.trailing, 5)
                }
            }
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "E0E0E0")!, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            List(filteredLocations, id: \.self) { location in
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    myLocation = location
                    print("\(locations[location]!)")
                }) {
                    Text("\(location)")
                }
                        }
            .listStyle(.inset)
            .padding(0)
        }
        .padding(0)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    @State static var myLocation: String = ""

    static var previews: some View {
        LocationSearchView(myLocation: $myLocation)
    }
}
