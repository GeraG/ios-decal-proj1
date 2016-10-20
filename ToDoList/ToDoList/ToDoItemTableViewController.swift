//
//  ToDoItemTableViewController.swift
//  ToDoList
//
//  Created by Gera Groshev on 10/16/16.
//  Copyright © 2016 individual. All rights reserved.
//

import UIKit

var toDoItems = [ToDoItem]()
var completedCount = 0
//var helloWorldTimer = Timer.scheduledTimerWithTimeInterval(60.0, target: self, selector: Selector("updateToDoList"), userInfo: nil, repeats: true)
//func updateToDoList()
//{
//    // iterate through all to do items if time stamps are 24 hours apart, delete completed items and decrement completedCount
//}

class ToDoItemTableViewController: UITableViewController {
    
    // MARK: Properties
    
    func loadSampleItems() {
        let item1 = ToDoItem(task: "Tap me to edit.", details: "Do this")!
        let item2 = ToDoItem(task: "Tap button on left to mark as completed", details: "Do that")!
        let item3 = ToDoItem(task: "Completed tasks disappear after 24 hours", details: "")!
        let item4 = ToDoItem(task: "All data is saved.", details: "Add stuff, delete stuff, close me, open me.")!
        let item5 = ToDoItem(task: "Stats show completed tasks in past 24 hours", details: "")!
        
        toDoItems += [item1, item2, item3, item4, item5]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedToDoItems = loadToDoItems() {
            toDoItems += savedToDoItems
        } else {
            // load the sample data
            loadSampleItems()
        }
        for toDoItem in toDoItems {
            if toDoItem.isCompleted {
                completedCount += 1
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        func secondsToHours(seconds: Int) -> Int {
            return seconds / 3600
        }
        var newToDoItemsList = [ToDoItem]()
        for toDoItem in toDoItems {
            let secondsSinceCompleted = Int(Date().timeIntervalSince(toDoItem.dateCompleted))
            if toDoItem.isCompleted && (secondsToHours(seconds: secondsSinceCompleted) >= 24) {
                completedCount -= 1
            } else {
                newToDoItemsList.append(toDoItem)
            }
        }
        toDoItems = newToDoItemsList
        // Reload all cells and their tags
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            let toDoDetailViewController = segue.destination as! ToDoItemViewController
            // Get the cell that generated this segue.
            if let selectedToDoCell = sender as? TaskTableViewCell {
                let indexPath = tableView.indexPath(for: selectedToDoCell)!
                let selectedTask = toDoItems[indexPath.row]
                toDoDetailViewController.toDoItem = selectedTask
            }
        }
        else if segue.identifier == "AddItem" {
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TaskTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskTableViewCell

        let toDoItem = toDoItems[indexPath.row]
        cell.taskLabel.text = toDoItem.task
        cell.taskDetails.text = toDoItem.details
        cell.checkMarkButton.setButtonSelected(toDoItem.isCompleted)
        cell.checkMarkButton.setButtonTag(indexPath.row)
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // Delete toDoItem data at current row
            if toDoItems[indexPath.row].isCompleted {
                // If this item was marked as completed, then decrement the completedCount if the item is deleted
                completedCount -= 1
            }
            toDoItems.remove(at: indexPath.row)
            ToDoItemTableViewController.saveToDoItems()
            // Reload all cells and their tags
            self.tableView.reloadData()
            // Delete cell at current row, this doesn't work since cell tags after current row need to be updated
            // tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    @IBAction func unwindToToDoItemsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ToDoItemViewController, let toDoItem = sourceViewController.toDoItem {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing item
                toDoItems[selectedIndexPath.row] = toDoItem
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new item.
                let newIndexPath = IndexPath(row: toDoItems.count,section: 0)
                toDoItems.append(toDoItem)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            // Save the items
            ToDoItemTableViewController.saveToDoItems()
        }
    }
    
    // MARK: NSCoding
    class func saveToDoItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(toDoItems, toFile: ToDoItem.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save items...")
        }
    }
    
    func loadToDoItems() -> [ToDoItem]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ToDoItem.ArchiveURL.path) as? [ToDoItem]
    }
}
