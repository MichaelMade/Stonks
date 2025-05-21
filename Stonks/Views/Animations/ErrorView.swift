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
    
    @State private var isAnimating = false
    
    init(message: String, onRetry: @escaping () -> Void) {
        self.message = message
        self.onRetry = onRetry
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.negativeChange.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
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
                
            }
            
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
            onRetry: {}
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ColorTheme.background)
}
