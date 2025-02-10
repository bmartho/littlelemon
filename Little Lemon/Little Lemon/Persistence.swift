import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "ExampleDatabase")
        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: {_,_ in })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func doesDishExist(title: String, _ context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Dish")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title as CVarArg)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch dish: \(error)")
            return false
        }
    }
}
