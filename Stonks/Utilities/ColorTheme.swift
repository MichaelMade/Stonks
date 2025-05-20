//
//  ColorTheme.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct ColorTheme {
    static let accent = Color("AccentColor")
    
    static let positiveChange = Color("PositiveColor")
    static let negativeChange = Color("NegativeColor")
    
    static let favorite = Color("FavoriteColor")
    
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    
    static let label = Color(.label)
    static let secondaryLabel = Color(.secondaryLabel)
    static let tertiaryLabel = Color(.tertiaryLabel)
    
    // MARK: - Helper Methods
    
    static func priceChangeColor(for change: Double) -> Color {
        change >= 0 ? positiveChange : negativeChange
    }
    
    static func priceChangeIcon(for change: Double) -> String {
        change >= 0 ? "arrow.up" : "arrow.down"
    }
}
