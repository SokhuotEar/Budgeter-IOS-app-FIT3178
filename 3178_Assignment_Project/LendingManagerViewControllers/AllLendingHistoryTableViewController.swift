//
//  AllLendingHistoryTableViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 28/5/2023.
//

import UIKit

class AllLendingHistoryTableViewController: UITableViewController, MarkAsPaidProtocol{
    
    func markAsPaidButtonPressed() {
        print("called")
        loadData()
    }
    
    var allLendings = [Lending]()
    var databaseController: DatabaseProtocol?
    let CELL_ID = "allLendingsHistoryCell"
    var selectedLending: Lending?

    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let databaseController
        {
            allLendings = databaseController.allLendings
        }
        
        tableView.separatorStyle = .singleLine
        super.viewDidLoad()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        let lendingCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! AllLendingHistoryTableViewCell
        let lending = allLendings[indexPath.row]
        
        if indexPath.row.isMultiple(of: 2)
        {
            lendingCell.contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        }
        
        lendingCell.amountLabel.text = String(describing: abs(lending.amount))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from: lending.dueDate ?? Date())
        
        if lending.date! < Date()
        {
            
            lendingCell.dueDateLabel.text = dateString
        }
        else{
            lendingCell.dueDateLabel.text = dateString
            lendingCell.dueDateLabel.textColor = .black
        }
        
        lendingCell.dateLabel.text = String(describing: dateFormatter.string(from: lending.date ?? Date()))
        lendingCell.toLabel.text = lending.to
        lendingCell.markAsPaid = self
        lendingCell.lending = lending
        
        
        return lendingCell
    }
    
    
    


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    
    func loadData()
    {
        if let databaseController
        {
            allLendings = []
            let allLendingsData = databaseController.allLendings
            
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

protocol MarkAsPaidProtocol: AnyObject
{
    func markAsPaidButtonPressed()
}
