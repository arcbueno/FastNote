//
//  HomeViewModel.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import SwiftUI
import Combine

class HomeViewModel : ObservableObject {
    let noteRepository: NoteRepository = NoteRepository(
        noteAPI: NoteAPI(),
        noteDao: NoteDAO(persistentContainer: PersistenceController.shared.container),
        syncRegistryRepository: SyncRegistryRepository(syncRegistryDao: SyncRegistryDAO(persistentContainer: PersistenceController.shared.container))
    )
    let tagRepository: LabelRepository = LabelRepository( labelDao: LabelDAO(persistentContainer: PersistenceController.shared.container), syncRegistryRepository: SyncRegistryRepository(syncRegistryDao: SyncRegistryDAO(persistentContainer: PersistenceController.shared.container)))
    @Published var state: HomeState = FillingHomeState(tags: [])
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getAllTags()
    }
    
    func save(text: String, tags: [Label]) -> Bool {
        if (text.isEmpty) {
            return false
        }
        let note = Note(text: text, tags: tags)
        noteRepository.saveNewNote(note: note)
        return true
    }
    
    func getAllTags(){
        tagRepository.getLabels()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch todos: \(error)")
                }
            } receiveValue: { [weak self] tags in
                var syncedTags = tags.filter{ tag in
                    return !tag.remoteId.isEmpty
                }
                self?.state = FillingHomeState(tags: syncedTags)
            }.store(in: &cancellables)
        
    }
    
}


