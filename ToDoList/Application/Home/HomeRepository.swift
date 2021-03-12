//
//  HomeRepository.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 12/03/2021.
//

import Foundation
import CoreData

class HomeRepository {
    let service = CoreDataService.shared
    
    func updateTask(uuid: String, title: String, description: String, done: Bool) -> Bool {
        let predicate = NSPredicate(format: "uuid = %@", uuid)
        let results = service.executeQuery(entityName: Constants.taskEntityName, predicate: predicate) as! [NSManagedObject]
        
        if !results.isEmpty {
            let task = results.first!
            task.setValue(title, forKey: "title")
            task.setValue(description, forKey: "desc")
            task.setValue(done, forKey: "done")
            
            service.saveContext()
            return true
        }
        return false
    }
    
    func getTaskList() -> [Task] {
        return service.fetch(entityName: Constants.taskEntityName) as! [Task]
    }
    
    func markDone(_ task: Task) -> Task {
        task.setValue(!task.done, forKey: "done")
        service.saveContext()
        return task
    }
    
    func removeTask(_ task: Task) {
        let _ = service.delete(object: task)
    }
}
