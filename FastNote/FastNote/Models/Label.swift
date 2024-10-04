//
//  Label.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import CoreData
import Foundation

struct Label: Codable, Hashable{
    var localId: UUID
    var remoteId: String
    var name: String
    var color: String
    var userId: String

    init(remoteId: String = "", localId: UUID = UUID(), name: String = "", color: String = "", userId: String = "") {
        self.remoteId = remoteId
        self.localId = localId
        self.name = name
        self.color = color
        self.userId = userId
    }
    
    init(entity: LabelEntity) {
        remoteId = entity.remoteId ?? ""
        localId = entity.localId ?? UUID()
        name = entity.name ?? ""
        color = entity.color ?? ""
        userId = entity.userId ?? ""
    }
}


