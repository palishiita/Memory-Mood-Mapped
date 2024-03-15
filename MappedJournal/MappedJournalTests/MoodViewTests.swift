import XCTest
import SwiftUI
import CoreData
@testable import MappedJournal

final class MoodViewTests: XCTestCase {
    
    var moodView: MoodView!
    var emojiJournalView: EmojiJournalView?
    
    override func setUp() {
        super.setUp()
        moodView = MoodView()
        emojiJournalView = nil
    }
    
    override func tearDown() {
        moodView = nil
        emojiJournalView = nil
        super.tearDown()
    }
    
    func test_MoodView_soundOptionForEmojiCategory_Happy() {
        // Given
        let emojiCategory = "Happy"
        
        // When
        let soundOption = MoodView.soundOption(for: emojiCategory)
        
        // Then
        XCTAssertEqual(soundOption, .Happy)
    }
    
    
    
    
    func testPlaySound() {
        let soundManager = SoundManager.instance
        let mockSound = SoundOption.Happy  // Replace with an actual sound option
        
        // Ensure that the playSound method doesn't throw an error
        XCTAssertNoThrow(try soundManager.playSound(sound: mockSound))
    }
    

    
    
    
    
    


    

    
}


