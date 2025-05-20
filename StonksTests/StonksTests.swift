//
//  StonksTests.swift
//  StonksTests
//
//  Created by Michael Moore on 5/15/25.
//

import Testing
@testable import Stonks

struct StonksTests {
    // This is the main test suite that imports and runs all our tests
    @Test func allTests() async throws {
        // Models
        StockTests().stockComputedProperties()
        StockTests().stockEquality()
        
        // JSON Decoding
        try StocksResponseTests().decodesValidJSONCorrectly()
        StocksResponseTests().failsWithInvalidJSON()
        
        // Services
        try await StockServiceTests().fetchStocksSuccess()
        
        // ViewModels
        try await StockViewModelTests().loadStocksSuccess()
        try await StockViewModelTests().loadStocksFailure()
        try await StockViewModelTests().featuredStocks()
        try await StockViewModelTests().favoritesManagement()
        try await StockViewModelTests().sortFavorites()
        try await StockViewModelTests().persistenceAndReload()
    }
}
