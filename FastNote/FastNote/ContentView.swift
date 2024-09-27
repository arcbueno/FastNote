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
    
    var body: some View {
        NavigationView {
            DrawerView(isOpen: $isOpen) {
                HomeView()
                    .navigationBarItems(leading: Button(action: {
                        withAnimation{
                            self.isOpen.toggle()
                        }
                    }) {
                        Image(systemName: "sidebar.left")
                    })
                
            } drawer: {
                Color.orange
                VStack(alignment: .leading){
                    Section{
                        Text("Nova nota")
                    }
                    Section{
                        Text("Todas as notas")
                    }
                    Spacer()
                }.background(.blue)
            }
        }
    }
    
    
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}


