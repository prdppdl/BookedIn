//
//  NewDashboardView.swift
//  BookedIn
//
//  Created by Ramchandra Poudel on 3/8/2024.
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

struct NewDashboardView: View {
    
    @State private var retrieveBusinessDetails = RetrievingBusinessDetails()
    @State private var retrieveBookingDetails = RetrievingBookingDetails()
    @State private var retrieveCustomerDetails = RetrievingCustomerDetails()
    @State private var currentUserEmail = Auth.auth().currentUser?.email
    @Binding public var isCustomerProfileTapped: Bool
    @State var isBusinessProfileTapped = false
    @State var makeBookingView: Bool = false
    @State var selectedBusinessName = ""
    @State var selectedBusinessEmail = ""
    @State var selectedBusinessAddress = ""
    @State var seeAllBusiness: Bool = false
    @State var seeAllBookings: Bool = false
    @State var profileView: Bool = false
    @State private var profilePhotoURL: String?
    @State private var activeTab: TabModel = .home
    @State private var isTabBarHidden: Bool = false
    @State private var saved = false
    let screenSize: CGRect = UIScreen.main.bounds
   
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if #available(iOS 18, *) {
                    TabView(selection: $activeTab) {
                        Tab.init(value: .home) {
                            
                            ZStack {
                                Color.color.ignoresSafeArea()
                                
                                ScrollView(.vertical, showsIndicators: false) {
                                    
                                    if screenSize.height > 667 && screenSize.height < 1080 {
                                        HStack {
                                           
                                            Text("Recommended places to you nearby")
                                                .font(.system(size: 13))
                                                .font(.subheadline)
                                                .foregroundStyle(.black)
                                                .offset(x: 10)
                                            Spacer()
                                            
                                        }
                                        .padding(.top, 100)
                                        
                                    }
                                    else {
                                        HStack {
                                            Text("Recommended places to you nearby")
                                                .font(.system(size: 13))
                                                .font(.subheadline)
                                                .foregroundStyle(.black)
                                                .offset(x: 10)
                                            Spacer()
                                
                                        }
                                        .padding(.top, 120)
                                    }
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        
                                        HStack {
                                            ForEach(retrieveBusinessDetails.businessDetails, id: \.self){ details in
                                                RoundedRectangle(cornerRadius: 20.0)
                                                    .containerRelativeFrame(.horizontal, count: 1, spacing: 15)
                                                    .foregroundStyle(Color.scroll)
                                                    .overlay {
                                                        HStack{
                                                            Spacer()
                                                        
                                                                Image("AppLogo")
                                                                    .resizable()
                                                                    .frame(width: 280 , height: 160)
                                                                    .clipShape(CustomCorner(radius: 20, corners: [.topRight, .bottomRight]))
                                                                    .overlay{
                                                                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.scroll.opacity(1.0)]), startPoint: .trailing, endPoint: .leading)
                                                                    }
                                                            
                                                        }
                                                        HStack {
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
                                                                            Button {
                                                                                
                                                                                
                                                                            } label: {
                                                                                Label("About \(details.businessName)", systemImage: "book.fill")
                                                                            }
                                                                           
                                                                        }
                                                                    } label: {
                                                                        Image(systemName: "ellipsis.circle")
                                                                            .foregroundStyle(Color.black)
                                                                            .padding(.trailing, 10)
                                                                        
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
                                                                        selectedBusinessAddress = details.businessAddress
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
                                                                    .padding(.bottom, 25)
                                                                   
                                                                    Spacer()
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                    }
                                                    .scrollTransition {content, phase in
                                                        content
                                                            .opacity(phase.isIdentity ? 1.0 : 0.3)
                                                            .scaleEffect(x: phase.isIdentity ? 1.0 : 0.8, y: phase.isIdentity ? 1.0 : 0.8)
                                                            .offset(y: phase.isIdentity ? 0 : 50)
                                                    }
                                                
                                                
                                            }
                                            
                                        }
                                        .scrollTargetLayout()
                                        
                                    }
                                    .shadow(color: Color.black.opacity(0.5), radius: 15)
                                    .contentMargins(10)
                                    .scrollTargetBehavior(.viewAligned)
                                    .frame(width: screenSize.width, height: 180)
                                    .offset(y: -15)
                                    .scrollContentBackground(.hidden)
                                    .padding(.top, 15)
                                    
                                   
                                   
