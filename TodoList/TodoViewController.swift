//
//  TodoViewController.swift
//  TodoList
//
//  Created by Gabriel Kirkley on 2021-02-02.
//

import UIKit

protocol TodoViewControllerDelegate : AnyObject {
    func todoViewController(_ vc: TodoViewController, didSaveTodo todo : Todo)
}

class TodoViewController : UIViewController {
 
    @IBOutlet weak var textField: UITextField!
    
    var todo : Todo?
    
    weak var delegate : TodoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = todo?.title
    }
    
    @IBAction func save(_ sender: Any) {
        let todo = Todo(title: textField.text!)
        delegate?.todoViewController(self, didSaveTodo: todo)
    }
    
}
