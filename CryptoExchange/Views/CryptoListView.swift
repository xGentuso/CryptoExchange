//
//  CryptoListView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-20.
//

import SwiftUI

struct CryptoListView: View {
    @State private var cryptos: [CryptoCurrency] = []
    @State private var filteredCryptos: [CryptoCurrency] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var searchText = ""
    
    private let service = CoinPaprikaService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header with search
                    VStack(spacing: 10) {
                        Text("Cryptocurrencies")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search Coins", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .onChange(of: searchText) { _ in
                                    filterCryptos()
                                }
                        }
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .padding(.top, 16)
                    
                    if isLoading {
                        Spacer()
                        ProgressView("Loading Cryptocurrencies...")
                            .foregroundColor(.white)
                        Spacer()
                    } else if let errorMessage = errorMessage {
                        Spacer()
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredCryptos, id: \.id) { coin in
                                    NavigationLink(destination: CryptoDetailView(crypto: coin)) {
                                        CryptoRowView(crypto: coin)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                fetchCryptos()
            }
        }
    }
    
    private func fetchCryptos() {
        isLoading = true
        errorMessage = nil
        service.fetchCryptos { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.cryptos = data
                    self.filteredCryptos = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }
    
    private func filterCryptos() {
        if searchText.isEmpty {
            filteredCryptos = cryptos
        } else {
            filteredCryptos = cryptos.filter { coin in
                coin.name.lowercased().contains(searchText.lowercased()) ||
                coin.symbol.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

struct CryptoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CryptoListView()
        }
    }
}

