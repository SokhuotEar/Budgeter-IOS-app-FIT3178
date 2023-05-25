//
//  ManageBudgetTableViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 25/5/2023.
//

import UIKit

class ManageBudgetTableViewController: UITableViewController {
    // attributes
    var categoryList: [Category] = []
    weak var databaseController: DatabaseProtocol?
    let CELL_ID = "ManageBudgetCell"
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

        return categoryCell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
                            UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let category = categoryList[indexPath.row]
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
            if let value = alert.textFields?.first?.text {
                // Process the entered value
                print("Entered value: \(value)")
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
