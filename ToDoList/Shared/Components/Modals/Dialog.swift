//
//  Dialog.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 12/03/2021.
//

import Foundation
import UIKit

class Dialog {
    static func showMessage(message: String, title: String, parent: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        parent.present(alert, animated: true)
        // duration in seconds
        let duration: Double = 1
            
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
}
