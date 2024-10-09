//
//  NoteAPI.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import Foundation
import Combine
import Network

class NoteAPI {
    let session: URLSession
    let baseURL = URL(string: "https://demo0947970.mockable.io/")!
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getNotes() -> AnyPublisher<[Note], Error> {
        let url = baseURL.appendingPathComponent("notes")
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Note].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func createNote(note: Note) async -> Result<[String: Any]?, RequestError>{
        return .success(["return": "success"])
        do {
            guard let url = URL(string: "\(baseURL)notes") else {
                return .failure(.invalidURL)
            }
            
            let encodedObject = try JSONEncoder().encode(note)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = encodedObject
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let message = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            return .success(message)
        }catch{
            return .failure(.errorRequest(error: error.localizedDescription))
        }
    }
}
