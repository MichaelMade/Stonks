//
//  FavoritesTabView.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct FavoritesTabView: View {
    @EnvironmentObject var viewModel: StockViewModel
    @State private var sortAscending = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.background
                    .edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    LoadingAnimationView()
                        .accessibilityLabel("Loading favorites")
                } else {
                    VStack {
                        if viewModel.favorites.isEmpty {
                            EmptyStateView(
                                title: "No Favorite Stocks",
                                message: "Add stocks to your favorites from the Stocks tab.",
                                systemImage: "star.slash"
                            )
                        } else {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Sort by price change:")
                                        .font(.subheadline)
                                        .foregroundColor(ColorTheme.secondaryLabel)
                                    
                                    Button(action: { 
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                            sortAscending.toggle()
                                            viewModel.setSortOrder(ascending: sortAscending)
                                        }
                                    }) {
                                        HStack {
                                            Text(sortAscending ? "Ascending" : "Descending")
                                                .font(.subheadline)
                                            
                                            Image(systemName: "arrow.up")
                                                .rotationEffect(.degrees(sortAscending ? 0 : 180))
                                        }
                                        .foregroundColor(ColorTheme.accent)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(ColorTheme.accent.opacity(0.1))
                                        .cornerRadius(8)
                                    }
                                    .accessibilityLabel("Sort by price change")
                                    .accessibilityValue(sortAscending ? "Ascending" : "Descending")
                                    .accessibilityHint("Tap to toggle sorting order")
                                }
                                .padding(.horizontal)
                                
                                Text("Showing \(viewModel.favorites.count) favorite stocks")
                                    .font(.caption)
                                    .foregroundColor(ColorTheme.secondaryLabel)
                                    .padding(.horizontal)
                                    .accessibilityLabel("Showing \(viewModel.favorites.count) favorite stocks")
                                
                                ScrollView {
                                    LazyVStack(spacing: 12) {
                                        ForEach(Array(viewModel.sortedFavorites.enumerated()), id: \.element.id) { index, stock in
                                            StockCellView(stock: stock)
                                            .transition(.asymmetric(
                                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                                removal: .move(edge: .leading).combined(with: .opacity)
                                            ))
                                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.05), value: sortAscending)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .accessibilityAction(named: "Sort \(sortAscending ? "Descending" : "Ascending")") {
                                    withAnimation {
                                        sortAscending.toggle()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            // Support dynamic type
            .dynamicTypeSize(.xSmall ... .xxxLarge)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    FavoritesTabView()
        .environmentObject(StockViewModel())
}
