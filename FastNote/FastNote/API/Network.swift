//
//  Network.swift
//  FastNote
//
//  Created by pedro.bueno on 09/10/24.
//

enum RequestError: Error {
    case invalidURL
    case errorRequest(error: String)
}

struct NetworkUtils{
    static let userId: String = "6ae07f42-bfb6-4a99-8335-acbf61f0a8e0"
}
