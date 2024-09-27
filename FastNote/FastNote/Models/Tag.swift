//
//  Tag.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import CoreData

public class Tag: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var color: String
    @NSManaged public var userId: String
    
}
