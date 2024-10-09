//
//  ContentView.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    let syncService: SyncRegistryService
    @State var isOpen = false
    @State var currentPage: Pages = .newNote
    
    init() {
        let persistanceContainer = PersistenceController.shared.container
        self.syncService = SyncRegistryService(syncRegistryDao: SyncRegistryDAO(persistentContainer: persistanceContainer), tagDao: LabelDAO(persistentContainer: persistanceContainer), noteDao: NoteDAO(persistentContainer: persistanceContainer), noteAPI: NoteAPI(), tagAPI: LabelAPI())
    }
    
    var body: some View {
        NavigationView {
            DrawerView(isOpen: $isOpen) {
                ZStack{
                    switch currentPage {
                    case .newNote:
                        HomeView(viewModel: HomeViewModel())
                    case .list:
                        NoteListView(viewModel: NoteListViewModel())
                    case .tag:
                        TagsView(viewModel: TagsListViewModel())
                    case .login:
                        HomeView(viewModel: HomeViewModel())
                    case .signup:
                        HomeView(viewModel: HomeViewModel())
                    case .sync:
                        HomeView(viewModel: HomeViewModel())
                    }
                }
                .toolbarBackground(.yellow, for: .navigationBar)
                .navigationBarItems(leading: Button(action: {
                    withAnimation{
                        self.isOpen.toggle()
                    }
                }) {
                    Image(systemName: "sidebar.left")
                })
                
            } drawer: {
                Color.orange
                DrawerBody(
                    syncService: self.syncService,
                    currentPage: currentPage, onSelect: { page in
                        print(page)
                        self.currentPage = page
                        self.isOpen.toggle()
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    
}

enum Pages {
    case newNote
    case list
    case login
    case signup
    case tag
    case sync
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}


