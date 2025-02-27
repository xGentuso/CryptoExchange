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
                if let cadQuote = crypto.quotes["CAD"] {
                    if let formattedPrice = NumberFormatter.decimalFormatter
                        .string(from: NSNumber(value: cadQuote.price)) {
                        Text("CA$\(formattedPrice)")
                            .font(.headline)
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
                // Plus button to add to portfolio
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.leading, 8)
                // Redesigned sheet
                .sheet(isPresented: $showAddSheet) {
                    ZStack {
                        // Gradient background
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 24) {
                            // Header
                            Text("Add \(crypto.name) to Portfolio")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.top, 40)
                            
                            // Frosted card
                            VStack(spacing: 16) {
                                TextField("Enter amount", text: $amountText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .padding(.horizontal)
                                    .padding(.top, 16)
                                
                                Button {
                                    if let amount = Double(amountText) {
                                        portfolioManager.addItem(coin: crypto, amount: amount)
                                    }
                                    amountText = ""
                                    showAddSheet = false
                                } label: {
                                    Text("Add")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(10)
                                }
                                .padding([.horizontal, .bottom], 16)
                            }
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 20)
                            
                            Spacer()
                        }
                    }
                }
            }
            // 24h change row
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
