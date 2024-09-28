//
//  Tag.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import CoreData

struct Tag {
    var localId: String
    var remoteId: String
    var name: String
    var color: String
    var userId: String
    
//    func CDTag toCoreData(){
//        var cdTag = CDTag()
//    }
}

public class CDTag: NSManagedObject {
    @NSManaged public var localId: String
    @NSManaged public var remoteId: String
    @NSManaged public var name: String
    @NSManaged public var color: String
    @NSManaged public var userId: String
}
