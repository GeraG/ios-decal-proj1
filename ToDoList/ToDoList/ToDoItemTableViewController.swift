//
//  ToDoItemTableViewController.swift
//  ToDoList
//
//  Created by Gera Groshev on 10/16/16.
//  Copyright © 2016 individual. All rights reserved.
//

import UIKit

var toDoItems = [ToDoItem]()

class ToDoItemTableViewController: UITableViewController {
    
    // MARK: Properties
    
    func loadSampleItems() {
        let item1 = ToDoItem(task: "Sample", details: "Do this")!
        let item2 = ToDoItem(task: "Another sample", details: "Do that")!
        
        toDoItems += [item1, item2]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedToDoItems = loadToDoItems() {
            toDoItems += savedToDoItems
        } else {
            // load the sample data
            loadSampleItems()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
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
            // Before removing, update row values of every cell after the cell to be deleted by subtracting 1 row
            // Don't subtract row value of current cell row, thus start at row + 1 instead of at row
            let cells = self.tableView.visibleCells as! Array<TaskTableViewCell>
            for row in (indexPath.row + 1)..<tableView.numberOfRows(inSection: 0) {
                cells[row].checkMarkButton.setButtonTag(cells[row].checkMarkButton.buttonTag - 1)
            }
            // Delete toDoItem data at current row
            toDoItems.remove(at: indexPath.row)
            ToDoItemTableViewController.saveToDoItems()
            // Delete cell at current row
            tableView.deleteRows(at: [indexPath], with: .fade)
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
