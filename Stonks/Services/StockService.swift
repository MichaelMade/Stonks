//
//  StockService.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import Foundation

class StockService {
    enum StockError: Error {
        case failedToLoadData
        case invalidResponse
    }
    
    func fetchStocks() async throws -> [Stock] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // Load mock data from JSON file
        guard let url = Bundle.main.url(forResource: "example_response", withExtension: "json") else {
            throw StockError.failedToLoadData
        }
        
        let data = try Data(contentsOf: url)
        let stocksResponse = try JSONDecoder().decode(StocksResponse.self, from: data)
        return stocksResponse.stocks
    }
}
