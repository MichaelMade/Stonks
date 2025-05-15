# Stonks - Stock Tracking App

A SwiftUI app that allows users to track stock prices, mark favorites, and manage their stock watchlist.

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Define the data structures for stocks and API responses
- **Views**: UI components for displaying stocks, favorites, and tabs
- **ViewModels**: Manage state, data fetching, and business logic

## Features

- Horizontal scrolling list of featured stocks
- Vertical list of all stocks
- Favorites tab with sorting capabilities 
- Persistence of favorites across app restarts using UserDefaults
- Support for light and dark mode
- Smooth animations for state transitions
- Responsive design for different iPhone screen sizes

## Project Structure

- **Models**
  - `Stock.swift`: Model for stock data
- **Views**
  - `StockCellView.swift`: Reusable cell for displaying stock information
  - `FeaturedStocksView.swift`: Horizontal scrolling list of featured stocks
  - `StocksTabView.swift`: Main stocks tab view
  - `FavoritesTabView.swift`: Favorites tab view
- **ViewModels**
  - `StockViewModel.swift`: Manages stock data and app state
- **Services**
  - `StockService.swift`: Handles mock API requests
- **Resources**
  - `example_response.json`: Mock API response data

## Implementation Details

### State Management
- Used `@StateObject` for the main view model to ensure it persists across view updates
- Used `@ObservedObject` for child views to observe the same state
- Used `@State` for view-specific state like sorting options

### Data Persistence
- Used UserDefaults to persist favorite stocks across app restarts
- Stored only the stock IDs to minimize storage requirements

### UI/UX
- Implemented light and dark mode support
- Added animations for UI transitions
- Created a responsive design that works across different screen sizes
- Used SF Symbols for icons for consistent visuals

## Running the App

1. Open the project in Xcode 15.0 or later
2. Select an iPhone simulator or device
3. Build and run the app