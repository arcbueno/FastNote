//
//  HomeView.swift
//  FastNote
//
//  Created by pedro.bueno on 26/09/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var text = ""
    @State private var toast: Toast? = nil
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .center){
                ZStack{
                    VStack{
                        HStack{
                            Text("Nova nota")
                                .font(.title)
                            Spacer()
                            Button(action: {
                                let success = viewModel.save(text: text)
                                if(success){
                                    toast = Toast(style: .success, message: "Saved.", width: 160)
                                    text = ""
                                }
                            }){
                                Text("Salvar")
                            }
                        }
                        TextField("Comprar pão...", text: $text,  axis: .vertical)
                        Spacer()
                    }
                    if(viewModel.state is LoadingState){
                        ProgressView()
                    }
                }
                
            }
            
            .padding()
            .frame(minHeight: geometry.size.height)
            .textFieldStyle(NoteFieldStyle())
            .background(.yellow)
        }.toastView(toast: $toast)
    }
}
	
#Preview {
    HomeView(viewModel: HomeViewModel())
}

struct NoteFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .background(.yellow)
            .foregroundColor(.black)
    }
}
