//
//  LabelRepository.swift
//  FastNote
//
//  Created by pedro.bueno on 01/10/24.
//

import CoreData
import Foundation
import Combine

class LabelRepository {
    let syncRegistryRepository: SyncRegistryRepository
    let labelDao: LabelDAO
    
    init(labelDao: LabelDAO, syncRegistryRepository: SyncRegistryRepository) {
        self.labelDao = labelDao
        self.syncRegistryRepository = syncRegistryRepository
    }
    
    func saveNewLabel(label: Label){
        
        labelDao.save(labels: [label])
        syncRegistryRepository.add(entityLocalId: label.localId, entityType: SyncRegistryUtils.TAG_ENTITY, operationType: SyncRegistryUtils.CREATE_OPERATION, entityRemoteId: label.remoteId)
    }
    
    func getLabels() -> AnyPublisher<[Label], Error> {
        return labelDao.getLabels().eraseToAnyPublisher()
    }
}
