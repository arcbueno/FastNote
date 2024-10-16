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
    let baseURL = URL(string: "https://fastnote-api.vercel.app/api/")!
    
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getNotes() async -> Result<[Note], RequestError> {
        do{
            guard let url = URL(string: "\(baseURL)notes/\(NetworkUtils.userId)") else {
                return .failure(.invalidURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let (data, _) = try await URLSession.shared.data(for: request)
            let notes = try JSONDecoder().decode([Note].self, from: data)
            return .success(notes)
        }catch{
            print("error getting notes \(error)")
            return .failure(.errorRequest(error: error.localizedDescription))
        }
    }
    
    func createNote(note: Note, completion: @escaping (Result<String, RequestError>) -> Void) async -> Void {
        do {
            guard let url = URL(string: "\(baseURL)notes/\(NetworkUtils.userId)") else {
                completion(.failure(.invalidURL))
                return
            }
            
            let encodedObject = try JSONEncoder().encode(note)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = encodedObject
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                var result: Result<String, RequestError> = .success("")
                let statusCode = (response as! HTTPURLResponse).statusCode

                if statusCode == 201 {
                    result = .success("OK")
                    print("SUCCESS")
                } else {
                    result = .failure(.errorRequest(error: ""))
                    print("FAILURE")
                }
                
                completion(result)
            }

            task.resume()
        }catch{
            print("error creating note \(error)")
            completion(.failure(.errorRequest(error: error.localizedDescription)))
        }
    }
}
