//
//  PersistenceManager.swift
//  StockApp
//
//  Created by Omotayo on 07/01/2022.
//

import Foundation

/// Object to manage saved caches
final class PersistenceManager {
    
    /// Singleton
    static let shared = PersistenceManager()
    
    /// Reference to user defaults
    private let userDefaults: UserDefaults = .standard
    
    
    /// Constants
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchlistKey = "watchlist"
    }
    
    private init() {}
    
    // MARK: - Public
    
    /// Get user watch list
    public var watchList: [String] {
        if !hasOnboarded {
            userDefaults.setValue(true, forKey: Constants.onboardedKey)
            setUpDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }
    
    
    /// Check if watch list contains item
    /// - Parameter symbol: symbol to check
    /// - Returns: Bool
    public func watchlistContains(symbol: String) -> Bool {
        return watchList.contains(symbol)
    }
    
    
    /// Add a symbol to watch list
    /// - Parameters:
    ///   - symbol: symbol to add
    ///   - companyName: Company name for symbol being added
    public func addToWatchList(symbol: String, companyName: String) {
        var current = watchList
        current.append(symbol)
        userDefaults.set(current, forKey: Constants.watchlistKey)
        userDefaults.set(companyName, forKey: symbol)
        
        NotificationCenter.default.post(name: .didAddToWatchlist, object: nil)
    }
    
    /// Remove item from watchlist
    /// - Parameter symbol: symbol to remove
    public func removeFromWatchList(symbol: String) {
        var newSymbolsList = [String]()
        userDefaults.set(nil, forKey: symbol)       // Clear out company name.
        for item in watchList where item != symbol {
            newSymbolsList.append(item)
        }
        userDefaults.set(newSymbolsList, forKey: Constants.watchlistKey)
    }
    
    // MARK: - Private
    
    /// Check if user has been onboarded
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: "hasOnboarded")
    }
    
    /// Set up default watchlist items
    private func setUpDefaults() {
        let map: [String: String] = [
            "APPL": "Apple Inc",
            "MSFT": "Microsoft Corporation",
            "SNAP": "Snap Inc.",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com Inc.",
            "WORK": "Slack Technologies",
            "FB": "Facebook Inc.",
            "NVDA": "Nvidia Inc.",
            "NKE": "Nike",
            "PINS": "Pinterest Inc."
        ]
        
        let symbols = map.keys.map { $0 }
        userDefaults.setValue(symbols, forKey: "watchlist")
        
        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
    
}
