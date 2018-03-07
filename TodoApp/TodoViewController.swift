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
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var todo = [Todo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if appDelegate.isFistBoost {
            readTodo()
            appDelegate.isFistBoost = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if appDelegate.checkUpdate {
            
            let todo = Todo()
            let todoTitle = appDelegate.newTask
            todo.title = todoTitle
            todo.isDone = false
            self.todo.insert(todo, at: 0)
            createTodo(todo)
            
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)
            appDelegate.checkUpdate = false
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createTodo(_ todo: Todo) {
        let ref = Database.database().reference()
        let todoRef = ref.child("TodoItems").childByAutoId()
        let newTodo = ["title": todo.title,"isDone": todo.isDone] as [String : Any]
        todoRef.updateChildValues(newTodo)
    }
    
    func readTodo() {
        let ref = Database.database().reference()
        ref.child("TodoItems").observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children {
                let child = item as! DataSnapshot
                let dic = child.value as! NSDictionary
                let todo = Todo()
                todo.title = dic["title"] as! String
                todo.isDone = dic["isDone"] as! Bool
                self.todo.insert(todo, at: 0)
                
            }
            self.tableView.reloadData()
        })
    }
    
    func updateTodo(_ location: Int) {
        let ref = Database.database().reference()
        var i = 1
        ref.child("TodoItems").observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children {
                let child = item as! DataSnapshot
                let uniqueId = child.key
                let dic = child.value as! NSDictionary
                if i == location {
                    let title = dic["title"] as! String
                    let isDone = dic["isDone"] as! Bool
                    let updateItems = ["TodoItems/\(uniqueId)":["title": title, "isDone": !isDone]]
                    ref.updateChildValues(updateItems)
                }
                i += 1
            }
        })
    }
    
    func deleteTodo(_ location: Int) {
        let ref = Database.database().reference()
        var i = 0
        ref.child("TodoItems").observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children {
                let child = item as! DataSnapshot
                let uniqueId = child.key
                if i == location {
                    ref.ref.child("TodoItems/\(uniqueId)").removeValue()
                }
                i += 1
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todo = self.todo[indexPath.row]
        cell.textLabel?.text = todo.title
        
        if todo.isDone {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = todo[indexPath.row]
        
        if myTodo.isDone {
            myTodo.isDone = false
        } else {
            myTodo.isDone = true
        }
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        let location = self.todo.count - indexPath.row
        updateTodo(location)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            todo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            let location = self.todo.count - indexPath.row
            deleteTodo(location)
        }
    }
}
