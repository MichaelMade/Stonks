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
    @Published var stocks: [Stock] = []
    @Published var favoriteStocks: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let stockService: StockServiceProtocol
    private let userDefaults: UserDefaults
    private let favoritesKey = "favoriteStocks"
    
    var featuredStocks: [Stock] {
        stocks.filter { $0.isFeatured }
    }
    
    var favorites: [Stock] {
        stocks.filter { favoriteStocks.contains($0.id) }
    }
    
    init(stockService: StockServiceProtocol = StockService(), userDefaults: UserDefaults = .standard) {
        self.stockService = stockService
        self.userDefaults = userDefaults
        loadFavorites()
    }
    
    func loadStocks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            stocks = try await stockService.fetchStocks()
            isLoading = false
        } catch {
            errorMessage = "Failed to load stocks: \(error.localizedDescription)"
            isLoading = false
        }
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
    
    // MARK: - Sorting
    
    func sortFavorites(byPriceChangeAscending ascending: Bool) -> [Stock] {
        return favorites.sorted {
            if ascending {
                return $0.priceChange < $1.priceChange
            } else {
                return $0.priceChange > $1.priceChange
            }
        }
    }
}
