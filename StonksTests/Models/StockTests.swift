//
//  StockTests.swift
//  StonksTests
//
//  Created by Michael Moore on 5/19/25.
//

import Testing
@testable import Stonks

struct StockTests {
    
    @Test func stockComputedProperties() {
        // Given
        let stock = Stock(
            id: "AAPL",
            ticker: "AAPL",
            name: "Apple Inc.",
            currentPrice: 150.00,
            previousClosePrice: 140.00,
            isFeatured: true
        )
        
        // When & Then
        // Test price change calculation
        #expect(stock.priceChange == 10.00, "Price change should be $10.00")
        
        // Test percentage change calculation (with floating point tolerance)
        let expectedPercentage = (10.0 / 140.0) * 100.0
        #expect(abs(stock.priceChangePercentage - expectedPercentage) < 0.001, "Price change percentage should be approximately 7.14%")
        
        // Test negative change
        let decreasingStock = Stock(
            id: "TSLA", 
            ticker: "TSLA", 
            name: "Tesla Inc.", 
            currentPrice: 190.00,
            previousClosePrice: 200.00,
            isFeatured: false
        )
        #expect(decreasingStock.priceChange == -10.00, "Price change should be -$10.00")
        #expect(decreasingStock.priceChangePercentage == -5.00, "Price change percentage should be -5.00%")
    }
    
    @Test func stockEquality() {
        // Given
        let stock1 = Stock(
            id: "AAPL",
            ticker: "AAPL",
            name: "Apple Inc.",
            currentPrice: 150.00,
            previousClosePrice: 140.00,
            isFeatured: true
        )
        
        let stock2 = Stock(
            id: "AAPL",
            ticker: "AAPL",
            name: "Apple Inc.",
            currentPrice: 155.00,  // Different price
            previousClosePrice: 145.00,  // Different previous price
            isFeatured: false  // Different featured status
        )
        
        let stock3 = Stock(
            id: "MSFT",  // Different ID
            ticker: "MSFT",
            name: "Microsoft Corporation",
            currentPrice: 300.00,
            previousClosePrice: 290.00,
            isFeatured: true
        )
        
        // When & Then
        // Test equality (based on ID only)
        #expect(stock1 == stock2, "Stocks with same ID should be equal regardless of other properties")
        #expect(stock1 != stock3, "Stocks with different IDs should not be equal")
    }
    
    @Test func edgeCases() {
        // Test zero price change
        let stableStock = Stock(
            id: "STABLE",
            ticker: "STABLE",
            name: "Stable Stock",
            currentPrice: 100.00,
            previousClosePrice: 100.00,
            isFeatured: false
        )
        #expect(stableStock.priceChange == 0.0, "Price change should be 0 when prices are equal")
        #expect(stableStock.priceChangePercentage == 0.0, "Percentage change should be 0 when prices are equal")
        
        // Test very small price changes
        let microStock = Stock(
            id: "MICRO",
            ticker: "MICRO", 
            name: "Micro Stock",
            currentPrice: 100.01,
            previousClosePrice: 100.00,
            isFeatured: false
        )
        #expect(abs(microStock.priceChange - 0.01) < 0.001, "Should handle small price changes accurately")
        #expect(abs(microStock.priceChangePercentage - 0.01) < 0.001, "Should handle small percentage changes accurately")
        
        // Test large price changes
        let volatileStock = Stock(
            id: "VOLATILE",
            ticker: "VOLATILE",
            name: "Volatile Stock", 
            currentPrice: 1000.00,
            previousClosePrice: 100.00,
            isFeatured: false
        )
        #expect(volatileStock.priceChange == 900.00, "Should handle large price increases")
        #expect(volatileStock.priceChangePercentage == 900.00, "Should handle large percentage increases")
    }
}
