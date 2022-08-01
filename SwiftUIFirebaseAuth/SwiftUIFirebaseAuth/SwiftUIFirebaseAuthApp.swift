//
//  SwiftUIFirebaseAuthApp.swift
//  SwiftUIFirebaseAuth
//
//  Created by 김태성 on 2022/07/31.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct SwiftUIFirebaseAuthApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            ContentView()
                .environmentObject(viewModel)
                .preferredColorScheme(.dark)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}
