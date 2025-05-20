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
                    ForEach(stocks) { stock in
                        FeaturedStockCard(
                            stock: stock,
                            isFavorite: isFavorite(stock),
                            onFavoriteToggle: { onFavoriteToggle(stock) }
                        )
                        .frame(width: 170, height: 130)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .accessibilityLabel("Horizontal scrolling list of featured stocks")
        }
    }
}
