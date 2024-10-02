//
//  NoteEntity+CoreDataProperties.swift
//  FastNote
//
//  Created by pedro.bueno on 01/10/24.
//
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var localId: UUID?
    @NSManaged public var remoteId: String?
    @NSManaged public var tags: String?
    @NSManaged public var text: String?
    @NSManaged public var userId: String?

}

extension NoteEntity : Identifiable {

}
