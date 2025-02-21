//
//  GlobalStats.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import Foundation

/// A model for global market data from CoinGecko’s /global endpoint.
struct CoinGeckoGlobal: Codable {
    let data: GlobalData
    
    struct GlobalData: Codable {
        let activeCryptocurrencies: Int
        let upcomingIcos: Int
        let ongoingIcos: Int
        let endedIcos: Int
        let markets: Int
        let totalMarketCap: [String: Double]
        let totalVolume: [String: Double]
        let marketCapPercentage: [String: Double]
        let marketCapChangePercentage24hUsd: Double
        
        enum CodingKeys: String, CodingKey {
            case activeCryptocurrencies = "active_cryptocurrencies"
            case upcomingIcos = "upcoming_icos"
            case ongoingIcos = "ongoing_icos"
            case endedIcos = "ended_icos"
            case markets
            case totalMarketCap = "total_market_cap"
            case totalVolume = "total_volume"
            case marketCapPercentage = "market_cap_percentage"
            case marketCapChangePercentage24hUsd = "market_cap_change_percentage_24h_usd"
        }
    }
}
