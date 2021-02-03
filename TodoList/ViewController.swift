//
//  ViewController.swift
//  TodoList
//
//  Created by Gabriel Kirkley on 2021-02-02.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todos = [
        Todo(title: "Return library books"),
        Todo(title: "Write in journal"),
        Todo(title: "Create amazing program"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startEditing(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    @IBSegueAction func todoViewController(_ coder: NSCoder) -> TodoViewController? {
        let vc = TodoViewController(coder: coder)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let todo = todos[indexPath.row]
            vc?.todo = todo
        }
        
        vc?.delegate = self
        vc?.presentationController?.delegate = self
        
        return vc
    }
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Complete") { action, view, complete in
            let todo = self.todos[indexPath.row].completeToggled()
            self.todos[indexPath.row] = todo
            
            let cell = tableView.cellForRow(at: indexPath) as! CheckTableViewCell
            cell.set(checked: todo.isComplete)
            
            complete(true)
        }
        
        if todos[indexPath.row].isComplete {
            action.title = "Incomplete"
            action.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        } else {
            action.backgroundColor = #colorLiteral(red: 0, green: 0.5415702462, blue: 0, alpha: 1)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // One of the benefits of implementing delete in this way is that
    // it also allows the delete functionality to carry over into the
    // tableView.isEditing state.
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Keep the data consistent with what the user sees
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos.remove(at: sourceIndexPath.row)
        todos.insert(todo, at: destinationIndexPath.row)
    }
}

extension ViewController :  UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! CheckTableViewCell
        
        cell.delegate = self
        
        let todo = todos[indexPath.row]
        
        cell.set(title: todo.title, checked: todo.isComplete)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete from data and then from tableView to ensure that
            // the data remains consistent with the tableView data source
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}


extension ViewController : CheckTableViewCellDelegate {
    func checkTableViewCell(_ cell: CheckTableViewCell, didChangeCheckedState checked: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let todo = todos[indexPath.row]
        
        let newTodo = Todo(title: todo.title, isComplete: !todo.isComplete)
        
        todos[indexPath.row] = newTodo
    }
    
}

extension ViewController : TodoViewControllerDelegate {
    func todoViewController(_ vc: TodoViewController, didSaveTodo todo: Todo) {
        
        // Animate the adding or updated after the TodoViewController has been dismissed
        dismiss(animated: true) {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // update
                self.todos[indexPath.row] = todo
                self.tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                self.todos.append(todo)
                self.tableView.insertRows(at: [IndexPath(row: self.todos.count - 1, section: 0)], with: .automatic)
            }
        }
    }

}

extension ViewController : UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
