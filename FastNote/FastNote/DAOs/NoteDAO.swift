//
//  NoteDAO.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import Foundation
import CoreData
import Combine

class NoteDAO {
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getNotes() -> AnyPublisher<[Note], Error> {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        let context = persistentContainer.viewContext
        
        return Future<[Note], Error> { promise in
            do {
                let noteEntities = try context.fetch(request)
                let notes = noteEntities.map { Note(entity: $0) }
                promise(.success(notes))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(notes: [Note])  {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            do {
                let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
                let existingNoteEntities = try context.fetch(request)
                let existingNoteIds = existingNoteEntities.compactMap { $0.localId }
                
                notes.forEach { note in
                    if !existingNoteIds.contains(note.localId) {
                        let noteEntity = NoteEntity(context: context)
                        noteEntity.localId = note.localId
                        noteEntity.remoteId = note.remoteId
                        noteEntity.text = note.text
                        noteEntity.userId = note.userId
                    }
                }
                try context.save()
            } catch {
                print("Failed to save notes to core data: \(error)")
            }
        }
    }
    
    func delete(note: Note) throws {
        let context = persistentContainer.newBackgroundContext()
        try context.performAndWait {
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            let existingNoteEntities = try context.fetch(request)
            let existingNoteIds = existingNoteEntities.compactMap { $0.localId }
            
            if(existingNoteIds.contains(note.localId)){
                let noteEntity = existingNoteEntities.first { entity in
                    entity.localId == note.localId
                }
                if let noteEntity = noteEntity{
                    context.delete(noteEntity)
                }
                
            }
            
            try context.save()
        }
    }
}
