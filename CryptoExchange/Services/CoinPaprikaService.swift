//
//  CoinPaprikaService.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

//
//  CoinPaprikaService.swift
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
    
    /// Fetches an array of cryptocurrencies (ticker data) from CoinPaprika in CAD.
    func fetchCryptos(completion: @escaping (Result<[CryptoCurrency], Error>) -> Void) {
        let urlString = "https://api.coinpaprika.com/v1/tickers?quotes=CAD"
        guard let url = URL(string: urlString) else { return }
        
        print("DEBUG: Starting fetchCryptos for CAD prices...")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG: fetchCryptos error -> \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("DEBUG: No data returned from fetchCryptos")
                completion(.failure(ServiceError.noData))
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([CryptoCurrency].self, from: data)
                print("DEBUG: fetchCryptos success -> \(cryptos.count) coins decoded.")
                
                // EXAMPLE: Store Bitcoin's CAD price in shared UserDefaults
                if let btc = cryptos.first(where: { $0.id == "btc-bitcoin" }),
                   let cadQuote = btc.quotes["CAD"] {
                    let btcPrice = cadQuote.price
                    
                    // Write to the App Group container
                    if let sharedDefaults = UserDefaults(suiteName: "group.com.triosRM.CryptoExchange") {
                        sharedDefaults.set(btcPrice, forKey: "btcPrice")
                        print("DEBUG: Wrote BTC price to shared defaults -> CA$\(btcPrice)")
                    } else {
                        print("DEBUG: Could not get sharedDefaults for group.com.triosRM.CryptoExchange")
                    }
                } else {
                    print("DEBUG: Could not find 'btc-bitcoin' or 'CAD' quote in cryptos.")
                }
                
                completion(.success(cryptos))
            } catch {
                print("DEBUG: JSON decode error -> \(error)")
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
    func fetchExchanges(completion: @escaping (Result<[Exchange], Error>) -> Void) {
        let urlString = "https://api.coinpaprika.com/v1/exchanges"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // This is likely where the error occurs:
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                // If there's no data, create your own error or use ServiceError.noData
                completion(.failure(ServiceError.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("DEBUG: /v1/exchanges raw JSON:\n\(jsonString)")
            } else {
                print("DEBUG: Could not decode /v1/exchanges data as UTF-8")
            }
            
            do {
                let exchanges = try JSONDecoder().decode([Exchange].self, from: data)
                completion(.success(exchanges))
            } catch {
                // Here, 'error' is the local do/catch error, which is non-optional
                completion(.failure(error))
            }
        }.resume()
    }

}
