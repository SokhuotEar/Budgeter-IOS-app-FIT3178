//
//  AllTransactionTableViewCell.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 4/5/2023.
//

import UIKit

/**
 Cell class that represents the cell used by AllTransactionViewController
 */
class AllTransactionsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /** Outlets to labels*/
    @IBOutlet weak var toFromLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        toFromLabel.numberOfLines = .max
        amountLabel.numberOfLines = .max
    }

}
