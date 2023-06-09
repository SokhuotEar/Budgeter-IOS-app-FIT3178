//
//  TransactionSummaryViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 5/5/2023.
//

import UIKit

class TransactionSummaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let transaction
        {
            amountLabel.text = String(transaction.amount)
            toLabel.text = transaction.toFrom
            
            if transaction.recurring == 0
            {
                recurringLabel.text = "No"
            }
            else
            {
                recurringLabel.text = "Yes"
            }
            
            
            noteLabel.text = transaction.note
            
            if transaction.category != nil
            {
                categoryLabel.text = transaction.category?.name
            }
            else
            {
                categoryLabel.text = transaction.category?.name
            }
            
            transactionTypeLabel.text = TransactionType(rawValue: transaction.transactionType)?.stringValue
            
            if TransactionType(rawValue: transaction.transactionType) == .income
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
    
    var transaction: Transaction?
    @IBOutlet weak var transactionTypeLabel: UILabel!
    
    @IBAction func doneButtonAction(_ sender: Any) {
    }
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var recurringLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    
    
}
