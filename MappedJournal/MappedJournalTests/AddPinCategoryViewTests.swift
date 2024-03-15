//import XCTest
//import CoreData
//@testable import MappedJournal 
//
//class AddPinCategoryViewTests: XCTestCase {
//    
//    var viewContext: NSManagedObjectContext!
//
//    override func setUp() {
//        super.setUp()
////        viewContext = setUpInMemoryPersistentContainer().viewContext
//    }
//
//    override func tearDown() {
//        super.tearDown()
//        flushDataFromPersistentStore()
//        viewContext = nil
//    }
//
//    func testSaveCategory() {
//        let addPinCategoryView = AddPinCategoryView()
//        
//        // Set up some test data
//        addPinCategoryView.categoryName = "Test Category"
//        addPinCategoryView.selectedSymbol = "heart"
//        
//        // Assign the test context to the view
//        addPinCategoryView.viewContext = viewContext
//
//        // Call the saveCategory function
//        addPinCategoryView.saveCategory()
//
//        // Fetch the saved category from the persistent store
//        let fetchRequest: NSFetchRequest<PinCategory> = PinCategory.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", "Test Category")
//
//        do {
//            let savedCategories = try viewContext.fetch(fetchRequest)
//            
//            // Verify that the category was saved
//            XCTAssertEqual(savedCategories.count, 1, "Category not saved")
//            
//            // Verify the category details
//            let savedCategory = savedCategories.first!
//            XCTAssertEqual(savedCategory.categoryName, "Test Category")
//            XCTAssertEqual(savedCategory.categorySymbol, "heart")
//            
//        } catch {
//            XCTFail("Error fetching categories: \(error.localizedDescription)")
//        }
//    }
//}
