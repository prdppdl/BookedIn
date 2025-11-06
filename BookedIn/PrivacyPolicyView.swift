//
//  PrivacyPolicyView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 5/11/2025.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack{
            Color.color.ignoresSafeArea()
            
            VStack{
                Text("Privacy Policy")
            }
        }
        .navigationTitle(Text("Privacy Policy"))
    }
}

#Preview {
    PrivacyPolicyView()
}
