//
//  CryptoService.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import Foundation

enum ServiceError: Error {
    case noData
}

/// A service that fetches data from the CoinPaprika API.
class CoinPaprikaService {
    
    /// Fetches an array of cryptocurrencies (ticker data) from CoinPaprika.
    func fetchCryptos(completion: @escaping (Result<[CryptoCurrency], Error>) -> Void) {
        // Request CAD prices instead of USD
        let urlString = "https://api.coinpaprika.com/v1/tickers?quotes=CAD"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([CryptoCurrency].self, from: data)
                completion(.success(cryptos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
    /// Fetches detailed information for a specific coin from CoinPaprika.
    func fetchCoinDetail(for coinID: String, completion: @escaping (Result<CoinDetail, Error>) -> Void) {
        let urlString = "https://api.coinpaprika.com/v1/coins/\(coinID)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            
            do {
                let detail = try JSONDecoder().decode(CoinDetail.self, from: data)
                completion(.success(detail))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - 1) Fetch Global Market Stats
    // Endpoint: GET /v1/global
    func fetchGlobalStats(completion: @escaping (Result<GlobalStats, Error>) -> Void) {
        let urlString = "https://api.coinpaprika.com/v1/global"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            
            do {
                let stats = try JSONDecoder().decode(GlobalStats.self, from: data)
                completion(.success(stats))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - 2) Fetch Exchanges
    // Endpoint: GET /v1/exchanges
    func fetchExchanges(completion: @escaping (Result<[Exchange], Error>) -> Void) {
        let urlString = "https://api.coinpaprika.com/v1/exchanges"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            
            // Debug: print the raw JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("DEBUG: /v1/exchanges raw JSON:\n\(jsonString)")
            }
            
            do {
                let exchanges = try JSONDecoder().decode([Exchange].self, from: data)
                completion(.success(exchanges))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
