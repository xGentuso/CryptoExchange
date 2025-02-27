//
//  CryptoExchangeWidget.swift
//  CryptoExchangeWidget
//
//  Created by ryan mota on 2025-02-27.
//
//

import WidgetKit
import SwiftUI

// Timeline entry
struct CryptoExchangeEntry: TimelineEntry {
    let date: Date
    let btcPrice: Double
}

// Timeline provider
struct CryptoExchangeProvider: TimelineProvider {
    func placeholder(in context: Context) -> CryptoExchangeEntry {
        CryptoExchangeEntry(date: Date(), btcPrice: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CryptoExchangeEntry) -> Void) {
        let entry = CryptoExchangeEntry(date: Date(), btcPrice: 0)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CryptoExchangeEntry>) -> Void) {
        let defaults = UserDefaults(suiteName: "group.com.triosRM.CryptoExchange")
        let price = defaults?.double(forKey: "btcPrice") ?? 0
        
        let entry = CryptoExchangeEntry(date: Date(), btcPrice: price)
        
        // Refresh in 10 minutes
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
        completion(timeline)
    }
}

// Widget’s main view
struct CryptoExchangeWidgetEntryView: View {
    var entry: CryptoExchangeProvider.Entry
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 8) {
                Text("Crypto X")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("BTC Price:")
                    .font(.caption)
                    .foregroundColor(.white)
                
                // Use shared NumberFormatter.decimalFormatter to format the price
                Text("CA$\(formattedPrice(entry.btcPrice))")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
    
    /// Returns the formatted price string, e.g., "123,493.17"
    private func formattedPrice(_ price: Double) -> String {
        if let formatted = NumberFormatter.decimalFormatter.string(from: NSNumber(value: price)) {
            return formatted
        }
        return String(format: "%.2f", price)
    }
}

// The widget
struct CryptoExchangeWidget: Widget {
    let kind: String = "CryptoExchangeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CryptoExchangeProvider()) { entry in
            CryptoExchangeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Crypto X")
        .description("Displays BTC price from shared data, formatted with commas.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
