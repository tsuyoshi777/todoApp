//
//  TodoViewModel.swift
//  TodoApp
//
//  Created by TsuyoshiTonobe on 2018/03/08.
//  Copyright © 2018年 TsuyoshiTonobe. All rights reserved.
//

import Foundation

class TodoViewModel: NSObject {
    static let sharedModel: TodoViewModel = TodoViewModel()
    
    var checkUpdate:Bool = false
    var isFistBoost:Bool = true
    var newTask:String = ""
    
}
