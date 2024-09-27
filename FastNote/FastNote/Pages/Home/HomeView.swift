//
//  HomeView.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import SwiftUI

struct HomeView: View {
    @State private var text = ""
    var body: some View {
        
        GeometryReader{ geometry in
            VStack(alignment: .leading){
                Text("Nova nota")
                    .font(.title)
                TextField("Comprar pão...", text: $text,  axis: .vertical)
                Spacer()
            }
            .padding()
            .frame(minHeight: geometry.size.height)
            .textFieldStyle(NoteFieldStyle())
            .background(.yellow)
        }//.navigationTitle("Nova nota")
        
    }
}

#Preview {
    HomeView()
}

struct NoteFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .background(.yellow)
            .foregroundColor(.black)
    }
}
