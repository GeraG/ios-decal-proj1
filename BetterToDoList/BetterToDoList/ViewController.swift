//
//  ViewController.swift
//  BetterToDoList
//
//  Created by Gera Groshev on 10/16/16.
//  Copyright © 2016 individual. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!

    var toDoItems = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        tableView.rowHeight = 50.0
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view, typically from a nib.
        toDoItems.append(ToDoItem(text: "1. Swipe right until checkmark turns green"))
        toDoItems.append(ToDoItem(text: "to mark as completed"))
        toDoItems.append(ToDoItem(text: "2. Swipe left until cross turns red to delete"))
        toDoItems.append(ToDoItem(text: "3. Tap/click on a task to edit it (still buggy)"))
        toDoItems.append(ToDoItem(text: "4. Press return to finish editing (still buggy)"))
        toDoItems.append(ToDoItem(text: "ToDo 1: Fix buggy edit"))
        toDoItems.append(ToDoItem(text: "ToDo 2: Add 'Add Item' functionality or"))
        toDoItems.append(ToDoItem(text: "import/copy it from the other ToDoList app"))
        toDoItems.append(ToDoItem(text: "ToDo 3: Add or import/copy statistics"))
        toDoItems.append(ToDoItem(text: "functionality from the other ToDoList app"))
        toDoItems.append(ToDoItem(text: "ToDo 4: Add persistent data functionality"))
        toDoItems.append(ToDoItem(text: "ToDo 5: Impress everyone"))
        toDoItems.append(ToDoItem(text: "Task 13"))
        toDoItems.append(ToDoItem(text: "Task 14"))
        toDoItems.append(ToDoItem(text: "Task 15"))
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let item = toDoItems[indexPath.row]
        // Commented items already set in TableViewCell.swift didSet observer for toDoItem
        // cell.textLabel?.backgroundColor = UIColor.clear
        // cell.textLabel?.text = item.text
        cell.selectionStyle = .none
        cell.delegate = self
        cell.toDoItem = item
        return cell
    }
    
    // MARK: - TableViewCellDelegate methods
    func toDoItemDeleted(toDoItem: ToDoItem) {
        let index = (toDoItems as NSArray).index(of: toDoItem)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        toDoItems.remove(at: index)
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPathForRow], with: .fade)
        tableView.endUpdates()
    }
    
    func cellDidBeginEditing(editingCell: TableViewCell) {
        let editingOffset = tableView.contentOffset.y - editingCell.frame.origin.y + self.navigationController!.navigationBar.frame.height as CGFloat
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for cell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform(translationX: 0, y: editingOffset)
                if cell !== editingCell {
                    cell.alpha = 0.5
                }
            })
        }
    }
    
    func cellDidEndEditing(editingCell: TableViewCell) {
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for cell: TableViewCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform.identity
                if cell !== editingCell {
                    cell.alpha = 1.0
                }
            })
        }
    }
    
    // MARK: - Table view delegate
    
    func colorForIndex(index: Int) -> UIColor {
        return UIColor.black
        // below return sets a gradient
        // let itemCount = toDoItems.count - 1
        // let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        // return UIColor(red: val, green: val, blue: val, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(index: indexPath.row)
    }
    
}
