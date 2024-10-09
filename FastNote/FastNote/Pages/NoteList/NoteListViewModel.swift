//
//  NoteListViewModel.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import Foundation
import SwiftUI
import Combine

class NoteListViewModel : ObservableObject {
    
    let noteRepository: NoteRepository = NoteRepository(
        noteAPI: NoteAPI(),
        noteDao: NoteDAO(persistentContainer: PersistenceController.shared.container),
        syncRegistryRepository: SyncRegistryRepository(syncRegistryDao: SyncRegistryDAO(persistentContainer: PersistenceController.shared.container))
    )
    
    @Published var state: NoteListState = LoadingListState()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getAll()
    }
    
    func getAll(){
        noteRepository.getNotes()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch todos: \(error)")
                }
            } receiveValue: { [weak self] notes in
                self?.state = SuccessListState(noteList: notes)
            }.store(in: &cancellables)
        
    }
    
    func delete(note: Note) -> Bool{
        var success = false
        noteRepository.delete(note: note)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch todos: \(error)")
                }
            } receiveValue: { [weak self] result in
                self?.getAll()
                success = result
            }.store(in: &cancellables)
        return success
    }
    
}


