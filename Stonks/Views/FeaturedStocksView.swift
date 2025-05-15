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

struct FeaturedStockCard: View {
    let stock: Stock
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(stock.ticker)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.label)
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? ColorTheme.favorite : .gray)
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
        .background(ColorTheme.secondaryBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .animation(.easeInOut(duration: 0.2), value: isFavorite)
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(stock.ticker), \(stock.name)")
        .accessibilityValue("Price: $\(String(format: "%.2f", stock.currentPrice)), \(stock.priceChange >= 0 ? "Up" : "Down") \(String(format: "%.2f", abs(stock.priceChange)))")
        // Dynamic Type support
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }
}