//
//  PaidLendingsTableViewCell.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 6/6/2023.
//

import UIKit

/**
 UITableViewCell class that represents the cells used by PaidLendingTableViewController*/
class PaidLendingsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /**
     Outlet for displaying all the label
     */
    @IBOutlet weak var paidByLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
