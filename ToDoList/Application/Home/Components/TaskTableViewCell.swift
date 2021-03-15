//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 11/03/2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                if #available(iOS 13.0, *) {
                    checkBoxImageView.image = UIImage(systemName: "app.fill")
                } else {
                    checkBoxImageView.image = UIImage(named: "app.fill")
                }
                let titleAttributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.titleLabel.text!)
                titleAttributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, titleAttributeString.length))
                self.titleLabel.attributedText = titleAttributeString
                
                let dateAttributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.dateLabel.text!)
                dateAttributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, dateAttributeString.length))
                self.dateLabel.attributedText = dateAttributeString
            }
            else {
                if #available(iOS 13.0, *) {
                    checkBoxImageView.image = UIImage(systemName: "app")
                } else {
                    checkBoxImageView.image = UIImage(named: "app")
                }
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.titleLabel.text!)
                self.titleLabel.attributedText = attributeString
                
                let dateAttributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.dateLabel.text!)
                self.dateLabel.attributedText = dateAttributeString
            }
            
           
        }
    }
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func toggleChecked() {
        self.isChecked = !self.isChecked
    }
}
