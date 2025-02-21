//
//  ExchangeDetailView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-21.
//

import SwiftUI

struct ExchangeDetailView: View {
    let exchange: Exchange

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text(exchange.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    // Info Card
                    VStack(alignment: .leading, spacing: 16) {
                        // WEBSITE
                        if let website = exchange.websiteUrl, !website.isEmpty {
                            DetailRowView(title: "Website", value: website)
                        } else {
                            DetailRowView(title: "Website", placeholder: "No website available.")
                        }
                        
                        // 24H VOLUME (USD)
                        if let volume = exchange.volume24hUsd {
                            DetailRowView(title: "24h Volume (USD)", value: shortFormat(volume))
                        } else {
                            DetailRowView(title: "24h Volume (USD)", placeholder: "No volume data.")
                        }
                        
                        // COUNTRY
                        if let country = exchange.country, !country.isEmpty {
                            DetailRowView(title: "Country", value: country)
                        } else {
                            DetailRowView(title: "Country", placeholder: "No country data.")
                        }
                    }
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Helper: Formats large numbers (e.g., 1.2B, 3.4M).
    private func shortFormat(_ number: Double) -> String {
        let absValue = abs(number)
        let sign = number < 0 ? "-" : ""
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

struct ExchangeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleExchange = Exchange(
            id: "binance",
            name: "Binance",
            country: "Cayman Islands",
            websiteUrl: "https://www.binance.com",
            logo: nil,
            volume24hUsd: 3367539450514.66 // example value in USD
        )
        NavigationStack {
            ExchangeDetailView(exchange: sampleExchange)
        }
    }
}
