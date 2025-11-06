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
import MapKit


struct JoinView: View {
    @Environment(\.presentationMode) var isPresented
    
    @State private var userEmail = ""
    @State private var userPassword = ""
    @State private var userFirstName = ""
    @State private var userLastName = ""
    @State private var userContactNumber = ""
    @State private var isSecure = true
    @State private var isAnimatingBack = false
    @State var messageLabel = "Create an account and discover thousands of best place to eat around you."
    
    var body: some View {
        
        VStack {
            
            
        VStack{
            Group {
                Image(systemName: "chevron.up")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.gray)
                    .offset(x: isAnimatingBack ? 0 : 0, y: isAnimatingBack ? 0 : 7)
                    .animation(.bouncy(duration: 0.4).repeatForever(autoreverses: true), value: isAnimatingBack)
                    .onTapGesture {
                        isPresented.wrappedValue.dismiss()
                    }
                    .onAppear{
                        isAnimatingBack = true
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
                            .foregroundStyle(Color.black)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        Spacer()
                    }
                    HStack {
                        Text("\(messageLabel)")
                            .foregroundStyle(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 12))
                            .font(.subheadline)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                }
                Spacer()
            }
            

                
                TextField(" ", text: $userFirstName)
                    .placeholder(when: userFirstName.isEmpty){
                        Text("First Name")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .customTextfield()
                    .keyboardType(.default)
                    .padding(.horizontal)
                
                TextField(" ", text: $userLastName)
                    .placeholder(when: userLastName.isEmpty){
                        Text("Last Name")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .customTextfield()
                    .keyboardType(.default)
                    .padding(.horizontal)
                
                TextField(" ", text: $userContactNumber)
                    .placeholder(when: userContactNumber.isEmpty){
                        Text("Contact Number")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .customTextfield()
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                
                TextField(" ", text: $userEmail)
                    .placeholder(when: userEmail.isEmpty){
                        Text("Email")
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
                                Text("Check if it matches the requirement of strong password.")
                                    .fixedSize(horizontal: false, vertical: true)
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
                .foregroundStyle(Color.black)
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
        .background(Color.color.ignoresSafeArea())
    }
       
  
    var joinedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-yyyy"
        return formatter.string(from: Date())
    }
    
    
    //SIGNING UP USER
    //
    //
    
    func signUpUser(){
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: {authResult, err in
            guard err == nil else{
               return
            }
            Auth.auth().currentUser?.sendEmailVerification()
            
            //SAVING USER DETAILS
                let customerDetails = [
                    "userEmail" : "\(userEmail)",
                    "userName" : "\(userFirstName)",
                    "userContactNumber" : "\(userContactNumber)",
                    "userLastName" : "\(userLastName)",
                    "joinedDate" : "\(joinedDate)"
                ]
                Firestore.firestore().collection("Customer").document("\(userEmail)").setData(customerDetails)
            
        })
    }
}

#Preview {
    JoinView()
}
