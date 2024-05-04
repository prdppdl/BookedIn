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
    let screenSize: CGRect = UIScreen.main.bounds
    @State private var coverPhotoURL: String?
    @State var selectedBusinessName = ""
    @State var selectedBusinessEmail = ""
    @State var makeBookingView: Bool = false
    
    var body: some View {
        VStack {
            
            
            
            
            
            
        }
        
        
    }
}
#Preview {
    SeeAllBusiness()
}
