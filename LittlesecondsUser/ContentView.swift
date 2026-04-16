//
//  ContentView.swift
//  LittlesecondsUser
//
//  Created by Ayodimeji on 14/04/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        MainTabView()
            .environmentObject(appState)
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            DiscoverViewV3()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }

            BookingsView()
                .tabItem {
                    Label("Bookings", systemImage: "calendar")
                }

            SavedView()
                .tabItem {
                    Label("Saved", systemImage: "heart")
                }

            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
        }
        .tint(.brandDarkGreen)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
