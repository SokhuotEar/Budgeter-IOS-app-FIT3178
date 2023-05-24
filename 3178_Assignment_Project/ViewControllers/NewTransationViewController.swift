//
//  NewTransationViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 28/4/2023.
//

import UIKit

class NewTransationViewController: UIViewController, SelectCategoryProtocol{
    
    func selectCategory(category: Category){
        categoryLabel.text = category.name
        transactionCategory = category
    }
    
    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //amount text field
        amountTextField.keyboardType = .numberPad
        
        
        // date text field and date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        dateTextField.inputView = datePicker
        
        datePicker.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let selectedDate = dateFormatter.string(from: datePicker.date)
            self.dateTextField.text = selectedDate
        }), for: .editingDidEnd)
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    
    }


    func dateInputEnds(datePicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        dateTextField.text = selectedDate
    }
    
    @IBOutlet weak var transactionTypeSegment: UISegmentedControl!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var recurringSegment: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var toFromTextField: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var noteTextField: UITextField!
    var transactionCategory: Category?
    
    var databaseController: DatabaseProtocol?
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        
        //initialise variable
        var amount = amountTextField.text ?? ""
        var toFrom = toFromTextField.text ?? ""
        var note =  noteTextField.text ?? ""
        var category = categoryLabel.text ?? ""
        
        


        
        //handling dates
        var dateText = dateTextField.text

        let dateFormatter = DateFormatter()
        
        var date: Date
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let dateVerify = dateFormatter.date(from: dateText ?? "") {
            // Use the date class instance
            date = dateVerify
        } else {
            // Date conversion failed
            displayMessage(controller: self, title: "Date error", message: "Date error")
            return
        }
        
        // check recurring
        var recurring: Recurring
        switch recurringSegment.selectedSegmentIndex {
        case 0:
            recurring = .none
        case 1:
            recurring = .weekly
        case 2:
            recurring = .yearly
        case 3:
            recurring = .monthly
        default:
            recurring = .none
        }
        
        // check transactionType
        var transactionType: TransactionType
        switch transactionTypeSegment.selectedSegmentIndex{
        case 0:
            transactionType = .income
        case 1:
            transactionType = .expense
        default:
            transactionType = .income
        }
        
        
        //verification
        if amountTextField.text == "" || toFromTextField.text == "" || dateTextField.text == "" || noteTextField.text == "" || categoryLabel.text == ""
        {
            displayMessage(controller: self, title: "Error", message: "Please make sure all the fields are filled")
            return
        }
        
        //add
        let transaction = databaseController?.addTransaction(transactionType: transactionType, amount: Double(amount) ?? 0, toFrom: toFrom, currency: .AUD, date: date, category: transactionCategory!, note: note, recurring: recurring)
        
        guard let transaction else {
            displayMessage(controller: self, title: "Error", message: "Problem processing the transaction")
            return
        }
        
        // set local notification
        if (switchButton.isOn)
        {
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            
            // make it repeat based on recurring:
            switch recurring
            {
            case .monthly:
                components = calendar.dateComponents([.day, .hour, .minute, .second], from: date)
                
            case .weekly:
                let dayOfweek = components.weekdayOrdinal
                components = calendar.dateComponents([.hour, .minute, .second], from: date)
                components.weekday = dayOfweek
                
            case .yearly:
                components = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: date)
            
            case .none:
                components = calendar.dateComponents([.minute, .second], from: date)
                
        }
                        
            sendNotification(transaction: transaction, dateComponents: components, repetition: true)
            
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCategory" {
            let destination = segue.destination as! SelectCategoryTableViewController
            destination.selectCategoryProtocol = self
        }
    }
    
    
    

}

protocol SelectCategoryProtocol: AnyObject
{
    func selectCategory(category: Category)
}






