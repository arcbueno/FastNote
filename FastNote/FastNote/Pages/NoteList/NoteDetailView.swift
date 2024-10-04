//
//  NoteDetailView.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import SwiftUI

struct NoteDetailView: View {
    var note: Note
    @ObservedObject var viewModel: NoteListViewModel
    @State private var toast: Toast? = nil
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading){
                HStack{
                    Spacer()
                    Button(action: {
                        let success = viewModel.delete(note: self.note)
                        if(success){
                            toast = Toast(style: .success, message: "Deletado com sucesso", width: geometry.size.width/2)
                        }
                    }){
                        Text("Deletar")
                    }
                }
                HStack{
                    Text(note.text)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.black)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .textSelection(.enabled)
                    Spacer()
                }.padding()
                Spacer()
            }
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.gray)
            )
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.yellow)
        }.toastView(toast: $toast)
            
    }
}
