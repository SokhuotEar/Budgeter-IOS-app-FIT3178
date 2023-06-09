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
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let databaseController
        {
            allLending = databaseController.allLendings
        }
        
        // configure total lending label and total pending label
        totalLendingLabel.text = String(describing: getTotalLending())
        totalPendingLabel.text = String(describing: getTotalPending())
    }
    @IBOutlet weak var totalPendingLabel: UILabel!
    @IBOutlet weak var totalLendingLabel: UILabel!
    
    
    var allLending =  [Lending]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let databaseController
        {
            allLending = databaseController.allLendings
        }
        
        // configure total ledning label and total pending label
        
        totalLendingLabel.text = String(describing: getTotalLending())
        totalPendingLabel.text = String(describing: getTotalPending())
    
    }
    
    func getTotalPending() -> Double
    {
        var amount: Double = 0
        if let databaseController
        {
            let allLendingsData = databaseController.allLendings
            
            for lending in allLendingsData {
                if lending.paid == false
                {
                    amount += abs(lending.amount)
                }
            }
        }
        return amount
    }
    
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
