//
//  NumberFormatter+Extensions.swift
//  CryptoExchange
//
//  Created by ryan mota on 2025-02-21.
//

import Foundation

extension NumberFormatter {
    /// A decimal formatter that uses commas for thousands separators
    /// and always shows exactly 2 decimal places.
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        // Always show 2 decimals, even if the last digit is zero
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
