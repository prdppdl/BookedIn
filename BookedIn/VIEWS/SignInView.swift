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
    
    
    @State private var userEmail: String = "prdppoudel123@icloud.com"
    @State private var userPassword: String = "1234567890@@"
    @State var forgotPasswordIsTapped = false
    @State var isSignedInCustomer = false
    @State var isSignedInBusiness = false
    @State var retrievingbusinessDetails = RetrievingBusinessDetails()
    @State var retrievingcustomerDetails = RetrievingCustomerDetails()
    @State private var isAnimatingBack = false
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.color.ignoresSafeArea()
                
                VStack{
                    Group {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.gray)
                            .offset(x: isAnimatingBack ? 0 : 0, y: isAnimatingBack ? 0 : 7)
                            //.animation(.bouncy(duration: 0.4).repeatForever(autoreverses: true), value: isAnimatingBack)
                            .onTapGesture {
                                isPresented.wrappedValue.dismiss()
                            }
                            .onAppear{
                                isAnimatingBack = true
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
                            Text("Email ")
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
                    
                    // Mark: Starting Different SIgnIn Options
                    
                    
                    //            Text("Or via social networks")
                    //                .font(.system(si)ze: 12))
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
                            .foregroundStyle(Color.accentColor)
                            .font(.system(size: 16))
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.top, 15)
                            .onTapGesture {
                                forgotPasswordIsTapped = true
                            }
                        
                    }
                }
            
            }
            
            .navigationDestination(isPresented: $isSignedInCustomer) {
                CustomerDashboardView()
            
            }
            .navigationDestination(isPresented: $forgotPasswordIsTapped){
                ForgotPassword()
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
        
                    self.isSignedInCustomer = true
            
        })
        
        
        
    }
    
    
}
