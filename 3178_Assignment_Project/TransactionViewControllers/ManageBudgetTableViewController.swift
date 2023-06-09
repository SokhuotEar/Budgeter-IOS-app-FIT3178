//
//  ManageBudgetTableViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 25/5/2023.
//

import UIKit
import SwiftUI

/**
 Manage budget table view controller: it shows all the categories and it set budget (monthly cashflow target budget  which is net for both spending or income)
 */
class ManageBudgetTableViewController: UITableViewController, UITextFieldDelegate{
    // attributes
    var categoryList: [Category] = []
    weak var databaseController: DatabaseProtocol?
    let CELL_ID = "ManageBudgetCell"
    let HEADER_CELL_ID = "ManageBudgetHeaderCell"
    let nameTextField = UITextField()
    let valueTextField = UITextField()
    
    
    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialise database
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    
        // get datafrom database
        if let categories = databaseController?.categories
        {
            categoryList = categories
        }
        
        // set text field delegate
        nameTextField.delegate = self
        valueTextField.delegate = self
        
        // make it so that the keyboard disappears after user taps anyway on screen
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    /**
     This function makes keyboard disppears after return is pressed
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }
    
    /** configute cell */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)

        var content = categoryCell.defaultContentConfiguration()
        let category = categoryList[indexPath.row]

        // set its content (category name and monthly budget)
        content.text = (category.name ?? "Cannot load category name")
        content.secondaryText = "Budget = " + (String(describing: category.value))
        categoryCell.contentConfiguration = content
        

        return categoryCell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    /** makes header cell for the table*/
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: HEADER_CELL_ID)
        _ = headerCell?.defaultContentConfiguration()
       
        return headerCell
    }
    
    /**
     function that supports deletion of a category. Users can only delete a category if it is not a default category.
     */
    override func tableView(_ tableView: UITableView, commit editingStyle:
                            UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // deletion set up.
        if editingStyle == .delete {
            let category = categoryList[indexPath.row]
            
            // if category is "Default" then user cannot delete it
            if category.name == DEFAULT_OTHER || category.name == DEFAULT_LENDING || category.name == DEFAULT_REPAYMENT

            {
                displayMessage(controller: self, title: "Error", message: "Cannot delete default categories")
                return
            }
            
            databaseController?.removeCategory(category: category)
            loadData()
        }

    }

    /** When users select a category cell it will prompts a message, allowing the user to change the value of the monthly budget*/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // create an alert
        let alert = UIAlertController(title: "Update Monthly budget", message: nil, preferredStyle: .alert)

        // add text fields for the alert fort value input
        alert.addTextField { textField in
            textField.placeholder = "Enter value"
        }

        // cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // okay action, which will perform the update of the value for the category
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            if let valueText = alert.textFields?.first?.text {
                // Process the entered value

                guard let value = Double(valueText) else
                {
                    // if value is inputted inappriopriately, an error will display
                    displayMessage(controller: self, title: "Error", message: "Please enter an appropriate amount")
                    tableView.deselectRow(at: indexPath, animated: true)
                    return
                }

                self.databaseController?.changeBudgetValueFor(category: self.categoryList[indexPath.row], newValue: value)

                self.loadData()
            }
        }

        // add action
        alert.addAction(cancelAction)
        alert.addAction(okAction)

        // present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    /** Prepares segue that leads the user to "Create new Category" screen. Set up appropriate delegate for the interactiom
    // between these 2 views */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewCategorySegue" {
            let destination = segue.destination as! CreateNewCategoryViewController
            destination.caller = self
        }
    }
    
    
    // loads data from database
    func loadData()
    {
        if let databaseController
        {
            categoryList = databaseController.categories
        }
        tableView.reloadData()
    }
    
    

}
