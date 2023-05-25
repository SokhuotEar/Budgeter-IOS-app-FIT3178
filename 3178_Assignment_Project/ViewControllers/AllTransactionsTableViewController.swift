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
        transactionCell.categoryLabel.text = transaction.category?.name
        transactionCell.toFromLabel.text = transaction.toFrom
        transactionCell.amountLabel.text = String(transaction.amount)
        return transactionCell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
                            UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transaction = transactionList[indexPath.row]
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
