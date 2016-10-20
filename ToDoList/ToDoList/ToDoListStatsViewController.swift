//
//  ToDoListStatsViewController.swift
//  ToDoList
//
//  Created by Gera Groshev on 10/19/16.
//  Copyright © 2016 individual. All rights reserved.
//

import UIKit

class ToDoListStatsViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var ToDoItemsCompletedCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToDoItemsCompletedCount.text = String(completedCount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
