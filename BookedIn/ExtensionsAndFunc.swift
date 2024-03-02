//
//  Extensions.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/12/2023.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseCore

extension View {
    
    func customTextfield() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 1).padding(.top, 35))
            .foregroundColor(.gray)
            .padding(1)
        
    }
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func linearGradient() -> some View {
        
        LinearGradient(gradient: Gradient(colors: [Color.color.opacity(0.6), Color.color.opacity(1.0)]), startPoint: .top, endPoint: .bottom)
         .ignoresSafeArea()
        
    }
    
}

