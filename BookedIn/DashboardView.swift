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
import WeatherKit
import SDWebImageSwiftUI
import Combine

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
    @ObservedObject var currentWeather = CurrentWeather()
    @StateObject var locationManager = LocationManager()
    @State private var weather: Weather?
    let screenSize: CGRect = UIScreen.main.bounds
    @State private var isAnimatingLeft = false
    @State private var isAnimatingRight = false
    @State var aboutBusinessPage: Bool = false
    @State private var coverPhotoURL: String?
    @State var seeAllBusiness: Bool = false
    private var animation : Animation {
        .linear(duration: 25)
        .repeatForever(autoreverses: true)
    }
    @State var currentTemp = ""
    @State var symbol = ""
    var body: some View {
        
        VStack {
            //CUSTOMER DAHSBOARD
            VStack {
                
                RoundedRectangle(cornerRadius: 40.0)
                    .frame(width: screenSize.width, height: 200)
                    .foregroundStyle(Color.accentColor)
                    .shadow(color: Color.black.opacity(1), radius: 15)
                    .overlay {
                        VStack {
                            Spacer()
                            HStack{
                                
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.black)
                                    .shadow(radius: 10)
                                    
                                    .onTapGesture {
                                        isProfileTapped = true
                                    }
                                Spacer()
                                Text("\(messages[currentMessageIndex])")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.black)
                                    .shadow(radius: 10)
                                Spacer()
                                
                                Image(systemName: "ellipsis.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                                    .shadow(radius: 10)
                            }
                            .offset(y: 20)
                            .onAppear{
                                startTiming()
                                retrieveCustomerDetails.retrieveCustomerData {}
                                retrieveBusinessDetails.retrieveBusinessDetailsForCustomerBooking()
                                retrieveBookingDetails.retrieveBooking()
                                isAnimatingLeft.toggle()
                                isAnimatingRight.toggle()
                                
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            
                            ForEach(retrieveCustomerDetails.customerDetails, id: \.self){ details in
                                Text("G'day, \(details.userName)")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.black)
                                    .padding(.bottom, 15)
                                    .offset(y: 20)
                            }
                        
                           
                            VStack {
                            HStack {
                                        Image(systemName: "cloud.fill")
                                            .resizable()
                                            .frame(width: 50, height: 30)
                                            .offset(x: isAnimatingLeft ? 20 : 50, y: 25)
                                            .foregroundStyle(Color.skyBlue)
                                            .shadow(radius: 20)
                                            .animation(animation)
                                        
                                        Image(systemName: "cloud.fill")
                                            .resizable()
                                            .frame(width: 50, height: 30)
                                            .offset(x: isAnimatingRight ? -20 : 60, y: 25)
                                            .foregroundStyle(Color.skyBlue)
                                            .shadow(radius: 20)
                                            .animation(animation)
                                        
                                        Image(systemName: "cloud.fill")
                                            .resizable()
                                            .frame(width: 50, height: 30)
                                            .offset(x: -30, y: 25)
                                            .foregroundStyle(Color.skyBlue)
                                            .shadow(radius: 20)
                                    
                                    Spacer()
                                
                                    Image(systemName: "\(symbol).fill")
                                        .resizable()
                                        .frame(width: 50, height: 30)
                                        .offset(x: -50, y: 27)
                                        .foregroundStyle(Color.yellow)
                                        .shadow(radius: 20)
                                
                                }
                                .frame(height: 30)
                                
                                RoundedRectangle(cornerRadius: 25.0)
                                    .frame(width: screenSize.width - 90, height: 50)
                                    .foregroundStyle(Color.bar)
                                    .shadow(color: Color.black.opacity(0.5), radius: 15)
                                    .overlay {
                                        HStack {
                                            Text(Date().formatted(.dateTime.day().weekday().month()))
                                                .font(.system(size: 15))
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                                .padding(.leading, 20)
                                            
                                            
                                            Spacer()
                                         
                                                Text("\(currentTemp)")
                                                    .font(.system(size: 15))
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)
                                                    .padding(.trailing, 20)
                                            
                                        }
                                      
                                    }
                                    .offset(y: 10)
                                    .task{
                                        await currentWeather.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                                    }
                            }
                            
                        }
                    }
                
                    .ignoresSafeArea(.all, edges: .top)
                
                HStack {
                    Text("Recommended places to you nearby")
                        .font(.system(size: 13))
                        .font(.subheadline)
                        .foregroundStyle(.black)
                        .padding(.leading, 20)
                        .offset(y: -15)
                    Spacer()
                }
                
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
                                    
                                    if let urlimage = coverPhotoURL {
                                        WebImage(url: URL(string: urlimage))
                                            .resizable()
                                            .frame(width: 280 , height: 160)
                                            .clipShape(CustomCorner(radius: 20, corners: [.topRight, .bottomRight]))
                                            .overlay{
                                                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.scroll.opacity(1.0)]), startPoint: .trailing, endPoint: .leading)
                                            }
                                    }
                                    else {
                                        Image("AppLogo")
                                            .resizable()
                                            .frame(width: 280 , height: 160)
                                            .clipShape(CustomCorner(radius: 20, corners: [.topRight, .bottomRight]))
                                            .overlay{
                                                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.scroll.opacity(1.0)]), startPoint: .trailing, endPoint: .leading)
                                            }
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
                                                        Label("Go to \(details.businessName)", systemImage: "location.fill")
                                                    }
                                                    Button {} label: {
                                                        Label("View Menu", systemImage: "newspaper.fill")
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
                                .onAppear{
                                    retrieveCoverImages()
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
            
            
            NavigationLink(destination: MakeBookingView(businessName: $selectedBusinessName , businessEmail: $selectedBusinessEmail), isActive: $makeBookingView){}
            NavigationLink(destination: ProfileView(isCustomerProfile: $isCustomerProfileTapped, isBusinessProfile: $isBusinessProfileTapped), isActive: $isProfileTapped){}
            
            NavigationLink(destination: SeeAllBusiness(), isActive: $seeAllBusiness){}
            
            
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 30)
                    .foregroundStyle(Color.color)
                    .shadow(color: Color.accentColor.opacity(0.9), radius: 10)
                    .offset(x: -15)
                    .padding(.bottom, 5)
                    .overlay{
                        Text("See all")
                            .bold()
                            .font(.system(size: 12))
                            .font(.subheadline)
                            .foregroundStyle(.black)
                            .offset(x: -15)
                            .padding(.bottom, 5)
                    }
                    .onTapGesture {
                        self.seeAllBusiness = true
                    }
            }
            
            
            VStack {
                HStack {
                    Text("Your current bookings")
                        .font(.system(size: 12))
                        .font(.subheadline)
                        .foregroundStyle(.black)
                        .padding(.vertical,15)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
               
            }
            
            
            Spacer()
            
            
            
        }
        .background(Color.color)
        .navigationBarBackButtonHidden(true)
    }
    
    private func startTiming() {
        Timer.scheduledTimer(withTimeInterval: 2.25, repeats: true) { timer in
            currentMessageIndex = (currentMessageIndex + 1) % messages.count
            
        }
        
    }
    
    func retrieveCoverImages() {
            
            Storage.storage().reference().child("Images/\(String(describing: selectedBusinessEmail))/Cover Picture/coverpicture.jpg").downloadURL { (url, error) in
                if error != nil {
                    
                    
                    
                    return
                }
                coverPhotoURL = url?.absoluteString
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
                Text(Date().formatted(.dateTime.day().weekday().month()))
                    .fontWeight(.semibold)
                    .font(.system(size: 15))
                    .font(.subheadline)
                    .padding(.leading, 20)
                
                Spacer()
                
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


#Preview {
    DashboardViewCustomer(isCustomerProfileTapped: .constant(true))
}
