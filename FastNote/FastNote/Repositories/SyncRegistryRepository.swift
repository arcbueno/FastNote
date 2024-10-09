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
    
    func getAllRegitries() -> AnyPublisher<[SyncRegistryEntity], Error> {
        return syncRegistryDao.getAllSyncRegistries().eraseToAnyPublisher()
    }
    
    func delete(syncRegistry: SyncRegistryEntity) -> AnyPublisher<Bool, Error>{
        return Future<Bool, Error> { promise in
            do {
                try self.syncRegistryDao.delete(syncRegistry: syncRegistry)
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
        
    }
}
