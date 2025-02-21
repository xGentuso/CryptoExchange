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
    
    // MARK: - Custom Initializer for Previews or Manual Creation
    //
    // This lets you create a CryptoCurrency using a "currentPrice" param if you like,
    // by automatically placing that price into quotes["USD"].price. If you already have
    // a dictionary of quotes, pass that in instead.
    //
    // Example usage in a preview:
    //   let sampleCrypto = CryptoCurrency(
    //       id: "btc-bitcoin",
    //       name: "Bitcoin",
    //       symbol: "BTC",
    //       rank: nil,
    //       currentPrice: 98312.29,
    //       percentChange24h: 1.46
    //   )
    //
    init(
        id: String,
        name: String,
        symbol: String,
        rank: Int? = nil,
        currentPrice: Double? = nil,
        percentChange24h: Double? = nil,
        volume24h: Double? = nil,
        marketCap: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.rank = rank
        
        // If the caller provided a price or other fields, we store them in quotes["USD"].
        // Otherwise, default to 0 or any default you prefer.
        let p = currentPrice ?? 0
        let vol = volume24h ?? 0
        let mc = marketCap ?? 0
        let pc24 = percentChange24h ?? 0
        
        let usdQuote = Quote(
            price: p,
            volume24h: vol,
            marketCap: mc,
            percentChange24h: pc24
        )
        
        self.quotes = ["USD": usdQuote]
    }
}

