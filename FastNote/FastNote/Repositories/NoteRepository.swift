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
    var cancellables = Set<AnyCancellable>()
    
    init(noteAPI: NoteAPI, noteDao: NoteDAO) {
        self.noteAPI = noteAPI
        self.noteDao = noteDao
    }
    
    func saveNewNote(note: Note){
        return noteDao.save(notes: [note])
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
}
