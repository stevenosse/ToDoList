//
//  AddTaskBSRepository.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 12/03/2021.
//

import Foundation

class AddTaskBSRepository {
    let service = CoreDataManager.shared
    
    func createTask(title: String, description: String? = "") -> Task {
        let task = TaskModel.createTask(uuid: UUID().uuidString, title: title, desc: description)
        service.saveContext()
        return task
    }
}
