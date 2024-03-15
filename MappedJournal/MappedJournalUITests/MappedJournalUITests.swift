import XCTest


final class MappedJournalUITests: XCTestCase {

    override func setUpWithError() throws {
            continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }    
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    // performance testing
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    //Test for opening page
    func testMoodViewNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to MoodView
        app.buttons["Next"].tap()
        app.buttons["Next"].tap()
        app.buttons["Start"].tap()
            
        
        // Navigate to MoodView
        let tabView = app.tabBars.buttons["Mood"]
        print(tabView)
        XCTAssertTrue(tabView.waitForExistence(timeout: 5), "Mood tab bar item not found")
    
    }

    
    
    func test_TappingHappyButtonNavigatesToEmojiJournalView() {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to MoodView
        app.buttons["Next"].tap()
        app.buttons["Next"].tap()
        app.buttons["Start"].tap()
        
        // Tap on the "Happy" button (replace "Mood-Button-Happy" with the actual identifier)
        let happyButton = app.buttons["Mood-Image-Happy"]
        XCTAssertTrue(happyButton.waitForExistence(timeout: 5), "Happy Image not found")
        happyButton.tap()
        
        // Verify that EmojiJournalView is presented
        let emojiNavBar = app.navigationBars["Happy"]
        XCTAssertTrue(emojiNavBar.waitForExistence(timeout: 5), "EmojiJournalView not displayed")
        
        
        
        // Find and tap on the first journal in the list
        let firstJournalCell = app.cells.firstMatch
        XCTAssertTrue(firstJournalCell.waitForExistence(timeout: 5), "First journal cell not found")
        firstJournalCell.tap()
       
    }
    
    func test_TappingMapTabNavigatesToMapView() {
        let app = XCUIApplication()
        app.launch()

        
        // Navigate to MoodView
        app.buttons["Next"].tap()
        app.buttons["Next"].tap()
        app.buttons["Start"].tap()
        
        
        // Navigate to MapView
        let mapTab = app.tabBars.buttons["Map"]
        XCTAssertTrue(mapTab.waitForExistence(timeout: 5), "Map tab not found")
        mapTab.tap()   
        
    }

    
}
