//
//  NewTransationViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 28/4/2023.
//

import UIKit

/**
 This class is for UIViewController that creating a new transaction
 */
class NewTransationViewController: UIViewController, SelectCategoryProtocol, ConvertCurrency, UITextFieldDelegate{
    

    /**
     The protocol function that updates the amount text field after the user converts their currency
     */
    func convertCurrency(amount: Double) {
        amountTextField.text = String(amount)
    }
    
    
    @IBAction func SelectCurrencyButtonAction(_ sender: Any) {
    }
    
    
    @IBOutlet weak var CurrencyButton: UIButton!
    
    /**
     The protocol function that updates the category text field of a transaction after the user selected their category
     */
    func selectCategory(category: Category){
        categoryLabel.text = category.name
        transactionCategory = category
    }
    
    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //amount text field
        amountTextField.keyboardType = .decimalPad
        
        
        // set the date text field to appear a date picker to aid with user's selection
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
        
        
        // get database
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        
        // set up text field delegates
        toFromTextField.delegate = self
        amountTextField.delegate = self
        dateTextField.delegate = self
        noteTextField.delegate = self
        
        // add gesture so that keybaord disppears upon touch
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func dateInputEnds(datePicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        dateTextField.text = selectedDate
    }
    
    // outltes
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
    
    /**
     Handles the on-click event when the user confirms adding the transaction
     */
    @IBAction func confirmButtonAction(_ sender: Any) {
        
        //initialise variable, set it to "" if nil
        let amount = amountTextField.text ?? ""
        let toFrom = toFromTextField.text ?? ""
        let note =  noteTextField.text ?? ""
        _ = categoryLabel.text ?? ""

        //handling dates
        let dateText = dateTextField.text

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
        
        
        // Empty inputs verification, shows error if true
        if amountTextField.text == "" || toFromTextField.text == "" || dateTextField.text == "" || noteTextField.text == "" || categoryLabel.text == ""
        {
            displayMessage(controller: self, title: "Error", message: "Please make sure all the fields are filled")
            return
        }
        //verification is the user enters too many digits
        if amountTextField.text?.count ?? 0 >= 8 || toFromTextField.text?.count ?? 0 >= 8
        {
            displayMessage(controller: self, title: "Error", message: "Plase make sure amount or to/from inputs are within 8 characters long")
            return
        }
        
        // if transaction date is in the future, then show an error
        if date > Date()
        {
            displayMessage(controller: self, title: "Error", message: "Transaction cannot occur in the future.")
        }
        
        // if amount is inputted inappropriately, show error
        guard let _ = Double(amount) else
        {
            displayMessage(controller: self, title: "Amount Input Error", message: "Please make sure amount is inputted appropriately")
            return
        }
        
        //add transaction
        let transaction = databaseController?.addTransaction(transactionType: transactionType, amount: Double(amount) ?? 0, toFrom: toFrom, currency: .AUD, date: date, category: transactionCategory!, note: note, recurring: recurring)
        
        // in case error happens when trying to insert transaction to database
        guard let transaction else {
            displayMessage(controller: self, title: "Error", message: "Problem processing the transaction")
            return
        }
        
        // set local notification if the switch button is fonw
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
                break
                
        }
            // send notificatioon, display error if notification is disabled
            sendNotification(controller: self, transaction: transaction, dateComponents: components, repetition: true)
            
        }
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    /**
     Prepare for segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // prepare segue to the screen that allows users to select category
        if segue.identifier == "selectCategory" {
            let destination = segue.destination as! SelectCategoryTableViewController
            destination.selectCategoryProtocol = self
        }
        // prepare segue to the screen that allows users to convert currency
        if segue.identifier == "convertCurrencySegue"
        {
            let destination = segue.destination as! ConvertCurrencyViewController
            destination.convertCurrencyDelegate = self
        }
    }

}

/**
 Protocol that helps interaction between this controller to the select category controller
 */
protocol SelectCategoryProtocol: AnyObject
{
    func selectCategory(category: Category)
}

/**
 Protocol that helps interaction between this controller to convert currency controller
 */
protocol ConvertCurrency: AnyObject
{
    func convertCurrency(amount: Double)
}





