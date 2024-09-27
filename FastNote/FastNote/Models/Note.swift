//
//  Note.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import CoreData

public class Note: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var text: String
    @NSManaged public var userId: String
    @NSManaged public var tags: [Tag]
}
