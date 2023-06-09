//
//  AllLendingHistoryTableViewCell.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 4/6/2023.
//

import UIKit

/** A class that represents a cell used by AllLendingHistoryTableView
 */
class AllLendingHistoryTableViewCell: UITableViewCell {

    var databaseController: DatabaseProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // get data from database
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    
    /**
     This function handles when the user clicks on "mark as paid" button for a lending*/
    @IBAction func markAsPaidButtonAction(_ sender: Any) {
        if let lending
        {
            // it marks that particular lending as paid
            print("lending")
            databaseController?.markLendingAsPaid(lending: lending)
        }

        if let markAsPaid
        {
            print("markAsPaid")
            // it tells AllLendingHistoryTableViewController to reload its table as the database has changed
            markAsPaid.markAsPaidButtonPressed()
        }
    }
    
    @IBOutlet weak var markAsPaidButton: UIButton!
    
    // the protocol that allows this cell to get which lending the user clicks on from AllLendingHistoryTableViewController
    var markAsPaid: MarkAsPaidProtocol?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // outlets
    @IBOutlet weak var toLabel: UILabel!
    var lending: Lending?
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
}
