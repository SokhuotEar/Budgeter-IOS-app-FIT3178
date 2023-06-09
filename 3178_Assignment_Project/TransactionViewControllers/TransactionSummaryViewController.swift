//
//  TransactionSummaryViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 5/5/2023.
//

import UIKit

/**
 This claass shows transaction summary of a particular transaction.
 */
class TransactionSummaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let transaction
        {
            // show texts to amount, to, reccuring, note labels
            amountLabel.text = String(transaction.amount)
            toLabel.text = transaction.toFrom
            
            // set texts to reflect recurring for the transaction
            if transaction.recurring == 0
            {
                recurringLabel.text = "No"
            }
            else
            {
                recurringLabel.text = "Yes"
            }
            
            // note label
            noteLabel.text = transaction.note
            
            // get the category. Guard it in case it is null (it shouldnt ever null anyway)
            if transaction.category != nil
            {
                categoryLabel.text = transaction.category?.name
            }
            else
            {
                categoryLabel.text = transaction.category?.name
            }
            
            transactionTypeLabel.text = TransactionType(rawValue: transaction.transactionType)?.stringValue
            
            // green if amount is positive, red if negative
            if transaction.amount >= 0
            {
                amountLabel.textColor = UIColor.systemGreen
            }
            else
            {
                amountLabel.textColor = UIColor.systemRed
            }
            
            
            //handle date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let dateString = dateFormatter.string(from: transaction.date ?? Date())
            dateLabel.text = dateString
            
        }
    }
    
    /** labels */
    var transaction: Transaction?
    @IBOutlet weak var transactionTypeLabel: UILabel!

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var recurringLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    
    
}
