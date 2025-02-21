//
//  GlobalStats.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import Foundation

/// Represents the data returned by CoinPaprika’s /v1/global endpoint.
struct GlobalStats: Codable {
    let marketCapUsd: Double?
    let volume24hUsd: Double?
    let bitcoinDominancePercentage: Double?
    let cryptocurrenciesNumber: Int?
    // ... add other fields if you want them
    
    enum CodingKeys: String, CodingKey {
        case marketCapUsd = "market_cap_usd"
        case volume24hUsd = "volume_24h_usd"
        case bitcoinDominancePercentage = "bitcoin_dominance_percentage"
        case cryptocurrenciesNumber = "cryptocurrencies_number"
    }
}
