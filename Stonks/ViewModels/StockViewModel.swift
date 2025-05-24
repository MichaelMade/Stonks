//
//  StockViewModel.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import Foundation

@MainActor
class StockViewModel: ObservableObject {
    @Published var stocks: [Stock] = []
    @Published var favoriteStocks: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let stockService: StockServiceProtocol
    private let userDefaults: UserDefaults
    private let favoritesKey = "favoriteStocks"
    private var favoriteSortAscending = false
    
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
            isLoading = false
            
            switch error {
                case let stockError as StockError:
                    errorMessage = stockError.localizedDescription
                default:
                    errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
            }
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
        favoriteStocks.contains(stock.id)
    }
    
    // MARK: - Persistence
    
    private func saveFavorites() {
        userDefaults.set(favoriteStocks, forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        favoriteStocks = userDefaults.stringArray(forKey: favoritesKey) ?? []
    }
    
    // MARK: - Computed Properties
    
    var featuredStocks: [Stock] {
        stocks.filter { $0.isFeatured }
    }
    
    var favorites: [Stock] {
        stocks.filter { favoriteStocks.contains($0.id) }
    }
    
    // MARK: - Sorting
    
    func setSortOrder(ascending: Bool) {
        favoriteSortAscending = ascending
    }
    
    var sortedFavorites: [Stock] {
        favorites.sorted { 
            favoriteSortAscending ? $0.priceChange < $1.priceChange : $0.priceChange > $1.priceChange
        }
    }
    
    var isSortedAscending: Bool {
        favoriteSortAscending
    }
}
