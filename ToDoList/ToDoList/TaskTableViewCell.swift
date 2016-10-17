//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Gera Groshev on 10/16/16.
//  Copyright © 2016 individual. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    // MARK: Properties

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskDetails: UILabel!
    @IBOutlet weak var checkMarkButton: checkMarkButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
