//
//  NewTagViewModel.swift
//  FastNote
//
//  Created by pedro.bueno on 02/10/24.
//

import Foundation
import SwiftUI
import Combine

class NewTagViewModel : ObservableObject {
    
    let tagRepository: LabelRepository = LabelRepository(
        labelDao: LabelDAO(persistentContainer: PersistenceController.shared.container),
        syncRegistryRepository: SyncRegistryRepository(syncRegistryDao: SyncRegistryDAO(persistentContainer: PersistenceController.shared.container))
    )
    
    @Published var state: NewTagState = FillingNewTagState()
    
    func save(name: String, color: String) -> Bool {
        let tag = Label(name: name, color: color)
        tagRepository.saveNewLabel(label: tag)
        return true
    }
    
}

