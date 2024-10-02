//
//  LabelEntity+CoreDataProperties.swift
//  FastNote
//
//  Created by pedro.bueno on 01/10/24.
//
//

import Foundation
import CoreData


extension LabelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LabelEntity> {
        return NSFetchRequest<LabelEntity>(entityName: "LabelEntity")
    }

    @NSManaged public var localId: UUID?
    @NSManaged public var remoteId: String?
    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var userId: String?

}

extension LabelEntity : Identifiable {

}
