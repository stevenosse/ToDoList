//
//  LoadingViewController.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 11/03/2021.
//

import UIKit

class LoadingViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        perform(#selector(showHomePage), with: nil, afterDelay: 1)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    @objc func showHomePage() {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.modalPresentationStyle = .overFullScreen
        self.present(homeViewController, animated: true, completion: nil)
    }
}
