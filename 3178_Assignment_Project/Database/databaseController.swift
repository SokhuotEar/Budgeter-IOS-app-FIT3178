//
//  databaseController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 3/5/2023.
//

import Foundation

class DatabaseController: DatabaseProtocol
{

    var balance: Double = 0
    
    var allTransactions: [Transaction] = []
    
    
    var categories: [Category] = [Category(name: "Food", budgetValue: 10, type: .expense), Category(name: "Full time work", budgetValue: 10, type: .income)]
    
    
    func addTransaction(transactionType: TransactionType, amount: Double, toFrom: String, currency: Currency, date: Date, category: Category, note: String, recurring: Recurring) -> Transaction {
        
        let transaction = Transaction(transactionType: transactionType, amount: amount, toOrFrom: toFrom, date: date, note: note, recurring: recurring, category: category)
        allTransactions.append(transaction)
        print(allTransactions[0].amount)
        return transaction
    }
    
    func deleteTransaction(transaction: Transaction, index: Int) {
            allTransactions.remove(at: index)
    }
    
    func cleanup() {
        //none
    }
    
    func addListener(listener: DatabaseListener) {
        //none
    }
    
    func removeListener(listener: DatabaseListener) {
        //none
    }
    
}


