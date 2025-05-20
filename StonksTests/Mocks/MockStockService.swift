//
//  MockStockService.swift
//  StonksTests
//
//  Created by Michael Moore on 5/19/25.
//

import Foundation
@testable import Stonks

class MockStockService: StockServiceProtocol {
    // Control mock behavior
    var stocksToReturn: [Stock] = []
    var errorToThrow: Error?
    var delayInSeconds: UInt64 = 0
    
    func fetchStocks() async throws -> [Stock] {
        // Simulate network delay if specified
        if delayInSeconds > 0 {
            try await Task.sleep(nanoseconds: delayInSeconds * 1_000_000_000)
        }
        
        // Throw error if specified
        if let error = errorToThrow {
            throw error
        }
        
        return stocksToReturn
    }
    
    // Helper to create test stocks
    static func createTestStocks() -> [Stock] {
        return [
            Stock(id: "AAPL", ticker: "AAPL", name: "Apple Inc.", currentPrice: 150.0, previousClosePrice: 145.0, isFeatured: true),
            Stock(id: "GOOGL", ticker: "GOOGL", name: "Alphabet Inc.", currentPrice: 2500.0, previousClosePrice: 2550.0, isFeatured: true),
            Stock(id: "MSFT", ticker: "MSFT", name: "Microsoft Corporation", currentPrice: 300.0, previousClosePrice: 295.0, isFeatured: false),
            Stock(id: "AMZN", ticker: "AMZN", name: "Amazon.com Inc.", currentPrice: 3100.0, previousClosePrice: 3050.0, isFeatured: false)
        ]
    }
}