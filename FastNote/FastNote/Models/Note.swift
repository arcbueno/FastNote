//
//  Note.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import Foundation

struct Note: Codable {
    let remoteId: String
    let localId: UUID
    let text: String
    let userId: String
    let tags: [Label]
    
    init(remoteId: String = "", localId: UUID = UUID(), text: String = "", userId: String = "", tags: [Label] = []) {
        self.remoteId = remoteId
        self.localId = localId
        self.text = text
        self.userId = userId
        self.tags = tags
    }
    
    init(entity: NoteEntity) {
        remoteId = entity.remoteId ?? ""
        localId = entity.localId ?? UUID()
        text = entity.text ?? ""
        userId = entity.userId ?? ""
        tags = TagMapper.stringToTagList(listString: entity.tags ?? "")
    }
}
