//
//  FeaturedStocksView.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct FeaturedStocksView: View {
    let stocks: [Stock]
    
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
                    ForEach(stocks, id: \.id) { stock in
                        FeaturedStockCard(stock: stock)
                        .frame(width: 200, height: 130)
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
    
    FeaturedStocksView(stocks: sampleStocks)
        .background(ColorTheme.background)
        .environmentObject(StockViewModel())
}
