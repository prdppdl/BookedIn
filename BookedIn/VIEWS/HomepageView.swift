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
    @State private var rightCardViewMessage = ["Join the group","Wanna Eat?"]
    @State private var isCustomerSignInTapped = false
    @State private var isBusinessSignInTapped = false
    @State private var isPopoverTrue = false
    @State private var isJoinViewTrue = false
    let screenSize: CGRect = UIScreen.main.bounds
    @State private var player = AVPlayer()
    
    var body: some View {
        ZStack {
            //Background Video
            VideoPlayer(player: player)
                .ignoresSafeArea(.all)
                .aspectRatio(contentMode: .fill)
                .onAppear {
                    // Loop the video
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
                        self.restartVideo()
                    }
                }
            
            // Gradient Overlay
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundStyle(Color.accentColor)
                    .frame(width: screenSize.width, height: 150)
                    .offset(y: 355)
                    .ignoresSafeArea(.all, edges: .bottom)
                
                Text("BookedIn.")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundStyle(Color.accentColor)
                    .shadow(radius: 10)
                
                Text("\(messages[currentMessageIndex])")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .shadow(radius: 5)
                    .foregroundStyle(Color.color)
                HStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.color)
                        .frame(width: 150, height: 150)
                        .shadow(color: Color.black.opacity(1), radius: 10)
                        .overlay(
                            VStack{
                                Image(systemName: "fork.knife")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.accentColor)
                                Text("\(leftCardViewMessage[leftMessageIndex])")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 17))
                                Text("I'm looking for place to eat")
                                
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            })
                        .onTapGesture {
                            isPopoverTrue = true
                            isCustomerSignInTapped = true
                        }
                    
                        .padding()
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.color)
                        .shadow(color: Color.black.opacity(1), radius: 10)
                        .frame(width: 150, height: 150)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.accentColor)
                                
                                Text(rightCardViewMessage[rightMessageIndex])
                                    .fontWeight(.bold)
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color.black)
                                
                                Text("I'd Like to join a group")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        )
                        .onTapGesture {
                            //isPopoverTrue = true
                            isJoinViewTrue = true
                        }
                        .padding()
                       
                }
                
                    Text("Don't let yourself starve mate!")
                        .foregroundStyle(Color.color)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .background(Color.clear)
                        .padding(.bottom, 10)
                        .fullScreenCover(isPresented: $isJoinViewTrue, content: {
                            JoinView()
                        })
                        .fullScreenCover(isPresented: $isPopoverTrue, content: {
                            SignInView()
                        })
                
                
                
                
                
            }
            
            .onAppear{
                
                startTiming()
                playVideo()
            }
            
        }
        
        
        
    }
    private func startTiming() {
        Timer.scheduledTimer(withTimeInterval: 2.25, repeats: true) { timer in
            currentMessageIndex = (currentMessageIndex + 1) % messages.count
            leftMessageIndex = (leftMessageIndex + 1) % leftCardViewMessage.count
            rightMessageIndex = (rightMessageIndex + 1) % rightCardViewMessage.count
        }
    }
    
    private func playVideo() {
        guard let url = videoURL() else {return}
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player.play()
    }
    private func restartVideo() {
        guard videoURL() != nil else {return}
        player.seek(to: .zero)
        player.play()
    }
    private func videoURL() -> URL? {
        return Bundle.main.url(forResource: "backgroundVideo", withExtension: "mp4")
    }
    
}

#Preview {
    HomepageView()
}

