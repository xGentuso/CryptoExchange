//
//  CoinDetail.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import Foundation

/// Represents additional coin details from CoinPaprika’s coins endpoint.
struct CoinDetail: Codable {
    let id: String         // e.g., "btc-bitcoin"
    let name: String       // e.g., "Bitcoin"
    let symbol: String     // e.g., "BTC"
    let description: String?
    // You can add more fields here if needed
}
