//
//  SignInView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/12/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


struct SignInView: View {
    @Environment(\.presentationMode) var isPresented
    
    
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    @State var forgotPasswordIsTapped = false
    @State var isSignedIn = false
    @Binding var isCustomerIsTapped: Bool
    @Binding var isBusinessIsTapped: Bool
    @State var retrievingbusinessDetails = RetrievingBusinessDetails()
    @State var retrievingcustomerDetails = RetrievingCustomerDetails()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.color.ignoresSafeArea()
                VStack{
                    Group {
                        Image(systemName: "chevron.up")
                            .foregroundColor(.gray)
                            .padding(1)
                        Text("Go back")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                            .onTapGesture {
                                isPresented.wrappedValue.dismiss()
                            }
                    }
                    Spacer()
                }
                
                VStack{
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
                            Text("Welcome to BookedIn.")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.horizontal)
                            Text("Please enter your registration email and password.")
                                .font(.system(size: 12))
                                .foregroundStyle(.black)
                                .font(.subheadline)
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
                        .padding(.horizontal)
                    
                    SecureField(" ", text: $userPassword)
                        .placeholder(when: userPassword.isEmpty){
                            Text("Password")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .customTextfield()
                        .padding(.horizontal)
                    
                    Button(action: {
                        
                        signInUser()
                        
                    }){
                        Text("Continue")
                            .fontWeight(.semibold)
                            .frame(width: 320,height: 25)
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                        
                    }
                    .background(Color.accentColor)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(5)
                    .padding(.bottom, 15)
                    
                    if isCustomerIsTapped {
                        NavigationLink(destination: DashboardViewCustomer(isCustomerProfileTapped: $isCustomerIsTapped), isActive: $isSignedIn){}
                    }
                    else {
                        
                        NavigationLink(destination: DashboardViewBusiness(isBusinessProfileTapped: $isBusinessIsTapped), isActive: $isSignedIn){}
                    }
                    // Mark: Starting Different SIgnIn Options
                    
                    
                    //            Text("Or via social networks")
                    //                .font(.system(size: 12))
                    //                .font(.subheadline)
                    //                .foregroundStyle(.gray)
                    
                    
                    //Mark: SIgn In WIth Apple Button Below
                    
                    
                    //            Button(action: {**Tell Button What to do**}){
                    //                Text("\(Image(systemName: "apple.logo")) Sign in with Apple")
                    //                    .frame(width: 320,height: 25)
                    //                    .foregroundColor(.black)
                    //                    .font(.system(size: 18))
                    //
                    //            }
                    //            .background(Color.color)
                    //            .buttonStyle(.bordered)
                    //            .cornerRadius(5)
                
                
                HStack{
                    Spacer()
                    Text("Forgot Password?")
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                        .font(.system(size: 16))
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.top, 15)
                        .onTapGesture {
                            forgotPasswordIsTapped = true
                        }
                    NavigationLink(destination: ForgotPassword(), isActive: $forgotPasswordIsTapped){}
                }
            }
            }
        }
    }
    
    
    
   // SIGN IN FUNCTION
    func signInUser() {
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion: {authResult, err in
            
            guard err == nil
                else {
                
                    
                return
                }
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.isSignedIn = true
            }
            
            
            
        })
        
        
        
    }
    
    
}
