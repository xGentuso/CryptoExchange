//
//  CoinGeckoExchangeDetail.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-21.
//

import Foundation

/// A model for detailed exchange data from CoinGecko’s /exchanges/{id} endpoint.
struct CoinGeckoExchangeDetail: Codable {
    let id: String
    let name: String
    let yearEstablished: Int?
    let country: String?
    let description: String?
    let url: String?
    let image: String?
    let facebookUsername: String?
    let redditUrl: String?
    let telegramUrl: String?
    let slackUrl: String?
    let otherUrl1: String?
    let otherUrl2: String?
    let twitterHandle: String?
    let hasTradingIncentive: Bool?
    let tradeVolume24hBtc: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case yearEstablished = "year_established"
        case country, description, url, image
        case facebookUsername = "facebook_username"
        case redditUrl = "reddit_url"
        case telegramUrl = "telegram_url"
        case slackUrl = "slack_url"
        case otherUrl1 = "other_url_1"
        case otherUrl2 = "other_url_2"
        case twitterHandle = "twitter_handle"
        case hasTradingIncentive = "has_trading_incentive"
        case tradeVolume24hBtc = "trade_volume_24h_btc"
    }
}
