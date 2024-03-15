import SwiftUI

struct PlaceLookupView: View {
    
    
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    var places = ["Here", "There", "Everywhere"]
    
    var body: some View {
        NavigationStack{
            List(places, id: \.self) { place in
                Text(place)
                    .font(.title2)
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .toolbar{
                ToolbarItem(placement: .automatic){
                    Button("Dismiss"){
                        dismiss()
                    }
                }
            }
            
        }
    }
    
}


struct PlaceLookupView_Preview: PreviewProvider {
    static var previews: some View {
        PlaceLookupView()
    }
}



