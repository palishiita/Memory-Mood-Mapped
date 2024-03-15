import SwiftUI
import _PhotosUI_SwiftUI
import AVKit
import MapKit
import CoreData

struct MemoryView: View {
    
    @State private var title = ""
    
    @State private var date = Date()
    
    @State private var backgroundColor = "Blue"
    @State private var selectedBackgroundColor: String = ""
    
    @State private var selectedMood = "Happy"
    
    @EnvironmentObject var locationManager: LocationManager
    @State  private var showPlaceLookupSheet = false;
    @State var returnedPlace = Place(mapItem: MKMapItem())
    @State private var showAddLocationView = false
    @State private var selectedLocation: Place?
    
    @StateObject private var viewModel = PhotosPickerViewModel()
    
    @StateObject var videoPicker = VideoPicker()
    
    @State private var textInput = ""
    
    public var videos: NSSet?


    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Mood.entity(), sortDescriptors: []) var moods: FetchedResults<Mood>

    var body: some View {
        
        VStack {
            Form {
                // MARK: Journal
                Section(header: Text("My Journal Entry")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black)
                    .textCase(nil)
                    .multilineTextAlignment(.center)
                        
                ) {
                    
                    // MARK: Title
                    TextField("Title", text: $title)

                    
                    // MARK: Location
                    Section(header: Text("Location")
                                .textCase(.uppercase)
                                .foregroundColor(.gray)
                                .font(.footnote)
                    ) {
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
                }
                
                
                // MARK: Date
                Section(header: Text("Date")) {
                    DatePicker("Date",
                               selection: $date,
                               displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                }
                
                
                // MARK: Mood
                Section(header: Text("Mood")) {
                    Picker("Mood", selection: $selectedMood) {
                        ForEach(moods, id: \.self) { mood in
                            Text(mood.emojiCategory ?? "")
                                .tag(mood.emojiCategory ?? "")
                                .font(Font.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                
                // MARK: Background Color
                Section(header: Text("Background Color")) {
                    let colors: [String] = ["Green", "Blue", "Purple", "Pink", "Orange", "Yellow"]
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .overlay(
                            HStack(spacing: 15) {
                                ForEach(colors, id: \.self) { color in
                                    Circle()
                                        .fill(Color(color))
                                        .frame(width: 25, height: 25)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(selectedBackgroundColor == color ? Color.black : Color.clear, lineWidth: 2)
                                        )
                                        .onTapGesture {
                                            selectedBackgroundColor = color
                                        }
                                }
                            }
                                .padding(5)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                
                // MARK: Photos picker
                Section(header: Text("Photos")) {
                    if !viewModel.selectedImages.isEmpty {
                        // Display selected images in a horizontal scroll view
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.selectedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    // PhotosPicker to allow the user to open the photo picker
                    PhotosPicker(selection: $viewModel.imagesSelections, matching: .images) {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.black)
                    }

                }
            
                
                
                // MARK: Video Picker
                Section(header: Text("Videos")) {
                    PhotosPicker(selection: $videoPicker.videoSelection, matching: .videos) {
                        Image(systemName: "video")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.black)
                    }
                    switch videoPicker.videoImportState {
                    case .success(let video):
                        VideoPlayer(player: video)
                            .frame(width: 300, height: 300)
                    case .loading:
                        ProgressView()
                    case .empty:
                        Image(systemName: "video.fill")
                            .font(.system(size: 2))
                            .foregroundColor(.white)
                    case .failure:
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 2))
                            .foregroundColor(.white)
                    }
                }
                
                
                // MARK: Text Input
                Section(header: Text("Text")) {
                    VStack {
                        TextEditor(text: $textInput)
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                            .cornerRadius(10)
                    }
                }
                
                
                // MARK: Publish Button
                Button("Publish") {
                    saveJournalEntry()
                    clearForm()
                }
                .font(.callout)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background {
                    Capsule()
                        .fill(.black)
                }
            }
            .navigationTitle("Memory")
        }
    }
    
    
     // MARK: Save Journal Entry
    func saveJournalEntry() {
        
        let newJournal = Journal(context: viewContext)
        newJournal.journalID = UUID()
        
        // title
        newJournal.title = title
        
        // date
        newJournal.date = date
        
        // background color
        newJournal.backgroundColor = selectedBackgroundColor
        
        // text
        newJournal.text = textInput
        
        // mood
        if let selectedMood = moods.first(where: { $0.emojiCategory == selectedMood }) {
            newJournal.mood = selectedMood
        }
        
//        // location
//        if let selectedLocation = selectedLocation {
//            let newLocation = Location(context: viewContext)
//            newLocation.location = selectedLocation.name
//            newLocation.latitude = selectedLocation.latitude
//            newLocation.longitude = selectedLocation.longitude
//            newJournal.location = newLocation
//        }
        
        
        // Inside saveJournalEntry function
        // location
        if let selectedLocation = selectedLocation {
            let newPin = Pin(context: viewContext)
            newPin.pinID = UUID().uuidString
            newPin.pinLatitude = selectedLocation.latitude
            newPin.pinLongtitude = selectedLocation.longitude
            newPin.categoryID = "journalPin" // Set a specific value for pins from the journal
            newJournal.pin = newPin
        }

        
        
        
        
        // Photos
        // Create Image entities and associate them with the new Journal
        for selectedImage in viewModel.selectedImages {
            let newImage = Images(context: viewContext)
            newImage.imageID = UUID()

            // Check the image format and set the appropriate data
            if let imageData = selectedImage.pngData() {
                newImage.imageData = imageData
            } else if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                newImage.imageData = imageData
            }

            // Add the new image to the journal
            newJournal.addToImages(newImage)
        }
        
        // video
        if let videoSelection = videoPicker.videoSelection,
           case .success(let player) = videoPicker.videoImportState,
           let videoItem = player.currentItem,
           let videoURL = (videoItem.asset as? AVURLAsset)?.url,
           let videoData = try? Data(contentsOf: videoURL) {
            saveVideo(journal: newJournal, videoData: videoData)
        }
        
        do {
            try viewContext.save()
            clearForm()
            
        } catch {
            print("Error saving journal entry: \(error.localizedDescription)")
        }
       
    }
    
    func saveVideo(journal: Journal, videoData: Data) {
        let videos = Videos(context: viewContext)
        videos.videoID = UUID()
        videos.videoData = videoData

        // Create an NSSet containing the Videos object
        let videoSet = NSSet(object: videos)

        // Assign the NSSet to the journal's videos property
        journal.videos = videoSet
    }

    
    func clearForm() {
        title = ""
        selectedLocation = nil
        date = Date()
        selectedBackgroundColor = ""
        selectedMood = ""
        textInput = ""
        viewModel.clearSelectedImages()
        videoPicker.videoSelection = nil
        videoPicker.clearVideoImportState()
    }
    
    
    
}


struct MemoryView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryView()
    }
}
