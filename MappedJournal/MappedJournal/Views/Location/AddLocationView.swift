import SwiftUI
import MapKit

struct AddLocationView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = PlaceViewModel()
    @State private var searchText = ""
    @Binding var returnedPlace: Place
    //@Binding var selectedLocation: Location? // Binding to update selectedLocation
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    
    
    var body: some View {
        NavigationView {
            List(placeVM.places) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.title2)
                    Text(place.address)
                        .font(.callout)
                }
                .onTapGesture {
                    returnedPlace = place
                        dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { text in
                if !text.isEmpty {
                    placeVM.search(text: text, region: locationManager.region)
                }else{
                    placeVM.places = []
                }
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Dismiss") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Locations")
        }
    }
}

//struct AddLocationView_Preview: PreviewProvider {
//    static var previews: some View {
//        AddLocationView(returnedPlace: .constant(Place(mapItem: <#T##MKMapItem#>())))
//            .environmentObject(LocationManager())
//    }
//}
