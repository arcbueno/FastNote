//
//  HomeViewModel.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import SwiftUI

class HomeViewModel : ObservableObject {
    let noteRepository: NoteRepository = NoteRepository(
        noteAPI: NoteAPI(),
        noteDao: NoteDAO(persistentContainer: PersistenceController.shared.container)
    )
    @Published var state: HomeState = FillingHomeState()
    
    func save(text: String) -> Bool {
        if (text.isEmpty) {
            return false
        }
        let note = Note(text: text)
        noteRepository.saveNewNote(note: note)
        return true
    }
    
}


