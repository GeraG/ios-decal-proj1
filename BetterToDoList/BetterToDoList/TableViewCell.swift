//
//  TableViewCell.swift
//  BetterToDoList
//
//  Created by Gera Groshev on 10/16/16.
//  Copyright © 2016 individual. All rights reserved.
//

import UIKit

// A protocol that the TableViewCell uses to inform its delegate of state change
protocol TableViewCellDelegate {
    // indicates that the given item has been deleted
    func toDoItemDeleted(toDoItem: ToDoItem)
    // Indicates that the edit process has begun for the given cell
    func cellDidBeginEditing(editingCell: TableViewCell)
    // Indicates that the edit process has committed for the given cell
    func cellDidEndEditing(editingCell: TableViewCell)
}

class TableViewCell: UITableViewCell, UITextFieldDelegate {
    
    let gradientLayer = CAGradientLayer()
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false, completeOnDragRelease = false
    var checkMarkLabel: UILabel, crossLabel: UILabel
    let label: StrikeThroughText
    var itemCompleteLayer = CALayer()
    // The object that acts as delegate for this cell.
    var delegate: TableViewCellDelegate?
    // The item that this cell renders.
    var toDoItem: ToDoItem? {
        didSet {
            label.text = toDoItem!.text
            label.strikeThrough = toDoItem!.completed
            itemCompleteLayer.isHidden = !label.strikeThrough
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // create a label that renders the to-do item text
        label = StrikeThroughText(frame: CGRect.null)
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        
        // utility method for creating the contextual cues
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.null)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 32.0)
            label.backgroundColor = UIColor.clear
            return label
        }
        
        // tick and cross labels for context cues
        checkMarkLabel = createCueLabel()
        checkMarkLabel.text = "\u{2713}" // unicode value for check  ark
        checkMarkLabel.textAlignment = .right
        crossLabel = createCueLabel()
        crossLabel.text = "\u{2717}" // unicode value for cross mark
        crossLabel.textAlignment = .left
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.delegate = self
        label.contentVerticalAlignment = .center
        
        addSubview(label)
        addSubview(checkMarkLabel)
        addSubview(crossLabel)
        // remove the default blue highlight for selected cells
        selectionStyle = .none
        
        // gradient layer for cell
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        let color4 = UIColor(white: 0.4, alpha: 0.1).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 0.99]
        layer.insertSublayer(gradientLayer, at: 0)
        
        // add a layer that renders a green background when an item is complete
        itemCompleteLayer = CALayer(layer: layer)
        itemCompleteLayer.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0,
                                                    alpha: 1.0).cgColor
        itemCompleteLayer.isHidden = true
        layer.insertSublayer(itemCompleteLayer, at: 0)
        
        // add a pan recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        
    }
    
    let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 50.0
    let kLabelLeftMargin: CGFloat = 15.0
    override func layoutSubviews() {
        // super.layoutSubviews()
        // ensure the gradient layer occupies the full bounds
        gradientLayer.frame = bounds
        itemCompleteLayer.frame = bounds
        label.frame = CGRect(x: kLabelLeftMargin, y: 0,
                             width: bounds.size.width - kLabelLeftMargin,
                             height: bounds.size.height)
        checkMarkLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0,
                                      width: kUICuesWidth, height: bounds.size.height)
        crossLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
                                  width: kUICuesWidth, height: bounds.size.height)
    }
    
    // MARK: - UITextFieldDelegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // disable editing of completed to-do items
        if toDoItem != nil {
            return !toDoItem!.completed
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if delegate != nil {
            delegate!.cellDidBeginEditing(editingCell: self)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if toDoItem != nil {
            toDoItem!.text = textField.text!
        }
        if delegate != nil {
            delegate!.cellDidEndEditing(editingCell: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close the keyboard on Enter
        textField.resignFirstResponder()
        return false
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            completeOnDragRelease = frame.origin.x > frame.size.width / 4.0
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            
            // fade the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            checkMarkLabel.alpha = cueAlpha
            crossLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            checkMarkLabel.textColor = completeOnDragRelease ? UIColor.green : UIColor.white
            crossLabel.textColor = deleteOnDragRelease ? UIColor.red : UIColor.white
        }
        // 3
        if recognizer.state == .ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            
            if deleteOnDragRelease {
                if delegate != nil && toDoItem != nil {
                    // notify the delegate that this item should be deleted
                    delegate!.toDoItemDeleted(toDoItem: toDoItem!)
                }
            } else if completeOnDragRelease {
                // if swipe right, negate completed, strikeTrhough, and isHidden to be able to undo by swiping right again
                if toDoItem != nil {
                    toDoItem!.completed = !toDoItem!.completed
                }
                label.strikeThrough = !label.strikeThrough
                itemCompleteLayer.isHidden = !itemCompleteLayer.isHidden
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            } else {
                // Otherwise snap back to the original location
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            }
            
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
}
