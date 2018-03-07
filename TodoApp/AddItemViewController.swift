//
//  AddItemViewController.swift
//  TodoApp
//
//  Created by TsuyoshiTonobe on 2018/03/07.
//  Copyright © 2018年 TsuyoshiTonobe. All rights reserved.
//

import UIKit

class AddItemViewController: TodoViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddButtonTapped(_ sender: Any) {
        guard let task = textField.text else { return }
        if task.isEmpty {
            
        } else {
//            var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.checkUpdate = true
//            appDelegate.newTask = task
            viewModel.checkUpdate = true
            viewModel.newTask = task
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
