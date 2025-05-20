//
//  FeaturedStocksView.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct FeaturedStocksView: View {
    let stocks: [Stock]
    let isFavorite: (Stock) -> Bool
    let onFavoriteToggle: (Stock) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Featured Stocks")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.label)
                .padding(.horizontal)
                .accessibilityAddTraits(.isHeader)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(Array(stocks.enumerated()), id: \.element.id) { index, stock in
                        FeaturedStockCard(
                            stock: stock,
                            isFavorite: isFavorite(stock),
                            onFavoriteToggle: { onFavoriteToggle(stock) }
                        )
                        .frame(width: 200, height: 130)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: stocks)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .accessibilityLabel("Horizontal scrolling list of featured stocks")
        }
    }
}

#Preview {
    let sampleStocks = [
        Stock(id: "1", ticker: "AAPL", name: "Apple Inc.", currentPrice: 150.25, previousClosePrice: 148.50, isFeatured: true),
        Stock(id: "2", ticker: "GOOGL", name: "Alphabet Inc.", currentPrice: 2750.80, previousClosePrice: 2732.10, isFeatured: true),
        Stock(id: "3", ticker: "MSFT", name: "Microsoft Corporation", currentPrice: 305.15, previousClosePrice: 307.20, isFeatured: true)
    ]
    
    FeaturedStocksView(
        stocks: sampleStocks,
        isFavorite: { _ in Bool.random() },
        onFavoriteToggle: { _ in }
    )
    .background(ColorTheme.background)
}
