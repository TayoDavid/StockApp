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
    
    private init() {}
    
    // MARK: - Public
    
    public var watchList: [String] {
        return []
    }
    
    public func addToWatchList() {
        
    }
    
    public func removeFromWatchList() {
        
    }
    
    // MARK: - Private
    
    private var hasOnboarded: Bool {
        return false
    }
}
