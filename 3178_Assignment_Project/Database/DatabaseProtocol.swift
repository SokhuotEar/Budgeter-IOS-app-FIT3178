//
//  DatabaseProtocol.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 4/5/2023.
//

import Foundation


import Foundation


enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onTransactionChange(change: DatabaseChange, transactions: [Transaction])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addTransaction(transactionType: TransactionType, amount: Double, toFrom: String, currency: Currency, date: Date, category: Category, note: String, recurring: Recurring) -> Transaction
    func deleteTransaction(transaction: Transaction)
    
    // team
    var allTransactions: [Transaction] {get set}
    var categories: [Category] {get set}
    var allLendings: [Lending] {get set}
    var balance: Double {get}
    func getBalance() -> Double
    func removeCategory(category: Category)
    
    func addCategory(name: String, value: Double)
    func createNewLending(amount: Double, date: Date, dueDate: Date, note: String, to: String)
}
