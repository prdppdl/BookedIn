//
//  CustomBackButton.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/12/2023.
//

import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        Button(action: {
            
            self.presentationMode.wrappedValue.dismiss()
            
        }){
            RoundedRectangle(cornerRadius: 6)
                .frame(width: 25, height: 25)
                .shadow(color: Color.black.opacity(0.9), radius: 4)
                .overlay {
                    Image(systemName: "chevron.left")
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color.color)
                }
        }
        
    }
}

#Preview {
    CustomBackButton()
}
