//
//  ToDoItem.swift
//  BetterToDoList
//
//  Created by Gera Groshev on 10/16/16.
//  Copyright © 2016 individual. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    // A text description of the item
    var text: String
    // A Boolean vlue that determines the completed state of this item.
    var completed: Bool
    
    // Returns a ToDoItem initialized with the given text and default completed value.
    init(text: String) {
        self.text = text
        self.completed = false
    }
}
