//
//  ViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 28/4/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let balance = databaseController?.balance
        {
            balanceLabel.text = String(balance)
        }
   
        super.viewDidLoad()
        
        
        
    }
    
    @IBOutlet weak var incomeThisMonthLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var budgetLeftToSpendLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBAction func forwardMonthButtonAction(_ sender: Any) {
        
        // Get the current month from the label text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        guard let currentMonth = monthLabel.text, let date = dateFormatter.date(from: currentMonth) else {
            return
        }
        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: date)

        // Update the label text with the new month value
        if let nextMonth = nextMonth {
            let nextMonthString = dateFormatter.string(from: nextMonth)
            monthLabel.text = nextMonthString
        }
        
        
        
        //display info
        
        
    }
    

    
    @IBOutlet weak var spendingThisMonthLabel: UILabel!
    @IBAction func backwardsMonthButtonAction(_ sender: Any) {
        // Get the current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        guard let currentMonth = monthLabel.text, let date = dateFormatter.date(from: currentMonth) else {
            return
        }
        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .month, value: -1, to: date)

        // Update the label text with the new month value
        if let nextMonth = nextMonth {
            let nextMonthString = dateFormatter.string(from: nextMonth)
            monthLabel.text = nextMonthString
        }
        
        
        //display info
    }
    
    
    func displayInfo()
    {
        
    }
}

