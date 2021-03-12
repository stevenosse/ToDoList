//
//  TaskModel.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 11/03/2021.
//

import Foundation
import CoreData

class TaskModel : NSManagedObject {
    var uuid: String!
    var title: String!
    var desc: String!
    var done: Bool!
    
    static func createTask(uuid: String, title: String, desc: String?, done: Bool = false) -> Task {
        let task = Task(entity: CoreDataService.shared.entityFor(entityName: Constants.taskEntityName), insertInto: CoreDataService.shared.managedContext)
        task.setValue(uuid, forKey: "uuid")
        task.setValue(title, forKey: "title")
        task.setValue(desc, forKey: "desc")
        task.setValue(done, forKey: "done")
        
        return task
    }
}
