//
//  TagsView.swift
//  FastNote
//
//  Created by pedro.bueno on 01/10/24.
//

import SwiftUI

struct TagsView: View {
    @ObservedObject var viewModel: TagsListViewModel
    @State private var toast: Toast? = nil
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                if(viewModel.state is SuccessTagState){
                    if let state = viewModel.state as? SuccessTagState {
                        
                        VStack{
                            HStack{
                                Text("Tags")
                                    .font(.title)
                                Spacer()
                                NavigationLink {
                                    NewTagView(viewModel: NewTagViewModel())
                                } label: {
                                    Text("Criar")
                                }.onAppear {
                                    viewModel.getAll()
                                }
                            }
                            .padding(.horizontal, 8)
                            ScrollView{
                                VStack{
                                    ForEach(state.tagList, id: \.localId){ tag in
                                        TagListItem(tag: tag)
                                    }
                                }.padding()
                            }
                        }
                    }
                    
                }
                
                if(viewModel.state is LoadingTagsState){
                    ProgressView()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.yellow)
        }.toastView(toast: $toast)
    }
}
