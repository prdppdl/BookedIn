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
    @State private var businessName = ""
    @State private var businessContactNumber = ""
    @State private var businessAddress = ""
    @State private var isSecure = true
    @State private var isJoiningAsBusiness = false
    @State private var userABN: String = ""
    @State var messageLabel = "Create an account and discover thousands of best place to eat around you."
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
                        Text("\(messageLabel)")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 12))
                            .font(.subheadline)
                            .padding(.horizontal)
                        Spacer()
                    }
                   
                }
                Spacer()
            }
            
            if isJoiningAsBusiness == false {
    
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
            }
            
            
            else {
                VStack {
                    Spacer()

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
                    
                    
                    VStack {
                        HStack {
                            TextField("", text: $userABN)
                                .placeholder(when: userABN.isEmpty){
                                    Text("Enter your ABN")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                    
                                }
                                .customTextfield()
                                .keyboardType(.numberPad)
                                .padding(.horizontal)
                            
                            if verifyABN(userABN) {
                                Image(systemName: "checkmark.seal.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.accentColor)
                                    .padding(.trailing)
                            }
                            else {
                                Image(systemName: "checkmark.seal")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }
                            
                        }
                        HStack {
                            Text("This helps us to verify your business.")
                                .font(.system(size: 12))
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .padding(.horizontal)
                            Spacer()
                        }
                        
                        TextField(" ", text: $businessName)
                            .placeholder(when: businessName.isEmpty){
                                Text("Business Name")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .customTextfield()
                            .keyboardType(.default)
                            .padding(.horizontal)
                        
                        TextField(" ", text: $businessContactNumber)
                            .placeholder(when: businessContactNumber.isEmpty){
                                Text("Contact Number")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .customTextfield()
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                        
                        TextField(" ", text: $businessAddress)
                            .placeholder(when: businessAddress.isEmpty){
                                Text("Business Address")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .customTextfield()
                            .keyboardType(.default)
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Let your customer know where to go.")
                                .font(.system(size: 12))
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .padding(.horizontal)
                            Spacer()
                        }
                        
                    }
                    
                    
                }
                .onAppear() {
                    if isJoiningAsBusiness == true {
                        messageLabel = "Create an account and meet thousands of amazing hungry people."
                    }
                    
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
    
    
    let joinedDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-yyyy"
        return formatter
    }()
    //VERIFYING BUSINESS ABN
    //
    //
    
    func verifyABN(_ abn: String) -> Bool {
        guard let _ = Int(abn), abn.count == 11 else {
                return false
            }

            var newNumber = Array(abn)
            newNumber[0] = Character(String(Int(String(newNumber[0]))! - 1))

            var sum = 0
            let weights: [Int] = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
            for (index, char) in newNumber.enumerated() {
                if let digit = Int(String(char)) {
                    sum += digit * weights[index]
                }
            }

            return sum % 89 == 0
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
            if isJoiningAsBusiness {
                let businessDetails: [String: Any] = [
                    "businessEmail" : "\(userEmail)",
                  "businessABN" : "\(userABN)",
                    "businessName" : "\(businessName)",
                    "businessContactNumber" : "\(businessContactNumber)",
                    "businessAddress" : "\(businessAddress)",
                    "joinedDate" : "\(joinedDate)"
                ]
                
                Firestore.firestore().collection("Business").document("\(userEmail)").setData(businessDetails)
                
            }
            else {
                let customerDetails = [
                    "userEmail" : "\(userEmail)",
                    "userName" : "\(userFirstName)",
                    "userContactNumber" : "\(userContactNumber)",
                    "userLastName" : "\(userLastName)",
                    "joinedDate" : "\(joinedDate)"
                ]
                Firestore.firestore().collection("Customer").document("\(userEmail)").setData(customerDetails)
                
            }
            
        })
    }
}

#Preview {
    JoinView()
}
