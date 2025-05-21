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
        .gesture(
            DragGesture()
                .onEnded { value in
                    let threshold: CGFloat = 50
                    if value.translation.width > threshold && selectedTab == 1 {
                        // Swipe right - go to previous tab (Stocks)
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedTab = 0
                        }
                    } else if value.translation.width < -threshold && selectedTab == 0 {
                        // Swipe left - go to next tab (Favorites)
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedTab = 1
                        }
                    }
                }
        )
        .accentColor(ColorTheme.accent)
        .preferredColorScheme(.none)
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }
}


#Preview {
    ContentView()
        .environmentObject(StockViewModel())
}