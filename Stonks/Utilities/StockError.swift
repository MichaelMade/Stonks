//
//  StockError.swift
//  Stonks
//
//  Created by Michael Moore on 5/20/25.
//

import Foundation

// Errors that can occur when fetching stocks
enum StockError: Error, LocalizedError, Equatable {
    case failedToLoadData
    case invalidResponse
    case networkUnavailable
    case decodingFailed(DecodingError)
    case fileNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .failedToLoadData:
            return "Unable to load stock data. Please try again."
        case .invalidResponse:
            return "Received invalid data from server. Please check your connection."
        case .networkUnavailable:
            return "Network connection unavailable. Please check your internet connection."
        case .decodingFailed(let decodingError):
            return "Data format error: \(decodingError.localizedDescription)"
        case .fileNotFound(let fileName):
            return "Required data file '\(fileName)' not found."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .failedToLoadData:
            return "Data loading operation failed"
        case .invalidResponse:
            return "Server returned malformed data"
        case .networkUnavailable:
            return "No internet connection available"
        case .decodingFailed:
            return "JSON decoding failed"
        case .fileNotFound:
            return "Bundle resource missing"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .failedToLoadData, .invalidResponse:
            return "Try refreshing the data or check your internet connection."
        case .networkUnavailable:
            return "Connect to the internet and try again."
        case .decodingFailed:
            return "This appears to be a data format issue. Please contact support if the problem persists."
        case .fileNotFound:
            return "Please reinstall the app if this issue continues."
        }
    }
    
    // Custom equality implementation for cases with associated values
    static func == (lhs: StockError, rhs: StockError) -> Bool {
        switch (lhs, rhs) {
        case (.failedToLoadData, .failedToLoadData),
             (.invalidResponse, .invalidResponse),
             (.networkUnavailable, .networkUnavailable):
            return true
        case (.decodingFailed, .decodingFailed):
            return true // Compare by case type only for DecodingError
        case (.fileNotFound(let lhsFile), .fileNotFound(let rhsFile)):
            return lhsFile == rhsFile
        default:
            return false
        }
    }
}
