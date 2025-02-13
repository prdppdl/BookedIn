//
//  MakeBookingView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 22/2/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


struct MakeBookingView: View {
    
    @State var customerName = ""
    @State var customerContactNumber = ""
    @State var bookingDate = Date()
    @State var bookingTime = Date()
    @State var numberOfPeople = ""
    @State var noteForBusiness = ""
    @Binding var businessName: String
    @Binding var businessEmail: String
    @Binding var businessAddress: String
    
    var body: some View {
        ZStack {
            Color.creamy.ignoresSafeArea()
        VStack {
            Spacer()
            HStack{
                Image("AppLogo")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .shadow(radius: 20)
                    .padding(.leading)
                Spacer()
            }
            HStack {
               
                    Text("Lets BookedIn.")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .padding(.leading)
                Spacer()
                }
            HStack {
                Text("Enter your details to book in at \(businessName)")
                    .font(.system(size: 12))
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .padding(.leading)
                
                Spacer()
            }
            
            TextField(" ", text: $customerName)
                .placeholder(when: customerName.isEmpty){
                    Text("Your Name")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .customTextfield()
                .padding(.horizontal)
            
            TextField(" ", text: $customerContactNumber)
                .placeholder(when: customerContactNumber.isEmpty){
                    Text("Contact Number")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .customTextfield()
                .padding(.horizontal)
            HStack {
                Text("When")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.leading)
                DatePicker(" ", selection: $bookingDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.trailing)
                
                
                Text("What time")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.leading)
                DatePicker(" ", selection: $bookingTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .padding(.trailing)
                
            }
            .padding(.top)
            VStack {
                TextField(" ", text: $numberOfPeople)
                    .placeholder(when: numberOfPeople.isEmpty){
                        Text("For how many?")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .customTextfield()
                    .padding(.horizontal)
                HStack{
                    Text("Let \(businessName) know how many you going.")
                        .font(.system(size: 12))
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.leading)
                    Spacer()
                }
            }
            
            TextField(" ", text: $noteForBusiness)
                .placeholder(when: noteForBusiness.isEmpty){
                    Text("Note")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .customTextfield()
                .padding(.horizontal)
            HStack{
                Text("Let \(businessName) know your requirements.")
                    .font(.system(size: 12))
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .padding(.leading)
                Spacer()
            }
            Button(action:{
                
                makeBooking()
                
                
                
            }){
                Text("BookIn")
                    .fontWeight(.semibold)
                    .frame(width: 320,height: 25)
                    .foregroundColor(.white)
                    .font(.system(size: 17))
            }
            .background(Color.accentColor)
            .buttonStyle(.borderedProminent)
            .cornerRadius(5)
            
            
            
        }
        .padding(.bottom)
    }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
    
    //DATE FORMATTER TO DD/MM and HH:MM
    
    var formattedDate : String {
        let date = DateFormatter()
        date.dateFormat = "dd/MM/yyyy"
        return date.string(from: bookingDate)
    }
    
    var formattedTime : String {
        let time = DateFormatter()
        time.dateFormat = "HH:mm"
        return time.string(from: bookingTime)
    }
    
    let customerEmail = Auth.auth().currentUser?.email
    
    // MAKE BOOKING FUNCTION
    
    func makeBooking() {
        
        let bookingDetails: [String: Any] = [
            "customerFullName" : "\(customerName)",
            "customerContactNumber" : "\(customerContactNumber)",
            "bookingDate" : "\(formattedDate)",
            "bookingTime" : "\(formattedTime)",
            "numberOfPeople" : "\(numberOfPeople)",
            "noteForBusiness" : "\(noteForBusiness)",
            "businessName" : "\(businessName)",
            "businessEmail" : "\(businessEmail)",
            "customerEmail" : "\(customerEmail!)",
            "businessAddress" : "\(businessAddress)"
     
     ]
        Firestore.firestore().collection("Booking Lists").document("\(customerEmail!) in \(businessEmail)").setData(bookingDetails)
        {
         err in
            if err != nil {
                print("Error Booking")
            }
            else {
                print("Booked with \(customerEmail!)")
            }
        }
        
        
        
    }
    
}
