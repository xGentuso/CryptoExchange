//
//  HomeView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import SwiftUI

struct HomeView: View {
    @State private var globalData: GlobalStats? = nil
    @State private var isLoadingGlobalStats = true
    private let service = CoinPaprikaService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Welcome to")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                            Text("Crypto X")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                        
                        // Subtitle
                        Text("Track and learn about your favorite cryptocurrencies.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 30)
                            .multilineTextAlignment(.center)
                        
                        // Quick Stats Card
                        VStack(spacing: 16) {
                            Text("Global Market Stats")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            if isLoadingGlobalStats {
                                ProgressView("Loading global stats...")
                                    .padding()
                            } else if let data = globalData {
                                HStack(spacing: 16) {
                                    StatCardView(
                                        title: "Market Cap",
                                        value: shortScaleFormat(data.marketCapUsd ?? 0)
                                    )
                                    StatCardView(
                                        title: "24H Volume",
                                        value: shortScaleFormat(data.volume24hUsd ?? 0)
                                    )
                                }
                                HStack(spacing: 16) {
                                    StatCardView(
                                        title: "BTC Dominance",
                                        value: String(format: "%.1f%%", data.bitcoinDominancePercentage ?? 0)
                                    )
                                    StatCardView(
                                        title: "Coins",
                                        value: "\(data.cryptocurrenciesNumber ?? 0)"
                                    )
                                }
                            } else {
                                Text("Unable to load global stats.")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        
                        // CTA Button to Explore Markets
                        NavigationLink(destination: CryptoListView()) {
                            Text("Explore Markets")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { fetchGlobalStats() }
        }
    }
    
    private func fetchGlobalStats() {
        isLoadingGlobalStats = true
        service.fetchGlobalStats { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let global):
                    // NOTE: If your GlobalStats model is top-level,
                    // you can assign directly. Otherwise, if it has a nested "data" property,
                    // you'll do something like `self.globalData = global.data`.
                    self.globalData = global
                case .failure(let error):
                    print("Error fetching global stats:", error)
                }
                isLoadingGlobalStats = false
            }
        }
    }
    
    private func shortScaleFormat(_ value: Double) -> String {
        let absValue = abs(value)
        let sign = value < 0 ? "-" : ""
        switch absValue {
        case 1_000_000_000_000...:
            return "\(sign)\(String(format: "%.1f", absValue / 1_000_000_000_000))T"
        case 1_000_000_000...:
            return "\(sign)\(String(format: "%.1f", absValue / 1_000_000_000))B"
        case 1_000_000...:
            return "\(sign)\(String(format: "%.1f", absValue / 1_000_000))M"
        case 1_000...:
            return "\(sign)\(String(format: "%.1f", absValue / 1_000))K"
        default:
            return "\(sign)\(String(format: "%.1f", absValue))"
        }
    }
}

/// A reusable view for displaying a stat card.
struct StatCardView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
