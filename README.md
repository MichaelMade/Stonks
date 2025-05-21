# Stonks - Stock Tracking App

A SwiftUI app that allows users to track stock prices, mark favorites, and manage their stock watchlist.

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Define the data structures for stocks and API responses
- **Views**: UI components for displaying stocks, favorites, and tabs
- **ViewModels**: Manage state, data fetching, and business logic
- **Services**: Handle API interactions and data processing

### Architecture Choices

1. **MVVM Pattern**: Chosen for its clear separation of concerns and compatibility with SwiftUI's reactive paradigm. The ViewModel serves as the bridge between the Model and View layers, handling business logic and state management.

   - **Benefits**: Promotes testability by isolating business logic, makes the codebase more maintainable, and aligns well with SwiftUI's declarative approach.
   - **Implementation**: Used a central `StockViewModel` that manages stock data, favorite selections, and sorting functionality.

2. **State Management**: Used `@StateObject` for the root view model to ensure it persists through view lifecycle, and `@ObservedObject` for child views to maintain a single source of truth.

   - **Benefits**: Prevents unnecessary recreations of the view model, avoids memory leaks, and ensures consistent UI updates.
   - **Implementation**: Root `ContentView` owns the `StockViewModel` as a `@StateObject`, while child views like `StocksTabView` and `FavoritesTabView` receive it as an `@ObservedObject`.

3. **Services Layer**: Implemented a dedicated `StockService` class to handle data fetching. This keeps network logic separate from presentation logic and allows for easy testing and mocking.

   - **Benefits**: Simplifies API interaction, makes testing easier by allowing service mocking, and provides a clean abstraction for data access.
   - **Implementation**: Used asynchronous Swift concurrency with `async/await` for clear, readable asynchronous code.

4. **Data Flow**: Unidirectional data flow from the ViewModel to Views ensures consistent UI updates and predictable behavior.

   - **Benefits**: Makes debugging easier, reduces state-related bugs, and creates a predictable pattern for data changes.
   - **Implementation**: All user interactions trigger ViewModel methods, which update published properties that Views observe.

## Features

- Horizontal scrolling list of featured stocks
- Vertical list of all stocks
- Favorites tab with sorting capabilities 
- Persistence of favorites across app restarts using UserDefaults
- Support for light and dark mode
- Smooth animations for state transitions
- Responsive design for different iPhone screen sizes
- Full accessibility support with VoiceOver and Dynamic Type

## Implementation Details

### State Management
- Used `@StateObject` for the main view model to ensure it persists across view updates
- Used `@ObservedObject` for child views to observe the same state
- Used `@State` for view-specific state like sorting options
- Leveraged SwiftUI's `@Published` properties for reactive UI updates

### Data Persistence
- Used UserDefaults to persist favorite stocks across app restarts
- Stored only the stock IDs to minimize storage requirements
- Implemented clean loading and saving methods in the ViewModel

### Mock API Implementation
- Created a simulated API response with a 1-second delay
- Used JSON decoding for type-safe data parsing
- Implemented proper error handling for potential failures

### UI/UX
- Implemented light and dark mode support with system-aware color theming
- Added animations for UI transitions to create a polished feel
- Created a responsive design that works across different iPhone screen sizes
- Used SF Symbols for icons to maintain platform consistency

### Accessibility
- Implemented comprehensive VoiceOver support with descriptive labels
- Added accessibility hints for interactive elements
- Support for Dynamic Type for adjustable font sizes
- Ensured sufficient color contrast for all UI elements
- Used proper accessibility traits for different content types

## Project Structure

- **Models**
  - `Stock.swift`: Model for stock data with computed properties
- **Views**
  - `StockCellView.swift`: Reusable cell for displaying stock information
  - `FeaturedStockCard.swift`: Card component for featured stocks
  - `FeaturedStocksView.swift`: Horizontal scrolling list of featured stocks
  - `StocksTabView.swift`: Main stocks tab view
  - `FavoritesTabView.swift`: Favorites tab view with sorting
  - `Animations/`: Loading, error, and empty state views
- **ViewModels**
  - `StockViewModel.swift`: Manages stock data and app state with reactive properties
- **Services**
  - `StockService.swift`: Handles mock API requests with error handling
  - `FormattingService.swift`: Centralized formatting for currency and percentages
- **Utilities**
  - `ColorTheme.swift`: Defines color scheme for light and dark mode
  - `StockError.swift`: Custom error types with localized descriptions
- **Resources**
  - `example_response.json`: Mock API response data

## Code Quality & Testing

- **Architecture**: Clean MVVM pattern with proper separation of concerns
- **Error Handling**: Comprehensive error types with user-friendly messages
- **Testing**: Full unit test coverage for ViewModels and Services
- **Mocking**: Protocol-based design enables easy testing with mock services
- **Performance**: Optimized with lazy loading and efficient state management
- **Code Cleanup**: Recently removed redundant methods to maintain clean APIs

## Future Improvements

- Implement real API integration with a stock data provider
- Add search functionality for finding specific stocks
- Create detailed stock view with charts and historical data
- Implement additional sorting and filtering options
- Add more robust data persistence with CoreData or SwiftData
- Implement user settings for customization

## Running the App

1. Open the project in Xcode 15.0 or later
2. Select an iPhone simulator or device
3. Build and run the app