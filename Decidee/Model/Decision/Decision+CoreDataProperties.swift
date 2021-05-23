//
//  Decision+CoreDataProperties.swift
//  Decidee
//
//  Created by Naufaldi Athallah Rifqi on 04/05/21.
//
//

import Foundation
import CoreData


extension Decision {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Decision> {
        return NSFetchRequest<Decision>(entityName: "Decision")
    }

    @NSManaged public var consPercentage: Int64
    @NSManaged public var name: String?
    @NSManaged public var prosPercentage: Int64
    @NSManaged public var cons: NSSet?
    @NSManaged public var pros: NSSet?

}

// MARK: Generated accessors for cons
extension Decision {

    @objc(addConsObject:)
    @NSManaged public func addToCons(_ value: Cons)

    @objc(removeConsObject:)
    @NSManaged public func removeFromCons(_ value: Cons)

    @objc(addCons:)
    @NSManaged public func addToCons(_ values: NSSet)

    @objc(removeCons:)
    @NSManaged public func removeFromCons(_ values: NSSet)

}

// MARK: Generated accessors for pros
extension Decision {

    @objc(addProsObject:)
    @NSManaged public func addToPros(_ value: Pros)

    @objc(removeProsObject:)
    @NSManaged public func removeFromPros(_ value: Pros)

    @objc(addPros:)
    @NSManaged public func addToPros(_ values: NSSet)

    @objc(removePros:)
    @NSManaged public func removeFromPros(_ values: NSSet)

}

extension Decision : Identifiable {

}
