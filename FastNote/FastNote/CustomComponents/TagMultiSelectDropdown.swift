//
//  TagMultiSelectDropdown.swift
//  FastNote
//
//  Created by pedro.bueno on 04/10/24.
//

import SwiftUI

struct TagMultiSelectDropdown: View {
    @Binding var isExpanded: Bool
    @Binding var selectedOptions: Set<Label>
    var options:Array<Label>
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader{ geometry in
                
                
                
                Button(action: { isExpanded.toggle() }) {
                    HStack {
                        Text(selectedOptions.isEmpty ? "Tags" : selectedOptions.map({ label in
                            label.name
                        }) .joined(separator: ", "))
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                if isExpanded {
                    ZStack {
                        
                        
                        VStack {
                            ForEach(options, id: \.localId) { option in
                                HStack {
                                    Text(option.name)
                                    Spacer()
                                    ZStack{
                                        Circle()
                                            .fill(Color(hex: option.color))
                                            .frame(width: 24, height: 24)
                                        if selectedOptions.contains(option) {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                                .padding()
                                .onTapGesture {
                                    if selectedOptions.contains(option) {
                                        selectedOptions.remove(option)
                                    } else {
                                        selectedOptions.insert(option)
                                    }
                                }
                                
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                    }
                    
                }
                
            }
        }
    }
}


