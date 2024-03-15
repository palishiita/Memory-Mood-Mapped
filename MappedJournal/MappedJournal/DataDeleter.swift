import CoreData

class DataDeleter {
    
    static func deleteAllMoods() {
        let context = CoreDataStack.shared.persistentContainer.viewContext

        // Specify the entity name you want to delete data from
        let entityName = "Mood"

        // Create a batch delete request for the specified entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            // Execute the batch delete request
            try context.execute(batchDeleteRequest)

            // Save the context to commit the changes
            try context.save()

            print("All data from \(entityName) deleted successfully.")
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }
}
