//
//  SelectCategoryCollectionViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 4/5/2023.
//

import UIKit

/**
 The table view controller for users to select their categories when creating a new transaction
 */
class SelectCategoryTableViewController: UITableViewController{
    
    weak var selectedCategory: Category?
    
    let CELL_ID = "selectCategoryCell"
    
    weak var databaseController: DatabaseProtocol?
    var categoryList: [Category] = []
    weak var selectCategoryProtocol : SelectCategoryProtocol?
    
    /** View did load */
    override func viewDidLoad() {
        //database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // get data from database controller. IF the category's name is DEFAULT_LENDING or DEFAULT_REPAYMENT,
        // it should not show up in the table view controller. These categories are only for lending type transaction
        if let databaseController
        {
            categoryList = []
            let categoryListData = databaseController.categories
            
            // check if name is DEFAULT_LENDING or DEFAULT_REPAYMENT
            for category in categoryListData
            {
                if category.name != DEFAULT_LENDING && category.name != DEFAULT_REPAYMENT
                {
                    categoryList.append(category)
                }
            }
        }
        
        super.viewDidLoad()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure and return a category cell showing its name
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        var content = categoryCell.defaultContentConfiguration()
        let category = categoryList[indexPath.row]
        content.text = category.name
        categoryCell.contentConfiguration = content
        return categoryCell
    }
    
    /** The function sets up did select row at.
     When user selects the cateory, it will go back to the new transaction page so users can create the transactiuon */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryList[indexPath.row]
        if let selectedCategory
        {
            // call the protocol so that new transaction view controller knows to update its category label
            selectCategoryProtocol?.selectCategory(category: selectedCategory)
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

