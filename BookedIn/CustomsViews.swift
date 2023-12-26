//
//  CustomLoading.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 28/12/2023.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseFirestore

//CUSTOM LOADING VIEW

struct CustomLoading: View {
    @Binding var messageLabelTips: String
    @Binding var messageLabel: String
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 200, height: 200)
                .shadow(radius: 20)
                .foregroundStyle(.clear)
                .background(Color.color)
                .overlay(
                    ProgressView(label: {
                        Text("\(messageLabelTips)")
                            .font(.system(size: 12))
                            .font(.subheadline)
                        Text("\(messageLabel)")
                            .font(.system(size: 12))
                            .font(.subheadline)
                        
                    })
                
                )
        }
    }
}

//CUSTOM NAVIGATION ITEMS

struct NavigationBatItemForCustomer: View {
    @State private var currentMessageIndex = 0
    @State private var messages = ["BookedIn.", "Book", "Eat", "Repeat"]
    var retrieveCustomerDetails = RetrievingCustomerDetails()
    @Binding var userName: String
    var body: some View {
        
        if Auth.auth().currentUser != nil {
            
            HStack{
                
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.accentColor)
                    .shadow(radius: 10)
       
                    Text("\(messages[currentMessageIndex]) \(userName)")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                        .foregroundStyle(.accent)
                        .shadow(radius: 10)
                    
                
                
            }
            .onAppear{
                startTiming()
                retrieveCustomerDetails.retrieveCustomerData {}
            }
        }
        else {
            HStack{
                
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.accentColor)
                    .shadow(radius: 10)
                
                    Text("\(messages[currentMessageIndex]), Guest")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                        .foregroundStyle(.accent)
                        .shadow(radius: 10)
                    
                    
                
                
            }
            .onAppear{
                startTiming()
            }
        }
    }
    private func startTiming() {
         Timer.scheduledTimer(withTimeInterval: 2.25, repeats: true) { timer in
             currentMessageIndex = (currentMessageIndex + 1) % messages.count
             
         }
     }
}


struct NavigationBatItemForBusiness: View {
    
    @State private var currentMessageIndex = 0
    @State private var messages = ["Welcome,", "Greetings,", "G'Day,"]
    var retrieveBusinessDetails = RetrievingBusinessDetails()
    var body: some View {
        
        if Auth.auth().currentUser != nil {
            HStack{
                
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.accentColor)
                    .shadow(radius: 10)
                
                ForEach(retrieveBusinessDetails.businessDetails, id: \.self) {details in
                    Text("\(messages[currentMessageIndex]) \(details.businessName)")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                        .foregroundStyle(.accent)
                        .shadow(radius: 10)
                    
                    
                }
                
            }
            .onAppear{
                startTiming()
                retrieveBusinessDetails.retrieveBusinessData{}
            }
        }
        else {
            HStack{
                
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.accentColor)
                    .shadow(radius: 10)
                
                    Text("\(messages[currentMessageIndex]), Owner")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                        .foregroundStyle(.accent)
                        .shadow(radius: 10)
                    
                    
                
                
            }
            .onAppear{
                startTiming()
            }
            
            
        }
    }

    
   private func startTiming() {
        Timer.scheduledTimer(withTimeInterval: 2.25, repeats: true) { timer in
            currentMessageIndex = (currentMessageIndex + 1) % messages.count
            

        }
    }
}

#Preview{NavigationBatItemForBusiness()}


