//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Gera Groshev on 10/16/16.
//  Copyright © 2016 individual. All rights reserved.
//

import Foundation



class ToDoItem: NSObject, NSCoding {
    // MARK: Properties
    struct PropertyKey {
        static let taskKey = "taks"
        static let detailsKey = "details"
        static let isCompletedKey = "isCompleted"
    }
    
    var task: String
    var details: String?
    var isCompleted: Bool
    // store entire button instead of just isCompleted?
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("toDoItems")
    
    init?(task: String, details: String?, isCompleted: Bool = false) {
        self.task = task
        self.details = details
        self.isCompleted = isCompleted
        
        super.init()
        
        if task.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(task, forKey: PropertyKey.taskKey)
        aCoder.encode(details, forKey: PropertyKey.detailsKey)
        aCoder.encode(isCompleted, forKey: PropertyKey.isCompletedKey)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let task = aDecoder.decodeObject(forKey: PropertyKey.taskKey) as! String
        let details = aDecoder.decodeObject(forKey: PropertyKey.detailsKey) as? String
        let isCompleted = aDecoder.decodeBool(forKey: PropertyKey.isCompletedKey)
        self.init(task: task, details: details, isCompleted: isCompleted)
    }
}
