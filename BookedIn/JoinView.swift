//
//  JoinView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/12/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


struct JoinView: View {
    @Environment(\.presentationMode) var isPresented
    
    @State private var userEmail = ""
    @State private var userPassword = ""
    @State private var isSecure = true
    @State private var isJoiningAsBusiness = false
    @State private var userABN: String = ""
    var body: some View {
        VStack{
            Group {
                Image(systemName: "chevron.up")
                    .foregroundColor(.secondary)
                    .padding(1)
                Text("Go back")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        isPresented.wrappedValue.dismiss()
                    }
            }
            Spacer()
            
        }
        VStack {
            Spacer()
            HStack{
                Image("AppLogo")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .shadow(radius: 20)
                    .padding(.horizontal)
                Spacer()
            }
            HStack{
                VStack{
                    HStack{
                        Text("Join BookedIn.")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        Spacer()
                    }
                    HStack {
                        Text("Create an account and discover thousands of best place to eat or take reservation from amazing people around your place.")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 12))
                            .font(.subheadline)
                            .padding(.horizontal)
                    }
                }
                Spacer()
            }
            TextField(" ", text: $userEmail)
                .placeholder(when: userEmail.isEmpty){
                    Text("Email or Username")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .customTextfield()
                .keyboardType(.emailAddress)
                .padding(.horizontal)
            HStack {
                if isSecure {
                    VStack {
                        SecureField(" ", text: $userPassword)
                            .placeholder(when: userPassword.isEmpty){
                                HStack {
                                    Text("Password")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                
                            }
                            .customTextfield()
                            .padding(.horizontal)
                        HStack{
                            Text("Combine upper and lowercase letters and numbers.")
                                .font(.system(size: 12))
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .padding(.horizontal)
                            Spacer()
                        }
                    }
                }
                else {
                    VStack {
                        TextField(" ", text: $userPassword)
                            .placeholder(when: userPassword.isEmpty){
                                Text("Password")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                
                            }
                            .customTextfield()
                            .padding(.horizontal)
                        HStack{
                            Text("Combine upper and lowercase letters and numbers.")
                                .font(.system(size: 12))
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .padding(.horizontal)
                            Spacer()
                        }
                    }
                }
                Button(action: {
                    isSecure.toggle()
                }, label: {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .padding(.trailing, 20)
                })
            }
            
            HStack {
                Toggle(isOn: $isJoiningAsBusiness, label: {
                    Text("Joining as Business")
                        .foregroundStyle(.accent)
                        .fontWeight(.semibold)
                    
                })
                .foregroundStyle(.accent)
                .padding(.horizontal)
                .padding(.top,20)
                
            }
            if isJoiningAsBusiness {
                VStack {
                    TextField("", text: $userABN)
                        .placeholder(when: userABN.isEmpty){
                            Text("Enter your ABN")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                        }
                        .customTextfield()
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                    HStack {
                        Text("This helps us to verify your business.")
                            .font(.system(size: 12))
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                }
            }
            Button(action: {
                
                signUpUser()
                
            }){
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .frame(width: 320,height: 25)
                    .foregroundColor(.white)
                    .font(.system(size: 17))
                
            }
            .background(Color.accentColor)
            .buttonStyle(.borderedProminent)
            .cornerRadius(5)
            .padding(7)
            
            HStack{
                Text("By joining, you agree to BookedIn's")
                    .font(.system(size: 12))
                    .font(.subheadline)
                Text("Terms of Service")
                    .font(.system(size: 12))
                    .font(.subheadline)
                    .foregroundStyle(.accent)
            }
            // Mark: Starting Different SIgnIn Options
            
            
            //            Text("Or via social networks")
            //                .font(.system(size: 12))
            //                .font(.subheadline)
            //                .foregroundStyle(.gray)
            
            
            //Mark: SIgn Up WIth Apple Button Below
            
            
            //            Button(action: {**Tell Button What to do**}){
            //                Text("\(Image(system Name: "apple.logo")) Sign up with Apple")
            //                    .frame(width: 320,height: 25)
            //                    .foregroundColor(.black)
            //                    .font(.system(size: 18))
            //
            //            }
            //            .background(Color.color)
            //            .buttonStyle(.bordered)
            //            .cornerRadius(5)
            Spacer()
        }
    }
    
    func signUpUser(){
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: {authResult, err in
            guard err == nil else{
               return
            }
            Auth.auth().currentUser?.sendEmailVerification()
            //SAVING USER DETAILS
            if isJoiningAsBusiness {
                let businessDetails: [String: Any] = [
                    "userEmail" : "\(userEmail)",
                  "userABN" : "\(userABN)"
                ]
                
                Firestore.firestore().collection("Business").document("\(userEmail)").setData(businessDetails)
                
            }
            else {
                let customerDetails = [
                    "userEmail" : "\(userEmail)"
                ]
                Firestore.firestore().collection("Customer").document("\(userEmail)").setData(customerDetails)
                
            }
            
        })
    }
}

#Preview {
    JoinView()
}
