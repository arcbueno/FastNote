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
    @State var dropdowndIsExpanded = false
    @State private var selectedOptions: Set<Label> = []
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .center){
                ZStack{
                    Rectangle()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .opacity(0.001)   // <--- important
                        .layoutPriority(-1)
                        .onTapGesture {
                            self.dropdowndIsExpanded = false
                        }
                    VStack{
                        HStack{
                            Text("Nova nota")
                                .font(.title)
                            Spacer()
                            Button(action: {
                                let success = viewModel.save(text: text, tags: Array(selectedOptions))
                                if(success){
                                    toast = Toast(style: .success, message: "Salvo com sucesso", width: geometry.size.width/2)
                                    text = ""
                                }
                            }){
                                Text("Salvar")
                            }
                        }.padding()
                        ZStack(alignment: .topTrailing){
                            TextField("Comprar pão...", text: $text,  axis: .vertical)
                                .padding(.top, 75)
                            TagMultiSelectDropdown(isExpanded: $dropdowndIsExpanded, selectedOptions: $selectedOptions, options: (viewModel.state as? FillingHomeState)?.tags ?? [])
                                .frame(height: 75)
                            
                            
                        }
                        Spacer()
                    }
                    
                    if(viewModel.state is LoadingHomeState){
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
