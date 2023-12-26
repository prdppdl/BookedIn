//
//  SignInView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 26/12/2023.
//

import SwiftUI
import AVKit

struct HomepageView: View {
    
    @State private var currentMessageIndex = 0
    @State private var messages = ["Reserve.", "Relax.", "Revel.","Indulge in Flavorful Moments."]
    @State private var leftMessageIndex = 0
    @State private var leftCardViewMessage = ["Hungry?","Book","Eat"]
    @State private var rightMessageIndex = 0
    @State private var rightCardViewMessage = ["Selling Food?","Take Bookings","Earn"]
    @State private var isPopoverTrue = false
    @State private var isJoinViewTrue = false
    @State private var isSkipTapped = false
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    Spacer()
                    Text("BookedIn.")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundStyle(.accent)
                        .shadow(radius: 10)
                    Text("\(messages[currentMessageIndex])")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .shadow(radius: 5)
                    HStack{
                        VStack{
                            Color.color
                            
                        }
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                        .shadow(radius: 15)
                        .overlay(
                            VStack{
                                Image(systemName: "fork.knife")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.accentColor)
                                Text("\(leftCardViewMessage[leftMessageIndex])")
                                    .fontWeight(.bold)
                                    .font(.system(size: 17))
                                Text("I'm looking for place to eat")
                                
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                            
                        )
                        .onTapGesture {
                            isPopoverTrue = true
                        }
                        
                        .padding()
                        VStack{
                            Color.color
                        }
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                        .shadow(radius: 15)
                        .overlay(
                            VStack{
                                Image(systemName: "calendar")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.accent)
                                Text("\(rightCardViewMessage[rightMessageIndex])")
                                    .fontWeight(.bold)
                                    .font(.system(size: 17))
                                Text("I'd Like to offer food to eaters")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                                
                            })
                        .onTapGesture {
                            isPopoverTrue = true
                        }
                        .fullScreenCover(isPresented: $isPopoverTrue, content: {
                            SignInView()
                        })
                    }
                    HStack{
                        Text("Join")
                            .foregroundStyle(.accent)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .onTapGesture {
                                isJoinViewTrue = true
                            }
                            .fullScreenCover(isPresented: $isJoinViewTrue, content: {
                                JoinView()
                            })
                            .padding(.leading)
                        Spacer()
                        
                        Text("Skip")
                            .onTapGesture {
                                isSkipTapped = true
                            }
                            .foregroundStyle(.accent)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.trailing)
                        NavigationLink(destination: DashboardViewCustomer(), isActive: $isSkipTapped){}
                    }
                }
                .onAppear{
                    
                    startTiming()
                    
                }
            }
        }
     
    }
   private func startTiming() {
        Timer.scheduledTimer(withTimeInterval: 2.25, repeats: true) { timer in
            currentMessageIndex = (currentMessageIndex + 1) % messages.count
            leftMessageIndex = (currentMessageIndex + 1) % leftCardViewMessage.count
            rightMessageIndex = (currentMessageIndex + 1) % rightCardViewMessage.count
        }
    }
}

#Preview {
    HomepageView()
}

