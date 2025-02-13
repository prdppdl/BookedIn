//
//  SeeAllBusiness.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 18/4/2024.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth
import SDWebImageSwiftUI
import Combine

struct SeeAllBusiness: View {
    
    @State private var retrieveBusinessDetails = RetrievingBusinessDetails()
    @State private var makeBookingView: Bool = false
    @State var selectedBusinessName = ""
    @State var selectedBusinessEmail = ""
    @State var selectedBusinessAddress = ""
    @State private var currentUserEmail = Auth.auth().currentUser?.email
    @State private var goToBookingView: Bool = false
    
    let screenSize: CGRect = UIScreen.main.bounds
    var body: some View {
        ZStack{
            Color.creamy.ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false){
                ForEach(retrieveBusinessDetails.businessDetails, id: \.self){details in
                    VStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 20.0)
                            .frame(width: screenSize.width - 20, height: 100)
                            .shadow(radius: 10)
                            .foregroundColor(.creamy)
                            .overlay{
                                HStack {
                                    VStack{
                                        HStack{
                                            Text("\(details.businessName)")
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.black)
                                                .padding(.leading,10)
                                            
                                            Text("Rating: 4.5\(Image(systemName: "star.fill"))")
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.black)
                                                .padding(.leading,10)
                                            Spacer()
                                           
                                            
                                        }
                                        HStack {
                                            Text("\(details.businessAddress)")
                                                .foregroundStyle(.gray)
                                                .fontWeight(.semibold)
                                                .padding(.leading,10)
                                            Spacer()
                                        }
                                        HStack{
                                            Text("\(details.businessContactNumber)")
                                                .foregroundStyle(.gray)
                                                .fontWeight(.semibold)
                                                .padding(.leading,10)
                                            Spacer()
                                        }
                                       
                                    }
                                    VStack {
                                        Menu {
                                            Section {
                                                Button {
                                                    
                                                    
                                                } label: {
                                                    Label("About \(details.businessName)", systemImage: "book.fill")
                                                }
                                                Button {} label: {
                                                    Label("View Menu", systemImage: "newspaper.fill")
                                                }
                                                Button {
                                                    
                                                    
                                                } label: {
                                                    Label("Go to \(details.businessName)", systemImage: "location.fill")
                                                }
                                                
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis.circle")
                                                .foregroundStyle(Color.black)
                                                .padding(.trailing, 10)
                                            
                                        }
                                        Button{
                                            selectedBusinessName = details.businessName
                                            selectedBusinessEmail = details.businessEmail
                                            selectedBusinessAddress = details.businessAddress
                                            goToBookingView = true
                                            
                                        } label: {
                                            
                                            Text("Lets Book")
                                                .foregroundStyle(Color.creamy)
                                            
                                        }
                                        
                                        .frame(width: 100, height: 35)
                                        .background(Color.bar.opacity(0.8))
                                        .cornerRadius(15)
                                        .padding(.trailing, 20)
                                    }
                                  
                                }
                                
                            }
                    }
                  
                }
                .padding(.top, 105)
            }
            .contentMargins(10)
            .scrollTargetBehavior(.viewAligned)
            .scrollContentBackground(.hidden)
          
            
            .overlay {
                VStack {
                    RoundedRectangle(cornerSize: .zero)
                        .clipShape(CustomCorner(radius: 25, corners: [.bottomLeft, .bottomRight]))
                        .frame(width: screenSize.width, height: 135)
                        .ignoresSafeArea(.all, edges: .top)
                        .foregroundStyle(Color.bar)
                    
                        .shadow(color: .black, radius: 10)
                        .overlay{
                            HStack {

                            VStack {
                                HStack {
                                    Text("PLACES TO BOOK IN")
                                        .font(.system(size: 19))
                                        .bold()
                                        .offset(x: 10, y: -20)
                                        .foregroundStyle(Color.creamy)
                                    Spacer()
                                }
                                HStack {
                                    Text("Here you can see places to book in.")
                                        .font(.system(size: 12))
                                        .font(.subheadline)
                                        .foregroundStyle(Color.creamy)
                                        .offset(x: 10, y: -20)
                                    Spacer()
                                }
                            }
                            .offset(x: 10)
                            Spacer()
                        }
                        }
                    Spacer()
                    
                    
                    
                }
            }
            
            .onAppear {
                retrieveBusinessDetails.retrieveBusinessDetailsForCustomerBooking()
            }
           
        }
        .navigationDestination(isPresented: $goToBookingView) {
            MakeBookingView(businessName: $selectedBusinessName , businessEmail: $selectedBusinessEmail, businessAddress: $selectedBusinessAddress)
        }
        .navigationTitle("Places to book")
    }
}
#Preview {
    SeeAllBusiness()
}
