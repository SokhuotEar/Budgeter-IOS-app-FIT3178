//
//  AllTransactionsTableViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 4/5/2023.
//

import UIKit

/**
 The table view controller that shows all the transactions in the history (income, expenses and lending)
 */
class AllTransactionsTableViewController: UITableViewController {

    var databaseController: DatabaseProtocol?
    var transactionList: [Transaction] = []
    var CELL_ID = "transactionCell"
    var HEADER_CELL_ID = "transactionHeaderCell"
    var selectedTransaction: Transaction?
    
    /** view did load */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let databaseController
        {
            transactionList = databaseController.allTransactions
        }
        

    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transactionList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue row
        let transactionCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! AllTransactionsTableViewCell
        let transaction = transactionList[indexPath.row]
        
        // set text for date label in the cell
        if let date = transaction.date
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let dateString = dateFormatter.string(from: date)
            transactionCell.dateLabel.text = dateString
        }
        
        // set amount text label colour (red is negative, green if 0 or positive)
        if transaction.amount.isLess(than: 0)
        {
            transactionCell.amountLabel.textColor = UIColor.red
        }
        else
        {
            transactionCell.amountLabel.textColor = UIColor.systemGreen
        }
        
        // set texts to labels in the cell
        transactionCell.toFromLabel.text = transaction.toFrom
        transactionCell.amountLabel.text = String(describing: transaction.amount)
        return transactionCell
    }
    
    /**
     Create a header for the table view controller; shows the headings
     */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerCell = tableView.dequeueReusableCell(withIdentifier: HEADER_CELL_ID) as! AllTransactionsTableViewCell
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /**
     Users can delete the transaction if it is an income type, expense type. If lending type, users cannot delete as it might lead to inconsistency
     */
    override func tableView(_ tableView: UITableView, commit editingStyle:
                            UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // set delete function
        if editingStyle == .delete {
            let transaction = transactionList[indexPath.row]
            if TransactionType(rawValue: transaction.transactionType) == .lending
            {
                displayMessage(controller: self, title: "Cannot delete a lending transaction!" , message: "You cannot delete this transaction as it part of a lending. Consider marking the lending as paid instead to reverse the transaction")
                return
            }
            databaseController?.deleteTransaction(transaction: transaction)
        }
        
        // get data from database again and reload data
        if let databaseController
        {
            transactionList = databaseController.allTransactions
        }
        
        loadData()
    }
    
    
    /**
     When user clicks on a transaction cell, it will lead the user to the transaction summary page */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTransaction = transactionList[indexPath.row]
        performSegue(withIdentifier: "showTransactionSummarySegue", sender: self)
        
    }

    /**
     Prepares segue to transaction summary page
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTransactionSummarySegue"
        {
            let destination = segue.destination as! TransactionSummaryViewController
            if let selectedTransaction
            {
                destination.transaction = selectedTransaction
        
            }
        }
    }
    
    /**
     Get the data from the database and then reload data
     */
    func loadData()
    {
        if let databaseController
        {
            transactionList = databaseController.allTransactions
        }
        tableView.reloadData()
    }
    
    
}
