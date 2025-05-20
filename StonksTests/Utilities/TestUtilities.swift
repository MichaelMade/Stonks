//
//  TestUtilities.swift
//  StonksTests
//
//  Created by Michael Moore on 5/19/25.
//

import Foundation
@testable import Stonks

// MARK: - Test Data Factory

struct TestFactory {
    // Creates a stock with default values that can be overridden
    static func createStock(
        id: String = "TEST",
        ticker: String? = nil,
        name: String = "Test Stock",
        currentPrice: Double = 100.0,
        previousClosePrice: Double = 90.0,
        isFeatured: Bool = false
    ) -> Stock {
        return Stock(
            id: id,
            ticker: ticker ?? id,
            name: name,
            currentPrice: currentPrice,
            previousClosePrice: previousClosePrice,
            isFeatured: isFeatured
        )
    }
    
    // Creates an array of test stocks
    static func createStocks(count: Int = 5, featured: Bool = false) -> [Stock] {
        return (0..<count).map { i in
            let id = "TEST\(i)"
            return createStock(
                id: id,
                name: "Test Stock \(i)",
                currentPrice: Double(100 + i * 10),
                previousClosePrice: Double(95 + i * 10),
                isFeatured: featured
            )
        }
    }
    
    // Creates a mixed array of featured and non-featured stocks
    static func createMixedStocks(featuredCount: Int = 2, normalCount: Int = 3) -> [Stock] {
        let featured = createStocks(count: featuredCount, featured: true)
        let normal = createStocks(count: normalCount, featured: false)
        return featured + normal
    }
}

// MARK: - UserDefaults Extensions

extension MockUserDefaults {
    // Helper to quickly setup favorites
    func setupFavorites(_ favorites: [String]) {
        set(favorites, forKey: "favoriteStocks")
    }
    
    // Helper to get current favorites
    func getFavorites() -> [String] {
        return stringArray(forKey: "favoriteStocks") ?? []
    }
    
    // Reset the storage
    func reset() {
        storage.removeAll()
    }
}