//
//  ErrorView.swift
//  Stonks
//
//  Created by Michael Moore on 5/20/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    let error: Error?
    let showRetryButton: Bool
    
    @State private var isAnimating = false
    
    init(message: String, error: Error? = nil, showRetryButton: Bool = true, onRetry: @escaping () -> Void) {
        self.message = message
        self.error = error
        self.showRetryButton = showRetryButton
        self.onRetry = onRetry
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.negativeChange.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(ColorTheme.negativeChange)
                }
                
                Text("Oops! Something went wrong")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTheme.label)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(ColorTheme.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Show recovery suggestion if available
                if let stockError = error as? StockError, 
                   let suggestion = stockError.recoverySuggestion {
                    Text(suggestion)
                        .font(.caption)
                        .foregroundColor(ColorTheme.tertiaryLabel)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                        .padding(.horizontal)
                }
            }
            
            if showRetryButton {
                Button(action: onRetry) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.headline)
                    
                    Text("Try Again")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [ColorTheme.accent, ColorTheme.accent.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: ColorTheme.accent.opacity(0.3), radius: 10, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                isAnimating = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Error: \(message)")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to retry")
    }
}

#Preview {
    VStack(spacing: 40) {
        ErrorView(
            message: "Unable to load stock data. Please check your internet connection and try again.",
            error: StockError.networkUnavailable,
            onRetry: {}
        )
        
        ErrorView(
            message: "Data format error occurred.",
            error: StockError.decodingFailed(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid JSON"))),
            showRetryButton: false,
            onRetry: {}
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ColorTheme.background)
}