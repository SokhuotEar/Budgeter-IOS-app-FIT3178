//
//  AllLendingHistoryTableViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 28/5/2023.
//

import UIKit

class AllLendingHistoryTableViewController: UITableViewController {
    
    var allLendings = [Lending]()
    var databaseController: DatabaseProtocol?
    let CELL_ID = "allLendingsHistoryCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .singleLine

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let databaseLending = databaseController?.allLendings
        {
            allLendings = databaseLending
        }

        
        
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
        let dateString = dateFormatter.string(from: lending.date ?? Date())
        
        if lending.date! < Date()
        {
            
            lendingCell.dueDateLabel.text = dateString
        }
        else{
            lendingCell.dueDateLabel.text = dateString
            lendingCell.dueDateLabel.textColor = .black
        }
        
        lendingCell.amountPendingLabel.text = String(describing: getAmountPending(lending: lending))
        lendingCell.toLabel.text = lending.to
        
        return lendingCell
    }
    
    func getAmountPending(lending: Lending) -> Double {
        var pendingAmount = abs(lending.amount)
        
        if let repayments = lending.repayments as? Set<Transaction>
        {
            for repayment in repayments
            {
                pendingAmount = pendingAmount - repayment.amount
            }
        }
        
        return pendingAmount
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 189
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
