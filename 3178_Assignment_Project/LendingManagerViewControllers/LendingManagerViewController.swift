//
//  LendingManagerViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 28/5/2023.
//

import UIKit

class LendingManagerViewController: UIViewController {
    var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        
        // obtain data from the database
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let databaseController
        {
            allLending = databaseController.allLendings
        }
        
        // update text values for total lending label and total pending label
        totalLendingLabel.text = String(describing: getTotalLending())
        totalPendingLabel.text = String(describing: getTotalPending())
    }
    
    // the outlets for totalPendingLabel and totalLendingLabel
    @IBOutlet weak var totalPendingLabel: UILabel!
    @IBOutlet weak var totalLendingLabel: UILabel!
    
    // the array for all the lendings
    var allLending =  [Lending]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        // update the all lending array from the database
        if let databaseController
        {
            allLending = databaseController.allLendings
        }
        
        // update text values for total lending label and total pending label, to reflect any changes
        
        totalLendingLabel.text = String(describing: getTotalLending())
        totalPendingLabel.text = String(describing: getTotalPending())
    
    }
    
    // get the total amount pending (not repaid) from all the lendings
    func getTotalPending() -> Double
    {
        var amount: Double = 0
        
        // first get values from the databse
        if let databaseController
        {
            let allLendingsData = databaseController.allLendings
            
            // loop though all the lendings in lending array, and update "amount" accordingly
            for lending in allLendingsData {
                if lending.paid == false
                {
                    amount += abs(lending.amount)
                }
            }
        }
        return amount
    }
    
    // get the total amount of lending (both not repaid or fully repaied (if the user havent deleted it yet))
    func getTotalLending() -> Double
    {
        var amount: Double = 0
        if let databaseController
        {
            let allLendingsData = databaseController.allLendings
            
            for lending in allLendingsData {
                amount += abs(lending.amount)
            }
        }
        return amount
    }
    


}
