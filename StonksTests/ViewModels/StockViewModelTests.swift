//
//  StockViewModelTests.swift
//  StonksTests
//
//  Created by Michael Moore on 5/19/25.
//

import Testing
@testable import Stonks

@MainActor
struct StockViewModelTests {
    
    @Test func loadStocksSuccess() async throws {
        // Given
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        mockService.stocksToReturn = MockStockService.createTestStocks()
        
        // When
        await viewModel.loadStocks()
        
        // Then
        #expect(viewModel.stocks.count == 4, "ViewModel should have 4 stocks")
        #expect(viewModel.isLoading == false, "Loading state should be false after successful fetch")
        #expect(viewModel.errorMessage == nil, "Error message should be nil after successful fetch")
    }
    
    @Test func loadStocksFailure() async throws {
        // Given
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        mockService.errorToThrow = StockError.failedToLoadData
        
        // When
        await viewModel.loadStocks()
        
        // Then
        #expect(viewModel.stocks.isEmpty, "ViewModel should have no stocks after failed fetch")
        #expect(viewModel.isLoading == false, "Loading state should be false after failed fetch")
        #expect(viewModel.errorMessage != nil, "Error message should not be nil after failed fetch")
    }
    
    @Test func featuredStocks() async throws {
        // Given
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        mockService.stocksToReturn = MockStockService.createTestStocks()
        await viewModel.loadStocks()
        
        // When
        let featured = viewModel.featuredStocks
        
        // Then
        #expect(featured.count == 2, "Should have 2 featured stocks")
        #expect(featured.allSatisfy { $0.isFeatured }, "All returned stocks should be featured")
        #expect(featured.contains { $0.id == "AAPL" }, "AAPL should be a featured stock")
        #expect(featured.contains { $0.id == "GOOGL" }, "GOOGL should be a featured stock")
    }
    
    @Test func favoritesManagement() async throws {
        // Given
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        mockService.stocksToReturn = MockStockService.createTestStocks()
        await viewModel.loadStocks()
        
        // When - Test adding favorites
        viewModel.toggleFavorite(for: viewModel.stocks[0]) // AAPL
        viewModel.toggleFavorite(for: viewModel.stocks[2]) // MSFT
        
        // Then
        #expect(viewModel.favorites.count == 2, "Should have 2 favorite stocks")
        #expect(viewModel.isFavorite(stock: viewModel.stocks[0]), "AAPL should be a favorite")
        #expect(viewModel.isFavorite(stock: viewModel.stocks[2]), "MSFT should be a favorite")
        #expect(!viewModel.isFavorite(stock: viewModel.stocks[1]), "GOOGL should not be a favorite")
        
        // When - Test removing a favorite
        viewModel.toggleFavorite(for: viewModel.stocks[0])
        
        // Then
        #expect(viewModel.favorites.count == 1, "Should have 1 favorite stock after removal")
        #expect(!viewModel.isFavorite(stock: viewModel.stocks[0]), "AAPL should no longer be a favorite")
        #expect(viewModel.isFavorite(stock: viewModel.stocks[2]), "MSFT should still be a favorite")
        
        // Verify UserDefaults was updated
        let savedFavorites = mockUserDefaults.stringArray(forKey: "favoriteStocks")
        #expect(savedFavorites?.count == 1, "UserDefaults should have 1 favorite")
        #expect(savedFavorites?.contains("MSFT") ?? false, "UserDefaults should contain MSFT")
    }
    
    @Test func sortFavorites() async throws {
        // Given
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        mockService.stocksToReturn = MockStockService.createTestStocks()
        await viewModel.loadStocks()
        
        // Add 3 stocks as favorites: AAPL (+5), GOOGL (-50), MSFT (+5)
        viewModel.toggleFavorite(for: viewModel.stocks[0]) // AAPL: +$5 (+3.45%)
        viewModel.toggleFavorite(for: viewModel.stocks[1]) // GOOGL: -$50 (-1.96%)
        viewModel.toggleFavorite(for: viewModel.stocks[2]) // MSFT: +$5 (+1.69%)
        
        // When - Sort ascending
        let ascendingResult = viewModel.sortFavorites(byPriceChangeAscending: true)
        
        // Then
        #expect(ascendingResult.count == 3, "Should have 3 sorted favorites")
        #expect(ascendingResult[0].id == "GOOGL", "GOOGL should be first with lowest price change")
        #expect(ascendingResult[1].id == "AAPL" || ascendingResult[1].id == "MSFT", "AAPL or MSFT should be next")
        
        // When - Sort descending
        let descendingResult = viewModel.sortFavorites(byPriceChangeAscending: false)
        
        // Then
        #expect(descendingResult.count == 3, "Should have 3 sorted favorites")
        #expect(descendingResult[0].id == "AAPL" || descendingResult[0].id == "MSFT", "AAPL or MSFT should be first with highest price change")
        #expect(descendingResult[2].id == "GOOGL", "GOOGL should be last with lowest price change")
    }
    
    @Test func persistenceAndReload() async throws {
        // Given
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        
        // Set up initial favorites
        mockUserDefaults.set(["AAPL", "TSLA"], forKey: "favoriteStocks")
        
        // When - Create a new view model that should load favorites from UserDefaults
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        // Then - Should have loaded favorites from UserDefaults
        #expect(viewModel.favoriteStocks.count == 2, "Should have 2 favorites from UserDefaults")
        #expect(viewModel.favoriteStocks.contains("AAPL"), "Should contain AAPL from UserDefaults")
        #expect(viewModel.favoriteStocks.contains("TSLA"), "Should contain TSLA from UserDefaults")
        
        // When - Add a new favorite and create a new view model
        viewModel.toggleFavorite(for: Stock(id: "MSFT", ticker: "MSFT", name: "Microsoft", currentPrice: 0, previousClosePrice: 0, isFeatured: false))
        let newViewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        // Then - New view model should have updated favorites
        #expect(newViewModel.favoriteStocks.count == 3, "Should have 3 favorites in new view model")
        #expect(newViewModel.favoriteStocks.contains("MSFT"), "Should contain newly added MSFT")
    }
}
