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
    @State private var currentMessageIndex = 0
    @State private var messages = ["BookedIn.", "Book", "Eat", "Repeat"]
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
                                    Image(systemName: "ellipsis.circle")
                                        .foregroundStyle(.black)
                                        .padding(.trailing,10)
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
                    .offset(x: cardOffset.width)
                    
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                cardOffset.width = gesture.translation.width
                            }
                            .onEnded { gesture in
                                if abs(cardOffset.width) > 100 {
                                    // Swiped far enough, reset the card offset
                                    withAnimation {
                                        cardOffset.width = gesture.translation.width > 0 ? 500 : -500
                                    }
                                } else {
                                    // Not swiped far enough, reset the card offset
                                    withAnimation {
                                        cardOffset.width = 0
                                    }
                                }
                            }
                    )
                    
                    Spacer()
                    
                }
            }
            .background(Color.accentColor)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                
                // Start a timer to automatically swipe the card after a delay
                Timer.scheduledTimer(withTimeInterval: 3.25, repeats: true) { _ in
                    
                    withAnimation {
                        cardOffset.width = -340
                    }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.25) {
                                            withAnimation {
                                                cardOffset.width = 0
                                            }
                                        }
                }
            }
            
            Spacer()
            
        
    
    }
    
    
    private func startTiming() {
        Timer.scheduledTimer(withTimeInterval: 2.25, repeats: true) { timer in
            currentMessageIndex = (currentMessageIndex + 1) % messages.count
            
        }
    }
    
}





struct DashboardViewBusiness: View {
    @State private var isSwiped = false
    @State private var currentUserEmail = Auth.auth().currentUser?.email
    @State private var retrieveCustomerDetails = RetrievingCustomerDetails()
    @State private var cardOffset: CGSize = .zero
    @State private var retrieveBusinessDetails = RetrievingBusinessDetails()
    @State private var currentMessageIndex = 0
    @State private var messages = ["BookedIn.", "Book", "Eat", "Repeat"]
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
                                    Image(systemName: "ellipsis.circle")
                                        .foregroundStyle(.black)
                                        .padding(.trailing,10)
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
                    .offset(x: cardOffset.width)
                    
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                cardOffset.width = gesture.translation.width
                            }
                            .onEnded { gesture in
                                if abs(cardOffset.width) > 100 {
                                    // Swiped far enough, reset the card offset
                                    withAnimation {
                                        cardOffset.width = gesture.translation.width > 0 ? 500 : -500
                                    }
                                } else {
                                    // Not swiped far enough, reset the card offset
                                    withAnimation {
                                        cardOffset.width = 0
                                    }
                                }
                            }
                    )
                    
                    Spacer()
                    
                }
            }
            .background(Color.accentColor)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                
                // Start a timer to automatically swipe the card after a delay
                Timer.scheduledTimer(withTimeInterval: 3.25, repeats: true) { _ in
                    
                    withAnimation {
                        cardOffset.width = -340
                    }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.25) {
                                            withAnimation {
                                                cardOffset.width = 0
                                            }
                                        }
                }
            }
            
            Spacer()
            
        
    
    }
    
    
    private func startTiming() {
        Timer.scheduledTimer(withTimeInterval: 2.25, repeats: true) { timer in
            currentMessageIndex = (currentMessageIndex + 1) % messages.count
            
        }
    }
    
}

