//
//  StockViewModel.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import Foundation
import SwiftUI

@MainActor
class StockViewModel: ObservableObject {
    @Published var stocks: [Stock] = [] {
        didSet {
            updateDerivedProperties()
        }
    }
    @Published var favoriteStocks: [String] = [] {
        didSet {
            updateDerivedProperties()
        }
    }
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastError: Error?
    
    // Cached computed properties
    @Published private(set) var featuredStocks: [Stock] = []
    @Published private(set) var favorites: [Stock] = []
    @Published private(set) var sortedFavorites: [Stock] = []
    @Published private(set) var stocksWithIndices: [(Int, Stock)] = []
    
    private let stockService: StockServiceProtocol
    private let userDefaults: UserDefaults
    private let favoritesKey = "favoriteStocks"
    private var retryCount = 0
    private let maxRetries = 3
    private var favoriteSortAscending = false
    
    init(stockService: StockServiceProtocol = StockService(), userDefaults: UserDefaults = .standard) {
        self.stockService = stockService
        self.userDefaults = userDefaults
        loadFavorites()
    }
    
    func loadStocks() async {
        await loadStocksWithRetry()
    }
    
    private func loadStocksWithRetry() async {
        isLoading = true
        errorMessage = nil
        lastError = nil
        
        do {
            stocks = try await stockService.fetchStocks()
            // Reset retry count on successful load
            retryCount = 0
            isLoading = false
        } catch {
            lastError = error
            isLoading = false
            
            // Handle specific error types
            switch error {
                case let stockError as StockError:
                    errorMessage = stockError.localizedDescription
                    
                    // Auto-retry for certain error types
                    if shouldRetry(for: stockError) && retryCount < maxRetries {
                        retryCount += 1
                        // Wait before retrying (exponential backoff)
                        let delay = UInt64(pow(2.0, Double(retryCount)) * 1_000_000_000) // 2^retryCount seconds
                        try? await Task.sleep(nanoseconds: delay)
                        await loadStocksWithRetry()
                    }
                default:
                    errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
            }
        }
    }
    
    private func shouldRetry(for error: StockError) -> Bool {
        switch error {
            case .networkUnavailable, .failedToLoadData:
                return true
            case .invalidResponse, .decodingFailed, .fileNotFound:
                return false
        }
    }
    
    func retryLoading() async {
        retryCount = 0
        await loadStocks()
    }
    
    var canRetry: Bool {
        return lastError != nil && !isLoading
    }
    
    var isRetryableError: Bool {
        guard let stockError = lastError as? StockError else { return true }
        return shouldRetry(for: stockError)
    }
    
    // MARK: - Favorites Management
    
    func toggleFavorite(for stock: Stock) {
        if favoriteStocks.contains(stock.id) {
            favoriteStocks.removeAll { $0 == stock.id }
        } else {
            favoriteStocks.append(stock.id)
        }
        saveFavorites()
    }
    
    func isFavorite(stock: Stock) -> Bool {
        return favoriteStocks.contains(stock.id)
    }
    
    // MARK: - Persistence
    
    private func saveFavorites() {
        userDefaults.set(favoriteStocks, forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        favoriteStocks = userDefaults.stringArray(forKey: favoritesKey) ?? []
    }
    
    // MARK: - Derived Properties Update
    
    private func updateDerivedProperties() {
        featuredStocks = stocks.filter { $0.isFeatured }
        favorites = stocks.filter { favoriteStocks.contains($0.id) }
        stocksWithIndices = Array(stocks.enumerated())
        updateSortedFavorites()
    }
    
    // MARK: - Sorting
    
    func setSortOrder(ascending: Bool) {
        favoriteSortAscending = ascending
        updateSortedFavorites()
    }
    
    private func updateSortedFavorites() {
        sortedFavorites = favorites.sorted { 
            favoriteSortAscending ? $0.priceChange < $1.priceChange : $0.priceChange > $1.priceChange
        }
    }
    
    var isSortedAscending: Bool {
        favoriteSortAscending
    }
}
