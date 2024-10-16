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
    
    var allRegistries: [SyncRegistryEntity] = Array<SyncRegistryEntity>()
    
    init(syncRegistryDao: SyncRegistryDAO, tagDao: LabelDAO, noteDao: NoteDAO, noteAPI: NoteAPI, tagAPI: LabelAPI) {
        self.syncRegistryDao = syncRegistryDao
        self.tagDao = tagDao
        self.noteDao = noteDao
        self.noteAPI = noteAPI
        self.tagAPI = tagAPI
    }
    
    func synchronizeAll()async {
        await getAllRegistries()
        // syncronizeTags
        await synchronizeNotes()
    }
    
    func deleteSyncRegistry(syncRegistry: SyncRegistryEntity) {
        do {
            try syncRegistryDao.delete(syncRegistry: syncRegistry)
        }catch{
            print("Error deleting sync registry: \(error)")
        }
    }
    
    func getAllRegistries() async {
        let result = await syncRegistryDao.getAllSyncRegistries()
        switch result {
        case .success(let syncRegistries):
            self.allRegistries = syncRegistries
        case .failure(let error):
            print("Failed to fetch todos: \(error)")
        }
        print(allRegistries)
    }
    
    func synchronizeNotes() async {
        var notesToCreate: [Note] = Array<Note>()
        let notesToCreateRegistries: [SyncRegistryEntity] = allRegistries.filter { registry in
            return registry.operationType == SyncRegistryUtils.CREATE_OPERATION && registry.entityType == SyncRegistryUtils.NOTE_ENTITY
        }
        let notesRegistriesToDelete: [SyncRegistryEntity] = allRegistries.filter { registry in
            return registry.entityType == SyncRegistryUtils.NOTE_ENTITY && registry.operationType == SyncRegistryUtils.DELETE_OPERATION
        }
        
        notesToCreate = getUnsychronizedNotes()
        
        print(notesToCreate)
        for note in notesToCreate {
            await noteAPI.createNote(note: note) { result in
                switch(result){
                case .success(let message):
                    if(message == "OK"){
                        do{
                            try self.noteDao.delete(note: note)
                            let registryToDelete = notesToCreateRegistries.filter { registry in
                                return registry.entityLocalId == note.localId
                            }.first
                            self.deleteSyncRegistry(syncRegistry: registryToDelete!)
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
        
        for registry in notesRegistriesToDelete {
            await noteAPI.deleteNote(remoteId: registry.entityRemoteId!) { result in
                switch(result){
                case .success(let message):
                    if(message == "OK"){
                        print("Remote delete Note OK")
                        self.deleteSyncRegistry(syncRegistry: registry)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
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
    
    private func getUnsychronizedNotes() -> [Note] {
        var unsynchronizedNotes: [Note] = Array<Note>()
        let result = noteDao.getUnsynchronizedNotes()
        switch result {
        case .success(let notes):
            unsynchronizedNotes = notes
        case .failure(let error):
            print("Failed to fetch todos: \(error)")
        }
        
        return unsynchronizedNotes.filter{ note in
            return allRegistries.contains(where: { registry in
                registry.entityLocalId == note.localId && registry.operationType == SyncRegistryUtils.CREATE_OPERATION
            })
        }
    }
}
