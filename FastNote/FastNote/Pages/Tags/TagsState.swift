//
//  TagsState.swift
//  FastNote
//
//  Created by pedro.bueno on 01/10/24.
//

protocol TagsStateState {}

class LoadingTagsState: TagsStateState {}

class SuccessTagState: TagsStateState {
    let tagList: [Label]
    
    init(tagList: [Label]) {
        self.tagList = tagList
    }
}

