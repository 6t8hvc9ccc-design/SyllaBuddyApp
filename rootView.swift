//
//  rootView.swift
//  
//
//  Created by DMK on 20/09/2026.
//

import SwiftUI
 
struct RootView: View {
    var body: some View {
        TabView {
            EventsView()
                .tabItem { Label("Deadlines", systemImage: "calendar") }
            CoursesView()
                .tabItem { Label("Courses", systemImage: "books.vertical.fill") }
        }
        .tint(Color(hex: "2563EB"))
    }
}
 
