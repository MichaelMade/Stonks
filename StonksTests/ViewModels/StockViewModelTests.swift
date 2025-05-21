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
    
    @Test func loadEmptyStockList() async throws {
        // Given
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        // Empty stock list
        mockService.stocksToReturn = []
        
        // When
        await viewModel.loadStocks()
        
        // Then
        #expect(viewModel.stocks.isEmpty, "ViewModel should have empty stocks array")
        #expect(viewModel.featuredStocks.isEmpty, "Featured stocks should be empty")
        #expect(viewModel.favorites.isEmpty, "Favorites should be empty")
        #expect(viewModel.isLoading == false, "Loading state should be false after fetch")
        #expect(viewModel.errorMessage == nil, "Error message should be nil after successful fetch")
    }
    
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
        viewModel.setSortOrder(ascending: true)
        let ascendingResult = viewModel.sortedFavorites
        
        // Then
        #expect(ascendingResult.count == 3, "Should have 3 sorted favorites")
        #expect(ascendingResult[0].id == "GOOGL", "GOOGL should be first with lowest price change")
        #expect(ascendingResult[1].id == "AAPL" || ascendingResult[1].id == "MSFT", "AAPL or MSFT should be next")
        
        // When - Sort descending
        viewModel.setSortOrder(ascending: false)
        let descendingResult = viewModel.sortedFavorites
        
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
    
    @Test func favoritesWithInvalidStockIDs() async throws {
        // Given
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        
        // Set up favorites that don't exist in our stock list
        mockUserDefaults.set(["NONEXISTENT1", "NONEXISTENT2"], forKey: "favoriteStocks")
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        // Add real stocks
        mockService.stocksToReturn = MockStockService.createTestStocks()
        await viewModel.loadStocks()
        
        // When
        let favorites = viewModel.favorites
        
        // Then
        #expect(viewModel.favoriteStocks.count == 2, "Should have 2 favorite IDs")
        #expect(favorites.isEmpty, "Should have 0 actual favorite stocks because the IDs don't match any stocks")
    }
    
    @Test func emptyFeaturedStocks() async throws {
        // Given
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        // Use test factory to create non-featured stocks
        mockService.stocksToReturn = TestFactory.createStocks(count: 5, featured: false)
        
        // When
        await viewModel.loadStocks()
        
        // Then
        #expect(viewModel.stocks.count == 5, "Should have 5 stocks")
        #expect(viewModel.featuredStocks.isEmpty, "Featured stocks should be empty")
    }
    
    @Test func testWithMixedStocksAndFavorites() async throws {
        // Given
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        
        // Set up favorites
        mockUserDefaults.setupFavorites(["TEST0", "TEST3"])
        
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        // Use test factory to create a mix of featured and non-featured stocks
        mockService.stocksToReturn = TestFactory.createMixedStocks(featuredCount: 2, normalCount: 3)
        
        // When
        await viewModel.loadStocks()
        
        // Then
        #expect(viewModel.stocks.count == 5, "Should have 5 stocks total")
        #expect(viewModel.featuredStocks.count == 2, "Should have 2 featured stocks")
        #expect(viewModel.favorites.count == 2, "Should have 2 favorite stocks")
        
        // Test that both lists correctly identify the right stocks
        #expect(viewModel.featuredStocks.allSatisfy { $0.isFeatured }, "All featured stocks should have isFeatured=true")
        #expect(viewModel.favorites.allSatisfy { viewModel.favoriteStocks.contains($0.id) }, "All favorites should have their ID in favoriteStocks")
    }
    
    @Test func viewModelStateManagement() async throws {
        // Test that loading states are managed correctly
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        mockService.stocksToReturn = MockStockService.createTestStocks()
        mockService.delayInSeconds = 1
        
        // Initially should not be loading
        #expect(viewModel.isLoading == false, "Should not be loading initially")
        #expect(viewModel.errorMessage == nil, "Should have no error initially")
        
        // Start loading
        let loadTask = Task {
            await viewModel.loadStocks()
        }
        
        // Check loading state after a brief moment
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds  
        #expect(viewModel.isLoading == true, "Should be loading during fetch")
        #expect(viewModel.errorMessage == nil, "Should have no error during loading")
        
        // Wait for completion
        await loadTask.value
        
        // Should finish loading successfully
        #expect(viewModel.isLoading == false, "Should not be loading after completion")
        #expect(viewModel.errorMessage == nil, "Should have no error after successful fetch")
        #expect(viewModel.stocks.count == 4, "Should have loaded stocks")
    }
    
    
    
    @Test func errorRecovery() async throws {
        // Test that view model can recover from errors
        let mockService = MockStockService()
        let mockUserDefaults = MockUserDefaults()
        let viewModel = StockViewModel(stockService: mockService, userDefaults: mockUserDefaults)
        
        // First request fails
        mockService.errorToThrow = StockError.failedToLoadData
        await viewModel.loadStocks()
        
        #expect(viewModel.stocks.isEmpty, "Should have no stocks after error")
        #expect(viewModel.errorMessage != nil, "Should have error message")
        #expect(!viewModel.isLoading, "Should not be loading after error")
        
        // Second request succeeds
        mockService.errorToThrow = nil
        mockService.stocksToReturn = MockStockService.createTestStocks()
        await viewModel.loadStocks()
        
        #expect(viewModel.stocks.count == 4, "Should have stocks after successful recovery")
        #expect(viewModel.errorMessage == nil, "Should clear error message on success")
        #expect(!viewModel.isLoading, "Should not be loading after success")
    }
}
