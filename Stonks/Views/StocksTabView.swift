//
//  StocksTabView.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct StocksTabView: View {
    @ObservedObject var viewModel: StockViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.background
                    .edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    LoadingAnimationView()
                        .accessibilityLabel("Loading stocks")
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage) {
                        Task {
                            await viewModel.loadStocks()
                        }
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            if !viewModel.featuredStocks.isEmpty {
                                FeaturedStocksView(
                                    stocks: viewModel.featuredStocks,
                                    isFavorite: { viewModel.isFavorite(stock: $0) },
                                    onFavoriteToggle: { viewModel.toggleFavorite(for: $0) }
                                )
                                .transition(.opacity)
                            }
                            
                            Text("All Stocks")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(ColorTheme.label)
                                .padding(.horizontal)
                                .accessibilityAddTraits(.isHeader)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(Array(viewModel.stocks.enumerated()), id: \.element.id) { index, stock in
                                    StockCellView(
                                        stock: stock,
                                        isFavorite: viewModel.isFavorite(stock: stock),
                                        onFavoriteToggle: { viewModel.toggleFavorite(for: stock) }
                                    )
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.05), value: viewModel.stocks)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        await viewModel.loadStocks()
                    }
                    .accessibilityAction(named: "Refresh stocks") {
                        Task {
                            await viewModel.loadStocks()
                        }
                    }
                }
            }
            .navigationTitle("Stonks")
            // Support dynamic type
            .dynamicTypeSize(.xSmall ... .xxxLarge)
            .task {
                if viewModel.stocks.isEmpty {
                    await viewModel.loadStocks()
                }
            }
        }
    }
}

#Preview {
    StocksTabView(viewModel: StockViewModel())
}
