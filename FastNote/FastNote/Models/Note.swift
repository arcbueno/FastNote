//
//  Note.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import Foundation

struct Note: Codable {
    var remoteId: String
    var localId: UUID
    var text: String
    var tags: [Label]
    var tagsIds: [String]
    
    init(remoteId: String = "", localId: UUID = UUID(), text: String = "", userId: String = "", tags: [Label] = [], tagsIds: [String] = []) {
        self.remoteId = remoteId
        self.localId = localId
        self.text = text
        self.tags = tags
        self.tagsIds = tagsIds
    }
    
    init(entity: NoteEntity) {
        remoteId = entity.remoteId ?? ""
        localId = entity.localId ?? UUID()
        text = entity.text ?? ""
        tags = TagMapper.stringToTagList(listString: entity.tags ?? "")
        tagsIds = tags.map{ $0.remoteId }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, content, tags, userId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        remoteId = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .content)
        tagsIds = try container.decode([String].self, forKey: .tags)
        tags = Array<Label>()
        localId = UUID()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(remoteId, forKey: .id)
        try container.encode(text, forKey: .content)
        try container.encode(tagsIds, forKey: .tags)
        try container.encode(NetworkUtils.userId, forKey: .userId)
    }
}
