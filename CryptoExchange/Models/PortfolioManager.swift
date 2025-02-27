//
//  PortfolioManager.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-27.
//

import Foundation
import SwiftUI

/// Represents a single holding in the portfolio.
struct PortfolioItem: Identifiable, Codable {
    let id = UUID()
    let coinID: String
    let coinName: String
    let coinSymbol: String
    let amount: Double
}

/// A class that manages the user’s portfolio.
class PortfolioManager: ObservableObject {
    @Published var items: [PortfolioItem] = []
    
    func addItem(coin: CryptoCurrency, amount: Double) {
        // Check if the coin already exists – if so, update the amount
        if let index = items.firstIndex(where: { $0.coinID == coin.id }) {
            let existing = items[index]
            // For simplicity, we add the amounts. In a real app, you might update cost basis.
            let updated = PortfolioItem(
                coinID: existing.coinID,
                coinName: existing.coinName,
                coinSymbol: existing.coinSymbol,
                amount: existing.amount + amount
            )
            items[index] = updated
        } else {
            let newItem = PortfolioItem(
                coinID: coin.id,
                coinName: coin.name,
                coinSymbol: coin.symbol,
                amount: amount
            )
            items.append(newItem)
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    /// Calculates total portfolio value based on a price lookup (passed in as a dictionary of coinID: price)
    func totalValue(using prices: [String: Double]) -> Double {
        items.reduce(0) { total, item in
            if let price = prices[item.coinID] {
                return total + price * item.amount
            }
            return total
        }
    }
}

