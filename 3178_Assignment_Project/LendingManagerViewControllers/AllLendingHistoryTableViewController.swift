//
//  AllLendingHistoryTableViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 28/5/2023.
//

import UIKit

/**
 Class representing table view controller. This controller shows all pending lending (not repaid)
 */
class AllLendingHistoryTableViewController: UITableViewController, MarkAsPaidProtocol{
    
    // handles when the user marks a certain lending as fully repaid
    func markAsPaidButtonPressed() {
        print("called")
        loadData()
    }
    
    // define variable
    var allLendings = [Lending]()
    var databaseController: DatabaseProtocol?
    let CELL_ID = "allLendingsHistoryCell"
    var selectedLending: Lending?       // if the user selected any lending cell

    override func viewDidLoad() {
        
        // get lending from database
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let databaseController
        {
            allLendings = databaseController.allLendings
        }
        
        // set seperator style
        tableView.separatorStyle = .singleLine
        super.viewDidLoad()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // update the allLending array to reflect any change
        if let databaseController
        {
            allLendings = databaseController.allLendings
        }
        loadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allLendings.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeue resuable cell to display all the lending history
        let lendingCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! AllLendingHistoryTableViewCell
        let lending = allLendings[indexPath.row]
        
        // set text for the amount label in the cell
        lendingCell.amountLabel.text = String(describing: abs(lending.amount))
        
        // set text for the lending date label in the cell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from: lending.dueDate ?? Date())
        
        // set text for the due date label in the cell; if lending is overdue, it should appear red
        if lending.date! < Date()
        {
            
            lendingCell.dueDateLabel.text = dateString
        }
        else{
            lendingCell.dueDateLabel.text = dateString
            lendingCell.dueDateLabel.textColor = .black
        }
        
        // set text for cell label
        lendingCell.dateLabel.text = String(describing: dateFormatter.string(from: lending.date ?? Date()))
        lendingCell.toLabel.text = lending.to
        lendingCell.markAsPaid = self
        lendingCell.lending = lending
        
        
        return lendingCell
    }
    
    
    


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    // get data from database and reload the table
    func loadData()
    {
        if let databaseController
        {
            allLendings = []
            let allLendingsData = databaseController.allLendings
            
            // loop through all the lendings and obtain only those that are unpaid
            for lending in allLendingsData {
                if lending.paid == false
                {
                    allLendings.append(lending)
                }
            }
        }
        tableView.reloadData()
    }
    
    
    
}
/**
 A protocol whose function gets called when the user clicks on mark as paid button
 */
protocol MarkAsPaidProtocol: AnyObject
{
    func markAsPaidButtonPressed()
}
