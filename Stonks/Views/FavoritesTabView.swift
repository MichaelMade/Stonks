import SwiftUI

struct FavoritesTabView: View {
    @ObservedObject var viewModel: StockViewModel
    @State private var sortAscending = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.background
                    .edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else {
                    VStack {
                        if viewModel.favorites.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "star.slash")
                                    .font(.system(size: 70))
                                    .foregroundColor(.gray)
                                    .padding()
                                
                                Text("No Favorite Stocks")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(ColorTheme.label)
                                
                                Text("Add stocks to your favorites from the Stocks tab.")
                                    .font(.body)
                                    .foregroundColor(ColorTheme.secondaryLabel)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .padding()
                        } else {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Sort by price change:")
                                        .font(.subheadline)
                                        .foregroundColor(ColorTheme.secondaryLabel)
                                    
                                    Button(action: { 
                                        withAnimation {
                                            sortAscending.toggle()
                                        }
                                    }) {
                                        HStack {
                                            Text(sortAscending ? "Ascending" : "Descending")
                                                .font(.subheadline)
                                            
                                            Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                                        }
                                        .foregroundColor(ColorTheme.accent)
                                    }
                                }
                                .padding(.horizontal)
                                
                                ScrollView {
                                    LazyVStack(spacing: 12) {
                                        ForEach(viewModel.sortFavorites(byPriceChangeAscending: sortAscending)) { stock in
                                            StockCellView(
                                                stock: stock,
                                                isFavorite: true,
                                                onFavoriteToggle: { 
                                                    withAnimation {
                                                        viewModel.toggleFavorite(for: stock)
                                                    }
                                                }
                                            )
                                            .transition(.opacity)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .animation(.default, value: sortAscending)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}