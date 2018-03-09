//
//  ViewController.swift
//  TodoApp
//
//  Created by TsuyoshiTonobe on 2018/03/07.
//  Copyright © 2018年 TsuyoshiTonobe. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TodoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let viewModel: TodoViewModel = TodoViewModel.sharedModel
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if viewModel.isFistBoost {
            readTodo()
            viewModel.isFistBoost = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.checkUpdate {
            
            let todo = Todo()
            let todoTitle = viewModel.newTask
            todo.title = todoTitle
            todo.isDone = false
            viewModel.todo.insert(todo, at: 0)
            viewModel.createTodo(todo)
            
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)
            viewModel.checkUpdate = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
    func readTodo() {
        let ref = Database.database().reference()
        ref.child("TodoItems").observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children {
                let child = item as! DataSnapshot
                let dic = child.value as! NSDictionary
                let todo = Todo()
                todo.title = dic["title"] as? String
                todo.isDone = dic["isDone"] as! Bool
                self.viewModel.todo.insert(todo, at: 0)
                
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todo = viewModel.todo[indexPath.row]
        cell.textLabel?.text = todo.title
        
        if todo.isDone {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = viewModel.todo[indexPath.row]
        
        if myTodo.isDone {
            myTodo.isDone = false
        } else {
            myTodo.isDone = true
        }
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        let location = viewModel.todo.count - indexPath.row
        viewModel.updateTodo(location)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            viewModel.todo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            let location = viewModel.todo.count - indexPath.row
            viewModel.deleteTodo(location)
        }
    }
}
