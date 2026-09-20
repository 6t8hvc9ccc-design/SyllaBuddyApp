//
//  SyllaBuddyApp.swift
//  
//
//  Created by DMK on 20/09/2026.
//

import SwiftUI
 
@main
struct SyllaBuddyApp: App {
    @StateObject private var store = Store()
 
    init() {
        NotificationManager.shared.requestAuthorization()
    }
 
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}
 
