//
//  ColorTheme.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct ColorTheme {
    static let accent = Color("AccentColor")
    
    static let positiveChange = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let negativeChange = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    
    static let label = Color(.label)
    static let secondaryLabel = Color(.secondaryLabel)
    static let tertiaryLabel = Color(.tertiaryLabel)
    
    static let favorite = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static var accentGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [accent, accent.opacity(0.7)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var positiveGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [positiveChange, positiveChange.opacity(0.7)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var negativeGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [negativeChange, negativeChange.opacity(0.7)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func cardGradient(for color: Color) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [color, color.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
