//
//  TagsViewModel.swift
//  FastNote
//
//  Created by pedro.bueno on 01/10/24.
//

import Foundation
import SwiftUI
import Combine

class TagsListViewModel : ObservableObject {
    
    let tagRepository: LabelRepository = LabelRepository(
        labelAPI: LabelAPI(),
        labelDao: LabelDAO(persistentContainer: PersistenceController.shared.container)
    )
    
    @Published var state: TagsStateState = LoadingTagsState()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getAll()
    }
    
    func getAll(){
        tagRepository.getLabels()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch todos: \(error)")
                }
            } receiveValue: { [weak self] tags in
                self?.state = SuccessTagState(tagList: [Label(name: "lorem ipsum", color:"af4f4f"),
                                                        Label(name: "lorem ipsum", color:"ABC123")
                                                       ])
            }.store(in: &cancellables)
        
    }
    
    //    func save(text: String) -> Bool {
    //        let note = Label(text: text)
    //        noteRepository.saveNewLabel(note: note)
    //        return true
    //    }
    
}


