//
//  HomeViewModel.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 11/03/2021.
//

import Foundation
class HomeViewModel : BaseViewModel{
    let repository: HomeRepository = HomeRepository()
    var taskList: [Task] = [] {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    func loadTaskList() {
        self.taskList = repository.getTaskList()
    }
    
    func removeTask(_ task: Task) {
        repository.removeTask(task)
        self.taskList.remove(at: self.taskList.firstIndex(of: task)!)
    }
    
    func markDone(uuid: String) {
        let result = self.taskList.first() {occ in
            return occ.uuid == uuid
        }
        if let task = result {
            let updatedTask = repository.markDone(task)
            let index: Int = self.taskList.firstIndex(of: result!)!
            self.taskList[index] = updatedTask
        }
    }
}