                                    HStack {
                                        Text("Your current bookings")
                                            .font(.system(size: 13))
                                            .font(.subheadline)
                                            .foregroundStyle(.black)
                                            .offset(x: 10)
                                        
                                        Spacer()
                                        
                                    }
                                    
                                    
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
                                                                            await deleteBookingLists()
                                                                        }
                                                                        
                                                                        
                                                                    } label: {
                                                                        Label("Cancel Booking", systemImage: "xmark")
                                                                    }
                                                                }
                                                                else {
                                                                    Button {
                                                                        Task {
                                                                            await deleteBookingLists()
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
                                    
                                }
                                .frame(width: screenSize.width - 10)
                                .ignoresSafeArea(edges: .bottom)
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
                                                        Text("HELLO,")
                                                            .font(.system(size: 13))
                                                            .offset(x: 10, y: -20)
                                                            .foregroundStyle(Color.creamy)
                                                        Spacer()
                                                    }
                                                    HStack {
                                                        ForEach(retrieveCustomerDetails.customerDetails) {details in
                                                            Text("\(details.userName)")
                                                                .font(.system(size: 20))
                                                                .offset(x: 10, y: -20)
                                                                .foregroundStyle(Color.creamy)
                                                                .bold()
                                                            
                                                        }
                                                        Spacer()
                                                      
                                                        
                                                        
                                                    }
                                                    HStack {
                                                        Text("Today is \(Date().formatted(.dateTime.day().weekday().month()))")
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
                                    .onAppear {
                                        retrieveCustomerDetails.retrieveCustomerData(){}
                                        retrieveBusinessDetails.retrieveBusinessDetailsForCustomerBooking()
                                        retrieveBookingDetails.retrieveBooking()
                                       
                                        
                                    }
                                }
                                
                                .navigationDestination(isPresented: $makeBookingView) {
                                    MakeBookingView(businessName: $selectedBusinessName , businessEmail: $selectedBusinessEmail, businessAddress: $selectedBusinessAddress)
                                }
                                
                            }
                        }
                        
                        Tab.init(value: .search) {
                            
                            SeeAllBusiness()
                            
                        }
                        
                        Tab.init(value: .notifications) {
                            SeeAllBookings()
                              
                        }
                        
                        Tab.init(value: .settings) {
                            
                            Settings()
                              
                        }
                    }
                } else {
                    TabView(selection: $activeTab) {
                        HomeView()
                            .tag(TabModel.home)
                            .overlay {
                                if !isTabBarHidden {
                                    HideTabBar {
                                        isTabBarHidden = true
                                    }
                                }
                            }
                        
                        Text("Search")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.primary.opacity(0.07))
                            .tag(TabModel.search)
                        
                        Text("Notifications")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.primary.opacity(0.07))
                            .tag(TabModel.notifications)
                        
                        Text("Settings")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.primary.opacity(0.07))
                            .tag(TabModel.settings)
                    }
                }
            }
            
            CustomTabBar(activeTab: $activeTab)
        }
        
        
        
        
        
        
      
        
    
        .navigationBarBackButtonHidden(true)
        
    }
    
    
    public func convertSecondsToDHMS(seconds: Double) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let days = Int(seconds / (60 * 60 * 24))
        let hours1 = (seconds.truncatingRemainder(dividingBy: 60 * 60 * 24))
        let hours = Int(hours1 / (60 * 60))
        let minutes = Int((seconds.truncatingRemainder(dividingBy: 60 * 60)) / 60)
        let remainingSeconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        
        return (days, hours, minutes, remainingSeconds)
    }
    
    private func deleteBookingLists() async {
        do {
            let db = Firestore.firestore()
            try await db.collection("Booking Lists").document("\(currentUserEmail!) in \(selectedBusinessEmail)").delete()
            print("Successfully deleted")
        } catch {
            print("Error Deleting")
        }
    }
    
    public func retrieveImages() {
        
        Storage.storage().reference().child("Images/\(String(describing: currentUserEmail))/Profile Picture/profilepicture.jpg").downloadURL { (url, error) in
            if error != nil {
                
                
                
                return
            }
            profilePhotoURL = url?.absoluteString
        }
    }
}

#Preview {
    NewDashboardView(isCustomerProfileTapped: .constant(true))
}
