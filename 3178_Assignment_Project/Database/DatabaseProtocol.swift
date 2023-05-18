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
    case team
    case heroes
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
    func deleteTransaction(transaction: Transaction, index: Int)
    
    // team
    var allTransactions: [Transaction] {get set}
    var categories: [Category] {get set}
    var balance: Double {get}
}
