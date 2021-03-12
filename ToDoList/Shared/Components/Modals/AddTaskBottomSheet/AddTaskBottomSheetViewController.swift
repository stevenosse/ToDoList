//
//  AddTaskBottomSheetViewController.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 11/03/2021.
//

import UIKit

class AddTaskBottomSheetViewController: UIViewController {
    let viewModel = AddTaskBSViewModel()
    
    @IBOutlet weak var addTaskButton: UIButton!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        title = "Nouvelle tâche"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: #selector(onCancelTapped))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Terminé", style: .done, target: self, action: #selector(onDoneTapped))
    }
    
    @objc func onCancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onDoneTapped() {
        let title = taskNameTextField.text
        let description = taskDescriptionLabel.text
        
        if !(title?.isEmpty ?? true) {
            let task = viewModel.createTask(title: title!, description: description)
            if let navController = presentingViewController as? UINavigationController {
               let presenter = navController.topViewController as! HomeViewController
                presenter.viewModel.taskList.append(task)
            }
            self.dismiss(animated: true, completion: nil)
        } else {
            Dialog.showMessage(message: "Le libellé de la tâche de peut être vide.", title: "Informations incorrectes", parent: self)
        }
    }
 
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        self.onDoneTapped()
    }
    func setupTextFields() {
        self.taskNameTextField.placeholder = "Titre de la tâche"
        self.taskDescriptionLabel.placeholder = "Description de la tâche"
    }
}
