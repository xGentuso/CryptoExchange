//
//  CoinDetail.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import Foundation

/// Represents detailed coin information from CoinPaprika.
struct CoinDetail: Codable {
    let id: String
    let name: String
    let symbol: String
    let description: String?
}
