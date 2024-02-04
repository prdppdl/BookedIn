//
//  UserData.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 30/12/2023.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseAuth
import FirebaseCore

//CustometDATA


class CustomerDetails: Identifiable, Codable, Hashable, Equatable {
    
    let userName: String
    let userEmail: String
    let contactNumber: String
    let joinedDate: String
    
    init(userName: String, userEmail: String, contactNumber: String, joinedDate: String) {
        self.userName = userName
        self.userEmail = userEmail
        self.contactNumber = contactNumber
        self.joinedDate = joinedDate
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(userName)
        hasher.combine(contactNumber)
        hasher.combine(userEmail)
        hasher.combine(joinedDate)
    }
    static func == (lhs: CustomerDetails, rhs: CustomerDetails) -> Bool {
        return lhs.id == rhs.id &&
        lhs.userName == rhs.userName &&
        lhs.contactNumber == rhs.contactNumber &&
        lhs.userEmail == rhs.userEmail &&
        lhs.joinedDate == rhs.joinedDate
    }
    
}



class RetrievingCustomerDetails: ObservableObject {
    
    
    @Published var customerDetails = [CustomerDetails]()
    let uidd = Auth.auth().currentUser?.email
    var customerData: CustomerDetails?
  
    func retrieveCustomerData(completion: @escaping () -> Void) -> CustomerDetails? {
        
        Firestore.firestore().collection("Customer").document("\(uidd!)").getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                
                let userName = data["userName"] as? String ?? ""
                let userPhoneNumber = data["userContactNumber"] as? String ?? ""
                let userEmail = data["userEmail"] as? String ?? ""
                let joinedDate = data["joinedDate"] as? String ?? ""
                print("Document data: \(data)")
                
                self.customerData = CustomerDetails(userName: userName, userEmail: userEmail, contactNumber: userPhoneNumber, joinedDate: joinedDate)
                self.customerDetails = [self.customerData!]
                completion()
            } else {
                print("Document does not exist")
            }
        }
        return customerData
        
    }
    
}


//Business DATA

class BusinessDetails: Identifiable, Codable, Hashable, Equatable {
    
    let businessName: String
    let businessContactNumber: String
    let businessAddress: String
    let businessABN: String
    let businessEmail: String
    
    init(businessName: String, businessContactNumber: String, businessAddress: String, businessABN: String, businessEmail: String) {
        self.businessName = businessName
        self.businessContactNumber = businessContactNumber
        self.businessAddress = businessAddress
        self.businessABN = businessABN
        self.businessEmail = businessEmail
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(businessName)
        hasher.combine(businessContactNumber)
        hasher.combine(businessAddress)
        hasher.combine(businessABN)
        hasher.combine(businessEmail)
    }
    static func == (lhs: BusinessDetails, rhs: BusinessDetails) -> Bool {
        return lhs.id == rhs.id &&
        lhs.businessName == rhs.businessName &&
        lhs.businessContactNumber == rhs.businessContactNumber &&
        lhs.businessABN == rhs.businessABN &&
        lhs.businessAddress == rhs.businessAddress &&
        lhs.businessEmail == rhs.businessEmail
    }
    
}

class RetrievingBusinessDetails: ObservableObject {
    
    @Published var businessDetails = [BusinessDetails]()
    let uidd = Auth.auth().currentUser?.email
    var businessData: BusinessDetails?
    

    
    
    func retrieveBusinessData(completion: @escaping () -> Void) -> BusinessDetails? {
        
        Firestore.firestore().collection("Business").document("\(uidd!)").getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                let businessName = data["userName"] as? String ?? ""
                let businessContactNumber = data["userContactNumber"] as? String ?? ""
                let businessAddress = data["userAddress"] as? String ?? ""
                let businessABN = data["userABN"] as? String ?? ""
                let businessEmail = data["userEmail"] as? String ?? ""
                print("Document data: \(data)")
                
                self.businessData = BusinessDetails(businessName: businessName, businessContactNumber: businessContactNumber, businessAddress: businessAddress, businessABN: businessABN, businessEmail: businessEmail)
                self.businessDetails = [self.businessData!]
                completion()
            } else {
                print("Document does not exist")
            }
        }
        return businessData
        
    }
    
    
    func retrieveBusinessDetailsForCustomerBooking(){
        
        Firestore.firestore().collection("Business").addSnapshotListener { (snapshot, err) in
            guard let data = snapshot?.documents else {
                print(err!)
                return

            }
            self.businessDetails = data.map { (snapshot) -> BusinessDetails in
                let data = snapshot.data()
                let businessName = data["userName"] as? String ?? ""
                let businessContactNumber = data["userContactNumber"] as? String ?? ""
                let businessAddress = data["userAddress"] as? String ?? ""
                let businessEmail = data["userEmail"] as? String ?? ""
                let businessABN = data["userABN"] as? String ?? ""
                return BusinessDetails(businessName: businessName, businessContactNumber: businessContactNumber, businessAddress: businessAddress, businessABN: businessABN, businessEmail: businessEmail)

            }



        }

    }
    
    
}


//BOOKING DATA


class BookingDetails: Identifiable {
    
    let customerName: String
    let customerContactNumber: String
    let bookingTime: String
    let bookingDate: String
    let numberOfPeople: Int
    let customerEmail: String
    let businessEmail: String
    let businessName: String
    
    init(customerName: String, customerContactNumber: String, bookingTime: String, bookingDate: String, numberOfPeople: Int, customerEmail: String, businessEmail: String, businessName: String) {
        self.customerName = customerName
        self.customerContactNumber = customerContactNumber
        self.bookingTime = bookingTime
        self.bookingDate = bookingDate
        self.numberOfPeople = numberOfPeople
        self.customerEmail = customerEmail
        self.businessEmail = businessEmail
        self.businessName = businessName
    }
    
    
}



class RetrievingBookingDetails: ObservableObject {
    
    @Published var bookingDetails = [BookingDetails]()
    
    func retrieveBooking() {
        
        
        Firestore.firestore().collection("Booking Lists").addSnapshotListener { (snapshot, err) in
            guard let data = snapshot?.documents else {
                print(err!)
                return
                
            }
            self.bookingDetails = data.map { (snapshot) -> BookingDetails in
                let data = snapshot.data()
                let customerName = data["personFullname"] as? String ?? ""
                let customerContactNumber = data["customerPhoneNumber"] as? String ?? ""
                let bookingTime = data["bookingTime"] as? String ?? ""
                let bookingDate = data["bookingDate"] as? String ?? ""
                let numberOfPeople = data["numberOfPeople"] as? Int ?? 0
                let customerEmail = data["customerEmail"] as? String ?? ""
                let businessEmail = data["businessEmail"] as? String ?? ""
                let businessName = data["businessName"] as? String ?? ""
                return BookingDetails(customerName: customerName, customerContactNumber: customerContactNumber, bookingTime: bookingTime, bookingDate: bookingDate, numberOfPeople: numberOfPeople, customerEmail: customerEmail, businessEmail: businessEmail, businessName: businessName)
                
            }
            
            
            
        }
        
    }
    
}
