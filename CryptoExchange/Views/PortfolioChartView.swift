//
//  PortfolioChartView.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-27.
//

import SwiftUI
import Charts

// MARK: - Data Model
struct PortfolioDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let totalValue: Double
}

// MARK: - Chart View
struct PortfolioChartView: View {
    let dataPoints: [PortfolioDataPoint]
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                // Title
                Text("Portfolio History")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // Frosted card for the chart
                VStack {
                    Chart {
                        ForEach(dataPoints) { point in
                            LineMark(
                                x: .value("Date", point.date),
                                y: .value("Total Value", point.totalValue)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(.blue)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: 5)) { value in
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                    .frame(height: 300)
                    .padding()
                }
                .background(.regularMaterial)
                .cornerRadius(16)
                .padding(.horizontal, 20)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                Spacer()
            }
        }
    }
}

struct PortfolioChartView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = [
            PortfolioDataPoint(date: Date().addingTimeInterval(-86400 * 5), totalValue: 5000),
            PortfolioDataPoint(date: Date().addingTimeInterval(-86400 * 4), totalValue: 6000),
            PortfolioDataPoint(date: Date().addingTimeInterval(-86400 * 3), totalValue: 5500),
            PortfolioDataPoint(date: Date().addingTimeInterval(-86400 * 2), totalValue: 7000),
            PortfolioDataPoint(date: Date().addingTimeInterval(-86400 * 1), totalValue: 7200),
            PortfolioDataPoint(date: Date(), totalValue: 7100)
        ]
        
        PortfolioChartView(dataPoints: sampleData)
    }
}
