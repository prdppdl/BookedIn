//
//  BookedInApp.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/12/2023.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
@main
struct BookedInApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
     
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
            //DashboardViewCustomer()
        }
    }
}
