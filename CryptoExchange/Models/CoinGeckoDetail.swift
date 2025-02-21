//
//  CoinDetail.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import Foundation

/// A model for detailed coin data from CoinGecko’s /coins/{id} endpoint.
struct CoinGeckoDetail: Codable {
    let id: String
    let symbol: String
    let name: String
    let description: Description?
    let marketData: MarketData?
    
    struct Description: Codable {
        let en: String?
    }
    
    struct MarketData: Codable {
        let currentPrice: [String: Double]?
        let priceChangePercentage24h: Double?
        
        enum CodingKeys: String, CodingKey {
            case currentPrice = "current_price"
            case priceChangePercentage24h = "price_change_percentage_24h"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description
        case marketData = "market_data"
    }
}
