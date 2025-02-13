//
//  Settings.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/2/2025.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


struct Settings: View {
    
    @State var showNotifications: Bool = true
    let screenSize: CGRect = UIScreen.main.bounds
    @State var bellImage: String = "bell.fill"
    @State private var retrieveCustomerDetails = RetrievingCustomerDetails()
    @State private var emailIsVerified: Bool = false
    @State private var  inviteFriendView: Bool = false
    var body: some View {
        ZStack{
            Color.creamy.edgesIgnoringSafeArea(.all)
            VStack{
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
                                    Text("SETTINGS")
                                        .font(.system(size: 19))
                                        .bold()
                                        .offset(x: 10, y: -20)
                                        .foregroundStyle(Color.creamy)
                                    Spacer()
                                }
                                HStack {
                                    Text("Here you can find preferences and settings for your account.")
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
                    
                    
                VStack(alignment: .center){
                    ForEach(retrieveCustomerDetails.customerDetails){ details in
                        HStack{
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.accent)
                            
                            
                    Text("\(details.userName) \(details.userLastName)")
                                .bold()
                                .font(.system(size: 17))
                                .foregroundStyle(.accent)
                        }
                        
                        HStack {
                            if emailIsVerified == true {
                                Image(systemName: "e.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.accentColor)
                                
                            }
                            else {
                                Image(systemName: "e.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.gray)
                                
                            }
                            Text("\(details.userEmail)")
                                .font(.system(size: 15))
                                .font(.subheadline)
                                .foregroundStyle(.black)
                            
                        }
                        Text("Member Since: \(details.joinedDate)")
                            .font(.system(size: 12))
                            .font(.subheadline)
                            .foregroundStyle(.black)
                    }
                    
                }
                .onAppear{
                    retrieveCustomerDetails.retrieveCustomerData{}
                    emailVerifier()
                }
                        NavigationView {
                                List {
                                   
                                    Section(header: Text("My BookedIns").foregroundStyle(.gray)) {
                                     
                                         Label {
                                             Text("Invite a Friend")
                                                 .foregroundColor(.black) // Set text color to black
                                         } icon: {
                                             Image(systemName: "person.badge.plus.fill")
                                                 .foregroundColor(Color.accentColor) // Set icon color to green
                                         }
                                         .onTapGesture {
                                             inviteFriendView.toggle()
                                         }
                                   .sheet(isPresented: $inviteFriendView) {
                                        ShareSheet(items: [
                                            "Check out BookedIn! It's a great app for managing your bookings.",
                                            URL(string: "https://www.apple.com")!
                                        ])
                                    }
                                    
                                        
                                        NavigationLink(destination: SavedPlacesView()) {
                                            Label{
                                                Text("Visited Places")
                                                    .foregroundStyle(.black)
                                            } icon: {
                                                Image(systemName: "bookmark.fill")
                                                    .foregroundColor(Color.accentColor)
                                            }
                                               
                                        }
                                   
                                          
                                      }
                                  .listRowBackground(Color.creamy)
                                
                               
                                  

                                  Section(header: Text("Account").foregroundStyle(.gray)) {
                                      NavigationLink(destination: AccountSettingsView()) {
                                          Label{
                                              Text("Account Settings")
                                                  .foregroundStyle(.black)
                                          } icon: {
                                              Image(systemName: "person.fill")
                                                  .foregroundColor(Color.accentColor)
                                          }
                                            
                                      }
                                     
                                      Button(action: handleLogout) {
                                          Label("Logout", systemImage: "arrow.right.circle.fill")
                                              .foregroundStyle(Color.red)
                                      }
                                      
                                  }
                                  .listRowBackground(Color.creamy)
                                
                         
                                    
                                    
                                  Section(header: Text("Notifications").foregroundStyle(.gray)) {
                                      HStack {
                                                  Toggle(isOn: $showNotifications.animation()) { // Smooth animation for toggle state change
                                                      Label {
                                                          Text("Enable Push Notifications")
                                                              .foregroundStyle(.black)
                                                      } icon: {
                                                          Image(systemName: showNotifications ? "bell.fill" : "bell.slash.fill")
                                                              .foregroundStyle(showNotifications ? .green : .red)
                                                              .rotationEffect(.degrees(showNotifications ? 0 : -20)) // Subtle rotation for slash effect
                                                              .opacity(showNotifications ? 1 : 0.8) // Slight opacity change
                                                              .animation(.easeInOut(duration: 0.3), value: showNotifications) // Animate icon change
                                                      }
                                                  }

                                              }
                             
                                      
                                  }
                                  .listRowBackground(Color.creamy)
                          
                                    
                                    
                                  Section(header: Text("Privacy").foregroundStyle(.gray)) {
                                      NavigationLink(destination: TermsOfServiceView()) {
                                          Label{
                                              Text("Terms of Service")
                                                  .foregroundStyle(.black)
                                          } icon: {
                                              Image(systemName: "text.document.fill")
                                                  .foregroundStyle(Color.accentColor)
                                          }                                      }
                                      NavigationLink(destination: PrivacyPolicyView()) {
                                          Label{
                                              Text("Privacy Policy")
                                                  .foregroundStyle(.black)
                                          }icon: {
                                              Image(systemName: "lock.fill")
                                                  .foregroundStyle(Color.accentColor)
                                          }
                                      }
                                  }
                                  .listRowBackground(Color.creamy)
                               
                                  
                              }
                               

                                .shadow(color: Color.black.opacity(0.3), radius: 10)
                                .background(Color.creamy)
                    .scrollContentBackground(.hidden)
                    
                    
                }
                    
                }
            }
         
        
    }
    
    //MARK: THIS FUNCTION HANDLES THE USER AUTHENTICATION LOGGING OUT
    
    func handleLogout() {
          print("Logging out...")
      }
    
    //MARK: THIS FUNCTION VERIFIES IF USER VERIFIED THEIR EMAIL OR NOT
    
    func emailVerifier(){
        
        guard let user = Auth.auth().currentUser else {
            
            return
        }
        if user.isEmailVerified {
            emailIsVerified = true
        }
        else {
            emailIsVerified = false
        }
        
        
    }
}

#Preview {
    Settings()
}


// Sample destination views

struct SavedPlacesView: View {
    var body: some View {
        Text("Saved Places Page")
            .navigationTitle("Saved Places")
    }
}

struct AccountSettingsView: View {
    var body: some View {
        Text("Account Settings Page")
            .navigationTitle("Account Settings")
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        Text("Terms of Service Page")
            .navigationTitle("Terms of Service")
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        Text("Privacy Policy Page")
            .navigationTitle("Privacy Policy")
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
