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


struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
               TabBarButton(imageName: "house.fill", selectedTab: $selectedTab, tabIndex: 0)
                .frame(width: 20, height: 20)
                .padding(.horizontal)
               TabBarButton(imageName: "magnifyingglass", selectedTab: $selectedTab, tabIndex: 1)
                .frame(width: 20, height: 20)
                .padding(.horizontal)
               TabBarButton(imageName: "person.fill", selectedTab: $selectedTab, tabIndex: 2)
                .frame(width: 20, height: 20)
                .padding(.horizontal)
           }
           .padding()
           .background(Color.white)
           .cornerRadius(25)
           .shadow(radius: 5)
    }
}


struct TabBarButton: View {
    let imageName: String
    @Binding var selectedTab: Int
    let tabIndex: Int
    
    var body: some View {
        
        Button(action: {
            selectedTab = tabIndex
        }) {
            Image(systemName: imageName)
                .font(.system(size: 24))
                .foregroundColor(selectedTab == tabIndex ? Color.accentColor : .gray)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(1))
}


