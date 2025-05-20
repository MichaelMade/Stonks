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
}