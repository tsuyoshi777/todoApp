//
//  TodoViewModel.swift
//  TodoApp
//
//  Created by TsuyoshiTonobe on 2018/03/08.
//  Copyright © 2018年 TsuyoshiTonobe. All rights reserved.
//

import Foundation
import FirebaseDatabase

class TodoViewModel: NSObject {
    static let sharedModel: TodoViewModel = TodoViewModel()
    
    var checkUpdate:Bool = false
    var isFistBoost:Bool = true
    var newTask:String = ""
    var todo = [Todo]()
    
    func createTodo(_ todo: Todo) {
        let ref = Database.database().reference()
        let todoRef = ref.child("TodoItems").childByAutoId()
        
        guard let title = todo.title else { return }
        let newTodo = ["title": title,"isDone": todo.isDone] as [String : Any]
        todoRef.updateChildValues(newTodo)
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
    
}
