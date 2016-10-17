//
//  ToDoItemViewController.swift
//  ToDoList
//
//  Created by Gera Groshev on 10/16/16.
//  Copyright © 2016 individual. All rights reserved.
//

import UIKit

class ToDoItemViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var toDoItem: ToDoItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text fie'ds user input through delegate callbacks
        taskTextField.delegate = self
        detailsTextField.delegate = self
        
        if let toDoItem = toDoItem {
            taskTextField.text = toDoItem.task
            detailsTextField.text = toDoItem.details
        }
        
        // Enable the Save button only if the text field as input
        taskTextField.addTarget(self, action: #selector(ToDoItemViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        checkInputTaskField()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        checkInputTaskField()
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        checkInputTaskField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkInputTaskField()
        if textField == taskTextField {
            taskTextField.text = textField.text
        } else if textField == detailsTextField {
            detailsTextField.text = textField.text
        }
    }
    
    func checkInputTaskField() {
        // Disable the Save button if the text field is empty.
        let text = taskTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // MARK: Navigation
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddToDoMode = presentingViewController is UINavigationController
        if isPresentingInAddToDoMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }

    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if saveButton === sender as! UIBarButtonItem {
            let task = taskTextField.text ?? ""
            let details = detailsTextField.text
            
            toDoItem = ToDoItem(task: task, details: details)
        }
    }
}

