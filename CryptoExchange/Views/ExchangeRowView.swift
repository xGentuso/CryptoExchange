//
//  ExchangeRowView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-21.
//

import SwiftUI

struct ExchangeRowView: View {
    let exchange: CoinGeckoExchange
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(exchange.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                if let country = exchange.country, !country.isEmpty {
                    Text(country)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("No country data")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            if let volume = exchange.tradeVolume24hBtc {
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
        let sampleExchange = CoinGeckoExchange(
            id: "binance",
            name: "Binance",
            country: "Cayman Islands",
            url: "https://www.binance.com",
            image: nil,
            trustScoreRank: 1,
            tradeVolume24hBtc: 350000.12
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

