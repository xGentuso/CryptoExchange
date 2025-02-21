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
            // MARK: - Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Header
                    Text(exchange.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    // MARK: - Info Card
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // WEBSITE
                        if let website = exchange.websiteURL, !website.isEmpty {
                            DetailRowView(
                                title: "Website",
                                value: website
                            )
                        } else {
                            DetailRowView(title: "Website", placeholder: "No website available.")
                        }
                        
                        // 24H VOLUME
                        if let volume = exchange.volume24h {
                            DetailRowView(
                                title: "24h Volume",
                                value: shortFormat(volume)
                            )
                        } else {
                            DetailRowView(title: "24h Volume", placeholder: "No 24h volume data.")
                        }
                        
                        // COUNTRIES
                        if let countries = exchange.countries, !countries.isEmpty {
                            DetailRowView(
                                title: "Countries",
                                value: countries.joined(separator: ", ")
                            )
                        } else {
                            DetailRowView(title: "Countries", placeholder: "No country data.")
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
    
    /// Formats large numbers into short scale, e.g., 1.2B, 3.4M.
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
            return "\(sign)\(absValue)"
        }
    }
}

struct ExchangeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleExchange = Exchange(
            id: "bcp-go",
            name: "BCP GO",
            websiteURL: "",
            volume24h: nil,
            volume24hChange: nil,
            countries: nil
        )
        
        NavigationStack {
            ExchangeDetailView(exchange: sampleExchange)
        }
    }
}
