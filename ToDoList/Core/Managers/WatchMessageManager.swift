//
//  WatchMessageManager.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 15/03/2021.
//

import Foundation

typealias WatchMessageCallback = (Any?) -> Void

class WatchMessageManager {
    static let shared = WatchMessageManager()
    
    func handleMessage(closure: WatchMessageCallback) {
        
    }
}
