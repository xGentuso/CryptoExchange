//
//  CryptoDetailView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import SwiftUI

struct CryptoDetailView: View {
    let crypto: CryptoCurrency
    
    @State private var isLoading = true
    @State private var detail: CoinDetail? = nil
    @State private var errorMessage: String? = nil
    
    let service = CryptoService()
    
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
                    // MARK: - Header
                    Text(crypto.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    // MARK: - Info Card
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Basic coin info from ticker data
                        if let usdQuote = crypto.quotes["USD"] {
                            DetailRowView(
                                title: "Symbol",
                                value: crypto.symbol.uppercased()
                            )
                            
                            // Use our non-private priceFormatter
                            let formattedPrice = NumberFormatter.priceFormatter.string(
                                from: NSNumber(value: usdQuote.price)
                            ) ?? "N/A"
                            
                            DetailRowView(
                                title: "Current Price",
                                value: "$\(formattedPrice)"
                            )
                            
                            DetailRowView(
                                title: "24h Change",
                                value: "\(String(format: "%.2f", usdQuote.percentChange24h))%",
                                valueColor: usdQuote.percentChange24h >= 0 ? .green : .red
                            )
                        } else {
                            DetailRowView(title: "Symbol", value: crypto.symbol.uppercased())
                            DetailRowView(title: "Current Price", placeholder: "N/A")
                            DetailRowView(title: "24h Change", placeholder: "No data")
                        }
                        
                        Divider()
                        
                        // Detailed coin info from API call
                        if isLoading {
                            ProgressView("Loading coin details...")
                                .padding()
                        } else if let errorMessage = errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                        } else if let detail = detail {
                            if let desc = detail.description, !desc.isEmpty {
                                Text("Description")
                                    .font(.headline)
                                Text(desc)
                                    .font(.body)
                            } else {
                                Text("No description available.")
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Text("No detailed data available.")
                                .foregroundColor(.secondary)
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
        .onAppear {
            fetchCoinDetail()
        }
    }
    
    private func fetchCoinDetail() {
        print("Fetching detail for ID:", crypto.id)
        service.fetchCoinDetail(for: crypto.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedDetail):
                    self.detail = fetchedDetail
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }
}

/// A reusable row for displaying a key-value pair.
struct DetailRowView: View {
    let title: String
    var value: String? = nil
    var placeholder: String? = nil
    var valueColor: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let val = value, !val.isEmpty {
                Text(val)
                    .font(.body)
                    .foregroundColor(valueColor)
            } else if let placeholder = placeholder {
                Text(placeholder)
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                Text("No data.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Public (internal) extension for Price Formatter
extension NumberFormatter {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

struct CryptoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // B) Provide currentPrice, percentChange24h, etc.
        let sampleCrypto = CryptoCurrency(
            id: "btc-bitcoin",
            name: "Bitcoin",
            symbol: "BTC",
            rank: nil,
            currentPrice: 98312.29,
            percentChange24h: 1.46,
            volume24h: 500_000_000,
            marketCap: 12_000_000_000
        )

        return NavigationStack {
            CryptoDetailView(crypto: sampleCrypto)
        }
    }
}
