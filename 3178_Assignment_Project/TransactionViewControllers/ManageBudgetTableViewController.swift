//
//  ManageBudgetTableViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 25/5/2023.
//

import UIKit
import SwiftUI

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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)

        var content = categoryCell.defaultContentConfiguration()
        let category = categoryList[indexPath.row]

        content.text = (category.name ?? "Cannot load category name")
        content.secondaryText = "Budget = " + (String(describing: category.value))
        categoryCell.contentConfiguration = content
        
        if indexPath.row.isMultiple(of: 2)
        {
            categoryCell.contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        }

        return categoryCell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerCell = tableView.dequeueReusableCell(withIdentifier: HEADER_CELL_ID)
        _ = headerCell?.defaultContentConfiguration()
       
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
                            UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let category = categoryList[indexPath.row]
            
            if category.name == DEFAULT_OTHER || category.name == DEFAULT_LENDING || category.name == DEFAULT_REPAYMENT

            {
                displayMessage(controller: self, title: "Error", message: "Cannot delete default categories")
                return
            }
            
            databaseController?.removeCategory(category: category)
            loadData()
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Update Monthly budget", message: nil, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Enter value"
        }


        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            if let valueText = alert.textFields?.first?.text {
                // Process the entered value

                guard let value = Double(valueText) else
                {
                    displayMessage(controller: self, title: "Error", message: "Please enter an appropriate amount")
                    tableView.deselectRow(at: indexPath, animated: true)
                    return
                }

                self.databaseController?.changeBudgetValueFor(category: self.categoryList[indexPath.row], newValue: value)

                self.loadData()
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewCategorySegue" {
            let destination = segue.destination as! CreateNewCategoryViewController
            destination.caller = self
        }
    }
    
    
    
    func loadData()
    {
        if let databaseController
        {
            categoryList = databaseController.categories
        }
        tableView.reloadData()
    }
    
    

}
