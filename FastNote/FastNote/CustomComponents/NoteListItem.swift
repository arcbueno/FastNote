//
//  NoteListItem.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import SwiftUI

struct NoteListItem: View {
    var note: Note
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(note.text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.black)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }.padding()
        }
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray)
        )
    }
    
    
}

#Preview {
    NoteListItem(note: Note(text: "lorem ipsum"))
}
