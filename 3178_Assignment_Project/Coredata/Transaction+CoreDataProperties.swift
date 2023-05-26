//
//  Transaction+CoreDataProperties.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 25/5/2023.
//
//

import Foundation
import CoreData


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
