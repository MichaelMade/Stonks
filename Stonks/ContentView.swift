//
//  ContentView.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var stockViewModel: StockViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            StocksTabView()
                .tabItem {
                    Label("Stonks", systemImage: "chart.line.uptrend.xyaxis")
                }
                .accessibilityHint("View all stocks")
                .tag(0)
            
            FavoritesTabView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
                .accessibilityHint("View your favorite stocks")
                .tag(1)
        }
        .accentColor(ColorTheme.accent)
        .preferredColorScheme(.none)
        .dynamicTypeSize(.xSmall ... .xxxLarge)
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }
}

#Preview {
    ContentView()
        .environmentObject(StockViewModel())
}
