////
////  ManageBudgetTableViewController.swift
////  3178_Assignment_Project
////
////  Created by Sokhuot Ear on 9/5/2023.
////
//
//import UIKit
//
//class ManageBudgetTableViewController: UITableViewController {
//
//    var databaseController: DatabaseProtocol?
//    var categoryList: [Category] = []
//    let SECTION_INCOME = 0
//    let SECTION_EXPENSE = 1
//    let CELL_ID = "manageBudgetCell"
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        databaseController = appDelegate?.databaseController
//
//        if let databaseController
//        {
//            categoryList = databaseController.categories
//        }
//
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var expenseCount = 0
//        var incomeCount = 0
//
//        for category in categoryList
//        {
//            if category.type == .income
//            {
//                expenseCount += 1
//            }
//            else
//            {
//                incomeCount += 1
//            }
//        }
//
//        if section == SECTION_INCOME
//        {
//            return expenseCount
//        }
//        else
//        {
//            return incomeCount
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.section == SECTION_INCOME {
//            let incomeCell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
//            let category = categoryList[indexPath.row]
//            content.text = hero.name
//            content.secondaryText = hero.abilities
//            heroCell.contentConfiguration = content
//            return heroCell
//        }
//        else
//        {
//            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath) as! HeroCountTableViewCell
//            infoCell.totalLabel?.text = "\(filteredHeroes.count) heroes in the database"
//            return infoCell
//        }
//    }
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
