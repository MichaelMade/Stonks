//
//  LoadingAnimationView.swift
//  Stonks
//
//  Created by Michael Moore on 5/20/25.
//

import SwiftUI

struct LoadingAnimationView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(ColorTheme.accent.opacity(0.2), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [ColorTheme.accent, ColorTheme.accent.opacity(0.3)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isAnimating)
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title2)
                    .foregroundColor(ColorTheme.accent)
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
            
            VStack(spacing: 8) {
                Text("Loading Stonks")
                    .font(.headline)
                    .foregroundColor(ColorTheme.label)
                
                Text("Fetching the latest market data...")
                    .font(.subheadline)
                    .foregroundColor(ColorTheme.secondaryLabel)
                    .multilineTextAlignment(.center)
            }
            .opacity(opacity)
        }
        .onAppear {
            isAnimating = true
            
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                scale = 1.2
            }
            
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                opacity = 0.7
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading stocks data")
    }
}

#Preview {
    LoadingAnimationView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTheme.background)
}