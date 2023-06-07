//
//  CreateNewCategoryViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 25/5/2023.
//

import UIKit

class CreateNewCategoryViewController: UIViewController {

    weak var databaseController: DatabaseProtocol?
    var caller: ManageBudgetTableViewController?
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //initialise database
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        
    }
    
    @IBAction func CreateCategoryAction(_ sender: Any) {
        if let name = nameTextField.text, let valueText = valueTextField.text
        {
            if !validateName(name: name)
            {
                displayMessage(controller: self, title: "Error", message: "Category already exists")
            }
            else if (name != "" || valueText != "") && validateName(name: name)
            {
                guard let value = Double(valueText) else
                {
                    displayMessage(controller: self, title: "Error", message: "Please enter an appropriate amount!")
                    return
                }
                
                if value.isLess(than: 0)
                {
                    displayMessage(controller: self, title: "Error", message: "Value must not be positive")
                }
                databaseController?.addCategory(name: name, value: Double(value) )
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
