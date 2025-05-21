//
//  StocksTabView.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

struct StocksTabView: View {
    @EnvironmentObject var viewModel: StockViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.background
                    .edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    LoadingAnimationView()
                        .accessibilityLabel("Loading stocks")
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(
                        message: errorMessage
                    ) {
                        Task {
                            await viewModel.loadStocks()
                        }
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            if !viewModel.featuredStocks.isEmpty {
                                FeaturedStocksView(stocks: viewModel.featuredStocks)
                                .transition(.opacity)
                            }
                            
                            Text("All Stocks")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(ColorTheme.label)
                                .padding(.horizontal)
                                .accessibilityAddTraits(.isHeader)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.stocksWithIndices, id: \.1.id) { index, stock in
                                    StockCellView(stock: stock)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(animationDelay(for: index)), value: viewModel.stocks)
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func animationDelay(for index: Int) -> Double {
        Double(index) * 0.05
    }
}

#Preview {
    StocksTabView()
        .environmentObject(StockViewModel())
}
