//
//  CoreDataProvider.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//

import CoreData

protocol CoreDataProvider {

    func add<T: NSManagedObject>(_ type: T.Type) -> T?
    func fetch<T:NSManagedObject>(_ entity: T.Type, query: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int) -> [T]?
    func save()
    func delete<T:NSManagedObject>(_ objectToDelete: T)
}

class CoreDataService: CoreDataProvider {
            
    private static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HackerNews")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("Unresolved error \(error), \(error.userInfo)")
            }
            print("Core Data stack has been initialized with description: \(storeDescription)")
        })
        return container
    }()
    
    // MARK: - Core Data viewContext
    
    /**
     Configures the Core Data stack at specified usage.
     
     # Code
     ```
     let numericToken = NumericTokenBiManagedObject(context: CoreDataService().viewContext)
     ```
     */
    
    private let viewContext: NSManagedObjectContext = CoreDataService.persistentContainer.viewContext
    
    // MARK: - Core Data adding support
    
    /**
     Adds Core Data NSManagedObject into specified entity.
     
     - Parameter type: Entity to which the object should be added.
     
     - Returns: Object to add into specified entity.
     
     # Code
     ```
     CoreDataService().add(Entity.self)
     ```
     */
    
    func add<T: NSManagedObject>(_ type: T.Type) -> T? {
        guard let entityName = T.entity().name else {
            return nil
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext) else {
            return nil
        }
        
        let object = T(entity: entity, insertInto: viewContext)
        return object
    }
        
    // MARK: - Core Data fetching support
    
    /**
     Retrieves Core Data NSManagedObject array of values for specified entity.
     
     - Parameter entity: Entity to which Core Data should look for.
     
     - Returns: Object array from Core Data, if available. If value is not available, console prints error and returns nil.
     
     # Code
     ```
     CoreDataService().fetch(Entity.self)
     ```
     */
    
    func fetch<T:NSManagedObject>(_ entity: T.Type, query: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int) -> [T]? {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = query
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchLimit = fetchLimit
        
        return try? viewContext.fetch(fetchRequest) as? [T]
    }
    
    
    // MARK: - Core Data save support
    
    /**
     Saves specified entity values in Core Data.
     
     # Code
     ```
     CoreDataService().save()
     ```
     */
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - Core Data delete support
    
    /**
     Deletes Core Data NSManagedObject values for specified entity.
     
     - Parameter toDelete: Object in specified entity to which Core Data should look for and delete.
     - Returns: Deletes the entities' specified object, if available, and updates the entity after deletion.
     
     # Code
     ```
     CoreDataService().delete(array[indexPath.row])
     ```
     */
    
    func delete<T:NSManagedObject>(_ objectToDelete: T) {
        viewContext.delete(objectToDelete)
        save()
    }
}
