//
//  TermsOfServiceView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 5/11/2025.
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ZStack{
            Color.color.ignoresSafeArea(edges: .all)
            VStack{
                Text("Terms of Service Page")
            }
        }
        .navigationTitle(Text("Terms of Service"))
    }
}

#Preview {
    TermsOfServiceView()
}
