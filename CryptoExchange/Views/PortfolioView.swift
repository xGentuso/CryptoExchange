//
//  PortfolioView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-27.
//

//
//  PortfolioView.swift
//  CryptoExchange
//
//  Created by Your Name on 2025-02-27.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var portfolioManager: PortfolioManager
    
    // Maps coinID -> current CAD price
    @State private var coinPrices: [String: Double] = [:]
    @State private var isLoading = false
    @State private var showChart = false
    
    private let service = CoinPaprikaService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1) Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // 2) Main Content
                VStack(spacing: 24) {
                    // Title
                    Text("Portfolio")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    // Frosted Card: List + Total Value
                    VStack(spacing: 0) {
                        // Portfolio List
                        List {
                            ForEach(portfolioManager.items) { item in
                                HStack {
                                    // Coin Name & Symbol
                                    VStack(alignment: .leading) {
                                        Text("\(item.coinName) (\(item.coinSymbol.uppercased()))")
                                            .font(.headline)
                                        Text("Amount: \(item.amount, specifier: "%.4f")")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    
                                    // Price & Value
                                    if let price = coinPrices[item.coinID] {
                                        let formattedPrice = NumberFormatter.decimalFormatter
                                            .string(from: NSNumber(value: price)) ?? "N/A"
                                        let totalVal = price * item.amount
                                        let formattedValue = NumberFormatter.decimalFormatter
                                            .string(from: NSNumber(value: totalVal)) ?? "N/A"
                                        VStack(alignment: .trailing) {
                                            Text("CA$\(formattedPrice)")
                                                .font(.subheadline)
                                            Text("Value: CA$\(formattedValue)")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    } else {
                                        Text("Price: N/A")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .onDelete { offsets in
                                portfolioManager.removeItem(at: offsets)
                            }
                        }
                        .listStyle(.insetGrouped)
                        // iOS 16+ to hide default background so frosted card is visible
                        .scrollContentBackground(.hidden)
                        
                        // Total Value Row
                        HStack {
                            Text("Total Value:")
                                .font(.headline)
                            Spacer()
                            Text("CA$\(totalPortfolioValue(), specifier: "%.2f")")
                                .font(.headline)
                        }
                        .padding()
                    }
                    .background(.regularMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    // Button to show chart
                    Button {
                        showChart = true
                    } label: {
                        Text("View Portfolio Chart")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .onAppear {
                updatePrices()
            }
            .refreshable {
                updatePrices()
            }
            // Chart Sheet (optional)
            .sheet(isPresented: $showChart) {
                PortfolioChartView(dataPoints: sampleHistoricalData())
            }
        }
    }
    
    // MARK: - Logic
    
    /// Example function to generate mock historical data for the chart
    /// In a real app, you'd store daily historical totals or fetch from an API.
    private func sampleHistoricalData() -> [PortfolioDataPoint] {
        let calendar = Calendar.current
        // Generate 7 data points for the past week
        return (0..<7).map { i in
            let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            let totalVal = totalPortfolioValue() * (1 + Double.random(in: -0.05...0.05))
            return PortfolioDataPoint(date: date, totalValue: totalVal)
        }
        .sorted { $0.date < $1.date }
    }
    
    private func totalPortfolioValue() -> Double {
        portfolioManager.items.reduce(0) { total, item in
            if let price = coinPrices[item.coinID] {
                return total + (price * item.amount)
            } else {
                return total
            }
        }
    }
    
    private func updatePrices() {
        isLoading = true
        service.fetchCryptos { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cryptos):
                    for item in portfolioManager.items {
                        if let coin = cryptos.first(where: { $0.id == item.coinID }),
                           let cadQuote = coin.quotes["CAD"] {
                            coinPrices[item.coinID] = cadQuote.price
                        }
                    }
                case .failure(let error):
                    print("Error updating prices: \(error)")
                }
                isLoading = false
            }
        }
    }
}

// MARK: - Preview
struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(PortfolioManager())
    }
}
