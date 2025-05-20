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
        
        // Test percentage change calculation
        #expect(stock.priceChangePercentage == 7.142857142857142, "Price change percentage should be approximately 7.14%")
        
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
}
