import SwiftUI
import MapKit

struct AddPinView: View {
    @State private var location: String = ""
//    @State private var selectedCategory: String = ""
    @State private var pinCategories: [String] = ["Category 1", "Category 2", "Category 3"]

    @EnvironmentObject var locationManager: LocationManager
    @State  private var showPlaceLookupSheet = false;
    @State var returnedPlace = Place(mapItem: MKMapItem())
    @State private var showAddLocationView = false
    @State private var selectedLocation: Place?
    @FetchRequest(entity: PinCategory.entity(), sortDescriptors: []) var categories: FetchedResults<PinCategory>
    
    @State private var selectedCategory: PinCategory? // Add this property


    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Form {
//                Section(header: Text("Location")) {
//                    TextField("Enter location", text: $location)
//                }
                
                
                
                // MARK: Location
                Section(header: Text("Location")) {
                    // Show the selected location name and coordinates
                    if let selected = selectedLocation {
                        VStack(alignment: .leading) {
                            Text("Selected Location: \(selected.name)")
                                .foregroundColor(.black)
                            Text("Coordinates: \(selected.latitude), \(selected.longitude)")
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text("Selected Location: No location selected")
                            .foregroundColor(.black)
                    }
                    
                    // Button to navigate to AddLocationView
                    Button(action: {
                        showAddLocationView = true
                    }) {
                        Text("Add Location")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black))
                    }
                    .sheet(isPresented: $showAddLocationView) {
                        NavigationView {
                            AddLocationView(returnedPlace: $returnedPlace)
                                .environmentObject(locationManager)
                                .onDisappear {
                                    // Update the selected location when AddLocationView is dismissed
                                    selectedLocation = returnedPlace
                                }
                        }
                    }
                }
                

//                Section(header: Text("Pin Category")) {
//                    Picker("Select Category", selection: $selectedCategory) {
//                        ForEach(categories, id: \.self) { category in
//                            Text(category.categoryName ?? "").foregroundColor(.white) // Display category name
//                        }
//                    }
//                    .pickerStyle(WheelPickerStyle())
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color.black)
//                    )
//                }
                
                // MARK: CATEGORY SELECTION
                Section(header: Text("Pin Category")) {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.categoryName ?? "").foregroundColor(.white) // Display category name
                                .tag(category as PinCategory?) // Set the category as the tag for selection
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                    )
                }


                
                // MARK: ADD CATEGORY
                Section(header: Text("Add Pin Category")) {
                    NavigationLink(
                        destination: AddPinCategoryView(),
                        label: {
                            Text("Add Pin Category")
                                .foregroundColor(.white)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.black))
                        }
                    )
                }

                // MARK: SAVE PIN
                Section {
                    Button(action: {
                        savePin()
                    }) {
                        Text("Add Pin")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .foregroundColor(.white)
                            .background(Capsule().fill(Color.black))
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Pin Manager")
        
        
    }
    
    
    func savePin() {
        let newPin = Pin(context: viewContext)
        newPin.pinID = UUID().uuidString // Generate a unique ID for the pin
        newPin.pinLatitude = selectedLocation?.latitude ?? 0.0 // Update with the actual latitude
        newPin.pinLongtitude = selectedLocation?.longitude ?? 0.0 // Update with the actual longitude
        // Assuming you have a selectedCategoryID that represents the chosen category
        
        newPin.categoryID = selectedCategory?.categoryID
        
        do {
            try viewContext.save() // Save changes to Core Data using viewContext
            print("Pin saved successfully")
            print(newPin)
            // Dismiss or perform any other action after saving the pin
        } catch {
            print("Error saving pin: \(error.localizedDescription)")
        }
    }
    
    
}





struct AddPinView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager = LocationManager() // You might need to create a mock or test instance of LocationManager()
        
        return NavigationView {
            AddPinView()
                .environmentObject(locationManager)
        }
    }
}
