//
//  ViewController.swift
//  TodoList_SQLite
//
//  Created by Chu Du on 29/09/2021.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var todos = [Todo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Todo List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.addSubview(tableView)
        
        tableView.frame = self.view.bounds
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        fetchData()
    }
    
    func fetchData() {
        todos = DBController.shared.getListTodo()
        tableView.reloadData()
    }
    
    @objc func handleAdd() {
        showAlert(title: "New Todo", message: "", name: "") { name in
            self.save(name: name)
            self.tableView.reloadData()
        }
    }
    
    func update(name: String, index: Int) {
        let todo = todos[index]
        todo.name = name
        todo.saveUpdate()
        tableView.reloadData()
      }
      
      func save(name: String) {
        let todo = Todo()
        todo.id = UUID().uuidString
        todo.name = name
        todo.insertToDB()
        
        todos.append(todo)
        tableView.reloadData()
      }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        showAlert(title: "Todo", message: "", name: todo.name) { name in
            self.update(name: name, index: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { action, view, closure in
            self.todos.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        deleteAction.backgroundColor = .red

        let actionConfig = UISwipeActionsConfiguration(actions: [deleteAction])

        return actionConfig
    }

}

extension ViewController {
    func showAlert(title: String, message: String, name: String, saveCompletionHandler:((_ name: String) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { nameTF in
            if name == "" {
                nameTF.placeholder = "name"
            } else {
                nameTF.text = name
            }
        }
        
        let submitAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newName = alert.textFields![0].text else { return }
            
            saveCompletionHandler?(newName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        alert.preferredAction = submitAction
        
        present(alert, animated: true)
    }
}
