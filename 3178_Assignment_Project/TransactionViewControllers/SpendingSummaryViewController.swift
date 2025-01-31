//
//  SpendingSummaryViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 11/5/2023.
//

import UIKit
import SwiftUI

/**
 This controller shows expense summary, shows a graph and summary for the particular month  described by "monthYear"*/
class SpendingSummaryViewController: UIViewController {
    
    // attributes
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
            // get transaction of expense type only, and is within the particular month
            let filteredTransactions = transactionList.filter { transaction in
                if transaction.transactionType == TransactionType.expense.rawValue {
                    let transactionDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: transaction.date ?? Date())
                    
                    // if it is within the particular month
                    if let transactionDate = Calendar.current.date(from: transactionDateComponents),
                       let targetDate = Calendar.current.date(from: monthYear) {
                        return Calendar.current.compare(transactionDate, to: targetDate, toGranularity: .month) == .orderedSame
                    }
                }
                return false
            }
            
            // prepare category data (x values) for graphing
            for category in categoryList {
                data.append(TransactionSummaryGraphStruct(categoryName: category.name ?? "", value: 0, budget: category.value))
            }
            
            // append transaction amount (y values) for graphing
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
        
        // configure the view for the graph
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
