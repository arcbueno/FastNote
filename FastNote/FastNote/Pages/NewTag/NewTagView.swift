//
//  NewTagView.swift
//  FastNote
//
//  Created by pedro.bueno on 02/10/24.
//

import SwiftUI

struct NewTagView: View {
    @ObservedObject var viewModel: NewTagViewModel
    @State private var toast: Toast? = nil
    @State private var name = ""
    @State private var color =
    Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                
                VStack{
                    HStack{
                        Text("Nova tag")
                            .font(.title)
                        Spacer()
                        Button(action: {
                            let success = viewModel.save(name: self.name, color: self.color.hex().replacingOccurrences(of: "#", with: ""))
                            if(success){
                                toast = Toast(style: .success, message: "Saved.", width: 160)
                                name = ""
                                dismiss()
                            }
                        }){
                            Text("Salvar")
                        }
                    }
                    .padding(.horizontal, 8)
                    ScrollView{
                        VStack{
                            HStack{
                                Text("Nome:")
                                    .font(.title3)
                                TextField("Lista de compras...", text: $name)
                                    
                            }.padding(.bottom, 12)
                            ColorPicker("Cor:", selection: $color)
                        }.padding()
                    }
                }
                
                
                if(viewModel.state is LoadingNewTagState){
                    ProgressView()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.yellow)
        }.toastView(toast: $toast)
    }
}
