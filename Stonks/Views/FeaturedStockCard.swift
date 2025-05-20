//
//  FeaturedStockCard.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct FeaturedStockCard: View {
    let stock: Stock
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    @State private var isPressed = false
    @State private var starScale: CGFloat = 1.0
    
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
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        starScale = 1.3
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            starScale = 1.0
                        }
                    }
                    
                    onFavoriteToggle()
                }) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? ColorTheme.favorite : .gray)
                        .scaleEffect(starScale)
                        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            Text(stock.name)
                .font(.subheadline)
                .foregroundColor(ColorTheme.secondaryLabel)
                .lineLimit(2)
                .padding(.top, 1)
            
            Spacer()
            
            Text("$\(String(format: "%.2f", stock.currentPrice))")
                .font(.headline)
                .foregroundColor(ColorTheme.label)
            
            HStack(spacing: 2) {
                Image(systemName: stock.priceChange >= 0 ? "arrow.up" : "arrow.down")
                
                Text("\(stock.priceChange >= 0 ? "+" : "")\(String(format: "%.2f", stock.priceChange))")
                    .font(.subheadline)
            }
            .foregroundColor(stock.priceChange >= 0 ? ColorTheme.positiveChange : ColorTheme.negativeChange)
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
        .shadow(color: Color.black.opacity(isPressed ? 0.15 : 0.08), radius: isPressed ? 8 : 6, x: 0, y: isPressed ? 6 : 3)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isFavorite)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = pressing
            }
        }, perform: {})
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(stock.ticker), \(stock.name)")
        .accessibilityValue("Price: $\(String(format: "%.2f", stock.currentPrice)), \(stock.priceChange >= 0 ? "Up" : "Down") \(String(format: "%.2f", abs(stock.priceChange)))")
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
        FeaturedStockCard(
            stock: sampleStock1,
            isFavorite: false,
            onFavoriteToggle: {}
        )
        .frame(width: 170, height: 130)
        
        FeaturedStockCard(
            stock: sampleStock2,
            isFavorite: true,
            onFavoriteToggle: {}
        )
        .frame(width: 170, height: 130)
    }
    .padding()
    .background(ColorTheme.background)
}
