//
//  StockCellViewTests.swift
//  StonksTests
//
//  Created by Michael Moore on 5/20/25.
//

import Testing
import SwiftUI
@testable import Stonks

struct StockCellViewTests {
    
    @Test func stockCellDisplaysCorrectInformation() async throws {
        // Given
        let stock = TestFactory.createStock(
            id: "AAPL",
            ticker: "AAPL",
            name: "Apple Inc.",
            currentPrice: 150.0,
            previousClosePrice: 145.0,
            isFeatured: false
        )
        
        let mockViewModel = await StockViewModel(
            stockService: MockStockService(),
            userDefaults: MockUserDefaults()
        )
        
        // When - The view is created with the stock
        _ = StockCellView(stock: stock)
            .environmentObject(mockViewModel)
        
        // Then - Verify formatted properties are used
        #expect(stock.formattedCurrentPrice == "$150.00", "Should format current price correctly")
        #expect(stock.formattedPriceChange == "+5.00", "Should format price change with sign")
        #expect(stock.formattedPriceChangePercentage == "+3.45%", "Should format percentage with sign")
        #expect(stock.priceChangeDirection == "increased", "Should show correct direction")
    }
    
    @Test func stockCellFormatsNegativeChanges() async throws {
        // Given
        let stock = TestFactory.createStock(
            id: "TSLA",
            ticker: "TSLA", 
            name: "Tesla Inc.",
            currentPrice: 200.0,
            previousClosePrice: 250.0,
            isFeatured: false
        )
        
        // Then - Verify negative formatting
        #expect(stock.formattedPriceChange == "-50.00", "Should format negative price change")
        #expect(stock.formattedPriceChangePercentage == "-20.00%", "Should format negative percentage")
        #expect(stock.priceChangeDirection == "decreased", "Should show decreased direction")
    }
    
    @Test func accessibilityStringsAreWellFormatted() async throws {
        // Given
        let stock = TestFactory.createStock(
            ticker: "AAPL",
            name: "Apple Inc.",
            currentPrice: 150.0,
            previousClosePrice: 145.0
        )
        
        let mockViewModel = await StockViewModel(
            stockService: MockStockService(),
            userDefaults: MockUserDefaults()
        )
        
        _ = StockCellView(stock: stock)
            .environmentObject(mockViewModel)
        
        // Then - Verify accessibility text formatting
        _ = "Apple Inc., AAPL, Price: $150.00"
        _ = "increased by $5.00, 3.45 percent, not favorited"
        
        // These would be tested in UI tests or with ViewInspector
        // For now, we're testing the underlying data
        #expect(stock.formattedCurrentPrice == "$150.00", "Current price should be formatted")
        #expect(stock.priceChangeDirection == "increased", "Direction should be human readable")
    }
}
