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
            Image(systemName: "chevron.left")
                .frame(width: 14, height: 14)
                .foregroundColor(Color.accentColor)
        }
    }
      
}

#Preview {
    CustomBackButton()
}
