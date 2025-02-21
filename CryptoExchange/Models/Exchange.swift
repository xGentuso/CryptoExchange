//
//  Exchange.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-21.
//

import Foundation

/// A model for exchange data from CoinPaprika’s /v1/exchanges endpoint.
struct Exchange: Codable, Identifiable {
    let id: String
    let name: String
    let country: String?
    let websiteUrl: String?
    let logo: String?
    let volume24hUsd: Double?   // 24h trading volume in USD
    
    enum CodingKeys: String, CodingKey {
        case id, name, country
        case websiteUrl = "website_url"
        case logo
        case volume24hUsd = "volume_24h_usd"
    }
}
