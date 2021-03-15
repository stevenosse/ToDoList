//
//  InterfaceController.swift
//  TodoList Watch WatchKit Extension
//
//  Created by Nossedjou Steve on 12/03/2021.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    @IBOutlet var todoListView: WKInterfaceTable!
    @IBOutlet var syncButton: WKInterfaceButton!
    
    let viewModel: TodoViewModel = TodoViewModel()
    
    var watchSession: WCSession?
    
    override func awake(withContext context: Any?) {
        self.setTitle("Mes tâches")
        
        configureTodoListView()
        setupWatchSession()
        setupViewModel()
        fetchData()
    }
    
    func setupWatchSession() {
        watchSession = WCSession.default
        watchSession?.delegate = self
        watchSession?.activate()
    }
    func fetchData() {
        viewModel.loadTaskList()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func setupViewModel() {
        viewModel.onTaskListUpdated = { [self] in
            self.configureTodoListView()
        }
    }
    
    func configureTodoListView() {
        todoListView.setNumberOfRows(viewModel.taskList.count, withRowType: "todo_item")
        
        var currentIndex: Int = 0
        for taskItem in viewModel.taskList {
            
            let row = todoListView.rowController(at: currentIndex) as! TodoController
            
            let title: String = (taskItem.value(forKey: "title") as! String)
            let desc: String = (taskItem.value(forKey: "desc") as! String)
            let done: Bool = (taskItem.value(forKey: "done") as! Bool)
            
            row.titleLabel.setText(title)
            row.descriptionLabel.setText(desc)
            row.title = title
            row.desc = desc
            row.done = done
            
            currentIndex += 1
        }
    }
    
    @IBAction func syncButtonTapped() {
        sendMessage(data: ["SYNC": "Sync data"])
    }
}

extension InterfaceController : WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        viewModel.syncData(data: message)
    }
}

extension InterfaceController {
    func sendMessage(data: [String: Any]) {
        watchSession?.sendMessage(data, replyHandler: nil, errorHandler: nil)
    }
    
    func sendMessageData(data: Data){
        watchSession?.sendMessageData(data, replyHandler: nil, errorHandler: nil)
    }
}
