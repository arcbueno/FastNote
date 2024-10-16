//
//  SyncRegistryDAO.swift
//  FastNote
//
//  Created by pedro.bueno on 09/10/24.
//


import Foundation
import CoreData
import Combine

class SyncRegistryDAO {
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getAllSyncRegistries() async -> Result<[SyncRegistryEntity], Error> {
        let request: NSFetchRequest<SyncRegistryEntity> = SyncRegistryEntity.fetchRequest()
        let context = persistentContainer.viewContext
        
        do {
            let syncRegistries = try context.fetch(request)
            return .success(syncRegistries)
        } catch {
            return .failure(error)
        }
    }
    
    func add(entityLocalId: UUID?, entityType: Int, operationType: Int, entityRemoteId: String)  {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            do {
                let newEntity = SyncRegistryEntity(context: context)
                newEntity.entityLocalId = entityLocalId
                newEntity.entityType = Int16(entityType)
                newEntity.operationType = Int16(operationType)
                newEntity.localId = UUID()
                newEntity.entityRemoteId = entityRemoteId
                try context.save()
            } catch {
                print("Failed to save notes to core data: \(error)")
            }
        }
    }
    
    func delete(syncRegistry: SyncRegistryEntity) throws {
        let context = persistentContainer.newBackgroundContext()
        try context.performAndWait {
            let request: NSFetchRequest<SyncRegistryEntity> = SyncRegistryEntity.fetchRequest()
            let existingSyncRegistries = try context.fetch(request)
            let existingSyncRegistriesIds = existingSyncRegistries.compactMap { $0.localId }
            
            if let localId = syncRegistry.localId {
                if(existingSyncRegistriesIds.contains(localId)){
                    let syncRegistry = existingSyncRegistries.first { entity in
                        entity.localId == syncRegistry.localId
                    }
                    if let syncRegistry = syncRegistry{
                        context.delete(syncRegistry)
                    }
                    
                }
            }
            
            try context.save()
        }
    }
}
