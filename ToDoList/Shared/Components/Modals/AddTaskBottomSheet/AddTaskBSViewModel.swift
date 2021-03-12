//
//  AddTaskBSViewModel.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 12/03/2021.
//

import Foundation

class AddTaskBSViewModel : BaseViewModel {
    let repository = AddTaskBSRepository()
    func createTask(title: String, description: String?) -> Task {
        let task = self.repository.createTask(title: title, description: description ?? "")
        return task
    }
}
