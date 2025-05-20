//
//  StockCellView.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct StockCellView: View {
    let stock: Stock
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.ticker)
                    .font(.headline)
                    .foregroundColor(ColorTheme.label)
                Text(stock.name)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(ColorTheme.secondaryLabel)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(String(format: "%.2f", stock.currentPrice))")
                    .font(.headline)
                    .foregroundColor(ColorTheme.label)
                
                HStack(spacing: 2) {
                    Image(systemName: stock.priceChange >= 0 ? "arrow.up" : "arrow.down")
                    
                    Text("\(stock.priceChange >= 0 ? "+" : "")\(String(format: "%.2f", stock.priceChange)) (\(String(format: "%.2f", stock.priceChangePercentage))%)")
                        .font(.subheadline)
                }
                .foregroundColor(stock.priceChange >= 0 ? ColorTheme.positiveChange : ColorTheme.negativeChange)
            }
            
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                onFavoriteToggle()
            }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? ColorTheme.favorite : .gray)
                    .font(.title2)
                    .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.leading, 8)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorTheme.accent.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(isPressed ? 0.12 : 0.06), radius: isPressed ? 6 : 4, x: 0, y: isPressed ? 4 : 2)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(stock.name), \(stock.ticker), Price: $\(String(format: "%.2f", stock.currentPrice))")
        .accessibilityValue("\(stock.priceChange >= 0 ? "Up" : "Down") \(String(format: "%.2f", abs(stock.priceChange))), \(String(format: "%.2f", abs(stock.priceChangePercentage)))% \(stock.priceChange >= 0 ? "gain" : "loss"), \(isFavorite ? "favorited" : "not in favorites")")
        // Support Dynamic Type
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }
}

#Preview {
    let sampleStocks = [
        Stock(
            id: "1",
            ticker: "AAPL",
            name: "Apple Inc.",
            currentPrice: 150.25,
            previousClosePrice: 148.50,
            isFeatured: false
        ),
        Stock(
            id: "2",
            ticker: "TSLA",
            name: "Tesla, Inc.",
            currentPrice: 245.80,
            previousClosePrice: 250.15,
            isFeatured: false
        ),
        Stock(
            id: "3",
            ticker: "GOOGL",
            name: "Alphabet Inc.",
            currentPrice: 2750.80,
            previousClosePrice: 2732.10,
            isFeatured: false
        ),
        Stock(
            id: "4",
            ticker: "MSFT",
            name: "Microsoft Corporation",
            currentPrice: 338.46,
            previousClosePrice: 340.12,
            isFeatured: false
        )
    ]
    
    VStack(spacing: 12) {
        ForEach(sampleStocks) { stock in
            StockCellView(
                stock: stock,
                isFavorite: stock.ticker == "AAPL",
                onFavoriteToggle: {}
            )
        }
    }
    .padding()
    .background(ColorTheme.background)
}
