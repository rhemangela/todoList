//
//  TodoListTableViewCell.swift
//  todoList
//
//  Created by Angela on 6/9/2020.
//  Copyright © 2020 AT Production. All rights reserved.
//

import UIKit

class TodoListTableViewCell: UITableViewCell {
    @IBOutlet weak var _tickBox: UIImageView!
    @IBOutlet weak var _todoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
