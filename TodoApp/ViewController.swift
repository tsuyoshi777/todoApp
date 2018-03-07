//
//  ViewController.swift
//  TodoApp
//
//  Created by TsuyoshiTonobe on 2018/03/07.
//  Copyright © 2018年 TsuyoshiTonobe. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var todo = [Todo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
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
        let id = self.todo.count
        let todoRef = ref.child("TodoItems").childByAutoId()
        let newTodo = ["title": todo.title,"isDone": todo.isDone] as [String : Any]
        todoRef.updateChildValues(newTodo)
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
}

