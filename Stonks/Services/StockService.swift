//
//  StockService.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import Foundation

// Protocol for dependency injection and mocking in tests
protocol StockServiceProtocol {
    func fetchStocks() async throws -> [Stock]
}

class StockService: StockServiceProtocol {
    func fetchStocks() async throws -> [Stock] {
        // Simulate network delay
        do {
            try await Task.sleep(for: .seconds(1)) // 1 second delay
        } catch {
            throw StockError.networkUnavailable
        }
        
        // Load mock data from JSON file
        guard let url = Bundle.main.url(forResource: "example_response", withExtension: "json") else {
            throw StockError.fileNotFound("example_response.json")
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            guard !data.isEmpty else {
                throw StockError.invalidResponse
            }
            
            let stocksResponse = try JSONDecoder().decode(StocksResponse.self, from: data)
            
            // Validate the response has stocks
            guard !stocksResponse.stocks.isEmpty else {
                throw StockError.invalidResponse
            }
            
            return stocksResponse.stocks
            
        } catch let decodingError as DecodingError {
            throw StockError.decodingFailed(decodingError)
        } catch {
            throw StockError.failedToLoadData
        }
    }
}
