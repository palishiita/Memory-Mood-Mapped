import SwiftUI
import MapKit



struct MapView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
    )
    @State private var isZoomInClicked = false
    @State private var isZoomOutClicked = false
    @State private var isAddPinClicked = false
    
    let minZoom: Double = 0.01
    let maxZoom: Double = 180
    
    @FetchRequest(entity: Location.entity(), sortDescriptors: []) var locations: FetchedResults<Location>
    @FetchRequest(entity: Pin.entity(), sortDescriptors: []) var pins: FetchedResults<Pin>
    @FetchRequest(entity: PinCategory.entity(), sortDescriptors: []) var categories: FetchedResults<PinCategory>
    
    
    // Function to delete a selected pin
    func deletePin(pin: Pin) {
        viewContext.delete(pin)
        
        do {
            try viewContext.save()
            print("Pin deleted successfully")
            // Handle any other actions after deletion
        } catch {
            print("Error deleting pin: \(error.localizedDescription)")
        }
    }
    
    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .bottom) {

                Map(coordinateRegion: $region, annotationItems: pins) { pin in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pin.pinLatitude, longitude: pin.pinLongtitude)) {
                        // Display the pin using a custom annotation
                        if let pinCategoryID = pin.categoryID,
                           let category = categories.first(where: { $0.categoryID == pinCategoryID }),
                           let categorySymbol = category.categorySymbol {
                            Image(systemName: categorySymbol)
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.blue) // Customize as needed
                                .contextMenu {
                                    Button(action: {
                                        deletePin(pin: pin)
                                    }) {
                                        Text("Delete Pin")
                                        Image(systemName: "trash")
                                    }
                                }
                        } else if let pinCategoryID = pin.categoryID, pinCategoryID == "journalPin" {
                            // Set a default symbol for pins with categoryID "journalPin"
                            Image(systemName: "leaf")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.green) // Customize as needed
                                .contextMenu {
                                    Button(action: {
                                        deletePin(pin: pin)
                                    }) {
                                        Text("Delete Pin")
                                        Image(systemName: "trash")
                                    }
                                }
                        } else {
                            Text("Invalid category symbol")
                        }
                    }
                }
                .accessibility(identifier: "MapView")
                
                
                
                
                HStack(spacing: 10) {
                    Button(action: {
                        // Zoom in
                        region.span = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta / 2, longitudeDelta: region.span.longitudeDelta / 2)
                        isZoomInClicked.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(isZoomInClicked ? .black : .black)
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Zoom out with error handling
                        if region.span.latitudeDelta * 2 <= maxZoom && region.span.longitudeDelta * 2 <= maxZoom {
                            region.span = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta * 2, longitudeDelta: region.span.longitudeDelta * 2)
                            isZoomOutClicked.toggle()
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(isZoomOutClicked ? .black : .black)
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(
                            destination: AddPinView(),
                            isActive: $isAddPinClicked,
                            label: {
                                EmptyView()
                            }
                        )
                        
                        Button(action: {
                            // Add Pin
                            isAddPinClicked = true
                        }) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.black))
                                .padding()
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
}
