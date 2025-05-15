import SwiftUI

struct ContentView: View {
    @StateObject private var stockViewModel = StockViewModel()
    
    var body: some View {
        TabView {
            StocksTabView(viewModel: stockViewModel)
                .tabItem {
                    Label("Stonks", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            FavoritesTabView(viewModel: stockViewModel)
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
        }
        .accentColor(ColorTheme.accent)
        .preferredColorScheme(.none) // Allows system to switch between light and dark mode
    }
}

#Preview {
    ContentView()
}
