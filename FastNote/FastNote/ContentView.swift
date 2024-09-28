//
//  ContentView.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var isOpen = false
    @State var currentPage: Pages = .newNote
    
    var body: some View {
        NavigationView {
            DrawerView(isOpen: $isOpen) {
                appPage
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
                    currentPage: currentPage, onSelect: { page in
                        print(page)
//                            currentPage = page
                    }
                )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    var appPage: some View {
        switch currentPage {
        case .newNote:
            return HomeView(viewModel: HomeViewModel())
        case .list:
            return HomeView(viewModel: HomeViewModel())
        case .login:
            return HomeView(viewModel: HomeViewModel())
        case .signup:
            return HomeView(viewModel: HomeViewModel())
        }
    }
}

enum Pages {
    case newNote
    case list
    case login
    case signup
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}


