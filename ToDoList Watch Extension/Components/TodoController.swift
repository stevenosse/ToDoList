//
//  TodoController.swift
//  TodoList Watch WatchKit Extension
//
//  Created by Nossedjou Steve on 12/03/2021.
//

import UIKit
import WatchKit

class TodoController: NSObject {
    var done: Bool = false {
        didSet {
            self.toggleDone()
        }
    }
    
    var title: String!
    var desc: String!
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    @IBOutlet var toggleTaskStateButton: WKInterfaceButton!

    func toggleDone() {
        if done {
            let titleAttributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.title)
            titleAttributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, titleAttributeString.length))
            
            self.titleLabel.setAttributedText(titleAttributeString)
            
            let descriptionAttributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.desc)
            descriptionAttributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, descriptionAttributeString.length))
            
            self.titleLabel.setAttributedText(titleAttributeString)
            self.descriptionLabel.setAttributedText(descriptionAttributeString)
            self.toggleTaskStateButton.setBackgroundImage(UIImage(systemName: "app.fill"))
        } else {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.title)
            self.titleLabel.setAttributedText(attributeString)
            
            let descAttributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.desc)
            self.descriptionLabel.setAttributedText(descAttributeString)
            self.toggleTaskStateButton.setBackgroundImage(UIImage(systemName: "app"))
        }
    }
}
