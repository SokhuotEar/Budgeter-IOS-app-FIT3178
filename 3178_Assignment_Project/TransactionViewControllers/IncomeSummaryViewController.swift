//
//  IncomeSummaryViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 9/5/2023.
//

import UIKit
import Charts
import SwiftUI

/**
 This screen shows income summary view controller, shows a graph and summary for the particular month */
class IncomeSummaryViewController: UIViewController {
    var chartController: UIHostingController<ChartUIView>?
    var transactionList: [Transaction]?
    var categoryList: [Category]?
    var databaseController: DatabaseProtocol?
    var monthYear: DateComponents = DateComponents()
    
    override func viewDidLoad() {
        // obtain the database
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        transactionList = databaseController?.allTransactions
        categoryList = databaseController?.categories
        

        // preparing data struct for graphing
        var data: [TransactionSummaryGraphStruct] = []
        if let transactionList, let categoryList{
            // constructing data
            
            // filter transaction list, get only the income type, within the particular month
            let filteredTransactions = transactionList.filter { transaction in
                if transaction.transactionType == TransactionType.income.rawValue {
                    let transactionDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: transaction.date!)
                    
                    if let transactionDate = Calendar.current.date(from: transactionDateComponents),
                       let targetDate = Calendar.current.date(from: monthYear) {
                        return Calendar.current.compare(transactionDate, to: targetDate, toGranularity: .month) == .orderedSame
                    }
                }
                return false
            }
            
            // set category for graphing (x value)
            for category in categoryList {
                data.append(TransactionSummaryGraphStruct(categoryName: category.name ?? "", value: 0, budget: category.value))
            }
            
            // set transaction for grahing (y value)
            for transaction in filteredTransactions
            {
                if let categoryName = transaction.category?.name,
                   let index = data.firstIndex(where: { $0.categoryName == categoryName }) {
                    data[index].value += transaction.amount
                }
            }
        }
        


        super.viewDidLoad()
        
        //graphing
        let controller = UIHostingController(rootView: ChartUIView(data: data, title: ""))
        guard let chartView = controller.view else {
            return
        }
        
        // set constraints and other view attributes
        view.addSubview(chartView)
        addChild(controller)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.0),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12.0),
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12.0)
            
            
            
        ])
        
        
        
        chartController = controller
        
    }
    
    
}


