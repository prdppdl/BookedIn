//
//  ForgotPassword.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/12/2023.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth

struct ForgotPassword: View {
    @State var userEmailToReset = ""
    var body: some View {
        NavigationStack {
            ZStack{
                Color.color
                VStack {
                    TextField(" ", text: $userEmailToReset)
                        .placeholder(when: userEmailToReset.isEmpty){
                            Text("Email")
                                .foregroundColor(.gray)
                        }
                        .customTextfield()
                        .padding(.top, 50)
                        .padding(.horizontal)
                    HStack{
                        Text("Your confirmation link will be sent to your email address.")
                            .font(.system(size: 12))
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .padding(.bottom)
                            .padding(.horizontal)
                        Spacer()
                    }
                    Button(action: {
                        
                        Auth.auth().sendPasswordReset(withEmail: userEmailToReset)
                    }){
                        Text("Send")
                            .fontWeight(.semibold)
                            .frame(width: 320,height: 25)
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                        
                    }
                    .background(Color.accentColor)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(5)
                    .padding(7)
                    Spacer()
                    
                }
                .background(Color.color)
            }
            
            .navigationTitle("Forgot password")
            .navigationBarBackButtonHidden(true)
            
            .navigationBarItems(leading: CustomBackButton())
        }
       
    }
}

#Preview {
    ForgotPassword()
}
