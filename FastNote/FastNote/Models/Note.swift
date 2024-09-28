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
    //    var tags: [Tag]
    
    init(remoteId: String = "", localId: UUID = UUID(), text: String = "", userId: String = "") {
        self.remoteId = remoteId
        self.localId = localId
        self.text = text
        self.userId = userId
    }
    
    init(entity: NoteEntity) {
        remoteId = entity.remoteId ?? ""
        localId = entity.localId ?? UUID()
        text = entity.text ?? ""
        userId = entity.userId ?? ""
    }
}

//public class NoteEntity: NSManagedObject {
//    @NSManaged public var remoteId: String
//    @NSManaged public var localId: String
//    @NSManaged public var text: String
//    @NSManaged public var userId: String
//    @NSManaged public var tagsJSON: String
//
//    var tags : [String] {
//        get { decodeArray(from: \.tagsJSON) }
//        set { tagsJSON = encodeArray(newValue) }
//    }
//
//    private func decodeArray(from keyPath: KeyPath<NoteEntity,String>) -> [String] {
//        return (try? JSONDecoder().decode([String].self, from: Data(self[keyPath: keyPath].utf8))) ?? []
//    }
//
//    private func encodeArray(_ array: [String]) -> String {
//        guard let data = try? JSONEncoder().encode(array) else { return "" }
//        return String(data: data, encoding: .utf8)!
//    }
//
//}
