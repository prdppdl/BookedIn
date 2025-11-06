//
//  ContactUs.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 6/11/2025.
//

import SwiftUI


struct ContactUs: View {
    @State private var userQuery: String = ""
    @State private var screenSize: CGRect = UIScreen.main.bounds
    @FocusState private var isEditorFocused: Bool
    var body: some View {
        ZStack{
            Color.color.ignoresSafeArea()
            VStack{
               
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: screenSize.width - 20, height: 150)
                    .foregroundStyle(Color.accent)
                    .padding(.top, 20)
                    .overlay{
                        TextEditor(text: $userQuery)
                            .keyboardType(.default)
                            .focused($isEditorFocused)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: screenSize.width - 25, height: 145)
                            .padding(.top, 20)
                            
                    }
                 
                
                Text("Please mote it may take up to 48 hours for us to get back to you. Thank you for reaching out!")
                    .frame(width: screenSize.width - 20)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                    .padding(.horizontal)
                
                Button(action: {
                    
                  
                    
                }){
                    Text("Submit")
                        .fontWeight(.semibold)
                        .frame(width: 320,height: 25)
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                    
                }
                .disabled(userQuery.isEmpty)
                .background(Color.accentColor)
                .buttonStyle(.borderedProminent)
                .cornerRadius(5)
                .padding(7)
                
            Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isEditorFocused = false
        }
        .navigationTitle("Contact Us")
    }
}

#Preview {
    ContactUs()
}
