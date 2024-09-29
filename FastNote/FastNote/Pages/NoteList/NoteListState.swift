//
//  NoteListState.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

protocol NoteListState {}

class LoadingListState: NoteListState {}

class SuccessListState: NoteListState {
    let noteList: [Note]
    
    init(noteList: [Note]) {
        self.noteList = noteList
    }
}

