//
//  DrawerBody.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import SwiftUI

struct DrawerBody: View {
    var currentPage: Pages
    var onSelect: ((Pages) -> ())
    
    var body: some View {
        VStack(alignment: .leading){
            RowView(isSelected: currentPage == .newNote, imageName: "plus.app.fill", title: "Nova nota"){
                onSelect(Pages.newNote)
            }
            RowView(isSelected: currentPage == .list, imageName: "list.bullet.rectangle.fill", title: "Todas as notas"){
                onSelect(Pages.list)
            }
            RowView(isSelected: currentPage == .tag, imageName: "tag.fill", title: "Tags"){
                onSelect(Pages.tag)
            }
            
            Spacer()
            RowView(isSelected: currentPage == .login,imageName: "person.fill", title: "Login"){
                onSelect(Pages.login)
            }
            
        }
        .padding(.top, 12)
    }
    
    func RowView(isSelected: Bool,imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(){
                    ZStack{
                        Image(systemName: imageName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isSelected ? .black : .gray)
                            .frame(width: 26, height: 26)
                    }
                    .frame(width: 30, height: 30)
                    .padding(.leading, 8)
                    
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(isSelected ? .black : .gray)
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? .black : .clear, lineWidth: 1)
        )
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
}
