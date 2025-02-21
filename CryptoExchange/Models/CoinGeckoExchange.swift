//
//  Exchange.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-21.
//

import Foundation

/// A model for exchange data from CoinGecko’s /exchanges endpoint.
struct CoinGeckoExchange: Codable, Identifiable {
    let id: String          // e.g. "binance"
    let name: String        // e.g. "Binance"
    let country: String?    // e.g. "Cayman Islands"
    let url: String?        // e.g. "https://www.binance.com/"
    let image: String?      // Exchange logo URL
    let trustScoreRank: Int? // e.g. 1
    let tradeVolume24hBtc: Double? // 24h trading volume in BTC
    
    enum CodingKeys: String, CodingKey {
        case id, name, country, url, image
        case trustScoreRank = "trust_score_rank"
        case tradeVolume24hBtc = "trade_volume_24h_btc"
    }
}
