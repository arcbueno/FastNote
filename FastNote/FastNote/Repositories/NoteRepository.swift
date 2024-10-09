//
//  NoteRepository.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import CoreData
import Foundation
import Combine

class NoteRepository {
    let noteAPI: NoteAPI
    let noteDao: NoteDAO
    let syncRegistryRepository: SyncRegistryRepository
    var cancellables = Set<AnyCancellable>()
    
    init(noteAPI: NoteAPI, noteDao: NoteDAO, syncRegistryRepository: SyncRegistryRepository) {
        self.noteAPI = noteAPI
        self.noteDao = noteDao
        self.syncRegistryRepository = syncRegistryRepository
    }
    
    func saveNewNote(note: Note){
        noteDao.save(notes: [note])
        
        syncRegistryRepository.add(entityLocalId: note.localId, entityType: SyncRegistryUtils.NOTE_ENTITY, operationType: SyncRegistryUtils.CREATE_OPERATION, entityRemoteId: note.remoteId)
    }
    
    func getNotes() -> AnyPublisher<[Note], Error> {
        return noteDao.getNotes().eraseToAnyPublisher()
//        noteAPI.getNotes()
//            .map { [weak self] notes in
//                // Adicionar criação de uuid
//                self?.noteDao.save(notes: notes)
//                return todos
//            }
//            .catch { error -> AnyPublisher<[Todo], Error> in
//                print("Failed to fetch todos from service: \(error)")
//                return self.todoOfflineService.getTodos()
//            }.eraseToAnyPublisher()
    }
    
    func delete(note: Note) -> AnyPublisher<Bool, Error>{
        // TODO: Implementar remover pela API
       
        
        return Future<Bool, Error> { promise in
            do {
                try self.noteDao.delete(note: note)
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
        
    }
}
