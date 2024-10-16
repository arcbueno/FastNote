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

    init(remoteId: String = "", localId: UUID = UUID(), name: String = "", color: String = "") {
        self.remoteId = remoteId
        self.localId = localId
        self.name = name
        self.color = color
    }
    
    init(entity: LabelEntity) {
        remoteId = entity.remoteId ?? ""
        localId = entity.localId ?? UUID()
        name = entity.name ?? ""
        color = entity.color ?? ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, color, userId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        remoteId = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        color = try container.decode(String.self, forKey: .color)
        localId = UUID()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(remoteId, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
        try container.encode(NetworkUtils.userId, forKey: .userId)
    }
}


