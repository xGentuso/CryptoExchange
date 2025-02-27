//
//  CryptoRowView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import SwiftUI

struct CryptoRowView: View {
    let crypto: CryptoCurrency
    @EnvironmentObject var portfolioManager: PortfolioManager
    @State private var showAddSheet = false
    @State private var amountText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(crypto.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(crypto.symbol.uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                // Display CAD price with SwiftUI's built-in specifier
                if let cadQuote = crypto.quotes["CAD"] {
                    Text("CA$\(cadQuote.price, specifier: "%.2f")")
                        .font(.headline)
                } else {
                    Text("N/A")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                // Plus button to add to portfolio (if needed)
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.leading, 8)
                .sheet(isPresented: $showAddSheet) {
                    // Minimal add sheet example
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 20) {
                            Text("Add \(crypto.name) to Portfolio")
                                .font(.headline)
                            
                            TextField("Enter amount", text: $amountText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .padding()
                            
                            Button("Add") {
                                if let amount = Double(amountText) {
                                    portfolioManager.addItem(coin: crypto, amount: amount)
                                }
                                amountText = ""
                                showAddSheet = false
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                            Spacer()
                        }
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                    }
                }
            }
            // 24h change
            if let cadQuote = crypto.quotes["CAD"] {
                let change = cadQuote.percentChange24h
                Text("\(String(format: "%.2f", change))%")
                    .font(.subheadline)
                    .foregroundColor(change >= 0 ? .green : .red)
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
            price: 99378.80,
            volume24h: 500000000,
            marketCap: 12000000000,
            percentChange24h: 2.40
        )
        let sampleCrypto = CryptoCurrency(
            id: "btc-bitcoin",
            name: "Bitcoin",
            symbol: "BTC",
            rank: 1,
            quotes: ["CAD": sampleQuote]
        )
        NavigationStack {
            CryptoRowView(crypto: sampleCrypto)
                .environmentObject(PortfolioManager())
        }
        .previewLayout(.sizeThatFits)
    }
}
