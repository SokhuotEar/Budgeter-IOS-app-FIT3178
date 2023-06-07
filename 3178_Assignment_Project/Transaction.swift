////
////  Transaction.swift
////  3178_Assignment_Project
////
////  Created by Sokhuot Ear on 3/5/2023.
////
//
//import Foundation
//
//class Transaction{
//
//    var transactionType: TransactionType
//    var amount: Double
//    var toOrFrom: String
//    var date: Date
//    var note: String
//    var recurring: Recurring
//    var category: Category
//
//    init(transactionType: TransactionType, amount: Double, toOrFrom: String, date: Date, note: String, recurring: Recurring, category: Category) {
//
//        self.transactionType = transactionType
//        self.amount = amount
//        self.toOrFrom = toOrFrom
//        self.date = date
//        self.note = note
//        self.recurring = recurring
//        self.category = category
//    }
//
//}
//
//class AllTransactions{
//    var allTransactions: [Transaction] = []
//}
//
//
//class Category{
//    var name: String
//    var budgetValue: Int
//    var type: categoryType
//
//    init(name: String, budgetValue: Int, type: categoryType)
//    {
//        self.name = name
//        self.budgetValue = budgetValue
//        self.type = type
//    }
//
//}
//
//enum categoryType{
//    case expense
//    case income
//
//    var stringValue: String {
//        switch self {
//        case .expense:
//            return "expense"
//        case .income:
//            return "income"
//        }
//    }
//
//}
//

//
//
