import SwiftUI

struct StocksTabView: View {
    @ObservedObject var viewModel: StockViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.background
                    .edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Error")
                            .font(.title)
                            .foregroundColor(.red)
                        
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Retry") {
                            Task {
                                await viewModel.loadStocks()
                            }
                        }
                        .padding()
                        .background(ColorTheme.accent)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
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
                            
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.stocks) { stock in
                                    StockCellView(
                                        stock: stock,
                                        isFavorite: viewModel.isFavorite(stock: stock),
                                        onFavoriteToggle: { viewModel.toggleFavorite(for: stock) }
                                    )
                                    .transition(.opacity)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        await viewModel.loadStocks()
                    }
                }
            }
            .navigationTitle("Stonks")
            .task {
                if viewModel.stocks.isEmpty {
                    await viewModel.loadStocks()
                }
            }
        }
    }
}
