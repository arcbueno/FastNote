//
//  Toast.swift
//  FastNote
//
//  Created by pedro.bueno on 28/09/24.
//


struct Toast: Equatable {
  var style: ToastStyle
  var message: String
  var duration: Double = 3
  var width: Double = .infinity
}
