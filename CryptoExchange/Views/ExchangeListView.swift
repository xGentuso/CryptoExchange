//
//  ExchangeListView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-21.
//

import SwiftUI

struct ExchangesListView: View {
    @State private var exchanges: [Exchange] = []
    @State private var filteredExchanges: [Exchange] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var searchText = ""
    
    private let cryptoService = CryptoService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // MARK: - Custom Nav Bar
                    VStack(spacing: 10) {
                        Text("Exchanges")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Search Bar
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
                    
                    // MARK: - Main Content
                    if isLoading {
                        Spacer()
                        ProgressView("Loading Exchanges...")
                            .padding()
                            .foregroundColor(.white)
                        Spacer()
                    } else if let errorMessage = errorMessage {
                        Spacer()
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                        Spacer()
                    } else {
                        // Scrollable list of exchanges
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
        cryptoService.fetchExchanges { result in
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
                (exchange.countries?.joined(separator: " ").lowercased().contains(searchText.lowercased()) ?? false)
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
