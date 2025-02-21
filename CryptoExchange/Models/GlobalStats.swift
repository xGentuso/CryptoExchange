//
//  GlobalStats.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import Foundation

/// Represents global market data returned by the CoinPaprika /v1/global endpoint.
struct GlobalStats: Codable {
    let marketCapUsd: Double        // e.g., 1.182787284385e+12
    let volume24hUsd: Double        // e.g., 5.5654474178e+10
    let bitcoinDominancePercentage: Double  // e.g., 45.28
    let cryptocurrenciesNumber: Int // e.g., 12739
    
    enum CodingKeys: String, CodingKey {
        case marketCapUsd = "market_cap_usd"
        case volume24hUsd = "volume_24h_usd"
        case bitcoinDominancePercentage = "bitcoin_dominance_percentage"
        case cryptocurrenciesNumber = "cryptocurrencies_number"
    }
}
