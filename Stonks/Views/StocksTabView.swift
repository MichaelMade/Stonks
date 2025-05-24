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
                                ForEach(viewModel.stocks, id: \.id) { stock in
                                    StockCellView(stock: stock)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
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
}

#Preview {
    StocksTabView()
        .environmentObject(StockViewModel())
}
