//
//  OverviewViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 11/5/2023.
//

import UIKit

class OverviewViewController: UIViewController {

    weak var databaseController: DatabaseProtocol?
    var dateFormatter = DateFormatter()
    var allTransactions = [Transaction]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController

        
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
        
    }
    
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var balanceLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        if let balance = databaseController?.getBalance()
        {
            balanceLabel.text = String(describing: balance)
        }
    }
    @IBOutlet weak var cashFlowThisMonthLabel: UILabel!
    
    
    @IBOutlet weak var spendingThisMonthLabel: UILabel!
    @IBOutlet weak var incomeThisMonthLabel: UILabel!
    func updateData()
    {
        reloadDatabase()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        // prapare
        incomeThisMonthLabel.text = "0"
        cashFlowThisMonthLabel.text = "0"
        spendingThisMonthLabel.text = "0"
        
        
        // update monthly income label text based on the month determined by monthLabel
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
            
            // update monthly spending label text based on the month determined by monthLabel
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
            cashFlowThisMonthLabel.text = String(budgetLeft)
            

        }
        
    }
    
    // reload the datebase in case any changes happens)
    func reloadDatabase()
    {
        if let databaseController
        {
            allTransactions = databaseController.allTransactions
        }
    }
    
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // date conversion in preparation for sending to the segue destination.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"

        // convert monthYear string to date conponent type
        var components: DateComponents = DateComponents()
        if let date = dateFormatter.date(from: monthTextField.text ?? "") {
            let calendar = Calendar.current
            components = calendar.dateComponents([.month, .year], from: date)
        }
        
        // it sends the monthYear as it determines in which month to graph the data
        if segue.identifier == "incomeOverviewSegue"
        {
            let destination = segue.destination as! IncomeSummaryViewController
            destination.monthYear = components
        }
        else if segue.identifier == "spendingOverviewSegue"
        {
            let destination = segue.destination as! SpendingSummaryViewController
            destination.monthYear = components
        }
        else if segue.identifier == "cashFlowOverviewSegue"
        {
            let destination = segue.destination as! CashFlowOverviewViewController
            destination.monthYear = components
        }
    }
    

}
