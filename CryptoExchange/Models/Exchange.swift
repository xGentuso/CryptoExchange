//
//  Exchange.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-21.
//

import Foundation

/// Represents an exchange as returned by CoinPaprika’s /v1/exchanges endpoint.
struct Exchange: Codable, Identifiable {
    let id: String            // e.g., "binance", "coinbase-pro", etc.
    let name: String          // e.g., "Binance", "Coinbase Pro"
    let websiteURL: String?   // e.g., "https://www.binance.com"
    let volume24h: Double?    // 24h trading volume
    let volume24hChange: Double? // 24h volume change percentage
    let countries: [String]?  // List of countries (if available)
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case websiteURL = "website_url"
        case volume24h = "volume_24h"
        case volume24hChange = "volume_24h_change_24h"
        case countries
    }
}
