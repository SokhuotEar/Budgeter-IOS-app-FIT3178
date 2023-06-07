//
//  AllLendingHistoryTableViewCell.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 4/6/2023.
//

import UIKit

class AllLendingHistoryTableViewCell: UITableViewCell {

    var databaseController: DatabaseProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    @IBAction func markAsPaidButtonAction(_ sender: Any) {
        if let lending
        {
            print("lending")
            databaseController?.markLendingAsPaid(lending: lending)
        }

        if let markAsPaid
        {
            print("markAsPaid")
            markAsPaid.markAsPaidButtonPressed()
        }
    }
    
    @IBOutlet weak var markAsPaidButton: UIButton!
    
    var markAsPaid: MarkAsPaidProtocol?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var toLabel: UILabel!
    var lending: Lending?
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
}
