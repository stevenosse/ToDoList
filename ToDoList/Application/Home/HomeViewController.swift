//
//  HomeViewController.swift
//  ToDoList
//
//  Created by Nossedjou Steve on 11/03/2021.
//

import UIKit

class HomeViewController: ViewController, UISearchControllerDelegate {
    @IBOutlet weak var taskListView: UITableView!
    @IBOutlet weak var noTaskLabel: UILabel!
    @IBOutlet weak var noTaskImage: UIImageView!
    
    let searchController = UISearchController()
    
    lazy var viewModel: HomeViewModel = HomeViewModel()
    
    var filteredTasks: [Task] = []
    
    let watchManager = WatchManager.shared
    
    func filterContentForSearchText(_ searchText: String) {
        filteredTasks = viewModel.taskList.filter { (task: Task) -> Bool in
            return (task.value(forKey: "title") as? String)!.lowercased().contains(searchText.lowercased())
                    || (task.value(forKey: "desc") as? String)!.lowercased().contains(searchText.lowercased())
        }
        taskListView.reloadData()
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mes tâches"
        
        self.navigationController?.navigationBar.backgroundColor = .systemPink
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        setupTableView()
        setupRightBarButtons()
        setupSearchBar()
        setupViewModel()
        setupWatchListeners()
        
        fetchData()
    }
    
    func setupSearchBar() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Rechercher une tâche..."
        searchController.searchBar.tintColor = .white
        
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupRightBarButtons() {
        let addTaskButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTaskButtonTapped))
        navigationItem.rightBarButtonItems = [addTaskButton]
    }
    func setupTableView() {
        self.taskListView.delegate = self
        self.taskListView.dataSource = self
    }
    
    @objc func addTaskButtonTapped() {
        let taskBottomSheet = UINavigationController(rootViewController: AddTaskBottomSheetViewController())
        taskBottomSheet.modalPresentationStyle = .pageSheet
        self.present(taskBottomSheet, animated: true, completion: nil)
    }
    
    func setupViewModel() {
        viewModel.reloadTableViewClosure = { [self] () in
            DispatchQueue.main.async {
                if self.viewModel.taskList.count == 0 {
                    showEmptyState()
                } else {
                    hideEmptyState()
                    self.taskListView.reloadData()
                    self.sendTodoListToWatch()
                }
                
            }
        }
    }
    
    func fetchData() {
        viewModel.loadTaskList()
        if viewModel.taskList.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
}

extension HomeViewController : UITableViewDelegate {
    
}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTasks.count
        }
        return viewModel.taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TaskTableViewCell", owner: self, options: nil)?.first as! TaskTableViewCell
        
        let item = isFiltering ? filteredTasks[indexPath.row] : viewModel.taskList[indexPath.row]
        cell.titleLabel.text = item.value(forKey: "title")! as? String
        cell.dateLabel.text = item.value(forKey: "desc")! as? String
        if item.value(forKey: "done") as? Bool ?? false {
            cell.toggleChecked()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markDoneAction = UIContextualAction(style: .normal, title: "Fait") {_,_,_ in
            self.viewModel.markDone(uuid: self.viewModel.taskList[indexPath.row].value(forKey: "uuid") as! String)
        }
        markDoneAction.backgroundColor = .systemBlue
        markDoneAction.image = UIImage(systemName: "checkmark")
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") {_,_,_ in
            self.viewModel.removeTask(self.viewModel.taskList[indexPath.row])
            self.sendTodoListToWatch()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [markDoneAction, deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        cell.toggleChecked()
        self.viewModel.markDone(uuid: self.viewModel.taskList[indexPath.row].value(forKey: "uuid") as! String)
        tableView.deselectRow(at: indexPath, animated: true)
        self.sendTodoListToWatch()
    }
    
    func hideEmptyState() {
        self.noTaskLabel.isHidden = true
        self.noTaskImage.isHidden = true
        self.taskListView.isHidden = false
    }
    
    func showEmptyState() {
        self.noTaskLabel.isHidden = false
        self.noTaskImage.isHidden = false
        self.taskListView.isHidden = true
    }
}

extension HomeViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text! as String
        filterContentForSearchText(query)
    }
}

extension HomeViewController {
    func setupWatchListeners() {
        watchManager.onSyncMessageReceived = { [self] (data) in
            self.sendTodoListToWatch()
        }
    }
    
    func sendTodoListToWatch() {
        var dict: [String:Any] = [:]
        viewModel.taskList.forEach( { (task) in
            dict[task.value(forKey: "uuid") as! String] = [
                "title": task.value(forKey: "title") as! String,
                "desc": task.value(forKey: "desc") as! String,
                "done": task.value(forKey: "done") as! Bool
            ]
        })
        watchManager.sendWatchMessage(message: ["TodoList": dict])
    }
}
