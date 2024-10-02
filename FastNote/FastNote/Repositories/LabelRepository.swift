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
    let labelAPI: LabelAPI
    let labelDao: LabelDAO
    var cancellables = Set<AnyCancellable>()
    
    init(labelAPI: LabelAPI, labelDao: LabelDAO) {
        self.labelAPI = labelAPI
        self.labelDao = labelDao
    }
    
    func saveNewLabel(label: Label){
        return labelDao.save(labels: [label])
    }
    
    func getLabels() -> AnyPublisher<[Label], Error> {
        return labelDao.getLabels().eraseToAnyPublisher()
//        labelAPI.getLabels()
//            .map { [weak self] labels in
//                // Adicionar criação de uuid
//                self?.labelDao.save(labels: labels)
//                return todos
//            }
//            .catch { error -> AnyPublisher<[Todo], Error> in
//                print("Failed to fetch todos from service: \(error)")
//                return self.todoOfflineService.getTodos()
//            }.eraseToAnyPublisher()
    }
}
