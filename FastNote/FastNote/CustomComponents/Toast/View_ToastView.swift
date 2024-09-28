//
//  View_ToastView.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//

import Foundation
import SwiftUI

extension View {

  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: toast))
  }
}
