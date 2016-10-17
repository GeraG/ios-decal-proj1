//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Gera Groshev on 10/16/16.
//  Copyright © 2016 individual. All rights reserved.
//

import XCTest
@testable import ToDoList

class ToDoListTests: XCTestCase {
    // MARK: ToDoList Tests
    
    
    // Tests to confirm that the ToDoItem initializer returns when no task is provided
    func testToDoItemInitialization() {
        // Success case.
        let potentialItem = ToDoItem(task: "Do this", details: nil)
        XCTAssertNotNil(potentialItem)
        
        // Failure cases.
        let noTask = ToDoItem(task: "", details: nil)
        XCTAssertNil(noTask, "Empty task is invalid")
        

    }
    

}
