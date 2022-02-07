//
//  PersistenceManager.swift
//  StockApp
//
//  Created by Omotayo on 07/01/2022.
//

import Foundation

final class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchlistKey = "watchlist"
    }
    
    private init() {}
    
    // MARK: - Public
    
    public var watchList: [String] {
        if !hasOnboarded {
            userDefaults.setValue(true, forKey: Constants.onboardedKey)
            setUpDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }
    
    public func watchlistContains(symbol: String) -> Bool {
        return watchList.contains(symbol)
    }
    
    public func addToWatchList(symbol: String, companyName: String) {
        var current = watchList
        current.append(symbol)
        userDefaults.set(current, forKey: Constants.watchlistKey)
        userDefaults.set(companyName, forKey: symbol)
        
        NotificationCenter.default.post(name: .didAddToWatchlist, object: nil)
    }
    
    public func removeFromWatchList(symbol: String) {
        var newSymbolsList = [String]()
        userDefaults.set(nil, forKey: symbol)       // Clear out company name.
        for item in watchList where item != symbol {
            newSymbolsList.append(item)
        }
        userDefaults.set(newSymbolsList, forKey: Constants.watchlistKey)
    }
    
    // MARK: - Private
    
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: "hasOnboarded")
    }
    
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
