//
//  ContentView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var portfolioManager = PortfolioManager()
    
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
                    .environmentObject(portfolioManager)
            }
            .tabItem {
                Label("Markets", systemImage: "chart.line.uptrend.xyaxis")
            }
            
            NavigationStack {
                ExchangesListView()
            }
            .tabItem {
                Label("Exchanges", systemImage: "building.columns")
            }
            
            NavigationStack {
                PortfolioView()
                    .environmentObject(portfolioManager)
            }
            .tabItem {
                Label("Portfolio", systemImage: "briefcase")
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

