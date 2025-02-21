//
//  CryptoRowView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import SwiftUI

struct CryptoRowView: View {
    let crypto: CoinGeckoCrypto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top row: Coin Name & Current Price
            HStack {
                Text(crypto.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                if let price = crypto.currentPrice {
                    let formattedPrice = NumberFormatter.priceFormatter.string(from: NSNumber(value: price)) ?? "N/A"
                    Text("$\(formattedPrice)")
                        .font(.headline)
                        .foregroundColor(.primary)
                } else {
                    Text("N/A")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            // Bottom row: Symbol & 24h Change
            HStack {
                Text(crypto.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                if let change = crypto.priceChangePercentage24h {
                    Text("\(String(format: "%.2f", change))%")
                        .font(.subheadline)
                        .foregroundColor(change >= 0 ? .green : .red)
                } else {
                    Text("No data")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

struct CryptoRowView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCrypto = CoinGeckoCrypto(
            id: "btc",
            symbol: "btc",
            name: "Bitcoin",
            image: nil,
            currentPrice: 98312.29,
            marketCap: 12000000000,
            totalVolume: 500000000,
            priceChangePercentage24h: 1.46,
            marketCapRank: 1
        )
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            CryptoRowView(crypto: sampleCrypto)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
