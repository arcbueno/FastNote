//
//  HomeState.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

protocol HomeState {}

class LoadingHomeState: HomeState {}

class FillingHomeState: HomeState {
    let tags: Array<Label>
    init(tags: Array<Label>) {
        self.tags = tags
    }
}

