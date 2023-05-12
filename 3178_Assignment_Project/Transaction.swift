//
//  Transaction.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 3/5/2023.
//

import Foundation

class Transaction{
    
    var transactionType: TransactionType
    var amount: Double
    var toOrFrom: String
    var date: Date
    var note: String
    var recurring: Recurring
    var category: Category
    
    init(transactionType: TransactionType, amount: Double, toOrFrom: String, date: Date, note: String, recurring: Recurring, category: Category) {
        
        self.transactionType = transactionType
        self.amount = amount
        self.toOrFrom = toOrFrom
        self.date = date
        self.note = note
        self.recurring = recurring
        self.category = category
    }

}

class AllTransactions{
    var allTransactions: [Transaction] = []
}


class Category{
    var name: String
    var budgetValue: Int
    var type: categoryType
    
    init(name: String, budgetValue: Int, type: categoryType)
    {
        self.name = name
        self.budgetValue = budgetValue
        self.type = type
    }
    
}

enum categoryType{
    case expense
    case income
    
    var stringValue: String {
        switch self {
        case .expense:
            return "expense"
        case .income:
            return "income"
        }
    }

}

enum Currency {
    case USD
    case EUR
    case JPY
    case GBP
    case AUD
    case CAD
    case CHF
    case CNH
    case HKD
    case NZD

    var stringValue: String {
        switch self {
        case .USD:
            return "USD"
        case .EUR:
            return "EUR"
        case .JPY:
            return "JPY"
        case .GBP:
            return "GBP"
        case .AUD:
            return "AUD"
        case .CAD:
            return "CAD"
        case .CHF:
            return "CHF"
        case .CNH:
            return "CNH"
        case .HKD:
            return "HKD"
        case .NZD:
            return "NZD"
        }
    }
}

enum TransactionType{
    case income
    case expense
    case lending
    
    var stringValue: String {
        switch self {
        case .income:
            return "Income"
        case .expense:
            return "Expense"
        case .lending:
            return "Lending"
            
        }
    }
}

enum Recurring{
    case none
    case weekly
    case fortnitely
    case monthly
    
    var stringValue: String {
        switch self {
        case .none:
            return "None"
        case .weekly:
            return "Weekly"
        case .fortnitely:
            return "Fortnightly"
        case .monthly:
            return "Monthly"
            
        }
    }
}


