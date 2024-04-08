//
//  BusinessDetailsView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/3/2024.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

struct BusinessDetailsView: View {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    
    var body: some View {
        VStack{
            Image("AppLogo")
                .resizable()
                .frame(width: screenSize.width, height: 250)
                .ignoresSafeArea(.all, edges: .top)
                
            RoundedRectangle(cornerRadius: 20)
                
                .frame(width: screenSize.width, height: .infinity)
                .foregroundStyle(Color.color)
               
                .offset(y: -80)
                .overlay {
                    VStack {
                        Text("About (businessName)")
                            .foregroundStyle(Color.accentColor)
                            .bold()
                            .font(.title3)
                            .offset(y: -50)
                            .padding(.bottom)
                        
                        Text("Description of business")
                            .foregroundStyle(Color.black)
                            .fontDesign(.default)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
                
            
        }
       
        .background(Color.color)
        .navigationBarItems(leading: CustomBackButton())
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    BusinessDetailsView()
}
    
    

struct MenuPage: View {
    var body: some View {
        VStack{
            
        }
    }
}

#Preview {
    MenuPage()
}
