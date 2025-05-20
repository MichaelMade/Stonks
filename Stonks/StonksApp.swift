//
//  StonksApp.swift
//  Stonks
//
//  Created by Michael Moore on 5/19/25.
//

import SwiftUI

@main
struct StonksApp: App {
    @StateObject private var stockViewModel = StockViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stockViewModel)
        }
    }
}
