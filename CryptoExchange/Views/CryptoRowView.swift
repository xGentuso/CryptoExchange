//
//  CryptoRowView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import SwiftUI

struct CryptoRowView: View {
    let crypto: CryptoCurrency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top row: name and price in CAD
            HStack {
                Text(crypto.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                if let cadQuote = crypto.quotes["CAD"] {
                    // Use your decimal formatter (wherever it's declared)
                    if let formattedPrice = NumberFormatter.decimalFormatter
                        .string(from: NSNumber(value: cadQuote.price)) {
                        Text("CA$\(formattedPrice)")
                            .font(.headline)
                            .foregroundColor(.primary)
                    } else {
                        Text("N/A")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("N/A")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Bottom row: symbol and 24h change
            HStack {
                Text(crypto.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                if let cadQuote = crypto.quotes["CAD"] {
                    let change = cadQuote.percentChange24h
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
        let sampleQuote = CryptoCurrency.Quote(
            price: 140197.80,
            volume24h: 500000000,
            marketCap: 12000000000,
            percentChange24h: 2.4
        )
        let sampleCrypto = CryptoCurrency(
            id: "btc-bitcoin",
            name: "Bitcoin",
            symbol: "BTC",
            rank: 1,
            quotes: ["CAD": sampleQuote]
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
