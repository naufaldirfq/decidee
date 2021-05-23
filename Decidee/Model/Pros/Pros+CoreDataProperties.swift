//
//  Pros+CoreDataProperties.swift
//  Decidee
//
//  Created by Naufaldi Athallah Rifqi on 04/05/21.
//
//

import Foundation
import CoreData


extension Pros {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pros> {
        return NSFetchRequest<Pros>(entityName: "Pros")
    }

    @NSManaged public var importance: Int64
    @NSManaged public var name: String?
    @NSManaged public var decision: Decision?

}

extension Pros : Identifiable {

}
