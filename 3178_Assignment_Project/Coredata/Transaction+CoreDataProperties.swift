//
//  Transaction+CoreDataProperties.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 25/5/2023.
//
//

import Foundation
import CoreData

/**
 Database for transaction
 */
extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var note: String?
    @NSManaged public var recurring: Int32
    @NSManaged public var toFrom: String?
    @NSManaged public var transactionType: Int32
    @NSManaged public var absoluteAmount: Double
    @NSManaged public var id: String
    @NSManaged public var category: Category?
    @NSManaged public var lending: Lending?

}

extension Transaction : Identifiable {

}

/**
 Set recurring to transaction: True or False
 */
extension Transaction{
    var recurringEnum: Recurring{
        get{
            return Recurring(rawValue: self.recurring)!
        }
        set{
            self.recurring = newValue.rawValue
        }
    }
}

/**
 Set transaction type to transaction: income, expenses or lending
 */
extension Transaction{
    var typeEnum: TransactionType{
        get{
            return TransactionType(rawValue: self.transactionType)!
        }
        set{
            self.transactionType = newValue.rawValue
        }
    }
}

/**
 Set transaction category attribute for transaction
 */
extension Transaction{
    var categoryAttribute: Category?{
        get{
            return self.category
        }
        set{
            self.category = category
        }
    }
}

/**
 Currency enum
 */
enum Currency: Int32 {
    case USD=0
    case EUR=1
    case JPY=2
    case GBP=3
    case AUD=4
    case CAD=5
    case CHF=6
    case CNH=7
    case HKD=8
    case NZD=9

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

/**
 Transaction type enum: income, expense or lending
 */
enum TransactionType: Int32{
    case income = 0
    case expense = 1
    case lending = 2

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

/**
 Recurring enum: weekly, fortnightly or monthly
 */
enum Recurring: Int32{
    case none = 0
    case weekly = 1
    case yearly = 2
    case monthly = 3

    var stringValue: String {
        switch self {
        case .none:
            return "None"
        case .weekly:
            return "Weekly"
        case .yearly:
            return "Fortnightly"
        case .monthly:
            return "Monthly"
        }
    }
}
