//
//  CryptoCurrency.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//


import Foundation

/// Represents a cryptocurrency as returned by CoinPaprika’s tickers endpoint.
struct CryptoCurrency: Codable, Identifiable {
    let id: String       // e.g., "btc-bitcoin"
    let name: String     // e.g., "Bitcoin"
    let symbol: String   // e.g., "BTC"
    let rank: Int?
    let quotes: [String: Quote]
    
    struct Quote: Codable {
        let price: Double
        let volume24h: Double
        let marketCap: Double
        let percentChange24h: Double
        
        enum CodingKeys: String, CodingKey {
            case price
            case volume24h = "volume_24h"
            case marketCap = "market_cap"
            case percentChange24h = "percent_change_24h"
        }
    }
}
