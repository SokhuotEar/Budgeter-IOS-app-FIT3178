//
//  Category+CoreDataProperties.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 25/5/2023.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: Double
    @NSManaged public var type: Int32
    @NSManaged public var transaction: NSSet?

}

// MARK: Generated accessors for transaction
extension Category {

    @objc(addTransactionObject:)
    @NSManaged public func addToTransaction(_ value: Transaction)

    @objc(removeTransactionObject:)
    @NSManaged public func removeFromTransaction(_ value: Transaction)

    @objc(addTransaction:)
    @NSManaged public func addToTransaction(_ values: NSSet)

    @objc(removeTransaction:)
    @NSManaged public func removeFromTransaction(_ values: NSSet)

}

extension Category : Identifiable {

}

enum CategoryType: Int32{
    case expense=0
    case income=1
    
    var stringValue: String {
        switch self {
        case .expense:
            return "expense"
        case .income:
            return "income"
        }
    }
}

extension Category{
    var categoryTypeEnum: CategoryType{
        get{
            return CategoryType(rawValue: self.type)!
        }
        set{
            self.type = newValue.rawValue
        }
    }
}

