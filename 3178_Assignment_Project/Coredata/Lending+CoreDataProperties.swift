//
//  Lending+CoreDataProperties.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 4/6/2023.
//
//

import Foundation
import CoreData


extension Lending {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lending> {
        return NSFetchRequest<Lending>(entityName: "Lending")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var note: String?
    @NSManaged public var to: String?
    @NSManaged public var repayments: NSSet?

}

// MARK: Generated accessors for repayments
extension Lending {

    @objc(addRepaymentsObject:)
    @NSManaged public func addToRepayments(_ value: Transaction)

    @objc(removeRepaymentsObject:)
    @NSManaged public func removeFromRepayments(_ value: Transaction)

    @objc(addRepayments:)
    @NSManaged public func addToRepayments(_ values: NSSet)

    @objc(removeRepayments:)
    @NSManaged public func removeFromRepayments(_ values: NSSet)

}

extension Lending : Identifiable {

}
