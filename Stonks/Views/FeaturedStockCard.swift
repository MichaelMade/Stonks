//
//  FeaturedStockCard.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct FeaturedStockCard: View {
    let stock: Stock
    @EnvironmentObject var viewModel: StockViewModel
        
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(stock.ticker)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.label)
                
                Spacer()
                
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    viewModel.toggleFavorite(for: stock)
                }) {
                    Image(systemName: viewModel.isFavorite(stock: stock) ? "star.fill" : "star")
                        .foregroundColor(viewModel.isFavorite(stock: stock) ? ColorTheme.favorite : .gray)
                        .accessibilityLabel(viewModel.isFavorite(stock: stock) ? "Remove from favorites" : "Add to favorites")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            Text(stock.name)
                .font(.subheadline)
                .foregroundColor(ColorTheme.secondaryLabel)
                .lineLimit(2)
                .padding(.top, 1)
            
            Spacer()
            
            Text(stock.formattedCurrentPrice)
                .font(.headline)
                .foregroundColor(ColorTheme.label)
            
            HStack(spacing: 2) {
                Image(systemName: ColorTheme.priceChangeIcon(for: stock.priceChange))
                
                Text(stock.formattedPriceChange)
                    .font(.subheadline)
            }
            .foregroundColor(ColorTheme.priceChangeColor(for: stock.priceChange))
        }
        .padding(12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorTheme.secondaryBackground,
                    ColorTheme.secondaryBackground.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(stock.ticker), \(stock.name)")
        .accessibilityValue("Price: \(stock.formattedCurrentPrice), \(stock.priceChangeDirection) by $\(String(format: "%.2f", abs(stock.priceChange)))")
        // Dynamic Type support
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }
}

#Preview {
    let sampleStock1 = Stock(
        id: "1",
        ticker: "AAPL", 
        name: "Apple Inc.", 
        currentPrice: 150.25, 
        previousClosePrice: 148.50, 
        isFeatured: true
    )
    let sampleStock2 = Stock(
        id: "2",
        ticker: "TSLA",
        name: "Tesla, Inc.",
        currentPrice: 245.80,
        previousClosePrice: 250.15,
        isFeatured: true
    )
    
    HStack(spacing: 16) {
        FeaturedStockCard(stock: sampleStock1)
            .frame(width: 170, height: 130)
        
        FeaturedStockCard(stock: sampleStock2)
            .frame(width: 170, height: 130)
    }
    .padding()
    .background(ColorTheme.background)
    .environmentObject(StockViewModel())
}
