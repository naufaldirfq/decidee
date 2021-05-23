//
//  Cons+CoreDataProperties.swift
//  Decidee
//
//  Created by Naufaldi Athallah Rifqi on 04/05/21.
//
//

import Foundation
import CoreData


extension Cons {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cons> {
        return NSFetchRequest<Cons>(entityName: "Cons")
    }

    @NSManaged public var importance: Int64
    @NSManaged public var name: String?
    @NSManaged public var decision: Decision?

}

extension Cons : Identifiable {

}
