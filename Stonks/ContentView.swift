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
        ZStack(alignment: .bottom) {
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
            .tabViewStyle(.page(indexDisplayMode: .never))
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
            .overlay(alignment: .bottom) {
                // Custom floating tab bar
                HStack(spacing: 0) {
                    TabBarButton(
                        title: "Stonks",
                        icon: "chart.line.uptrend.xyaxis",
                        isSelected: selectedTab == 0
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedTab = 0
                        }
                    }
                    
                    TabBarButton(
                        title: "Favorites", 
                        icon: "star",
                        isSelected: selectedTab == 1
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedTab = 1
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(ColorTheme.accent.opacity(0.2), lineWidth: 1)
                            )
                        
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 20)
                                .fill(ColorTheme.accent.opacity(0.1))
                                .frame(width: geometry.size.width / 2)
                                .offset(x: selectedTab == 0 ? 0 : geometry.size.width / 2)
                                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedTab)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                )
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 32)
                .padding(.bottom, 34)
            }
        }
        .accentColor(ColorTheme.accent)
        .preferredColorScheme(.none)
        .dynamicTypeSize(.xSmall ... .xxxLarge)
        .onAppear {
            // Hide the default tab bar
            UITabBar.appearance().isHidden = true
        }
    }
}

struct TabBarButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.accent : ColorTheme.secondaryLabel)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? ColorTheme.accent : ColorTheme.secondaryLabel)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
        .accessibilityHint(isSelected ? "Currently selected" : "Tap to switch to \(title)")
    }
}

#Preview {
    ContentView()
        .environmentObject(StockViewModel())
}