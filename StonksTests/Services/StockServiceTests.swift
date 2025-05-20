//
//  StockServiceTests.swift
//  StonksTests
//
//  Created by Michael Moore on 5/19/25.
//

import Testing
import Foundation
@testable import Stonks

struct StockServiceTests {
    
    @Test func fetchStocksSuccess() async throws {
        // In a real test we might want to inject a mock Bundle to control test data
        // For now, we'll test that the real service can load the sample data
        
        // Given
        let service = StockService()
        
        // When
        let stocks = try await service.fetchStocks()
        
        // Then
        #expect(!stocks.isEmpty, "Should fetch non-empty stocks array")
        
        // Verify some known values from the example_response.json
        let apple = stocks.first { $0.id == "AAPL" }
        #expect(apple != nil, "Should contain Apple stock")
        if let apple = apple {
            #expect(apple.name == "Apple Inc.", "Should have correct company name")
            #expect(apple.isFeatured == true, "Apple should be featured")
        }
    }
    
    @Test func mockStockServiceBasics() async throws {
        // Given
        let mockService = MockStockService()
        let testStocks = [
            Stock(id: "TEST1", ticker: "TEST1", name: "Test Stock 1", 
                  currentPrice: 100.0, previousClosePrice: 95.0, isFeatured: true),
            Stock(id: "TEST2", ticker: "TEST2", name: "Test Stock 2", 
                  currentPrice: 200.0, previousClosePrice: 210.0, isFeatured: false)
        ]
        mockService.stocksToReturn = testStocks
        
        // When
        let stocks = try await mockService.fetchStocks()
        
        // Then
        #expect(stocks.count == 2, "Should return 2 test stocks")
        #expect(stocks[0].id == "TEST1", "First stock should be TEST1")
        #expect(stocks[1].id == "TEST2", "Second stock should be TEST2")
    }
    
    @Test func mockStockServiceError() async throws {
        // Given
        let mockService = MockStockService()
        mockService.errorToThrow = StockError.failedToLoadData
        
        // When & Then
        await #expect(throws: StockError.failedToLoadData, "Service should throw the specified error", performing: try await mockService
            .fetchStocks)
    }
    
    @Test func mockStockServiceDelay() async throws {
        // Given
        let mockService = MockStockService()
        mockService.stocksToReturn = MockStockService.createTestStocks()
        mockService.delayInSeconds = 1
        
        // Measure execution time
        let startTime = Date()
        
        // When
        let _ = try await mockService.fetchStocks()
        
        // Then
        let elapsedTime = Date().timeIntervalSince(startTime)
        #expect(elapsedTime >= 1.0, "Service should simulate network delay of at least 1 second")
    }
}
