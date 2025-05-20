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
    
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.id == rhs.id
    }
}

// Response structure for decoding the API response
struct StocksResponse: Codable {
    let stocks: [Stock]
}
