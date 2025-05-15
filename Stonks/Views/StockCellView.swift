import SwiftUI

struct StockCellView: View {
    let stock: Stock
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(ColorTheme.label)
                
                Text(stock.ticker)
                    .font(.subheadline)
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
            
            Button(action: onFavoriteToggle) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? ColorTheme.favorite : .gray)
                    .font(.title2)
                    .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.leading, 8)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(ColorTheme.background)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(stock.name), \(stock.ticker), Price: $\(String(format: "%.2f", stock.currentPrice))")
        .accessibilityValue("\(stock.priceChange >= 0 ? "Up" : "Down") \(String(format: "%.2f", abs(stock.priceChange))), \(String(format: "%.2f", abs(stock.priceChangePercentage)))% \(stock.priceChange >= 0 ? "gain" : "loss"), \(isFavorite ? "favorited" : "not in favorites")")
        // Support Dynamic Type
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }
}