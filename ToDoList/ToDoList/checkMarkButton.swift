//
//  checkMarkButton.swift
//  ToDoList
//
//  Created by Gera Groshev on 10/16/16.
//  Copyright © 2016 individual. All rights reserved.
//

import UIKit

class checkMarkButton: UIView {
    var isButtonSelected = false
    var row = 0
    let emptyCheckMarkImage = UIImage(named: "emptyCheckMark")
    let filledCheckMarkImage = UIImage(named: "filledCheckMark")
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let buttonSize = Int(frame.size.height)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        
        button.setImage(emptyCheckMarkImage, for: .normal)
        button.setImage(filledCheckMarkImage, for: .selected)
        button.setImage(filledCheckMarkImage, for: [.highlighted, .selected])
        button.adjustsImageWhenHighlighted = false
        
        button.addTarget(self, action: #selector(checkMarkButton.checkMarkButtonTapped(_:)), for: .touchDown)
        addSubview(button)
    }
    
    // MARK: Button Action
    func checkMarkButtonTapped(_ button: UIButton) {
        isButtonSelected = !isButtonSelected
        button.isSelected = isButtonSelected
    }
}
