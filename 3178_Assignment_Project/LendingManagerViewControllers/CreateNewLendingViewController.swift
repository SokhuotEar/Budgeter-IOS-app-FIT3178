//
//  CreateNewLendingViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 28/5/2023.
//

import UIKit

class CreateNewLendingViewController: UIViewController, ConvertCurrency, UITextFieldDelegate{
    func convertCurrency(amount: Double) {
        amountTextField.text = String(amount)
    }
    
    @IBOutlet weak var sendNotificationSwitch: UISwitch!
    
    var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController

        // Do any additional setup after loading the view.
        //amount text field
        amountTextField.keyboardType = .decimalPad
        
        
        // date text field and date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        dueDateTextField.inputView = datePicker
        
        datePicker.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let selectedDate = dateFormatter.string(from: datePicker.date)
            self.dueDateTextField.text = selectedDate
        }), for: .editingDidEnd)
        
        
        // set text field delegate
        amountTextField.delegate = self
        dueDateTextField.delegate = self
        noteTextField.delegate = self
        toTextField.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    

    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var dueDateTextField: UITextField!
    

    @IBOutlet weak var noteTextField: UITextField!
    
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        if let to = toTextField.text, let amount = amountTextField.text, let dueDate = dueDateTextField.text, let note = noteTextField.text {
            
            if to == "" || amount == "" || dueDate == "" || note == "" {
                displayMessage(controller: self, title: "Error", message: "Please fill all the inputs")
                return
            }
            
            
            guard let  amount_double = Double(amount) else
            {
                displayMessage(controller: self, title: "Error", message: "Please make sure amount is inputted correctly!")
                return
            }
            
            // verify date
            let dateFormatter = DateFormatter()
            var dueDateDate = Date()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            if let dateVerify = dateFormatter.date(from: dueDate) {
                // Use the date class instance
                dueDateDate = dateVerify
            } else {
                // Date conversion failed
                displayMessage(controller: self, title: "Date error", message: "Incorrect date format!")
                return
            }
            
            if dueDateDate < Date()
            {
                displayMessage(controller: self, title: "Due Date Error", message: "Due date must be in the future")
                return
            }
            
            // create a new lending
            let transaction = databaseController?.createNewLending(amount: amount_double, date: Date(), dueDate: dueDateDate, note: note, to: to)
            
            if sendNotificationSwitch.isOn
            {
                if let transaction
                {
                    // set local notification
                    // set up local notification for the due date
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dueDateDate)
                    
                    sendNotification(controller: self, transaction: transaction, dateComponents: components, repetition: false)
                }
            }
            
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "convertCurrencyLendingSegue"
        {
            let destination = segue.destination as! ConvertCurrencyViewController
            destination.convertCurrencyDelegate = self
        }
    }

    



}
