//
//  EmptyStateView.swift
//  Stonks
//
//  Created by Michael Moore on 5/20/25.
//

import SwiftUI

struct EmptyStateView: View {
    @State private var isAnimating = false
    @State private var iconScale: CGFloat = 1.2
    @State private var iconRotation: Double = 0
    
    let title: String
    let message: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(ColorTheme.accent.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                
                Image(systemName: systemImage)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(ColorTheme.accent.opacity(0.8))
                    .scaleEffect(iconScale)
                    .rotationEffect(.degrees(iconRotation))
            }
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTheme.label)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(ColorTheme.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .opacity(isAnimating ? 1.0 : 0.8)
        }
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
            
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                iconScale = 1.1
            }
            
            if systemImage.contains("star") {
                withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                    iconRotation = 15
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(message)")
    }
}

#Preview {
    VStack(spacing: 50) {
        EmptyStateView(
            title: "No Favorite Stocks",
            message: "Add stocks to your favorites from the Stocks tab.",
            systemImage: "star.slash"
        )
        
        EmptyStateView(
            title: "No Data Available",
            message: "Please check your connection and try again.",
            systemImage: "wifi.slash"
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ColorTheme.background)
}
