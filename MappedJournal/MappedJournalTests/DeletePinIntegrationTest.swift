import XCTest
import CoreData
@testable import MappedJournal 

class DeletePinIntegrationTests: XCTestCase {

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

    func testDeletePin() {
        // Given
        let pin = Pin(context: managedObjectContext)
        pin.pinLatitude = 37.7749
        pin.pinLongtitude = -122.4194
        // Set other properties as needed

        do {
            try managedObjectContext.save()
        } catch {
            XCTFail("Failed to save context: \(error)")
            return
        }

        // When
        managedObjectContext.delete(pin)

        do {
            try managedObjectContext.save()
        } catch {
            XCTFail("Failed to save context after deleting pin: \(error)")
            return
        }

        // Then
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        do {
            let pins = try managedObjectContext.fetch(fetchRequest)
            XCTAssertEqual(pins.count, 0, "There should be no pins in the database after deletion")
        } catch {
            XCTFail("Failed to fetch pins: \(error)")
        }
    }
}

