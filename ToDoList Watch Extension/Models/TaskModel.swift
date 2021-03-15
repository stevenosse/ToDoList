//
//  TaskModel.swift
//  TodoList Watch Extension
//
//  Created by Nossedjou Steve on 15/03/2021.
//

import Foundation
import CoreData

class TaskModel : NSManagedObject {
    var uuid: String!
    var title: String!
    var desc: String!
    var done: Bool!
    
    static func createTask(uuid: String, title: String, desc: String?, done: Bool = false) -> NSManagedObject {
        let task = NSManagedObject(entity: CoreDataManager.shared.entityFor(entityName: Constants.taskEntityName), insertInto: CoreDataManager.shared.managedContext)
        
        task.setValue(uuid, forKey: "uuid")
        task.setValue(title, forKey: "title")
        task.setValue(desc, forKey: "desc")
        task.setValue(done, forKey: "done")
        
        return task
    }
}
