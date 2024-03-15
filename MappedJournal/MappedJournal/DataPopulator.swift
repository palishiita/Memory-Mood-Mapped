import CoreData

class DataPopulator {

    static func populateEmojis() {
        let context = CoreDataStack.shared.persistentContainer.viewContext

        // Check if there are existing records in the Mood entity
        let fetchRequest: NSFetchRequest<Mood> = Mood.fetchRequest()

        do {
            let existingMoods = try context.fetch(fetchRequest)
            
            // If there are no existing records, populate the database
            if existingMoods.isEmpty {
                let emojis: [Emoji] = [
                    Emoji(imageName: "Angry", name: "Angry", moodCategory: "Angry"),
                    Emoji(imageName: "Bored", name: "Bored", moodCategory: "Bored"),
                    Emoji(imageName: "Funny", name: "Funny", moodCategory: "Funny"),
                    Emoji(imageName: "Happy", name: "Happy", moodCategory: "Happy"),
                    Emoji(imageName: "Love", name: "Love", moodCategory: "Love"),
                    Emoji(imageName: "Scared", name: "Scared", moodCategory: "Scared"),
                    Emoji(imageName: "Shy", name: "Shy", moodCategory: "Shy"),
                    Emoji(imageName: "Smirk", name: "Smirk", moodCategory: "Smirk"),
                    Emoji(imageName: "Surprise", name: "Surprise", moodCategory: "Surprise")
                ]

                for emoji in emojis {
                    let mood = Mood(context: context)
                    mood.emojiCategory = emoji.moodCategory
                }

                do {
                    try context.save()
                    print("Database populated successfully.")
                } catch {
                    print("Error saving emojis: \(error.localizedDescription)")
                }
            } else {
                print("Database already populated. No need to update.")
            }
        } catch {
            print("Error fetching existing moods: \(error.localizedDescription)")
        }
    }
}
