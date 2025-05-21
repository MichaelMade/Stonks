//
//  StockCellView.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct StockCellView: View {
    let stock: Stock
    @EnvironmentObject var viewModel: StockViewModel
    
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
                Text(stock.formattedCurrentPrice)
                    .font(.headline)
                    .foregroundColor(ColorTheme.label)
                
                HStack(spacing: 2) {
                    Image(systemName: ColorTheme.priceChangeIcon(for: stock.priceChange))
                    
                    Text("\(stock.formattedPriceChange) (\(stock.formattedPriceChangePercentage))")
                        .font(.subheadline)
                }
                .foregroundColor(ColorTheme.priceChangeColor(for: stock.priceChange))
            }
            
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    viewModel.toggleFavorite(for: stock)
                }
            }) {
                Image(systemName: viewModel.isFavorite(stock: stock) ? "star.fill" : "star")
                    .foregroundColor(viewModel.isFavorite(stock: stock) ? ColorTheme.favorite : .gray)
                    .font(.title2)
                    .accessibilityLabel(viewModel.isFavorite(stock: stock) ? "Remove from favorites" : "Add to favorites")
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
        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabelText)
        .accessibilityValue(accessibilityValueText)
        // Support Dynamic Type
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }
    
    private var accessibilityLabelText: String {
        "\(stock.name), \(stock.ticker), Price: \(stock.formattedCurrentPrice)"
    }
    
    private var accessibilityValueText: String {
        let favoriteStatus = viewModel.isFavorite(stock: stock) ? "favorited" : "not favorited"
        return "\(stock.priceChangeDirection) by $\(String(format: "%.2f", abs(stock.priceChange))), \(String(format: "%.2f", abs(stock.priceChangePercentage))) percent, \(favoriteStatus)"
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
            StockCellView(stock: stock)
        }
    }
    .padding()
    .background(ColorTheme.background)
    .environmentObject(StockViewModel())
}
