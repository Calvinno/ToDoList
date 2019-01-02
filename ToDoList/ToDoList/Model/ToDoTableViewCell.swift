//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Calvin Cantin on 2018-12-30.
//  Copyright © 2018 Calvin Cantin. All rights reserved.
//

import UIKit

@objc protocol ToDoCellDelegate: class
{
    func checkmarkTapped(sender: ToDoTableViewCell)
}

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: ToDoCellDelegate?
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    
    
    
}
