//
//  AllTransactionsTableViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 4/5/2023.
//

import UIKit

class AllTransactionsTableViewController: UITableViewController {

    var databaseController: DatabaseProtocol?
    var transactionList: [Transaction] = []
    var CELL_ID = "transactionCell"
    var HEADER_CELL_ID = "transactionHeaderCell"
    var selectedTransaction: Transaction?
    
    
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
        
        let transactionCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! AllTransactionsTableViewCell
        let transaction = transactionList[indexPath.row]
        
        if let date = transaction.date
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let dateString = dateFormatter.string(from: date)
            transactionCell.dateLabel.text = dateString
        }
        
        if transaction.amount.isLess(than: 0)
        {
            transactionCell.amountLabel.textColor = UIColor.red
        }
        else
        {
            transactionCell.amountLabel.textColor = UIColor.systemGreen
        }
        

        transactionCell.toFromLabel.text = transaction.toFrom
        transactionCell.amountLabel.text = String(describing: transaction.amount)
        return transactionCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerCell = tableView.dequeueReusableCell(withIdentifier: HEADER_CELL_ID) as! AllTransactionsTableViewCell
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
                            UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transaction = transactionList[indexPath.row]
            if TransactionType(rawValue: transaction.transactionType) == .lending
            {
                displayMessage(controller: self, title: "Cannot delete a lending transaction!" , message: "You cannot delete this transaction as it part of a lending. Consider marking the lending as paid instead to reverse the transaction")
                return
            }
            databaseController?.deleteTransaction(transaction: transaction)
        }
        
        
        if let databaseController
        {
            transactionList = databaseController.allTransactions
        }
        
        loadData()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTransaction = transactionList[indexPath.row]
        performSegue(withIdentifier: "showTransactionSummarySegue", sender: self)
        
    }

    
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
    
    func loadData()
    {
        if let databaseController
        {
            transactionList = databaseController.allTransactions
        }
        tableView.reloadData()
    }
    
    
}
