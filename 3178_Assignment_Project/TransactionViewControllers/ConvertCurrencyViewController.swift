//
//  ConvertCurrencyViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 26/5/2023.
//

import UIKit

class ConvertCurrencyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CallsConvertCurrencyProtocol{
    
    func displayError(error: Error) {
        displayMessage(controller: self, title: "Error", message: String(describing: error))
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the UIPickerView
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        
        // Set the initial selection
        currencyPickerView.selectRow(0, inComponent: 0, animated: false)
        
        // Add the UIPickerView to the view
        view.addSubview(currencyPickerView)
        
        
        // -------------------------------------
        // Date picker
        // date text field and date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        dateTextField.inputView = datePicker
        
        datePicker.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let selectedDate = dateFormatter.string(from: datePicker.date)
            self.dateTextField.text = selectedDate
        }), for: .editingDidEnd)
        
        // set keypad for amountTextField
        amountTextField.keyboardType = .decimalPad
        amountTextField.delegate = self
        
        // make the keyboard disappear when touched on the screen
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    

    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    weak var convertCurrencyDelegate: ConvertCurrency?
    
    @IBOutlet weak var dateTextField: UITextField!
    let currencies = ["USD", "EUR", "GBP", "JPY", "CAD", "CHF", "CNY", "SEK", "NZD"]
    var selectedCurrency: String = ""
    
    
    
    @IBAction func convertButtonAction(_ sender: Any) {
        var convertedAmount: Double?
        
        if let amountText = amountTextField.text, let dateText = dateTextField.text
        {
            if dateText == ""
            {
                displayMessage(controller: self, title: "Error", message: "Please make sure date input is not empty")
            }
            if let amount = Double(amountText)
            {
                convertedAmount = convert_from_date(controller: self, amount: amount, from: "AUD", to: selectedCurrency, date: dateText)
                
                if let convertedAmount
                {
                    convertCurrencyDelegate?.convertCurrency(amount: convertedAmount)
                }
                else
                {
                    return
                }

                
                navigationController?.popViewController(animated: true)
            }
            else
            {
                displayMessage(controller: self, title: "Error", message: "Please make sure amount is inputted corretly")
            }
            
        }
        
    }
    
    
    
    // picker view ------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // We only need one column
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencies[row]
    }
    
    
}

protocol CallsConvertCurrencyProtocol
{
    func displayError(error: Error)
}
