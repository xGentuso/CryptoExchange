//
//  CryptoCurrency.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//


import Foundation

/// A simplified model for coins from the CoinGecko /coins/markets endpoint.
struct CoinGeckoCrypto: Codable, Identifiable {
    let id: String              // e.g. "bitcoin"
    let symbol: String          // e.g. "btc"
    let name: String            // e.g. "Bitcoin"
    let image: String?          // URL string for coin logo
    let currentPrice: Double?   // e.g. 98363.72
    let marketCap: Double?
    let totalVolume: Double?
    let priceChangePercentage24h: Double?
    let marketCapRank: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case totalVolume = "total_volume"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketCapRank = "market_cap_rank"
    }
}

