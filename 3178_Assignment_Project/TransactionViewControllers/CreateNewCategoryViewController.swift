//
//  CreateNewCategoryViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 25/5/2023.
//

import UIKit

/**This controller allows the users to create a  new category **/
class CreateNewCategoryViewController: UIViewController, UITextFieldDelegate{

    // attributes
    weak var databaseController: DatabaseProtocol?
    var caller: ManageBudgetTableViewController?
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    /** view did load */
    override func viewDidLoad() {
        super.viewDidLoad()

        //initialise database
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // setup text fields and its delegate
        valueTextField.delegate = self
        nameTextField.delegate = self
        valueTextField.keyboardType = .numbersAndPunctuation
        
        // allows keyboard to disappear when the user touches on the screen
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    /** allows the key board to return when return is clicked*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /** A function that handles the creation of a new category when the create category button is pressed*/
    @IBAction func CreateCategoryAction(_ sender: Any) {
        
        // validate input so that it is not empty
        if let name = nameTextField.text, let valueText = valueTextField.text
        {
            // validate name (to check if the new name is a duplication of existing category's name), display error when it
            // happens
            if !validateName(name: name)
            {
                displayMessage(controller: self, title: "Error", message: "Category already exists")
            }
            else if (name != "" || valueText != "") && validateName(name: name)
            {
                // check if value is entered correctly
                guard let value = Double(valueText) else
                {
                    // display message if error
                    displayMessage(controller: self, title: "Error", message: "Please enter an appropriate amount!")
                    return
                }
                
                // add to database
                databaseController?.addCategory(name: name, value: Double(value) )
                
                // reload data
                if let caller
                {
                    caller.loadData()
                }
            }
            else
            {
                displayMessage(controller: self, title: "Error", message: "Please make sure all the fields are filled")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    // check if the name duplicates
    func validateName(name: String) -> Bool
    {
        if name == "" || name.count > 10
        {
            return false
        }
        
        // check for duplication in name
        if let allCategories = databaseController?.categories {
            for category in allCategories {
                if category.name == name {
                    return false
                }
            }
        }
        return true
    }
    
    
    

    
    
    
}
