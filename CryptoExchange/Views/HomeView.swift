//
//  HomeView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import SwiftUI

struct HomeView: View {
    @State private var globalStats: GlobalStats? = nil
    @State private var isLoadingGlobalStats = true
    private let cryptoService = CryptoService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Header
                        VStack(spacing: 8) {
                            Text("Welcome to")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                            Text("Crypto Nexus")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                        
                        // MARK: - Subtitle
                        Text("Track and learn about your favorite cryptocurrencies.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 30)
                            .multilineTextAlignment(.center)
                        
                        // MARK: - Logo
                        Image("crypto_logo") // Replace with your asset name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                            .padding(.vertical, 5)
                        
                        // MARK: - Quick Stats
                        VStack(spacing: 16) {
                            Text("Quick Stats")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            if isLoadingGlobalStats {
                                ProgressView("Loading global stats...")
                                    .padding()
                            } else if let stats = globalStats {
                                HStack(spacing: 16) {
                                    StatCardView(
                                        title: "Market Cap",
                                        value: shortScaleFormat(stats.marketCapUsd)
                                    )
                                    StatCardView(
                                        title: "24H Volume",
                                        value: shortScaleFormat(stats.volume24hUsd)
                                    )
                                }
                                HStack(spacing: 16) {
                                    StatCardView(
                                        title: "BTC Dominance",
                                        value: String(format: "%.1f%%", stats.bitcoinDominancePercentage)
                                    )
                                    StatCardView(
                                        title: "Coins",
                                        value: "\(stats.cryptocurrenciesNumber)"
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
                        
                        // MARK: - CTA Button
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
                        .padding(.bottom, 20) // Adjust if you need more/less space
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchGlobalStats()
            }
        }
    }
    
    // MARK: - Fetch Global Stats
    private func fetchGlobalStats() {
        isLoadingGlobalStats = true
        cryptoService.fetchGlobalStats { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stats):
                    self.globalStats = stats
                case .failure(let error):
                    print("Error fetching global stats:", error)
                }
                self.isLoadingGlobalStats = false
            }
        }
    }
    
    // MARK: - Short Scale Number Formatting
    /// Converts large numbers into short scale strings like "3.3T", "2.1B", "5.6M", etc.
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
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
