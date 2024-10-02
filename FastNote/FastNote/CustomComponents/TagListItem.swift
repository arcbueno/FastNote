//
//  TagListItem.swift
//  FastNote
//
//  Created by pedro.bueno on 01/10/24.
//

import SwiftUI

struct TagListItem: View {
    var tag: Label
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(tag.name)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.black)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Circle()
                    .fill(Color(hex: tag.color))
                    .frame(width: 24, height: 24)
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
    TagListItem(tag: Label(name: "lorem ipsum", color:"FFFFF"))
}
