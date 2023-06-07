//
//  PaidLendingsTableViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 6/6/2023.
//

import UIKit

class PaidLendingsTableViewController: UITableViewController {


    var allPaidLendings = [Lending]()
    var databaseController: DatabaseProtocol?
    let CELL_ID = "allPaidLendingsCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .singleLine

    }
    override func viewWillAppear(_ animated: Bool) {
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
        
        let lendingCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! PaidLendingsTableViewCell
        let lending = allPaidLendings[indexPath.row]
        
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
        lendingCell.paidByLabel.text = String(describing: dateFormatter.string(from: lending.paidBy ?? Date()))
        
        
        return lendingCell
    }
    
    


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
                            UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            databaseController?.removeLending(lending: allPaidLendings[indexPath.row])
            loadData()
        }
    }

    
    func loadData()
    {
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
