//
//  CoreDataService.swift
//  TodoList Watch WatchKit Extension
//
//  Created by Nossedjou Steve on 12/03/2021.
//

import Foundation
import CoreData
import UIKit
import WatchKit

class CoreDataManager {
    var extensionDelegate: ExtensionDelegate!
    
    static let shared = CoreDataManager()
    
    var managedContext: NSManagedObjectContext {
        return self.extensionDelegate.persistentContainer.viewContext
    }
    
    init() {
        extensionDelegate = WKExtension.shared().delegate as? ExtensionDelegate;
    }
    
    func entityFor(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedContext)!
    }
    
    func fetch(entityName: String) -> [NSManagedObject] {
        do {
            let result = try self.managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: entityName))
            return result
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func executeQuery(entityName: String, predicate: NSPredicate) -> [Any] {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
        request.predicate = predicate
        
        do {
            let results = try managedContext.fetch(request)
            return results
        } catch {
            let nserror = error as NSError
            fatalError("An error occured : \(nserror)")
        }
        
    }
    
    func saveContext() {
        if managedContext.hasChanges {
            managedContext.perform { [self] in
                //operations
                do {
                    try managedContext.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("An error occured : \(nserror)")
                }
            }
        }
    }
    
    func delete(object: NSManagedObject) -> Bool {
        self.managedContext.delete(object)
        self.saveContext()
        return true
    }
}
