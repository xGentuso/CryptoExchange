//
//  ContentView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import SwiftUI

struct ContentView: View {
    init() {
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.20, green: 0.30, blue: 0.55, alpha: 1.0)
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationStack {
                CryptoListView()
            }
            .tabItem {
                Label("Markets", systemImage: "chart.line.uptrend.xyaxis")
            }
            
            // New Exchanges tab
            NavigationStack {
                ExchangesListView()
            }
            .tabItem {
                Label("Exchanges", systemImage: "building.columns")
            }
        }
        .accentColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
