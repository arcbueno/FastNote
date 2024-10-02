//
//  LabelDAO.swift
//  FastNote
//
//  Created by pedro.bueno on 01/10/24.
//

import Foundation
import CoreData
import Combine

class LabelDAO {
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getLabels() -> AnyPublisher<[Label], Error> {
        let request: NSFetchRequest<LabelEntity> = LabelEntity.fetchRequest()
        let context = persistentContainer.viewContext
        
        return Future<[Label], Error> { promise in
            do {
                let labelEntities = try context.fetch(request)
                let labels = labelEntities.map { Label(entity: $0) }
                promise(.success(labels))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(labels: [Label])  {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            do {
                let request: NSFetchRequest<LabelEntity> = LabelEntity.fetchRequest()
                let existingLabelEntities = try context.fetch(request)
                let existingLabelIds = existingLabelEntities.compactMap { $0.localId }
                
                labels.forEach { label in
                    if !existingLabelIds.contains(label.localId) {
                        let labelEntity = LabelEntity(context: context)
                        labelEntity.localId = label.localId
                        labelEntity.remoteId = label.remoteId
                        labelEntity.name = label.name
                        labelEntity.color = label.color
                        labelEntity.userId = label.userId
                    }
                }
                try context.save()
            } catch {
                print("Failed to save labels to core data: \(error)")
            }
        }
    }
}
