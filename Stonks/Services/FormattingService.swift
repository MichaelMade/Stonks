//
//  FormattingService.swift
//  Stonks
//
//  Created by Michael Moore on 5/20/25.
//

import Foundation

// MARK: - Formatting Service

protocol FormattingServiceProtocol {
    func formatCurrency(_ amount: Double, locale: Locale?) -> String
    func formatPercentage(_ percentage: Double, decimalPlaces: Int) -> String
    func formatPriceChange(_ change: Double, showSign: Bool) -> String
}

class FormattingService: FormattingServiceProtocol {
    static let shared = FormattingService()
    
    private init() {}
    
    func formatCurrency(_ amount: Double, locale: Locale? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale ?? Locale.current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: amount)) ?? String(format: "$%.2f", amount)
    }
    
    func formatPercentage(_ percentage: Double, decimalPlaces: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces
        
        return formatter.string(from: NSNumber(value: percentage / 100)) ?? String(format: "%.2f%%", percentage)
    }
    
    func formatPriceChange(_ change: Double, showSign: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        if showSign {
            formatter.positivePrefix = "+"
        }
        
        return formatter.string(from: NSNumber(value: change)) ?? String(format: showSign ? "%+.2f" : "%.2f", change)
    }
}
