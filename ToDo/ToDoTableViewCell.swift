//
//  ToDoTableViewCell.swift
//  ToDo
//
//  Created by Zofia Drabek on 25/06/2019.
//  Copyright © 2019 Zofia Drabek. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    var toggleDone: () -> Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        toggleDone()
    }
    
}
