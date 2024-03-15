import XCTest
import CoreData
@testable import MappedJournal 

class PinIntegrationTests: XCTestCase {

    var managedObjectContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        // Set up the Core Data stack for testing
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: Pin.self)])
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            fatalError("Failed to initialize in-memory store coordinator: \(error)")
        }

        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    }

    override func tearDown() {
        managedObjectContext = nil
        super.tearDown()
    }

    func testSaveAndFetchPin() {
        // Given
        let pin = Pin(context: managedObjectContext)
        pin.pinLatitude = 37.7749
        pin.pinLongtitude = -122.4194
        // Set other properties as needed

        // When
        do {
            try managedObjectContext.save()
        } catch {
            XCTFail("Failed to save context: \(error)")
            return
        }

        // Then
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        do {
            let pins = try managedObjectContext.fetch(fetchRequest)
            XCTAssertEqual(pins.count, 1, "There should be one pin in the database")
            XCTAssertEqual(pins.first?.pinLatitude, 37.7749, "Latitude should match")
            XCTAssertEqual(pins.first?.pinLongtitude, -122.4194, "Longitude should match")
            // Add other assertions as needed
        } catch {
            XCTFail("Failed to fetch pins: \(error)")
        }
    }
}
