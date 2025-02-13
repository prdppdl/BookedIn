//
//  SeeAllBookings.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 20/2/2025.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import WeatherKit
import SDWebImageSwiftUI
import Combine


struct SeeAllBookings: View {
    @State private var retrieveBookingDetails = RetrievingBookingDetails()
    let screenSize: CGRect = UIScreen.main.bounds
    @State var selectedBusinessEmail = ""
    @State private var currentUserEmail = Auth.auth().currentUser?.email
    
    var body: some View {
        ZStack {
            Color.creamy.edgesIgnoringSafeArea(.all)
            
            ScrollView (.vertical, showsIndicators: false) {
                ForEach(retrieveBookingDetails.bookingDetails) { details in
                    
                    RoundedRectangle(cornerRadius: 20.0)
                        .frame(width: screenSize.width - 20, height: 125)
                        .shadow(radius: 10)
                        .foregroundColor(.creamy)
                        .overlay {
                            VStack {
                                let currentDate = Date()
                                let futureDateString = "\(details.bookingDate) \(details.bookingTime)"
                                
                                let futureDate = futureDateFromString(futureDateString, format: "dd/MM/yyyy HH:mm")
                                let differenceDate = timeDifference(from: currentDate, to: futureDate!)
                                
                                
                                let (days, hours, minutes, remainingSeconds) = convertSecondsToDHMS(seconds: differenceDate)
                                
                                HStack {
                                    Text("At")
                                        .foregroundStyle(Color.black)
                                    Text("\(details.businessName)")
                                        .foregroundStyle(Color.black)
                                        .bold()
                                    Spacer()
                                    Menu {
                                        Section {
                                            if (days >= 0), (hours >= 0), (minutes >= 0), (remainingSeconds >= 0) {
                                                Button {
                                                    Task {
                                                        await deleteBookingListsFromBookedIns()
                                                    }
                                                    
                                                    
                                                } label: {
                                                    Label("Cancel Booking", systemImage: "xmark")
                                                }
                                            }
                                            else {
                                                Button {
                                                    Task {
                                                        await deleteBookingListsFromBookedIns()
                                                    }
                                                    
                                                } label: {
                                                    Label("Mark as Complete", systemImage: "checkmark")
                                                }
                                                
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis.circle")
                                            .foregroundStyle(Color.black)
                                            .padding(.trailing, 10)
                                        
                                    }
                                    .onTapGesture {
                                        selectedBusinessEmail = details.businessEmail
                                    }
                                }
                                .padding(.leading, 10)
                                
                                HStack {
                                    Text("Address:")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15))
                                    Text("\(details.businessAddress)")
                                        .foregroundStyle(Color.black)
                                        .bold()
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                                .padding(.leading, 10)
                                
                                
                                
                                
                                
                                
                                HStack {
                                    Text("Date:")
                                        .foregroundStyle(Color.black)
                                    Text("\(details.bookingDate)")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15))
                                        .bold()
                                    Text("Time:")
                                        .foregroundStyle(Color.black)
                                    Text("\(details.bookingTime)")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                    Text("\(days) days \(hours) hours remaining")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color.gray)
                                    
                                    
                                    
                                    Spacer()
                                }
                                .padding(.leading, 10)
                                
                                HStack {
                                    Text("For:")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15))
                                    Text("\(details.numberOfPeople)")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                    Spacer()
                                }
                                .padding(.leading, 10)
                                HStack {
                                    Text("Requirements:")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15))
                                    Text("\(details.noteForBusiness)")
                                        .foregroundStyle(Color.black)
                                        .font(.system(size: 15))
                                        .bold()
                                    Spacer()
                                }
                                .padding(.leading, 10)
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
                                    Text("ALREADY BOOKED FOR YOU")
                                        .font(.system(size: 19))
                                        .bold()
                                        .offset(x: 10, y: -20)
                                        .foregroundStyle(Color.creamy)
                                    Spacer()
                                }
                                HStack {
                                    Text("Here you can see places you booked with")
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
            
            .onAppear{
                retrieveBookingDetails.retrieveBooking()
            }
        }
    }
    public func convertSecondsToDHMS(seconds: Double) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let days = Int(seconds / (60 * 60 * 24))
        let hours1 = (seconds.truncatingRemainder(dividingBy: 60 * 60 * 24))
        let hours = Int(hours1 / (60 * 60))
        let minutes = Int((seconds.truncatingRemainder(dividingBy: 60 * 60)) / 60)
        let remainingSeconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        
        return (days, hours, minutes, remainingSeconds)
    }
    
    private func deleteBookingListsFromBookedIns() async {
        do {
            let db = Firestore.firestore()
            try await db.collection("Booking Lists").document("\(currentUserEmail!) in \(selectedBusinessEmail)").delete()
            print("Successfully deleted")
        } catch {
            print("Error Deleting")
        }
    }
}
