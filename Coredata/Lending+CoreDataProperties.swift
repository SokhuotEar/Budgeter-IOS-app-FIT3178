//
//  Lending+CoreDataProperties.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 25/5/2023.
//
//

import Foundation
import CoreData


extension Lending {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lending> {
        return NSFetchRequest<Lending>(entityName: "Lending")
    }

    @NSManaged public var dueDate: Date?
    @NSManaged public var amount: Double
    @NSManaged public var to: String?
    @NSManaged public var date: Date?
    @NSManaged public var note: String?
    @NSManaged public var repayments: Transaction?

}

extension Lending : Identifiable {

}
