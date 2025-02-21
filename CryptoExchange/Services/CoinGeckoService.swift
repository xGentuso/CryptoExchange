//
//  CryptoService.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import Foundation

/// A service that fetches data from the CoinGecko API.
class CoinGeckoService {
    
    // MARK: - 1) Fetch Cryptocurrencies (Ticker Data)
    // Endpoint: GET /coins/markets?vs_currency=usd
    // Example: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd
    func fetchCryptos(completion: @escaping (Result<[CoinGeckoCrypto], Error>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let cryptos = try JSONDecoder().decode([CoinGeckoCrypto].self, from: data)
                    completion(.success(cryptos))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - 2) Fetch Coin Detail
    // Endpoint: GET /coins/{id}?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false
    // Example: https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false
    func fetchCoinDetail(for coinID: String, completion: @escaping (Result<CoinGeckoDetail, Error>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coinID)?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let detail = try JSONDecoder().decode(CoinGeckoDetail.self, from: data)
                    completion(.success(detail))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - 3) Fetch Exchanges (List)
    // Endpoint: GET /exchanges
    // Example: https://api.coingecko.com/api/v3/exchanges
    func fetchExchanges(completion: @escaping (Result<[CoinGeckoExchange], Error>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/exchanges"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let exchanges = try JSONDecoder().decode([CoinGeckoExchange].self, from: data)
                    completion(.success(exchanges))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - 4) Fetch Exchange Detail
    // Endpoint: GET /exchanges/{id}
    // Example: https://api.coingecko.com/api/v3/exchanges/binance
    func fetchExchangeDetail(for exchangeID: String, completion: @escaping (Result<CoinGeckoExchangeDetail, Error>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/exchanges/\(exchangeID)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let detail = try JSONDecoder().decode(CoinGeckoExchangeDetail.self, from: data)
                    completion(.success(detail))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - 5) Fetch Global Market Stats
    // Endpoint: GET /global
    // Example: https://api.coingecko.com/api/v3/global
    func fetchGlobalStats(completion: @escaping (Result<CoinGeckoGlobal, Error>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/global"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let globalData = try JSONDecoder().decode(CoinGeckoGlobal.self, from: data)
                    completion(.success(globalData))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

