//
//  LabelAPI.swift
//  FastNote
//
//  Created by pedro.bueno on 01/10/24.
//

import Foundation
import Combine

class LabelAPI {
    let session: URLSession
    let baseURL = URL(string: "https://demo0947970.mockable.io/")!
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getLabels() -> AnyPublisher<[Label], Error> {
        let url = baseURL.appendingPathComponent("todos")
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Label].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
