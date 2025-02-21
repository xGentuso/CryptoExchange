//
//  ExchangeRowView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-21.
//

import SwiftUI

struct ExchangeRowView: View {
    let exchange: Exchange
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(exchange.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                if let countries = exchange.countries, !countries.isEmpty {
                    Text(countries.joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("No country data")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            if let volume = exchange.volume24h {
                Text("Vol: \(shortFormat(volume))")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            } else {
                Text("No volume")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
    
    /// Formats large numbers (e.g., 1.2B, 3.4M).
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

struct ExchangeRowView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleExchange = Exchange(
            id: "binance",
            name: "Binance",
            websiteURL: "https://www.binance.com",
            volume24h: 1234567890,
            volume24hChange: 5.2,
            countries: ["Cayman Islands", "Malta"]
        )
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            ExchangeRowView(exchange: sampleExchange)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
