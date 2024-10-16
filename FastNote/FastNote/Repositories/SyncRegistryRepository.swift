//
//  SyncRegistryRepository.swift
//  FastNote
//
//  Created by pedro.bueno on 09/10/24.
//

import CoreData
import Foundation
import Combine

class SyncRegistryRepository {
    let syncRegistryDao: SyncRegistryDAO
    var cancellables = Set<AnyCancellable>()
    
    init(syncRegistryDao: SyncRegistryDAO) {
        self.syncRegistryDao = syncRegistryDao
    }
    
    func add(entityLocalId: UUID?, entityType: Int, operationType: Int, entityRemoteId: String){
        return syncRegistryDao.add(entityLocalId: entityLocalId, entityType: entityType, operationType: operationType, entityRemoteId: entityRemoteId)
    }
    
    func getAllRegitries() async -> Result<[SyncRegistryEntity], Error> {
        return await syncRegistryDao.getAllSyncRegistries()
    }
    
    func delete(syncRegistry: SyncRegistryEntity) -> Result<Bool, Error>{
        do {
            try self.syncRegistryDao.delete(syncRegistry: syncRegistry)
            return .success(true)
        } catch {
            return .failure(error)
        }
        
    }
}
