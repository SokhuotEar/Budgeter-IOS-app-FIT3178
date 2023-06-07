//
//  CashFlowOverviewViewController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 7/6/2023.
//

import UIKit
import SwiftUI

class CashFlowOverviewViewController: UIViewController {

    var chartController: UIHostingController<BudgetChartUIView>?
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
            let filteredTransactions = transactionList.filter { transaction in
                    let transactionDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: transaction.date!)
                    
                    if let transactionDate = Calendar.current.date(from: transactionDateComponents),
                       let targetDate = Calendar.current.date(from: monthYear) {
                        return Calendar.current.compare(transactionDate, to: targetDate, toGranularity: .month) == .orderedSame
                    }
                return false
            }
            
            
            // append category (x values)
            for category in categoryList {
                data.append(TransactionSummaryGraphStruct(categoryName: category.name ?? "", value: 0, budget: category.value))
            }
            
            
            // append transaction amount (y values)
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
        let controller = UIHostingController(rootView: BudgetChartUIView(data: data, title: "Cashflow in "))
        guard let chartView = controller.view else {
            return
        }
        

        view.addSubview(chartView)
        addChild(controller)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0)

        ])
    
        
        chartController = controller
        
        

    }
    
}
