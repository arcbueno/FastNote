//
//  ToastView.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import SwiftUI

struct ToastView: View {
  
  var style: ToastStyle
  var message: String
  var width = CGFloat.infinity
  var onCancelTapped: (() -> Void)
  
  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      Image(systemName: style.iconFileName)
            .foregroundColor(.black)
      Text(message)
        .font(Font.caption)
        .foregroundColor(.black)
      
      Spacer(minLength: 10)
      
      Button {
        onCancelTapped()
      } label: {
        Image(systemName: "xmark")
              .foregroundColor(.black)
      }
    }
    .padding()
    .frame(minWidth: 0, maxWidth: width)
    .background(style.themeColor)
    .cornerRadius(8)
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        //.stroke(style.themeColor, lineWidth: 0.5)
        .stroke(style.themeColor, lineWidth: 1)
        .opacity(0.6)
        //.glow(color: style.themeColor, radius: 4)
    )
    .padding(.horizontal, 16)
  }
}
