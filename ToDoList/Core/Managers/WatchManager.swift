//
//  WatchManager.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 15/03/2021.
//

import Foundation
import WatchConnectivity

class WatchManager : NSObject {
    var session : WCSession?
    var lastMessage: CFAbsoluteTime = 0
    
    var onSyncMessageReceived: (([String:Any])->())?
    
    static let shared = WatchManager()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func sendWatchMessage(message: [String: Any]) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        if lastMessage + 0.5 > currentTime {
            return
        }

        if ((session?.isReachable ?? false)) {
            session?.sendMessage(message, replyHandler: nil)
        }
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
    
    func sendMessageData(data: Data) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        if lastMessage + 0.5 > currentTime {
            return
        }
        if ((session?.isReachable ?? false)) {
            session?.sendMessageData(data, replyHandler: nil, errorHandler: nil)
        }
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
}

extension WatchManager : WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message")
        switch message.keys.first {
        case WatchMessage.SYNC.rawValue:
            onSyncMessageReceived?(message)
        default:
            print("nope")
        }
    }
}
