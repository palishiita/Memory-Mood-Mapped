//import XCTest
//import MapKit
//import CoreData
//@testable import MappedJournal 
//
//class MemoryViewIntegrationTests: XCTestCase {
//
//    var managedObjectContext: NSManagedObjectContext!
//
//    override func setUp() {
//        super.setUp()
//
//        // Set up the Core Data stack for testing
//        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: Journal.self), Bundle(for: Mood.self)])
//        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
//
//        do {
//            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
//        } catch {
//            fatalError("Failed to initialize in-memory store coordinator: \(error)")
//        }
//
//        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
//    }
//
//    override func tearDown() {
//        managedObjectContext = nil
//        super.tearDown()
//    }
//
//    func testSaveJournalEntry() {
//        // Given
//        let memoryView = MemoryView()
//        memoryView.viewModel.managedObjectContext = managedObjectContext 
//
//        // When
//        memoryView.title = "Test Journal"
//        memoryView.date = Date()
//        memoryView.selectedBackgroundColor = "Blue"
//        memoryView.selectedMood = "Happy"
//        memoryView.textInput = "This is a test journal entry."
//
//        // Simulate selecting a location (you can modify this part based on how your AddLocationView works)
//        memoryView.selectedLocation = Place(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))))
//        
//        // Simulate selecting images (you may want to add actual images to the test bundle)
//        memoryView.viewModel.selectedImages = [UIImage(systemName: "photo")!, UIImage(systemName: "heart.fill")!]
//
//        // Simulate selecting a video (you may want to add an actual video to the test bundle)
//        memoryView.videoPicker.videoSelection = .success(AVPlayer(url: URL(fileURLWithPath: "test_video.mp4")))
//
//        memoryView.saveJournalEntry()
//
//        // Then
//        do {
//            let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
//            let journals = try managedObjectContext.fetch(fetchRequest)
//            
//            XCTAssertEqual(journals.count, 1, "There should be one journal entry in the database")
//            XCTAssertEqual(journals.first?.title, "Test Journal", "Title should match")
//            // Add more assertions as needed for other properties
//
//        } catch {
//            XCTFail("Failed to fetch journals: \(error)")
//        }
//    }
//}

