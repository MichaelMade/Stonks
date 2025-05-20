//
//  StocksResponseTests.swift
//  StonksTests
//
//  Created by Michael Moore on 5/19/25.
//

import Testing
import Foundation
@testable import Stonks

struct StocksResponseTests {
    
    @Test func decodesValidJSONCorrectly() throws {
        // Given
        let jsonString = """
        {
          "stocks": [
            {
              "id": "AAPL",
              "ticker": "AAPL",
              "name": "Apple Inc.",
              "currentPrice": 182.63,
              "previousClosePrice": 180.25,
              "isFeatured": true
            },
            {
              "id": "MSFT",
              "ticker": "MSFT",
              "name": "Microsoft Corporation",
              "currentPrice": 338.46,
              "previousClosePrice": 340.12,
              "isFeatured": false
            }
          ]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let stocksResponse = try decoder.decode(StocksResponse.self, from: jsonData)
        
        // Then
        #expect(stocksResponse.stocks.count == 2, "Should decode 2 stocks from the JSON")
        
        let apple = stocksResponse.stocks[0]
        #expect(apple.id == "AAPL", "First stock ID should be AAPL")
        #expect(apple.ticker == "AAPL", "First stock ticker should be AAPL")
        #expect(apple.name == "Apple Inc.", "First stock name should be Apple Inc.")
        #expect(apple.currentPrice == 182.63, "First stock current price should be 182.63")
        #expect(apple.previousClosePrice == 180.25, "First stock previous close price should be 180.25")
        #expect(apple.isFeatured == true, "First stock should be featured")
        
        let microsoft = stocksResponse.stocks[1]
        #expect(microsoft.id == "MSFT", "Second stock ID should be MSFT")
        #expect(microsoft.ticker == "MSFT", "Second stock ticker should be MSFT")
        #expect(microsoft.name == "Microsoft Corporation", "Second stock name should be Microsoft Corporation")
        #expect(microsoft.currentPrice == 338.46, "Second stock current price should be 338.46")
        #expect(microsoft.previousClosePrice == 340.12, "Second stock previous close price should be 340.12")
        #expect(microsoft.isFeatured == false, "Second stock should not be featured")
    }
    
    @Test func failsWithInvalidJSON() {
        // Given invalid JSON missing required fields
        let invalidJsonString = """
        {
          "stocks": [
            {
              "id": "AAPL",
              "name": "Apple Inc."
            }
          ]
        }
        """
        
        let invalidJsonData = invalidJsonString.data(using: .utf8)!
        
        // When & Then
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(StocksResponse.self, from: invalidJsonData)
        #expect(decodedData == nil)
    }
    
    @Test func handlesEmptyStocksList() throws {
        // Given JSON with empty stocks array
        let emptyJsonString = """
        {
          "stocks": []
        }
        """
        
        let jsonData = emptyJsonString.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let stocksResponse = try decoder.decode(StocksResponse.self, from: jsonData)
        
        // Then
        #expect(stocksResponse.stocks.isEmpty, "Should handle empty stocks array")
    }
    
    @Test func handlesExtremeValues() throws {
        // Test with very large and small price values
        let extremeJsonString = """
        {
          "stocks": [
            {
              "id": "PENNY",
              "ticker": "PENNY",
              "name": "Penny Stock",
              "currentPrice": 0.01,
              "previousClosePrice": 0.02,
              "isFeatured": false
            },
            {
              "id": "EXPENSIVE",
              "ticker": "EXPENSIVE",
              "name": "Expensive Stock",
              "currentPrice": 999999.99,
              "previousClosePrice": 1000000.00,
              "isFeatured": true
            }
          ]
        }
        """
        
        let jsonData = extremeJsonString.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let stocksResponse = try decoder.decode(StocksResponse.self, from: jsonData)
        
        // Then
        #expect(stocksResponse.stocks.count == 2, "Should decode both extreme value stocks")
        
        let pennyStock = stocksResponse.stocks[0]
        #expect(pennyStock.currentPrice == 0.01, "Should handle very small prices")
        #expect(abs(pennyStock.priceChange - (-0.01)) < 0.001, "Should calculate negative penny change")
        
        let expensiveStock = stocksResponse.stocks[1]
        #expect(expensiveStock.currentPrice == 999999.99, "Should handle very large prices")
        #expect(abs(expensiveStock.priceChange - (-0.01)) < 0.01, "Should calculate small negative change for large numbers")
    }
}
