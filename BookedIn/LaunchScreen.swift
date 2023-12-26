//
//  ContentView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 26/12/2023.
//

import SwiftUI

struct LaunchScreen: View {
    @State var isActive:Bool = false
    @State var messageLabel = " Checking For Update..."
    @State var checkingForUpdate = true
    @State var fadeInAnimation = false
    
    var body: some View {
        ZStack {
            Color.color.ignoresSafeArea()
            if self.isActive {
                HomepageView()
            }
            else {
                VStack {
                    
                    
                    Image("AppLogo")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                        .shadow(radius: 30)
                    ProgressView()
                        .padding(.vertical)
                    
                    Text("\(messageLabel)")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                    
                }
                .onAppear {
                    
                    fadeInAnimation = true
                    startTiming()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.25) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
            
        }
    }
    func startTiming() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            if checkingForUpdate {
                self.messageLabel = "Launching App..."
            }
            timer.invalidate()
        }
        
    }
}



#Preview {
    LaunchScreen()
}
