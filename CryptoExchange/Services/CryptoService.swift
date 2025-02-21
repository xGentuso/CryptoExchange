//
//  CryptoService.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import Foundation

class CryptoService {
    
    /// Fetches an array of cryptocurrencies (using the CoinPaprika tickers endpoint).
    func fetchCryptos(completion: @escaping (Result<[CryptoCurrency], Error>) -> Void) {
        let urlString = "https://api.coinpaprika.com/v1/tickers"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let cryptos = try JSONDecoder().decode([CryptoCurrency].self, from: data)
                    completion(.success(cryptos))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    /// Fetches detailed information for a specific coin (using the coins endpoint).
    func fetchCoinDetail(for coinID: String, completion: @escaping (Result<CoinDetail, Error>) -> Void) {
        let urlString = "https://api.coinpaprika.com/v1/coins/\(coinID)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let detail = try JSONDecoder().decode(CoinDetail.self, from: data)
                    completion(.success(detail))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    /// Fetches global crypto market stats from CoinPaprika's /v1/global endpoint.
    func fetchGlobalStats(completion: @escaping (Result<GlobalStats, Error>) -> Void) {
        let urlString = "https://api.coinpaprika.com/v1/global"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let stats = try JSONDecoder().decode(GlobalStats.self, from: data)
                    completion(.success(stats))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    /// Fetches an array of exchanges (using the CoinPaprika /v1/exchanges endpoint).
    func fetchExchanges(completion: @escaping (Result<[Exchange], Error>) -> Void) {
        let urlString = "https://api.coinpaprika.com/v1/exchanges"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let exchanges = try JSONDecoder().decode([Exchange].self, from: data)
                    completion(.success(exchanges))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
