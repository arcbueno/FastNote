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
    var cancellables = Set<AnyCancellable>()
    
    init(syncRegistryDao: SyncRegistryDAO, tagDao: LabelDAO, noteDao: NoteDAO, noteAPI: NoteAPI, tagAPI: LabelAPI) {
        self.syncRegistryDao = syncRegistryDao
        self.tagDao = tagDao
        self.noteDao = noteDao
        self.noteAPI = noteAPI
        self.tagAPI = tagAPI
    }
    
    func synchronizeAll()async {
        await getAllRegistries()
        await synchronizeTags()
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
    
    func synchronizeTags() async {
        var tagsToCreate: [Label] = Array<Label>()
        let tagsToCreateRegistries: [SyncRegistryEntity] = allRegistries.filter { registry in
            return registry.operationType == SyncRegistryUtils.CREATE_OPERATION && registry.entityType == SyncRegistryUtils.TAG_ENTITY
        }
        
        tagsToCreate = getUnsychronizedTags()
        
        print(tagsToCreate)
        for tag in tagsToCreate {
            await tagAPI.createLabel(label: tag) { result in
                switch(result){
                case .success(let message):
                    if(message == "OK"){
                        do{
                            try self.tagDao.delete(tag: tag)
                            let registryToDelete = tagsToCreateRegistries.filter { registry in
                                return registry.entityLocalId == tag.localId
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
        
        tagDao.clear()
        await downloadAllTags()
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
    
    private func downloadAllTags() async{
        let result = await tagAPI.getLabels()
        switch(result){
        case .success(let tags):
            self.tagDao.save(labels: tags)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func downloadAllNotes() async{
        let result = await noteAPI.getNotes()
        switch(result){
        case .success(let notes):
            let notesFilled = fillNotesWithTags(notes: notes)
            self.noteDao.save(notes: notesFilled)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func fillNotesWithTags(notes:[Note]) -> [Note] {
        var newNotes = Array<Note>()
        let allTags = getAllLabels()
        
        for note in notes {
            var currentNote = note
            
            if(!note.tagsIds.isEmpty){
                let tags = allTags.filter{ note.tagsIds.contains($0.remoteId)}
                currentNote.tags = tags
            }
            
            newNotes.append(currentNote)
        }
        
        return newNotes
    }
    
    private func getAllLabels() -> [Label]{
        var labels = Array<Label>()
        tagDao.getLabels()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch todos: \(error)")
                }
            } receiveValue: { tags in
                labels = tags
            }.store(in: &cancellables)
        return labels
    }
    
    private func getUnsychronizedTags() -> [Label] {
        var unsynchronizedTags: [Label] = Array<Label>()
        let result = tagDao.getUnsynchronizedLabels()
        switch result {
        case .success(let tags):
            unsynchronizedTags = tags
        case .failure(let error):
            print("Failed to fetch todos: \(error)")
        }
        
        return unsynchronizedTags.filter{ tag in
            return allRegistries.contains(where: { registry in
                registry.entityLocalId == tag.localId && registry.operationType == SyncRegistryUtils.CREATE_OPERATION && registry.entityType == SyncRegistryUtils.TAG_ENTITY
            })
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
                registry.entityLocalId == note.localId && registry.operationType == SyncRegistryUtils.CREATE_OPERATION && registry.entityType == SyncRegistryUtils.NOTE_ENTITY
            })
        }
    }
}
