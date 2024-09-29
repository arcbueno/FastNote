//
//  NoteListView.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//


import SwiftUI

struct NoteListView: View {
    @ObservedObject var viewModel: NoteListViewModel
    @State private var toast: Toast? = nil
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                if(viewModel.state is SuccessListState){
                    if let state = viewModel.state as? SuccessListState {
                        
                        ScrollView{
                            VStack(alignment: .center){
                                ForEach(state.noteList, id: \.localId){ note in
                                    NavigationLink(destination: NoteDetailView(note: note, viewModel: viewModel), label: {
                                        NoteListItem(note: note)
                                    })
                                }
                            }.padding()
                        }
                    }
                    
                }
                
                if(viewModel.state is LoadingListState){
                    ProgressView()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.yellow)
        }.toastView(toast: $toast)
    }
}


