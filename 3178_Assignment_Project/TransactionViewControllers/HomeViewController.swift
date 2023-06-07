//
//  ViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 28/4/2023.
//

import UIKit

class HomeViewController: UIViewController{
    
    
    var listenerType = ListenerType.all
    var selectedDate: Date?
    @IBOutlet weak var incomeThisMonthLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var budgetLeftToSpendLabel: UILabel!
    @IBOutlet weak var spendingThisMonthLabel: UILabel!
    
    var allTransactions = [Transaction]()
    var allLending = [Lending]()
    var allCategories = [Category]()
    var dateFormatter = DateFormatter()
    
    func updateData()
    {
        reloadDatabase()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        // prapare
        incomeThisMonthLabel.text = "0"
        budgetLeftToSpendLabel.text = "0"
        spendingThisMonthLabel.text = "0"
        
        
        // update monthly income based on the month determined by monthLabel
        for transaction in allTransactions {
            if TransactionType(rawValue: transaction.transactionType) == .income
            {
                let formattedDate = dateFormatter.string(from: transaction.date ?? Date())
                if formattedDate == monthTextField.text ?? ""
                {
                    if let currentText = incomeThisMonthLabel.text,
                       let currentAmount = Double(currentText) {
                        let newAmount = currentAmount + transaction.amount
                        incomeThisMonthLabel.text = String(abs(newAmount))
                    }
                }
            }
            
            // update monthly spending based on the month determined by monthLabel
            else if TransactionType(rawValue: transaction.transactionType) == .expense
            {
                let formattedDate = dateFormatter.string(from: transaction.date ?? Date())
                if formattedDate == monthTextField.text ?? ""
                {
                    if let currentText = spendingThisMonthLabel.text,
                       let currentAmount = Double(currentText) {
                        let newAmount = currentAmount - transaction.amount
                        spendingThisMonthLabel.text = String(abs(newAmount))
                    }
                }
            }
        }
        
        // update monthly cashflow
        if let spendingText = spendingThisMonthLabel.text,
           let incomeText = incomeThisMonthLabel.text,
           let spendingAmount = Double(spendingText),
           let incomeAmount = Double(incomeText) {
            let budgetLeft = incomeAmount - spendingAmount
            budgetLeftToSpendLabel.text = String(budgetLeft)
            

        }
        

        
    }
    
    func reloadDatabase()
    {
        if let databaseController
        {
            allTransactions = databaseController.allTransactions
            allLending = databaseController.allLendings
            allCategories = databaseController.categories
        }
    }
    

    @IBOutlet weak var monthTextField: UITextField!
    

    var databaseController: DatabaseProtocol?
    
    
    override func viewDidLoad() {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let balance = databaseController?.getBalance()
        {
            balanceLabel.text = String(balance)
        }
        
        
        
   
        // date text field and date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        monthTextField.inputView = datePicker
        
        datePicker.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM YYYY"
            let selectedDate = dateFormatter.string(from: datePicker.date)
            self.monthTextField.text = selectedDate
            self.updateData()
        }), for: .editingDidEnd)
        
        super.viewDidLoad()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
        if let balance = databaseController?.getBalance(){
            balanceLabel.text = "AUD " + String(describing: balance)
        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateData()
        super.viewWillDisappear(animated)
    }
    


    
    func displayInfo()
    {
        
    }
}

