//
//  PaidLendingsTableViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 6/6/2023.
//

import UIKit


/**
 A table view controller class that displays all the lending that has been marked as paid
 */
class PaidLendingsTableViewController: UITableViewController {


    var allPaidLendings = [Lending]()
    var databaseController: DatabaseProtocol?
    let CELL_ID = "allPaidLendingsCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .singleLine

    }
    override func viewWillAppear(_ animated: Bool) {
        
        // get data from database the reload the table
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        loadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allPaidLendings.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // set up cell for row at
        let lendingCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! PaidLendingsTableViewCell
        let lending = allPaidLendings[indexPath.row]
        
        // set up text for amount label
        lendingCell.amountLabel.text = String(describing: abs(lending.amount))
        
        // set up date for date label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from: lending.dueDate ?? Date())
        
        
        // set up other labels
        lendingCell.dateLabel.text = String(describing: dateFormatter.string(from: lending.date ?? Date()))
        lendingCell.toLabel.text = lending.to
        lendingCell.paidByLabel.text = String(describing: dateFormatter.string(from: lending.paidBy ?? Date()))
        
        
        return lendingCell
    }
    
    


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    /**
        If a lending is paid, it can be deleted. So set the delete functionality for this table view controller.
     */
    override func tableView(_ tableView: UITableView, commit editingStyle:
                            UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete
        {
            databaseController?.removeLending(lending: allPaidLendings[indexPath.row])
            loadData()
        }
    }

    /**
            Descriptions done below
     */
    func loadData()
    {
        // get any updated data from the database
        // then obtain only lendings that has been repaid
        // then display on the table view
        if let databaseController
        {
            allPaidLendings = []
            let allLendingsData = databaseController.allLendings
            
            for lending in allLendingsData {
                if lending.paid == true
                {
                    allPaidLendings.append(lending)
                }
            }
        }
        tableView.reloadData()
    }
    
    
    

}
