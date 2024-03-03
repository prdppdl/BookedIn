//
//  DashboardView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/12/2023.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct DashboardViewCustomer: View {
    @State private var isSwiped = false
    @State private var currentUserEmail = Auth.auth().currentUser?.email
    @State private var retrieveCustomerDetails = RetrievingCustomerDetails()
    @State private var cardOffset: CGSize = .zero
    @State private var retrieveBusinessDetails = RetrievingBusinessDetails()
    @State private var retrieveBookingDetails = RetrievingBookingDetails()
    @State private var currentMessageIndex = 0
    @State private var messages = ["BookedIn.", "Book", "Eat", "Repeat"]
    @State var makeBookingView: Bool = false
    @State var selectedBusinessName = ""
    @State var selectedBusinessEmail = ""
    @Binding public var isCustomerProfileTapped: Bool
    @State var isBusinessProfileTapped = false
    @State var isProfileTapped = false
    
    var body: some View {
        
        //CUSTOMER DAHSBOARD
            VStack {
                HStack {
                    HStack{
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.accentColor)
                            .shadow(radius: 10)
                            .onTapGesture {
                                isProfileTapped = true
                            }
                        Spacer()
                        Text("\(messages[currentMessageIndex])")
                            .fontWeight(.semibold)
                            .font(.system(size: 15))
                            .foregroundStyle(.accent)
                            .shadow(radius: 10)
                        Spacer()
                        
                        Image(systemName: "magnifyingglass.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.accentColor)
                            .shadow(radius: 10)
                    }
                    .onAppear{
                        startTiming()
                        retrieveCustomerDetails.retrieveCustomerData {}
                        retrieveBusinessDetails.retrieveBusinessDetailsForCustomerBooking()
                        retrieveBookingDetails.retrieveBooking()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ForEach(retrieveCustomerDetails.customerDetails, id: \.self){ details in
                    Text("G'day \(details.userName)")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                        .foregroundStyle(.accent)
                        .shadow(radius: 10)
                }
                HStack {
                    Text("Recommended places to you nearby")
                        .font(.system(size: 12))
                        .font(.subheadline)
                        .padding(.vertical,15)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
                
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    
                    ForEach(retrieveBusinessDetails.businessDetails, id: \.self){ details in
                        
                        VStack{
                            Color.color
                        }
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                        .shadow(radius: 20)
                        .overlay(content: {
                            
                            VStack{
                                HStack{
                                    Text("\(details.businessName)")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.black)
                                        .padding(.leading,10)
                                    Text("4.5 \(Image(systemName: "star.fill"))")
                                        .foregroundStyle(.black)
                                        .lineSpacing(1.0)
                                        .padding(.horizontal,10)
                                    Spacer()
                                    
                                    Menu {
                                        Section {
                                            Button {} label: {
                                                Label("About \(details.businessName)", systemImage: "ellipsis.vertical.bubble.fill")
                                            }
                                            Button {} label: {
                                                Label("View Menu", systemImage: "newspaper.fill")
                                            }
                                            
                                        }
                                    } label: {
                                        Label("",systemImage: "ellipsis.circle")
                                    }
                                }
                                
                                .padding(.top,20)
                                HStack{
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
                                .padding(.bottom)
                                HStack{
                                    Button(action: {
                                        selectedBusinessName = details.businessName
                                        selectedBusinessEmail = details.businessEmail
                                        makeBookingView = true
                                        
                                    }){
                                        Text("Book")
                                            .fontWeight(.semibold)
                                            .frame(width: 50,height: 25)
                                            .foregroundColor(.white)
                                            .font(.system(size: 17))
                                        
                                    }
                                    .background(Color.accentColor)
                                    .buttonStyle(.borderedProminent)
                                    .cornerRadius(5)
                                    .padding(.leading, 20)
                                    Spacer()
                                }
                                
                            }
                            
                            
                        })
                        
                    }
                    .frame(width: 350, height: 175)

                    NavigationLink(destination: MakeBookingView(businessName: $selectedBusinessName , businessEmail: $selectedBusinessEmail), isActive: $makeBookingView){}
                    NavigationLink(destination: ProfileView(isCustomerProfile: $isCustomerProfileTapped, isBusinessProfile: $isBusinessProfileTapped), isActive: $isProfileTapped){}
                    Spacer()
                    
                }
            }
            .background(Color.color)
            .navigationBarBackButtonHidden(true)
        
        
        VStack {
            HStack {
                Text("Your current bookings")
                    .font(.system(size: 12))
                    .font(.subheadline)
                    .padding(.vertical,15)
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            List(retrieveBookingDetails.bookingDetails) { details in
                if currentUserEmail! == details.customerEmail {
                    VStack {
                        HStack {
                            Text("At \(details.businessName)")
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .padding(.leading,10)
                            Spacer()
                        }
                        HStack{
                            Text("On \(details.bookingDate) at \(details.bookingTime)")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            Spacer()
                        }
                        HStack {
                            Text("For \(details.numberOfPeople) person")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            Spacer()
                        }
                    }
                }
                
            }
            .frame(height: 300)
            .background(Color.color)
            
            
            
        }
        
        
            Spacer()
            
        
    
    }
    
    
    private func startTiming() {
        Timer.scheduledTimer(withTimeInterval: 2.25, repeats: true) { timer in
            currentMessageIndex = (currentMessageIndex + 1) % messages.count
            
        }
    }
    
}




//MARK: BUSINESS DASHBOARD STARTS HERE

struct DashboardViewBusiness: View {
    @State private var isSwiped = false
    @State private var currentUserEmail = Auth.auth().currentUser?.email
    @State private var retrieveBookingDetails = RetrievingBookingDetails()
    @State private var cardOffset: CGSize = .zero
    @State private var retrieveBusinessDetails = RetrievingBusinessDetails()
    @State private var currentMessageIndex = 0
    @State private var messages = ["BookedIn.", "Book", "Eat", "Repeat"]
    let businessEmailCheck = Auth.auth().currentUser?.email
    @State var isProfileTapped = false
    @Binding var isBusinessProfileTapped: Bool
    @State var isCustomerProfileTapped = false
    
    var body: some View {
        
        //Business DAHSBOARD
            VStack {
            
                HStack {
                    HStack{
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.accentColor)
                            .shadow(radius: 10)
                            .onTapGesture {
                                isProfileTapped = true
                                
                            }
                        
                        Spacer()
                        Text("\(messages[currentMessageIndex])")
                            .fontWeight(.semibold)
                            .font(.system(size: 15))
                            .foregroundStyle(.accent)
                            .shadow(radius: 10)
                        Spacer()
                        
                        Image(systemName: "magnifyingglass.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.accentColor)
                            .shadow(radius: 10)
                    }
                    .onAppear{
                       startTiming()
                        retrieveBookingDetails.retrieveBooking()
                        retrieveBusinessDetails.retrieveBusinessData() {}
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ForEach(retrieveBusinessDetails.businessDetails, id: \.self){ details in
                   
                    Text("G'day \(details.businessName)")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                        .foregroundStyle(.accent)
                        .shadow(radius: 10)
                }
                HStack {
                    Text("Your current bookings")
                        .font(.system(size: 12))
                        .font(.subheadline)
                        .padding(.vertical,15)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
                
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    
                    ForEach(retrieveBookingDetails.bookingDetails, id: \.self){ details in
                        
                        if businessEmailCheck! == details.businessEmail {
                            
                            VStack{
                                Color.color
                            }
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                            .shadow(radius: 20)
                            .overlay(content: {
                                
                                VStack{
                                    HStack{
                                        Text("\(details.customerName)")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                            .font(.system(size: 15))
                                            .padding(.leading,10)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "ellipsis.circle")
                                            .foregroundStyle(.black)
                                            .padding(.trailing,10)
                                       
                                    }
                                    
                                    .padding(.top,20)
                                    HStack{
                                        Text("\(details.customerContactNumber)")
                                            .foregroundStyle(.gray)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .padding(.leading,10)
                                        Spacer()
                                    }
                                    HStack{
                                        Text("On: \(details.bookingDate)")
                                            .foregroundStyle(.gray)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .padding(.leading, 10)
                                        
                                        Text("At: \(details.bookingTime)")
                                            .foregroundStyle(.gray)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .padding(.trailing)
                                        Spacer()
                                    }
                                    
                                    HStack{
                                        Text("For \(details.numberOfPeople) people")
                                            .foregroundStyle(.gray)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                            .padding(.leading, 10)
                                        
                                        Spacer()
                                    }
                                    .padding(.bottom)
                                    HStack {
                                        VStack {
                                            Text("Requirements:")
                                                .foregroundStyle(.black)
                                                .fontWeight(.semibold)
                                                .font(.system(size: 15))
                                                .padding(.leading, 10)
                                            Text("\(details.noteForBusiness)")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 15))
                                                .fontWeight(.semibold)
                                                .padding(.leading, 10)
                        
                                        }
                                        
                                        Spacer()
                                    }
                                   
                                }
                                
                                
                            })
                        }
                    }
                    .frame(width: 350, height: 200)
                    NavigationLink(destination: ProfileView(isCustomerProfile: $isCustomerProfileTapped, isBusinessProfile: $isBusinessProfileTapped), isActive: $isProfileTapped){}
                    Spacer()
                    
                }
            }
            .background(Color.color)
            .navigationBarBackButtonHidden(true)
           
            
            Spacer()
            
        
    
    }
    
    
    private func startTiming() {
        Timer.scheduledTimer(withTimeInterval: 2.25, repeats: true) { timer in
            currentMessageIndex = (currentMessageIndex + 1) % messages.count
            
        }
    }
    
}

