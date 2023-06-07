//
//  SelectCategoryCollectionViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 4/5/2023.
//

import UIKit

class SelectCategoryTableViewController: UITableViewController{
    weak var selectedCategory: Category?
    
    let CELL_ID = "selectCategoryCell"
    
    weak var databaseController: DatabaseProtocol?
    var categoryList: [Category] = []
    weak var selectCategoryProtocol : SelectCategoryProtocol?
    
    override func viewDidLoad() {
        //database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let databaseController
        {
            categoryList = []
            let categoryListData = databaseController.categories
            
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
        // Configure and return a hero cell
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        var content = categoryCell.defaultContentConfiguration()
        let category = categoryList[indexPath.row]
        content.text = category.name
        categoryCell.contentConfiguration = content
        return categoryCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryList[indexPath.row]
        if let selectedCategory
        {
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

