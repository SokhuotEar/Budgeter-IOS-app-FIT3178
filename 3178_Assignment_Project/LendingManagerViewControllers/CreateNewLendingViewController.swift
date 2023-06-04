//
//  CreateNewLendingViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 28/5/2023.
//

import UIKit

class CreateNewLendingViewController: UIViewController {

    var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //amount text field
        amountTextField.keyboardType = .numberPad
        
        
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
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
            
            guard let  _ = Double(amount) else
            {
                displayMessage(controller: self, title: "Error", message: "Please make sure amount is inputted correctly!")
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
            
            // create a new lending
            databaseController?.createNewLending(amount: amount_double, date: Date(), dueDate: dueDateDate, note: note, to: to)
            
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    



}
