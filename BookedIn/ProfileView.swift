//
//  ProfileView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 2/3/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore


struct ProfileView: View {
       @Binding var isCustomerProfile: Bool
    
    @State private var retrieveCustomerDetails = RetrievingCustomerDetails()
    @State private var retrieveBusinessDetails = RetrievingBusinessDetails()
    let currentUserEmail = Auth.auth().currentUser?.email
    public let screenSize: CGRect = UIScreen.main.bounds
    
    
    
    
    var body: some View {
        ZStack {
            if isCustomerProfile == true {
                VStack {
                    Image("AppLogo")
                        .resizable()
                        .frame(width: screenSize.width, height: screenSize.height / 3)
                        .scaledToFit()
                    Spacer()
                    
                    
                }
                .onAppear{
                    retrieveCustomerDetails.retrieveCustomerData(){}
                }
                .ignoresSafeArea(.all, edges: .top)
                
                VStack {
                    ForEach(retrieveCustomerDetails.customerDetails) {details in
                        if currentUserEmail == details.userEmail {
                            Text("\(details.userName)")
                                .fontWeight(.semibold)
                                .font(.system(size: 15))
                                .foregroundStyle(.accent)
                                .shadow(radius: 10)
                            
                        }
                    }
                    Spacer()
                }
                .scaledToFill()
                .frame(width: screenSize.width)
                .background(Color.color)
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .padding(.top, 180)
                .ignoresSafeArea(.all, edges: .bottom)
                
                .shadow(radius: 20)
                
            }
            
            else {
                
                VStack {
                    Image("AppLogo")
                        .resizable()
                        .frame(width: screenSize.width, height: screenSize.height / 3)
                        .scaledToFit()
                    Spacer()
                    
                    
                }
                .onAppear{
                    retrieveBusinessDetails.retrieveBusinessData(){}
                }
                .ignoresSafeArea(.all, edges: .top)
                
                VStack {
                    ForEach(retrieveBusinessDetails.businessDetails) {details in
                        if currentUserEmail == details.businessEmail {
                            Text("\(details.businessName)")
                                .fontWeight(.semibold)
                                .font(.system(size: 15))
                                .foregroundStyle(.accent)
                                .shadow(radius: 10)
                            
                        }
                    }
                    Spacer()
                }
                .scaledToFill()
                .frame(width: screenSize.width)
                .background(Color.color)
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .padding(.top, 180)
                .ignoresSafeArea(.all, edges: .bottom)
                
                .shadow(radius: 20)
                
                
                
            }
          
            
         
            
        }
        .navigationBarItems(leading: CustomBackButton())
        .navigationBarBackButtonHidden()
    }
}

