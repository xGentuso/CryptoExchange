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
            // Header: Coin Name and Current Price
            HStack {
                Text(crypto.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let usdQuote = crypto.quotes["USD"] {
                    // Format price with commas (e.g., 98,312.29)
                    let formattedPrice = NumberFormatter.priceFormatter.string(from: NSNumber(value: usdQuote.price)) ?? "N/A"
                    
                    Text("$\(formattedPrice)")
                        .font(.headline)
                        .foregroundColor(.primary)
                } else {
                    Text("N/A")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Footer: Symbol and 24h Change
            HStack {
                Text(crypto.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let usdQuote = crypto.quotes["USD"] {
                    let change = usdQuote.percentChange24h
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
        // We assume your CryptoCurrency.Quote is something like:
        // struct Quote {
        //    let price: Double
        //    let volume24h: Double
        //    let marketCap: Double
        //    let percentChange24h: Double
        // }
        
        let sampleCrypto = CryptoCurrency(
            id: "btc-bitcoin",
            name: "Bitcoin",
            symbol: "BTC",
            currentPrice: 98312.29,
            percentChange24h: 1.46,
            volume24h: 500_000_000,
            marketCap: 12_000_000_000
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
