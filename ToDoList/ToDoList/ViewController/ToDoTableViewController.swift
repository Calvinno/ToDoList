//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Calvin Cantin on 2018-12-28.
//  Copyright © 2018 Calvin Cantin. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    var todos = [ToDo]()
    {
        didSet
        {
            ToDo.saveTodos(todos)
        }
    }
    var searchTodos = [String]()
    var searching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        if let todos = ToDo.loadToDos()
        {
            self.todos = todos
        }
        else
        {
            self.todos = ToDo.loadSampleToDo()
        }
        navigationItem.leftBarButtonItem = editButtonItem
    }
    func checkmarkTapped(sender: ToDoTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender)
        {
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Search bar methode
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchTodosTitle = todos.map({$0.title})
        searchTodos = searchTodosTitle.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        self.searchBar.endEditing(true)
    }
        
    
    
    //Table View set up
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching
        {
            return searchTodos.count
        }
        else
        {
            return todos.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoTableViewCell else {fatalError("Could not dequeue a cell")}
        
        cell.delegate = self
        let toDo = todos[indexPath.row]
        
        cell.isCompleteButton.isSelected = toDo.isComplete
        if searching
        {
            cell.titleLabel.text = searchTodos[indexPath.row]
        }
        else
        {
            cell.titleLabel.text = toDo.title
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //Segue func
    @IBAction func unwindToDoList(segue:UIStoryboardSegue)
    {
        guard segue.identifier == "saveUnwind" else {return}
        let sourceViewController = segue.source as! ToDoViewController
        
        if let todo = sourceViewController.todo
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                todos[indexPath.row] = todo
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            else
            {
            let newIndexPath = IndexPath(row: todos.count, section: 0)
            todos.append(todo)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"
        {
            let toDoViewController = segue.destination as! ToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedToDo = todos[indexPath.row]
            toDoViewController.todo = selectedToDo
        }
    }
}
