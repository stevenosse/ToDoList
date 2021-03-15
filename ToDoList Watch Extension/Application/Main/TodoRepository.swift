//
//  TodoRepository.swift
//  TodoList Watch WatchKit Extension
//
//  Created by Nossedjou Steve on 12/03/2021.
//

import Foundation
import CoreData

class TodoRepository {
    let service = CoreDataManager.shared
    
    static let shared: TodoRepository = TodoRepository()
    
    func createTask(uuid: String, title: String, description: String, done: Bool) -> NSManagedObject {
        let task = TaskModel.createTask(uuid: uuid, title: title, desc: description, done: done)
        service.saveContext()
        return task
    }
    
    func getTaskList() -> [Task] {
        return service.fetch(entityName: Constants.taskEntityName) as! [Task]
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Constants.taskEntityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try service.managedContext.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
    }
    
    func updateTask(uuid: String, title: String, description: String, done: Bool) -> NSManagedObject? {
        let predicate = NSPredicate(format: "uuid = %@", uuid)
        let results = service.executeQuery(entityName: Constants.taskEntityName, predicate: predicate) as! [NSManagedObject]
        
        if !results.isEmpty {
            let task = results.first!
            task.setValue(title, forKey: "title")
            task.setValue(description, forKey: "desc")
            task.setValue(done, forKey: "done")
            
            service.saveContext()
            return task
        }
        return nil
    }
}
