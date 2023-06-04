//
//  AllLendingHistoryTableViewCell.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 4/6/2023.
//

import UIKit

class AllLendingHistoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var amountPendingLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
}
