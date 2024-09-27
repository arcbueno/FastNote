//
//  FastNoteApp.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import SwiftUI

@main
struct FastNoteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
