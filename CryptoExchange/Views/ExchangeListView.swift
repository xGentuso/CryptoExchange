//
//  ExchangeListView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-21.
//

import SwiftUI

struct ExchangesListView: View {
    @State private var exchanges: [CoinGeckoExchange] = []
    @State private var filteredExchanges: [CoinGeckoExchange] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var searchText = ""
    
    private let service = CoinGeckoService()
    
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
                    // Custom Nav Bar with Search
                    VStack(spacing: 10) {
                        Text("Exchanges")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search Exchanges", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .onChange(of: searchText) { _ in
                                    filterExchanges()
                                }
                        }
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .padding(.top, 16)
                    
                    // Main Content
                    if isLoading {
                        Spacer()
                        ProgressView("Loading Exchanges...")
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
                                ForEach(filteredExchanges, id: \.id) { exchange in
                                    NavigationLink(destination: ExchangeDetailView(exchange: exchange)) {
                                        ExchangeRowView(exchange: exchange)
                                    }
                                    .buttonStyle(.plain)
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
                fetchExchanges()
            }
        }
    }
    
    private func fetchExchanges() {
        isLoading = true
        errorMessage = nil
        service.fetchExchanges { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.exchanges = data
                    self.filteredExchanges = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }
    
    private func filterExchanges() {
        if searchText.isEmpty {
            filteredExchanges = exchanges
        } else {
            filteredExchanges = exchanges.filter { exchange in
                exchange.name.lowercased().contains(searchText.lowercased()) ||
                (exchange.country?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
    }
}

struct ExchangesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExchangesListView()
        }
    }
}
