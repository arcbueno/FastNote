//
//  NoteAPI.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import Foundation
import Combine

class NoteAPI {
    let session: URLSession
    let baseURL = URL(string: "https://demo0947970.mockable.io/")!
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getNotes() -> AnyPublisher<[Note], Error> {
        let url = baseURL.appendingPathComponent("todos")
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Note].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
