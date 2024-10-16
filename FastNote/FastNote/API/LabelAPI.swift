//
//  LabelAPI.swift
//  FastLabel
//
//  Created by pedro.bueno on 01/10/24.
//

import Foundation
import Combine
import Network

class LabelAPI {
    let session: URLSession
    let baseURL = URL(string: "https://fastnote-api.vercel.app/api/")!
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getLabels() async -> Result<[Label], RequestError> {
        do{
            guard let url = URL(string: "\(baseURL)tags/\(NetworkUtils.userId)") else {
                return .failure(.invalidURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let (data, _) = try await URLSession.shared.data(for: request)
            let labels = try JSONDecoder().decode([Label].self, from: data)
            return .success(labels)
        }catch{
            print("error getting labels \(error)")
            return .failure(.errorRequest(error: error.localizedDescription))
        }
    }
    
    func createLabel(label: Label, completion: @escaping (Result<String, RequestError>) -> Void) async -> Void {
        do {
            guard let url = URL(string: "\(baseURL)tags/\(NetworkUtils.userId)") else {
                completion(.failure(.invalidURL))
                return
            }
            
            let encodedObject = try JSONEncoder().encode(label)
            
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
            print("error creating label \(error)")
            completion(.failure(.errorRequest(error: error.localizedDescription)))
        }
    }
    
    func deleteLabel(remoteId: String, completion: @escaping (Result<String, RequestError>) -> Void) async -> Void {
        guard let url = URL(string: "\(baseURL)labels/\(NetworkUtils.userId)/\(remoteId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            var result: Result<String, RequestError> = .success("")
            let statusCode = (response as! HTTPURLResponse).statusCode

            if (statusCode == 200 || statusCode == 204) {
                result = .success("OK")
                print("SUCCESS")
            } else {
                result = .failure(.errorRequest(error: ""))
                print("FAILURE")
            }
            
            completion(result)
        }

        task.resume()
    }
}
