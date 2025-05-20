//
//  Stock.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import Foundation

struct Stock: Identifiable, Codable, Equatable {
    let id: String
    let ticker: String
    let name: String
    let currentPrice: Double
    let previousClosePrice: Double
    let isFeatured: Bool
    
    var priceChange: Double {
        return currentPrice - previousClosePrice
    }
    
    var priceChangePercentage: Double {
        return (priceChange / previousClosePrice) * 100
    }
    
    // MARK: - Formatted Properties
    var formattedCurrentPrice: String {
        String(format: "$%.2f", currentPrice)
    }
    
    var formattedPriceChange: String {
        let sign = priceChange >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", priceChange))"
    }
    
    var formattedPriceChangePercentage: String {
        let sign = priceChangePercentage >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", priceChangePercentage))%"
    }
    
    var priceChangeDirection: String {
        priceChange >= 0 ? "increased" : "decreased"
    }
    
    // Custom equality based on ID only (since Stock conforms to Identifiable)
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.id == rhs.id
    }
}

// Response structure for decoding the API response
struct StocksResponse: Codable {
    let stocks: [Stock]
}
