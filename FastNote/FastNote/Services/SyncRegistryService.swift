//
//  SyncRegistryService.swift
//  FastNote
//
//  Created by pedro.bueno on 09/10/24.
//

import Combine
import SwiftUI
import Foundation

class SyncRegistryService{
    let syncRegistryDao: SyncRegistryDAO
    let tagDao: LabelDAO
    let noteDao: NoteDAO
    let noteAPI: NoteAPI
    let tagAPI: LabelAPI
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var allRegistries: [SyncRegistryEntity] = Array<SyncRegistryEntity>()
    
    init(syncRegistryDao: SyncRegistryDAO, tagDao: LabelDAO, noteDao: NoteDAO, noteAPI: NoteAPI, tagAPI: LabelAPI) {
        self.syncRegistryDao = syncRegistryDao
        self.tagDao = tagDao
        self.noteDao = noteDao
        self.noteAPI = noteAPI
        self.tagAPI = tagAPI
    }
    
    func synchronizeAll()async {
        getAllRegistries()
        await synchronizeNotes()
    }
    
    func getAllRegistries(){
        syncRegistryDao.getAllSyncRegistries()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch todos: \(error)")
                }
            } receiveValue: { registries in
                self.allRegistries = registries
            }.store(in: &cancellables)
        print(allRegistries)
    }
    
    func synchronizeNotes() async {
        var notesToCreate: [Note] = Array<Note>()
        var notesToDelete: [Note] = Array<Note>()
        
        getUnsychronizedNotes(notesToCreate: &notesToCreate, notesToDelete: &notesToDelete)
        
        print(notesToCreate)
        for note in notesToCreate {
             await noteAPI.createNote(note: note) { result in
                 switch(result){
                 case .success(let message):
                     if(message == "OK"){
                         do{
                             try self.noteDao.delete(note: note)
                         }
                         catch{
                             print("Error deleting note after sync \(error.localizedDescription)")
                         }
                     }
                     
                 case .failure(let error):
                     print(error)
                 }
            }
            
        }
        
        // TODO: Create notes to delete
        
        noteDao.clear()
        await downloadAllNotes()
    }
    
    
    
    private func downloadAllNotes() async{
        let result = await noteAPI.getNotes()
        switch(result){
        case .success(let notes):
            self.noteDao.save(notes: notes)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func getUnsychronizedNotes(notesToCreate: inout [Note], notesToDelete: inout [Note]){
        var unsynchronizedNotes: [Note] = Array<Note>()
        noteDao.getUnsynchronizedNotes()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch todos: \(error)")
                }
            } receiveValue: { notes in
                unsynchronizedNotes = notes
            }.store(in: &cancellables)
        
        notesToCreate = unsynchronizedNotes.filter{ note in
            return allRegistries.contains(where: { registry in
                registry.entityLocalId == note.localId && registry.operationType == SyncRegistryUtils.CREATE_OPERATION
            })
        }
    }
}
