//
//  TodoViewModel.swift
//  TodoList Watch WatchKit Extension
//
//  Created by Nossedjou Steve on 12/03/2021.
//

import Foundation
import CoreData

class TodoViewModel {
    let repository : TodoRepository = TodoRepository.shared
    var taskList: [NSManagedObject] = [] {
        didSet {
            self.onTaskListUpdated?()
        }
    }
    
    var onTaskListUpdated: (()->())?
    
    func syncData(data: [String:Any]) {
        let todoElements: [String:Any] = data["TodoList"] as! [String : Any]
        taskList.removeAll()
        repository.deleteAll()
        
        todoElements.forEach({ (key, rawData) in
            guard let data = rawData as? [String:Any] else { return }
            
            let title = data["title"] as! String
            let desc = data["desc"] as! String
            let done = data["done"] as! Bool
            
            var task: NSManagedObject? = repository.updateTask(uuid: key, title: title, description: desc, done: done)
            if task == nil {
                task = repository.createTask(uuid: key, title: title, description: desc, done: done)
            }
            
            taskList.append(task!)
        })
    }
    
    func loadTaskList() {
        self.taskList = repository.getTaskList()
    }
}
